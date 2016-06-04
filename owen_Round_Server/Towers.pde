class Tower {        //Turrets and ¿Foggers?
  PVector location;
  PVector target;
  int range;
  int health;
  String icon;
  
  Tower(int[] loc, int hth, String icn) {
    location = new PVector(loc[0],loc[1]);
    target = new PVector();
    icon = icn;
    health = hth;
    range = 0;
  }
}

class Turret extends Tower {
  int damage;
  int radius;
  int timer;
  String owner;
  String trueTarget;
  String code;
  boolean targetFound;
  
  Turret(int[] loc, int[] tar, int dam, int rad, int hth, String icn, String own) {
    super(loc,hth,icn);
    
    target.set(tar[0],tar[1]);
    damage = dam;
    radius = rad;
    timer = 0;
    owner = own;
    trueTarget = "";
    targetFound = false;
    
    PVector magnitude = new PVector(tar[0],tar[1]);
    magnitude.sub(location);
    range = round(magnitude.mag());
    
    if (icon.length() > 0) {
      int i = 0;
      while (i<iconList.size() && !iconList.get(i).equals(icon)) {
        i++;
      }
      
      if (iconList.get(i).equals(icon)) {
        code = codeList.get(i);
      }
    }
  }
  
  void aim() {
    if (!targetFound) {
      target.sub(location);
      target.normalize();
      target.mult(range);
      
      for (int i=0; i<clientList.size(); i++) {
        String client = clientList.get(i);
        
        if ((!client.substring(client.indexOf(iconID)+iconID.length(),client.indexOf(endID+ownerID)).equals(icon) || extractString(client,iconID,endID).length() == 0) && !extractString(client,nameID,endID).equals(owner)) {
          PVector difference = new PVector();
          int[] clientL = int(split(extractString(client,locationID,endID),','));
          
          difference.set(clientL[0],clientL[1]);
          difference.sub(location);
          
          if (difference.mag() < target.mag()) {
            target.set(difference);
            trueTarget = nameID + "client" + endID + addressID + str(i) + endID;
            targetFound = true;
          }
        }
      }
      
      for (int i=0; i<enemyList.size(); i++) {
        PVector difference = new PVector();
        difference.set(enemyList.get(i).location);
        difference.sub(location);
        
        if (difference.mag() < target.mag()) {
          target.set(difference);
          trueTarget = nameID + "enemy" + endID + addressID + str(i) + endID;
          targetFound = true;
        }
      }
      
      for (int i=0; i<turretList.size(); i++) {
        if (!turretList.get(i).location.equals(location) && (!turretList.get(i).icon.equals(icon) || turretList.get(i).icon.length() == 0) && !turretList.get(i).owner.equals(owner)) {
          PVector difference = new PVector();
          difference.set(turretList.get(i).location);
          difference.sub(location);
          
          if (difference.mag() < target.mag()) {
            target.set(difference);
            trueTarget = nameID + "turret" + endID + addressID + str(i) + endID;
            targetFound = true;
          }
        }
      }
      
      for (int i=0; i<objectList.size(); i++) {
        String name = extractString(objectList.get(i),nameID,endID);
        String objectI = extractString(objectList.get(i),iconID,endID);
        String objectO = extractString(objectList.get(i),ownerID,endID);
        
        if (name.equals("base") && (!objectI.equals(icon) || objectI.length() == 0) && !objectO.equals(owner)) {
          PVector difference = new PVector();
          int[] objectL = int(split(extractString(objectList.get(i),locationID,endID),','));
          difference.set(objectL[0],objectL[1]);
          difference.sub(location);
          
          if (difference.mag() < target.mag()) {
            target.set(difference);
            trueTarget = nameID + "object" + endID + addressID + str(i) + endID;
            targetFound = true;
          }
        }
      }
      
      if (targetFound) {
        target.normalize();
        target.mult(range);
      }
      target.add(location);
    }
    else if (targetFound) {
      PVector difference = new PVector();
      
      if (extractString(trueTarget,nameID,endID).equals("client")) {
        if (clientList.size() > int(extractString(trueTarget,addressID,endID))) {
          String client = clientList.get(int(extractString(trueTarget,addressID,endID)));
          int[] clientL = int(split(extractString(client,locationID,endID),','));
          
          difference.set(clientL[0],clientL[1]);
          difference.sub(location);
          if (difference.mag() < range) {
            target.set(clientL[0],clientL[1]);
          }
          else {
            targetFound = false;
          }
        }
        else {
          targetFound = false;
        }
      }
      else if (extractString(trueTarget,nameID,endID).equals("enemy")) {
        if (enemyList.size() > int(extractString(trueTarget,addressID,endID))) {
          Enemy enemy = enemyList.get(int(extractString(trueTarget,addressID,endID)));
          
          difference.set(enemy.location);
          difference.sub(location);
          if (difference.mag() < range) {
            target.set(enemy.location);
          }
          else {
            targetFound = false;
          }
        }
        else {
          targetFound = false;
        }
      }
      else if (extractString(trueTarget,nameID,endID).equals("turret")) {
        if (turretList.size() > int(extractString(trueTarget,addressID,endID))) {
          Turret turret = turretList.get(int(extractString(trueTarget,addressID,endID)));
          
          difference.set(turret.location);
          difference.sub(location);
          if (difference.mag() < range) {
            target.set(turret.location);
          }
          else {
            targetFound = false;
          }
        }
        else {
          targetFound = false;
        }
      }
      else if (extractString(trueTarget,nameID,endID).equals("object")) {
        if (objectList.size() > int(extractString(trueTarget,addressID,endID))) {
          String object = objectList.get(int(extractString(trueTarget,addressID,endID)));
          int[] objectL = int(split(extractString(object,locationID,endID),','));
          
          difference.set(objectL[0],objectL[1]);
          difference.sub(location);
          if (difference.mag() < range) {
            target.set(objectL[0],objectL[1]);
          }
          else {
            targetFound = false;
          }
        }
        else {
          targetFound = false;
        }
      }
    }
  }

