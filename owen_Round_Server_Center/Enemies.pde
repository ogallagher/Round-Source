class Enemy {
  PVector location;
  PVector previousLocation;
  PVector targetMove;
  PVector previousMove;
  PVector targetShoot;
  
  float angle;
  float animationAngle;
  String cpackage;
  int coolTime;
  int searchTime;
  int stuckTime;
  float toTarget;
  int health;
  
  int damage;
  float speed;
  float[] accuracy = {0,0};  //{errorProbability,currentError}
  float aimSpeed;
  float agility;
  int range;
  int peripheral;
  boolean targetShootFound;
  boolean inSmokeScreen;
  
  Enemy(float x, float y, String pack, int spd, int dmg) {
    location = new PVector(x,y);
    previousLocation = new PVector(x,y);
    targetMove = new PVector(location.x,location.y);
    previousMove = new PVector(location.x,location.y);
    targetShoot = new PVector(0,0);
    
    health = int(random(50,150));
    angle = 0;
    animationAngle = 0;
    
    cpackage = pack;
    coolTime = 100;
    searchTime = 100;
    stuckTime = 0;
    toTarget = 0;
    
    damage = dmg;
    speed = spd * random(0.6,1);
    accuracy[0] = random(1);
    accuracy[1] = PI*random(-0.2,0.2)*accuracy[0];
    agility = random(0,1.25);
    aimSpeed = random(0.1,0.9);
    range = 700;
    peripheral = round(PI/3);
    targetShootFound = false;
    inSmokeScreen = false;
  }
  
  void awareness() {  //smokescreens, bullets, grenades, demolition, hazardRings
    if (inSmokeScreen) {
      agility *= 0.5;
    }
    inSmokeScreen = false;
    
    for (int i=0; i<objectList.size(); i++) {
      String name = extractString(objectList.get(i),nameID,endID);
      if (name.equals("bullet") || name.equals("grenade") || name.equals("demolition") || name.equals("hazardRing")) {
        if (!extractString(objectList.get(i),ownerID,endID).equals("enemy")) {
          int[] components = int(split(extractString(objectList.get(i),locationID,endID),','));
          PVector repulsion = new PVector(components[0],components[1]);
          
          repulsion.sub(location);
          float distance = repulsion.mag();
          distance -= 30;
          if (name.equals("hazardRing")) {
            distance -= int(extractString(objectList.get(i),alphaID,endID));
          }
          if (distance < 30) {
            distance = 30;
          }
          
          repulsion.normalize();
          repulsion.mult(-1*speed*agility);
          repulsion.div(distance*0.03);
          distance = constrain(repulsion.mag(),0,speed);
          repulsion.normalize();
          repulsion.mult(distance);
          location.add(repulsion);
        }
      }
      else if (!inSmokeScreen && name.equals("smokescreen")) {
        int[] components = int(split(extractString(objectList.get(i),locationID,endID),','));
        PVector difference = new PVector(components[0],components[1]);
        difference.sub(location);
        
        if (difference.mag() < int(extractString(objectList.get(i),radiusID,endID)) + 30) {
          inSmokeScreen = true;
        }
      }
    }
  }
  
  void setTargetShoot() {
    targetShootFound = false;
    
    int i=0;
    PVector current = new PVector();
    PVector difference = new PVector();
    float distance;
    
    current.set(targetShoot);
    current.sub(location);
    current.normalize();
    
    if (coolTime == 0) {
      if (inSmokeScreen) {
        accuracy[1] = PI*random(-0.4,0.4)*accuracy[0];
      }
      else {
        accuracy[1] = PI*random(-0.2,0.2)*accuracy[0];
      }
    }
    
    while (i < clientList.size()) {
      int[] clientLocation = int(split(extractString(clientList.get(i),locationID,endID),','));
      int clientAlpha = int(extractString(clientList.get(i),alphaID,endID));
      
      if (clientLocation.length > 1 && clientAlpha > 0) {
        difference.set(clientLocation[0],clientLocation[1]);
        difference.sub(location);
        distance = difference.mag();
        if (inSmokeScreen) {
          distance *= 1.3333;
        }
        
        if (distance < range) {
          float change = difference.heading()+accuracy[1];
          float currentAngle = current.heading();
          
          while (change > PI*2) {
            change -= PI*2;
          }
          while (change < 0) {
            change += PI*2;
          }
          while (currentAngle > PI*2) {
            currentAngle -= PI*2;
          }
          while (currentAngle < 0) {
            currentAngle += PI*2;
          }
          
          change -= currentAngle;
          
          if (abs(change) > PI) {
            change = -1*(change/abs(change))*(PI*2-abs(change));
          }
          
          difference = PVector.fromAngle(current.heading() + (change)*0.2*aimSpeed);
          difference.mult(distance);
          targetShoot.set(location);
          targetShoot.add(difference);
          
          targetShootFound = true;
        }
      }
      
      i++;
    }
  }
  
  void setTargetMove() {
    if ((toTarget < 60 && searchTime < 1) || (stuckTime > 150)) {
      int i = 0;
      PVector difference = new PVector();
      float distance = range;
      int wallRadius = 10;
      PVector wallPosition = new PVector();
      
      if (targetShootFound) {
        PVector clientDifference = new PVector(targetShoot.x,targetShoot.y);
        clientDifference.sub(location);
        float angleClientWall = peripheral;
        
        while (i < objectList.size()) {
          String objectName = extractString(objectList.get(i),nameID,endID);
          
          if (objectName.equals("wall")) {
            int[] wallLocation = int(split(extractString(objectList.get(i),locationID,endID),','));
            
            if (wallLocation.length > 1) {
              difference.set(wallLocation[0],wallLocation[1]);
              
              if (!(previousMove.x == difference.x && previousMove.y == difference.y)) {
                difference.sub(location);
              
                if (difference.mag() < distance && difference.mag() < clientDifference.mag()) {
                  angleClientWall = PVector.angleBetween(clientDifference,difference);
                  
                  if (angleClientWall < peripheral && angle > peripheral/12) {
                    distance = difference.mag();
                    wallPosition.set(wallLocation[0],wallLocation[1]);
                    wallRadius = int(extractString(objectList.get(i),radiusID,endID));
                  }
                }
              }
            }  
          }
          
          i++;
        }
        
        targetMove.set(targetShoot);
        
        if (distance < range) {
          previousMove.set(wallPosition);
          difference.set(wallPosition);
          difference.sub(targetShoot);
          distance = difference.mag();
          difference.normalize();
          
          distance += wallRadius + 40;
          difference.mult(distance);
          
          targetMove.add(difference);
        }
      }
      
      if (!(targetShootFound) || (stuckTime > 300)) {
        while (i < objectList.size()) {
          String objectName = extractString(objectList.get(i),nameID,endID);
          
          if (objectName.equals("coin")) {
            int[] coinLocation = int(split(extractString(objectList.get(i),locationID,endID),','));
            
            if (coinLocation.length > 1) {
              difference.set(coinLocation[0],coinLocation[1]);
              difference.sub(location);
              
              if (difference.mag() < distance) {
                targetMove.set(coinLocation[0],coinLocation[1]);
                distance = difference.mag();
              }
            }
          }
          
          i++;
        }
        
        if (distance >= range) {
          targetMove.set(random(60,fieldWidth-60),random(60,fieldWidth-60));
        }
      }
    }
  }
  
  void move() {
    PVector velocity = new PVector(targetMove.x,targetMove.y);
    velocity.sub(location);
    toTarget = velocity.mag();
    velocity.normalize();
    velocity.mult(speed);
    
    if (toTarget > 30) {
      previousLocation.set(location);
      location.add(velocity);
      searchTime = int(random(50,150));
    }
    else {
      if (searchTime > 0) {
        searchTime--;
      }
    }
    
    if (targetShootFound) {
      velocity.set(targetShoot);
      velocity.sub(location);
    }
    angle = velocity.heading();
    
    if (cpackage.equals("turtle")) {
      animationAngle += 0.05;
      
      if (animationAngle > 2*PI) {
          animationAngle = 0;
      }
    }
  }
  
  void collide() {
    if (location.x < 30) {
      location.x += abs(30-location.x);
    }
    if (location.x > fieldWidth - 30) {
      location.x -= abs(location.x - (fieldWidth-30));
    }
    if (location.y < 30) {
      location.y += abs(30-location.y);
    }
    if (location.y > fieldWidth - 30) {
      location.y -= abs(location.y - (fieldWidth-30));
    }
    
    for (int i=0; i<clientList.size(); i++) {                                          // repel with clients
      String client = clientList.get(i);
      float[] clientLocation = float(split(extractString(client,locationID,endID),','));
      
      if (clientLocation.length > 1) {
        PVector otherLocation = new PVector(clientLocation[0],clientLocation[1]);
        otherLocation.sub(location);
        float distance = otherLocation.mag() - 60;
        otherLocation.normalize();
        otherLocation.mult(distance);
        
        if (distance < 0) {
          location.add(otherLocation);
        }
      }
    }
    
    for (int i=0; i<objectList.size(); i++) {                                           // repel with walls, react with and delete coins/bullets/hazardRings
      String object = objectList.get(i);
      float[] objectLocation = float(split(extractString(object,locationID,endID),','));
      
      if (objectLocation.length > 1) {
        if (extractString(object,nameID,endID).equals("wall")) {
          PVector otherLocation = new PVector(objectLocation[0],objectLocation[1]);
          otherLocation.sub(location);
          float distance = otherLocation.mag() - (30 + int(extractString(object,radiusID,endID)) + 2);
          otherLocation.normalize();
          otherLocation.mult(distance);
          
          if (distance < 0) {
            location.add(otherLocation);
          }
        }
        
        else if (extractString(object,nameID,endID).equals("coin") || extractString(object,nameID,endID).equals("bullet") || extractString(object,nameID,endID).equals("hazardRing")) {
          int minDistance = 30;
          
          if (extractString(object,nameID,endID).equals("bullet")) {
            minDistance += 4;
          }
          else if (extractString(object,nameID,endID).equals("hazardRing")) {
            minDistance += int(extractString(object,alphaID,endID));
          }
          else {
            minDistance += 10;
          }
          
          PVector difference = new PVector(objectLocation[0],objectLocation[1]);
          
          difference.sub(location);
          
          if (difference.mag() < minDistance) {
            if ((extractString(object,nameID,endID).equals("bullet") || extractString(object,nameID,endID).equals("hazardRing")) && !(extractString(object,ownerID,endID).equals("enemy"))) {
              health -= int(extractString(object,damageID,endID));
            }
            
            if (!extractString(object,nameID,endID).equals("hazardRing")) {
              delete(object);
            }
          }
        }
      }
    }
    
    for (int i=0; i<enemyList.size(); i++) {                                        // repel with other enemies
      Enemy otherEnemy = enemyList.get(i);
      
      PVector otherLocation = new PVector(otherEnemy.location.x,otherEnemy.location.y);
      if (!(otherLocation.x == location.x && otherLocation.y == location.y)) {
        otherLocation.sub(location);
        float distance = otherLocation.mag() - 60;
        otherLocation.normalize();
        otherLocation.mult(distance);
        
        if (distance < 0) {
          location.add(otherLocation);
        }
      }
    }
    
    PVector difference = new PVector(previousLocation.x,previousLocation.y);          //After potential pushback, actual spatial gains are assessed.
    difference.sub(location);
    
    if (difference.mag() < 1) {
      stuckTime++;
      searchTime = 0;
    }
    else {
      stuckTime = 0;
    }
  }
  
  void shoot() {
    String addition = "";
    
    if (targetShootFound && coolTime == 0) {
      PVector objectL;
      PVector targetL;
      PVector velocity;
      int radius = 0;
      
      objectL = PVector.fromAngle(angle);
      targetL = PVector.fromAngle(angle);
      velocity = PVector.fromAngle(angle);
      
      if (cpackage.equals("woodpecker") || cpackage.equals("beaver") || cpackage.equals("salamander")) {
        objectL.mult(55);
        objectL.add(location);
        
        targetL.mult(300);
        targetL.add(objectL);
        
        if (cpackage.equals("woodpecker")) {
          velocity.mult(5);
        }
        else if (cpackage.equals("beaver")) {
          velocity.mult(7);
        }
        
        if (cpackage.equals("salamander")) {
          radius = 300;
          velocity.mult(5);
        }
      }
      else if (cpackage.equals("turtle")) {
        objectL.set(location);
        radius = 200;
      }
      else if (cpackage.equals("hedgehog")) {
        objectL.mult(55);
        objectL.add(location);
        
        velocity.mult(6);
        
        radius = 300;
      }
        
        if (cpackage.equals("woodpecker") || cpackage.equals("beaver")) {
          addition = nameID + "bullet" + endID + locationID + str(round(objectL.x)) + ',' + str(round(objectL.y)) + endID + velocityID + str(round(velocity.x)) + ',' + str(round(velocity.y)) + endID + targetID + str(round(targetL.x)) + ',' + str(round(targetL.y)) + endID + damageID + damage + endID + ownerID + "enemy" + endID;
        }
        else if (cpackage.equals("salamander")) {
          addition = nameID + "grenade" + endID + locationID + str(round(objectL.x)) + ',' + str(round(objectL.y)) + endID + velocityID + str(round(velocity.x)) + ',' + str(round(velocity.y)) + endID + targetID + str(round(targetL.x)) + ',' + str(round(targetL.y)) + endID + radiusID + str(radius) + endID + damageID + damage + endID + ownerID + "enemy" + endID;
        }
        else if (cpackage.equals("turtle")) {
          addition = nameID + "hazardRing" + endID + locationID + str(round(objectL.x)) + ',' + str(round(objectL.y)) + endID + radiusID + radius + endID + alphaID + "30" + endID + damageID + str(damage) + endID + ownerID + "enemy" + endID;
        }
        else if (cpackage.equals("hedgehog")) {
          addition = nameID + "fanshot" + endID + locationID + str(round(objectL.x)) + ',' + str(round(objectL.y)) + endID + velocityID + str(round(velocity.x)) + ',' + str(round(velocity.y)) + endID + radiusID + str(radius) + endID + alphaID + "1" + endID + damageID + str(damage) + endID + ownerID + "enemy" + endID;
        }
    }
    
    if (addition.length() > 0) {
      spawn(addition);
    }
    
    if (coolTime > 0) {
      coolTime--;
    }
    else {
      if (cpackage.equals("woodpecker")) {
        coolTime = int(random(5,100));
      }
      else if (cpackage.equals("salamander")) {
        coolTime = int(random(150,300));
      }
      else if (cpackage.equals("beaver")) {
        coolTime = int(random(50,200));
      }
      else if (cpackage.equals("turtle")) {
        coolTime = int(random(100,200));
      }
      else if (cpackage.equals("hedgehog")) {
        coolTime = int(random(150,200));
      }
    }
  }
  
  void dropCoin() {
    if (health < 1) {
      float randomDrop = random(1);
      
      if (randomDrop < 0.33) {
        PVector objectL;
        objectL = PVector.fromAngle(angle);
        objectL.mult(55);
        objectL.add(location);
        
        String coin = nameID + "coin" + endID + locationID + str(round(objectL.x)) + ',' + str(round(objectL.y)) + endID;
        spawn(coin);
      }
    }
  }
}

void updateEnemies() {
  for (int i=0; i<enemyList.size(); i++) {
    Enemy enemy = enemyList.get(i);
    
    enemy.awareness();
    enemy.setTargetShoot();
    enemy.setTargetMove();
    enemy.move();
    enemy.collide();
    enemy.shoot();
    enemy.dropCoin();
    
    if (enemy.health < 1) {
      enemyList.remove(i);
    }
  }
}