  void shoot() {
    PVector bLocation = new PVector(target.x,target.y);
    PVector velocity = new PVector();
    
    bLocation.sub(location);
    bLocation.normalize();
    
    velocity.set(bLocation);
    velocity.mult(6);
    
    bLocation.mult(55);
    bLocation.add(location);
    
    String projectile = "";
    
    if (radius == -1) {
      projectile = nameID + "bullet" + endID + locationID + str(round(bLocation.x)) + ',' + str(round(bLocation.y)) + endID + velocityID + str(round(velocity.x)) + ',' + str(round(velocity.y)) + endID + targetID + str(round(target.x)) + ',' + str(round(target.y)) + endID + damageID + str(damage) + endID + iconID + code + endID + ownerID + owner + endID;
    }
    else {
      projectile = nameID + "grenade" + endID + locationID + str(round(bLocation.x)) + ',' + str(round(bLocation.y)) + endID + velocityID + str(round(velocity.x)) + ',' + str(round(velocity.y)) + endID + targetID + str(round(target.x)) + ',' + str(round(target.y)) + endID + radiusID + str(radius) + endID + damageID + str(damage) + endID + iconID + code + endID + ownerID + owner + endID;
    }
    objectList.append(projectile); //<>//
  }
  
  void time() {
    if (timer > 0) {
      timer--;  
    }
    else {
      timer = int(random(80,100));
    }
  }
  
  void collide() {
    for (int i=0; i<objectList.size(); i++) {                                           // react with and delete coins/ammoBoxes/healthBoxes/bullets/grenades/hazardRings
      String object = objectList.get(i);
      int[] objectLocation = int(split(extractString(object,locationID,endID),','));
      
      if (objectLocation.length > 1 && (extractString(object,nameID,endID).equals("coin") || extractString(object,nameID,endID).equals("bullet") || extractString(object,nameID,endID).equals("hazardRing"))) {
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
          if (extractString(object,nameID,endID).equals("bullet") || extractString(object,nameID,endID).equals("grenade") || extractString(object,nameID,endID).equals("hazardRing")) {
            if (!extractString(object,ownerID,endID).equals(owner)) {
              float damage = int(extractString(object,damageID,endID));
              if (object.substring(object.indexOf(iconID)+iconID.length(),object.indexOf(endID+ownerID)).equals(code)) {
                damage *= 0.5;
              }
              
              health -= damage;
            }
          }
          
          if (!extractString(object,nameID,endID).equals("hazardRing")) {
            objectList.remove(i);
            i--;
          }
        }
      }
    }
  }
}

void updateTurrets() {
  for (int i=0; i<turretList.size(); i++) {
    Turret turret = turretList.get(i);
    
    turret.aim();
    if (turret.timer == 0 && turret.targetFound) {
      turret.shoot();
    }
    turret.collide();
    turret.time();
    
    if (turret.health < 1) {
      turretList.remove(i);
      i--;
    }
  }
}