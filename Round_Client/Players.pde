class Player {
  String name;
  int score;
  float angle;
  String cpackage;
  int health;
  int ammo1;
  int ammo2;
  float coolTime1;
  float coolTime2;
  int speed;
  float speedConstant;
  
  PVector location;
  PVector camera;
  PVector target;
  
  float animationAngle;
  
  StringList beaverWalls;
  String lastTaken;
  String lastPlaced;                  //For bullet/grenade/demolition placement (shield deflection)
  boolean switch1 = false;            //Currently used to switch between bullets in woodpecker dual machine gun.
  boolean healthEstablished = false;
  
  Player() {
    name = "";
    score = -1;
    angle = 0;
    cpackage = "";
    health = -1;
    
    ammo1 = 0;
    ammo2 = 0;
    coolTime1 = 100;
    coolTime2 = 100;
    
    location = new PVector(-1,-1);
    camera = new PVector(-1,-1);
    target = new PVector(-1,-1);
    
    animationAngle = 0;
    
    beaverWalls = new StringList(); 
    lastTaken = "";
    lastPlaced = "";
  }
  
  void restart() {
    otherClients.clear();
    objects.clear();
    z = 1;
    
    name = "";
    score = -1;
    angle = 0;
    cpackage = "";
    health = -1;
    
    ammo1 = 0;
    ammo2 = 0;
    coolTime1 = 100;
    coolTime2 = 100;
    
    location.set(-1,-1);
    camera.set(-1,-1);
    target.set(-1,-1);
    
    animationAngle = 0;
    
    beaverWalls.clear(); 
    lastTaken = "";
    lastPlaced = "";
    
    icon = "";
    
    chatBoxString = "[,],*,:,$,TAB = Not Permitted. Limit = 60 char.";
    chatting = false;
    healthEstablished = false;
  }
  
  void getData(String data) {
    if (name.equals("")) {
      name = extractString(data,nameID,endID);
    }
    else if (newNamePending && extractString(data,ownerID,endID).length() > 0 && extractString(data,ownerID,endID).equals("APPROVED") && name.equals(extractString(data,nameID,endID))) {
      chatList.append(nameID + "SERVER" + endID + chatID + "NAME APPROVED." + endID);
      reading = true;
      name = cleanString(newname,"0123456789");
      username = newname;
      newname = "TYPE USERNAME ([,],*,TAB,: are not allowed)";
      newNamePending = false;
    }
    if (newNamePending && extractString(data,ownerID,endID).length() > 0 && extractString(data,ownerID,endID).equals("TAKEN")) {
      chatList.append(nameID + "SERVER" + endID + chatID + "NAME TAKEN." + endID);
      reading = true;
      newNamePending = false;
    }
    if (score < 0) {
      score = int(extractString(data,scoreID,endID));
    }
    
    if (location.x < 35 && location.y < 35) {
      int[] locationInt = int(split(extractString(data,locationID,endID),','));
      location.set(locationInt[0],locationInt[1]);
    }
    if (cpackage.length() == 0) {
      cpackage = extractString(data,packageID,endID);
      if (cpackage.equals("woodpecker")) {
        speed = int(upgrade("speed1",5));
        ammo1 = 50;
        ammo2 = 5;
      }
      else if (cpackage.equals("mole")) {
        speed = int(upgrade("speed1",1));
        ammo1 = 15;
      }
      else if (cpackage.equals("salamander")) {
        speed = int(upgrade("speed1",10));
        ammo1 = 7;
        ammo2 = 2;
      }
      else if (cpackage.equals("spider")) {
        speed = int(upgrade("speed1",3));
        ammo1 = 5;
      }
      else if (cpackage.equals("beaver")) {
        speed = int(upgrade("speed1",7));
        ammo1 = 6;
      }
      else if (cpackage.equals("turtle")) {
        speed = int(upgrade("speed1",2));
        ammo1 = 20;
      }
      else if (cpackage.equals("hedgehog")) {
        speed = int(upgrade("speed1",4));
        ammo1 = 5;
      }
      else if (cpackage.equals("termite")) {
        speed = int(upgrade("speed1",8));
        ammo1 = 3;
        ammo2 = 3;
      }
    }
    if (health < 0 && !healthEstablished) {
      health = int(upgrade("health",100));
      healthEstablished = true;
    }
  }
  
  void control() {
    if (!chatting && !renaming) {
      if (mousePressed && mouseButton == LEFT) {
        if (cpackage.equals("woodpecker")) {
          speedConstant = 0.4;
        }
        else {
          speedConstant = 1;
        }
      }
      else if (mousePressed && mouseButton == RIGHT) {
        if (cpackage.equals("hedgehog")) {
          if (score >= 10) {
            speedConstant = 0.2; 
          }
          else {
            speedConstant = 0;
          }
        }
        else {
          speedConstant = 1;
        }
      }
      else if (cpackage.equals("termite") && (coolTime1 > 0 || coolTime2 > 0)) {
        speedConstant = 0;
      }
      else {
        speedConstant = 1;
      }
      
      updateKeys();
      if (keys[0] && location.y > 30) {
        location.y -= speed * 0.8 * speedConstant;
      }
      if (keys[2] && location.y < fieldWidth - 30) {
        location.y += speed * 0.8 * speedConstant;
      }
      if (keys[1] && location.x > 30) {
        location.x -= speed * 0.8 * speedConstant;
      }
      if (keys[3] && location.x < fieldWidth - 30) {
        location.x += speed * 0.8 * speedConstant;
      }
    }
    
    PVector difference = new PVector(target.x,target.y);
    PVector zoomLocation = new PVector(z*location.x,z*location.y);
    difference.sub(zoomLocation);
    if (cpackage.equals("turtle")) {
      target.set(zoomLocation);
    }
    else {
      if (difference.mag() > 400) {
        target.set(zoomLocation);
      }
    }
    
    difference.set(target);
    difference.sub(camera);
    difference.mult(0.1);
    camera.add(difference);
    
    PVector compass = new PVector(mouseX,mouseY);
    compass.x -= zoomLocation.x - camera.x + width/2;
    compass.y -= zoomLocation.y - camera.y + height/2;
    angle = compass.heading();
    
    if (mousePressed && mouseButton == RIGHT && ((mouseX-(width/2)+camera.x)/z > 0 && (mouseX-(width/2)+camera.x)/z < fieldWidth) && ((mouseY-(height/2)+camera.y)/z > 0 && (mouseY-(height/2)+camera.y)/z < fieldWidth)) {
      if (cpackage.equals("mole")) {
        PVector teleport = new PVector(mouseX-(width/2),mouseY-(height/2));
        teleport.add(camera);
        teleport.div(z);
        location.set(teleport);
        
        mousePressed = false;
      }
    }
    
    if (coolTime1 > 0) {
      if (cpackage.equals("woodpecker")) {
        coolTime1 -= upgrade("time",8);
      }
      if (cpackage.equals("mole")) {
        coolTime1 -= upgrade("time",5);
      }
      if (cpackage.equals("salamander")) {
        coolTime1 -= upgrade("time",5);
      }
      if (cpackage.equals("spider")) {
        coolTime1 -= upgrade("time",0.5);
      }
      if (cpackage.equals("beaver")) {
        coolTime1 -= upgrade("time",5);
      }
      if (cpackage.equals("turtle")) {
        coolTime1 -= upgrade("time",2);
      }
      if (cpackage.equals("hedgehog")) {
        coolTime1 -= upgrade("time",1);
      }
      if (cpackage.equals("termite")){
        coolTime1 -= 0.8;
      }
    }
    else if (mousePressed && mouseButton == LEFT && ammo1 > 0 && !(escapeHover || chatHover || nameHover)){
      coolTime1 = 100;
      ammo1--;
    }
    
    if (coolTime2 > 0) {
      if (cpackage.equals("woodpecker")) {
        coolTime2 -= upgrade("time",1);
      }
      if (cpackage.equals("salamander")) {
        coolTime2 -= upgrade("time",0.5);
      }
      if (cpackage.equals("spider")) {
        coolTime2 -= 1;
      }
      if (cpackage.equals("termite")){
        coolTime2 -= 0.8;
      }
    }
    else if (mousePressed && mouseButton == RIGHT) {
      if ((cpackage.equals("woodpecker") || cpackage.equals("salamander") || cpackage.equals("termite")) && ammo2 > 0) {
        coolTime2 = 100;
        ammo2--;
      }
      if (cpackage.equals("spider")) {
        coolTime2 = 100;
      }
    }
  }
  
  void collision() {
    if (location.x < 30) {
      location.x = 30;
    }
    if (location.x > fieldWidth - 30) {
      location.x = fieldWidth - 30;
    }
    if (location.y < 30) {
      location.y = 30;
    }
    if (location.y > fieldWidth - 30) {
      location.y = fieldWidth - 30;
    }
    
    for (int i=0; i<otherClients.size(); i++) {            // repel with other clients
      OtherPlayer otherClient = otherClients.get(i);
      
      PVector otherLocation = new PVector(otherClient.location.x,otherClient.location.y);
      otherLocation.sub(location);
      float distance = otherLocation.mag() - 60;
      otherLocation.normalize();
      otherLocation.mult(distance);
      
      if (distance < 0) {
        location.add(otherLocation);
      }
    }
    
    boolean inBase = false;
    for (int i=0; i<objects.size(); i++) {            // repel with other objects (walls and enemies and bases and turrets)
      Object object = objects.get(i);
      
      if (object.name.equals("wall") || object.name.equals("enemy") || object.name.equals("base") || object.name.equals("turret")) {
        PVector objectLocation = new PVector(object.location.x,object.location.y);
        objectLocation.sub(location);
        
        float distance = objectLocation.mag();
        if (object.name.equals("wall")) {
          distance -= (30 + int(extractString(object.specifics,radiusID,endID)) + 2);
        }
        else {
          if (object.name.equals("base") && !inBase) {
            if (distance < 30 + int(extractString(object.specifics,radiusID,endID)) && (extractString(object.specifics,ownerID,endID).equals(name) || object.specifics.substring(object.specifics.indexOf(iconID) + iconID.length(), object.specifics.indexOf(endID + ownerID)).equals(icon))) {
              health += 1;
              inBase = true;
              if (health > upgrade("health",100)) {
                health = round(upgrade("health",100));
              }
            }
          }
          distance -= 62;
        }
        
        objectLocation.normalize();
        objectLocation.mult(distance);
        
        if (distance < 0) {
          location.add(objectLocation);
          if (object.name.equals("enemy")) {
            health -= 2; 
          }
          
          if (health < 0) {
            health = 0;
          }
        }
      }
    }
  }
  
  void sendData() {
    String broadcast =  nameID     + name                                    + endID
                      + locationID + str(round(location.x)) + ',' + str(round(location.y)) + endID 
                      + packageID  + cpackage                                + endID
                      + healthID   + str(health)                             + endID;
                      
    if (score > -1) {
      broadcast += scoreID + str(score) + endID;
    }
    
    if (cpackage.equals("mole") || cpackage.equals("turtle")) {
      if (!(mousePressed && mouseButton == RIGHT && cpackage.equals("turtle"))) {
        broadcast += angleID + str(animationAngle) + endID;
      }
      else {
        broadcast += angleID + str(angle) + endID;
      }
    }
    else {
      broadcast += angleID + str(angle) + endID;
    }
    
    if (cpackage.equals("hedgehog") && mousePressed && mouseButton == RIGHT) {
      broadcast += alphaID + "0" + endID;
    }
    else if (cpackage.equals("turtle") && mousePressed && mouseButton == RIGHT) {
      if (score >= 30) {
        broadcast += alphaID + str(round(upgrade("shield",-30))) + endID;
      }
      else {
        broadcast += alphaID + str(round(upgrade("shield",10))) + endID;
      }
    }
    else if (cpackage.equals("termite")) {
      broadcast += alphaID + str(animationAngle) + endID;
    }
    else {
      broadcast += alphaID + "1" + endID;
    }
     
    if (!(newname.equals("TYPE USERNAME ([,],*,TAB,: are not allowed)")) && newname.length() > 0 && newNamePending) {
      broadcast += ownerID + newname + endID;
    }
      
    broadcast(broadcast,clientHD);
    
    broadcast = "";
    for (int i=0; i<objects.size(); i++) {
      if (!objects.get(i).verified) {
        broadcast += nameID + objects.get(i).name + endID + locationID + str(round(objects.get(i).location.x)) + ',' + str(round(objects.get(i).location.y)) + endID + objects.get(i).specifics;
        if (i<objects.size()-1) {
          broadcast += splitID;
        }
      }
    }
    
    broadcast(broadcast,spawnHD);
  }
  
  void changeObjects() {
    String addition = "";
    String subtractions = "";
    
    if (cpackage.equals("woodpecker")) {
      if (mousePressed) {
        if (mouseButton == LEFT && ammo1 > 0 && coolTime1 < 0.1 && !(escapeHover || chatHover || nameHover)) {
          PVector objectL;
          PVector targetL;
          PVector velocity;
          
          objectL = PVector.fromAngle(angle);
          targetL = PVector.fromAngle(angle);
          velocity = PVector.fromAngle(angle);
          
          int damage = round(upgrade("damage",10));
          
          if (score >= 25) {      
            PVector translation;
            translation = PVector.fromAngle(angle);
            if (switch1) {
              translation.rotate(PI/2);
            }
            else {
              translation.rotate(-1*PI/2);
            }
            translation.mult(20);
             
            objectL.mult(46);
            objectL.add(location);
            objectL.add(translation);
            targetL.mult(upgrade("range",300));
            targetL.add(objectL);
            velocity.mult(upgrade("speed2",5));
             
            addition = nameID + "bullet" + endID + locationID + str(round(objectL.x)) + ',' + str(round(objectL.y)) + endID + velocityID + str(round(velocity.x)) + ',' + str(round(velocity.y)) + endID + targetID + str(round(targetL.x)) + ',' + str(round(targetL.y)) + endID + damageID + damage + endID + iconID + code + endID + ownerID + name + endID;  
            
            if (switch1) {
              switch1 = false;
            }
            else {
              switch1 = true;
            }
          }
          else {
            objectL.mult(55);
            objectL.add(location);
            
            targetL.mult(upgrade("range",300));
            targetL.add(objectL);
            
            velocity.mult(upgrade("speed2",5));
            
            addition = nameID + "bullet" + endID + locationID + str(round(objectL.x)) + ',' + str(round(objectL.y)) + endID + velocityID + str(round(velocity.x)) + ',' + str(round(velocity.y)) + endID + targetID + str(round(targetL.x)) + ',' + str(round(targetL.y)) + endID + damageID + damage + endID + iconID + code + endID + ownerID + name + endID;        //name[bullet]location[X,Y]velocity[Xv,Yv]target[Xf,Yf]damage[D]icon[C]owner[player0]
          }
        }
        
        else if(mouseButton == RIGHT && coolTime2 < 0.1 && ammo2 > 0) {
          PVector objectL;
          objectL = PVector.fromAngle(angle);
          objectL.mult(55);
          objectL.add(location);
          
          int objectR = round(upgrade("range",300));
          int objectA = 350;
          
          addition = nameID + "smokescreen" + endID + locationID + str(round(objectL.x)) + ',' + str(round(objectL.y)) + endID + radiusID + objectR + endID + alphaID + objectA + endID;        //name[smokescreen]location[X,Y]radius[R]alpha[A]
        }
      }
    }
    
    if (cpackage.equals("mole")) {
      if (mousePressed) {
        if (mouseButton == LEFT && coolTime1 < 0.1 && ammo1 > 0 && !(escapeHover || chatHover || nameHover)) {
          int objectR = round(upgrade("range",50));
          int objectA = 30;
          int damage = round(upgrade("damage",5));
          
          addition = nameID + "hazardRing" + endID + locationID + str(round(location.x)) + ',' + str(round(location.y)) + endID + radiusID + str(objectR) + endID + alphaID + str(objectA) + endID + damageID + damage + endID + iconID + code + endID + ownerID + name + endID;    //name[hazardRing]location[X,Y]radius[R]alpha[A]damage[D]owner[player0]
        }
      }
    }
    
    if (cpackage.equals("salamander")) {
      if (mousePressed) {
        if (mouseButton == LEFT && coolTime1 < 0.1 && ammo1 > 0 && !(escapeHover || chatHover || nameHover)) {
          PVector objectL;
          objectL = PVector.fromAngle(angle);
          objectL.mult(40);
          objectL.add(location);
          
          int objectR = round(upgrade("range",270));
          int objectA = 500;
          int damage = round(upgrade("damage",20));
          
          addition = nameID + "detonator" + endID + locationID + str(round(objectL.x)) + ',' + str(round(objectL.y)) + endID + radiusID + objectR + endID + alphaID + objectA + endID + damageID + damage + endID + iconID + code + endID + ownerID + name + endID;  //name[detonator]location[X,Y]radius[R]alpha[A]damage[D]owner[player0] 
        }
        
        else if (mouseButton == RIGHT && coolTime2 < 0.1 && ammo2 > 0) {
          PVector objectL;
          objectL = PVector.fromAngle(angle);
          objectL.mult(40);
          objectL.add(location);
          
          PVector targetL;
          targetL = PVector.fromAngle(angle);
          targetL.mult(upgrade("range",500));
          targetL.add(objectL);
          
          PVector velocity;
          velocity = PVector.fromAngle(angle);
          velocity.mult(5);
          
          int objectR = round(upgrade("range",150));
          int damage = round(upgrade("damage",3));
          
          if (score < 201) {
            addition = nameID + "grenade" + endID + locationID + str(round(objectL.x)) + ',' + str(round(objectL.y)) + endID + velocityID + str(round(velocity.x)) + ',' + str(round(velocity.y)) + endID + targetID + str(round(targetL.x)) + ',' + str(round(targetL.y)) + endID + radiusID + objectR + endID + damageID + damage + endID + iconID + code + endID + ownerID + name + endID;        //name[grenade]location[X,Y]velocity[Xv,Yv]target[Xf,Yf]radius[R]damage[D]owner[player0]
          }
          else {
            addition = nameID + "demolition" + endID + locationID + str(round(objectL.x)) + ',' + str(round(objectL.y)) + endID + velocityID + str(round(velocity.x)) + ',' + str(round(velocity.y)) + endID + targetID + str(round(targetL.x)) + ',' + str(round(targetL.y)) + endID + radiusID + objectR + endID + damageID + damage + endID + iconID + code + endID + ownerID + name + endID;        //name[demolition]location[X,Y]velocity[Xv,Yv]target[Xf,Yf]radius[R]damage[D]owner[player0]
          }
        }
      }
    }
    
    if (cpackage.equals("spider")) {
      PVector objectL = new PVector(0,0);
      
      if (coolTime1 < 0.1 && ammo1 > 0 && !(mousePressed && mouseButton == RIGHT)) {
          objectL.set(sightLine());
          
          if (mousePressed && mouseButton == LEFT && !(escapeHover || chatHover || nameHover)) {
            int objectR = round(upgrade("range",5));
            int objectA = 1;
            int damage = round(upgrade("damage",40));
            addition = nameID + "hazardRing" + endID + locationID + str(round(objectL.x)) + ',' + str(round(objectL.y)) + endID + radiusID + str(objectR) + endID + alphaID + str(objectA) + endID + damageID + damage + endID + iconID + code + endID + ownerID + name + endID;
          }
          else if (z < 0.8 && !(round((mouseX - width/2 + camera.x)/z) == round(objectL.x) && round((mouseY - height/2 + camera.y)/z) == round(objectL.y))) {
            addition = nameID + "laserPoint" + endID + locationID + str(round(objectL.x)) + ',' + str(round(objectL.y)) + endID + alphaID + '1' + endID;
          }
      }
      else if (coolTime2 < 0.1 && mousePressed && mouseButton == RIGHT) {
        objectL = PVector.fromAngle(angle);
        objectL.mult(50);
        objectL.add(location);
        
        int objectR = round(upgrade("range",10));
        int objectA = 1;
        int damage = round(upgrade("damage",10));
        addition = nameID + "hazardRing" + endID + locationID + str(round(objectL.x)) + ',' + str(round(objectL.y)) + endID + radiusID + str(objectR) + endID + alphaID + str(objectA) + endID + damageID + damage + endID + iconID + code + endID + ownerID + name + endID;  
      }
    }
    
    if (cpackage.equals("beaver")) {
      if (mousePressed) {
        if (mouseButton == LEFT && coolTime1 < 0.1 && ammo1 > 0 && !(escapeHover || chatHover || nameHover)) {
          PVector objectL;
          objectL = PVector.fromAngle(angle);
          objectL.mult(55);
          objectL.add(location);
          
          PVector targetL;
          targetL = PVector.fromAngle(angle);
          targetL.mult(upgrade("range",350));
          targetL.add(objectL);
          
          PVector velocity;
          velocity = PVector.fromAngle(angle);
          velocity.mult(upgrade("speed2",7));
          
          int damage = round(upgrade("damage",15));
          
          if (score >= 20) {
            addition = nameID + "grenade" + endID + locationID + str(round(objectL.x)) + ',' + str(round(objectL.y)) + endID + velocityID + str(round(velocity.x)) + ',' + str(round(velocity.y)) + endID + targetID + str(round(targetL.x)) + ',' + str(round(targetL.y)) + endID + radiusID + str(150) + endID + damageID + damage + endID + iconID + code + endID + ownerID + name + endID;
          }
          else {
            addition = nameID + "bullet" + endID + locationID + str(round(objectL.x)) + ',' + str(round(objectL.y)) + endID + velocityID + str(round(velocity.x)) + ',' + str(round(velocity.y)) + endID + targetID + str(round(targetL.x)) + ',' + str(round(targetL.y)) + endID + damageID + damage + endID + iconID + code + endID + ownerID + name + endID;
          }
        }
        
        else if (mouseButton == RIGHT) {
          PVector targetL = new PVector(mouseX - width/2 + camera.x, mouseY - height/2 + camera.y);
          boolean wallFound = false;
          
          for (int i=0; i<objects.size() && !wallFound; i++) {
            if (wallFound == false) {
              Object object = objects.get(i);
              
              if (object.name.equals("wall")) {
                PVector distance = new PVector(object.location.x,object.location.y);
                distance.sub(targetL);
                int radius = int(extractString(object.specifics,radiusID,endID));
                
                if (distance.mag() < radius + 10) {
                  wallFound = true;
                  String wallData = nameID + object.name + endID + locationID + str(round(object.location.x)) + ',' + str(round(object.location.y)) + endID + radiusID + str(radius) + endID;
                  
                  if (lastTaken.equals(wallData) == false && beaverWalls.size() < floor(score/50) + 1) {
                    subtractions += wallData + splitID;
                    beaverWalls.append(wallData);
                    lastTaken = wallData;
                  }
                } 
              }
            }
          }
            
          if (!wallFound && beaverWalls.size() > 0 && (targetL.x > 0 && targetL.x < fieldWidth && targetL.y > 0 && targetL.y < fieldWidth)) {
            String newWall = replaceString(beaverWalls.get(0),str(round(targetL.x)) + ',' + str(round(targetL.y)),locationID,endID);
            addition = newWall;
            beaverWalls.remove(0);
          }
          
          mousePressed = false;
        }
      }
    }
    
    if (cpackage.equals("turtle")) {
      if (mousePressed) {
        if (mouseButton == LEFT && coolTime1 < 0.1 && ammo1 > 0 && !(escapeHover || chatHover || nameHover)) {
          int objectR = round(upgrade("range",200));
          int objectA = 30;
          int damage = round(upgrade("damage",5));
          addition = nameID + "hazardRing" + endID + locationID + str(round(location.x)) + ',' + str(round(location.y)) + endID + radiusID + str(objectR) + endID + alphaID + str(objectA) + endID + damageID + damage + endID + iconID + code + endID + ownerID + name + endID;
        }
        else if (mouseButton == RIGHT) {
          PVector shieldPoint;
          
          int shieldLength = round(upgrade("shield",10));
          if (score >= 30) {
            shieldLength = round(upgrade("shield",-30));
          }
          
          for (int i=0; i<objects.size(); i++) {
            Object object = objects.get(i);
            
            shieldPoint = PVector.fromAngle(angle);
            shieldPoint.mult(55);
            shieldPoint.add(location);
            
            if ((object.name.equals("bullet") || object.name.equals("grenade") || object.name.equals("demolition")) && !(extractString(object.specifics,ownerID,endID).equals(name))) {                      // delete touching bullets or sliding grenades. IT WORKS!!! (but only one at a time, so not always...
              PVector v = new PVector(shieldPoint.x,shieldPoint.y);
              v.sub(location);
              v.normalize();
              
              PVector onePoint = new PVector(shieldPoint.x,shieldPoint.y);
              onePoint.x += v.y * shieldLength/2;
              onePoint.y -= v.x * shieldLength/2;
              PVector twoPoint = new PVector(shieldPoint.x,shieldPoint.y);
              twoPoint.x -= v.y * shieldLength/2;
              twoPoint.y += v.x * shieldLength/2;
              
              PVector oneLine = new PVector(object.location.x,object.location.y);
              oneLine.sub(onePoint);
              PVector twoLine = new PVector(object.location.x,object.location.y);
              twoLine.sub(twoPoint);
              
              PVector oneShield = new PVector(shieldPoint.x,shieldPoint.y);
              oneShield.sub(onePoint);
              PVector twoShield = new PVector(shieldPoint.x,shieldPoint.y);
              twoShield.sub(twoPoint);
              
              float oneAngle = PVector.angleBetween(oneShield,oneLine);
              float twoAngle = PVector.angleBetween(twoShield,twoLine);
              
              if (oneAngle < PI/2 && twoAngle < PI/2) {
                shieldPoint.set(oneShield);                        // shieldPoint becomes the point where the projectile is nearest the shield. (it's shadow)
                shieldPoint.normalize();
                shieldPoint.mult(oneLine.mag() * cos(oneAngle));
                shieldPoint.add(onePoint);
                
                v.set(object.location);                            // v becomes the line between the projectile and its shadow.
                v.sub(shieldPoint);
                
                if (v.mag() < 15) {
                  subtractions += nameID + object.name + endID + locationID + str(object.location.x) + ',' + str(object.location.y) + endID + object.specifics + splitID;
                  
                  if (score >= 30) {                               //bullet and grenade deflection
                    v.set(onePoint);
                    v.sub(twoPoint);
                    
                    float[] velocityFloat = float(split(extractString(object.specifics,velocityID,endID),','));
                    PVector velocity1 = new PVector(velocityFloat[0],velocityFloat[1]);
                    
                    if (PVector.angleBetween(v,velocity1) > PI/2) {
                      v.mult(-1);
                    }
                    
                    oneAngle = PVector.angleBetween(v,velocity1);
                    
                    PVector Pvx = new PVector(v.x,v.y);
                    PVector Pvy = new PVector(velocity1.x,velocity1.y);
                    Pvx.normalize();
                    Pvx.mult(velocity1.mag() * cos(oneAngle));
                    
                    Pvy.sub(Pvx);
                    Pvy.mult(-1);
                    
                    PVector velocity2 = new PVector(Pvx.x,Pvx.y);
                    velocity2.add(Pvy);
                    
                    twoPoint.set(velocity2);
                    twoPoint.normalize();
                    twoPoint.mult(upgrade("range",100));
                    twoPoint.add(object.location);
                    
                    if (!(extractString(lastPlaced,nameID,endID).equals(object.name) && extractString(lastPlaced,locationID,endID).equals(str(object.location.x) + ',' + str(object.location.y)))) {
                      addition = nameID + object.name + endID + locationID + str(round(object.location.x)) + ',' + str(round(object.location.y)) + endID + velocityID + str(round(velocity2.x)) + ',' + str(round(velocity2.y)) + endID + targetID + str(round(twoPoint.x)) + ',' + str(round(twoPoint.y)) + endID;
                      lastPlaced = addition;
                      
                      if (object.name.equals("grenade") || object.name.equals("demolition")) {
                        addition += radiusID + extractString(object.specifics,radiusID,endID) + endID;
                      }
                      
                      addition += damageID + extractString(object.specifics,damageID,endID) + endID + iconID + code + endID + ownerID + name + endID;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    
    if (cpackage.equals("hedgehog")) {
      if (mousePressed) {
        if (mouseButton == LEFT && coolTime1 < 0.1 && ammo1 > 0 && !(escapeHover || chatHover || nameHover)) {
          PVector objectL;
          PVector velocity;
          
          objectL = PVector.fromAngle(angle);
          objectL.mult(55);
          objectL.add(location);
          
          velocity = PVector.fromAngle(angle);
          velocity.mult(upgrade("speed2",6));
          
          int radius = round(upgrade("range",300));
          int alpha = 1;
          int damage = round(upgrade("damage",30));
          
          addition = nameID + "fanshot" + endID + locationID + str(round(objectL.x)) + ',' + str(round(objectL.y)) + endID + velocityID + str(round(velocity.x)) + ',' + str(round(velocity.y)) + endID + radiusID + str(radius) + endID + alphaID + str(alpha) + endID + damageID + damage + endID + iconID + code + endID + ownerID + name + endID;    //name[fanshot]location[X,Y]velocity[X,Y]radius[R]alpha[A]damage[D]owner[]
        }
      }
    }
    
    if (cpackage.equals("termite")) {
      if (mousePressed && !(escapeHover || chatHover || nameHover)) {
        if (mouseButton == LEFT && coolTime1 < 0.1 && ammo1 > 0) {
          PVector objectL = PVector.fromAngle(angle);
          objectL.mult(60);
          objectL.add(location);
          
          PVector targetL = PVector.fromAngle(angle);
          targetL.mult(upgrade("range",300));
          targetL.add(objectL);
          
          int damage = 0;
          String objectR = "";
          
          if (score >= 40) {
            damage = round(upgrade("damage",3));
            objectR = radiusID + str(150) + endID;
          }
          else {
            damage = round(upgrade("damage",10));
          }
          int objectH = round(upgrade("health",100));
          
          addition = nameID + "turret" + endID + locationID + str(round(objectL.x)) + ',' + str(round(objectL.y)) + endID + targetID + str(round(targetL.x)) + ',' + str(round(targetL.y)) + endID + objectR + damageID + str(damage) + endID + healthID + objectH + endID + iconID + icon + endID + ownerID + name + endID;
        }
        else if (mouseButton == RIGHT && coolTime2 < 0.1 && ammo2 > 0) {
          PVector objectL = PVector.fromAngle(angle);
          objectL.mult(60);
          objectL.add(location);
          
          int radius = round(upgrade("range",180));
          
          addition = nameID + "base" + endID + locationID + str(round(objectL.x)) + ',' + str(round(objectL.y)) + endID + radiusID + str(radius) + endID + iconID + icon + endID + ownerID + name + endID;
        }
      }
    }
    
    for (int i=0; i<objects.size(); i++) {
      Object object = objects.get(i);
      
      if (object.name.equals("healthBox") || object.name.equals("ammoBox") || object.name.equals("coin") || object.name.equals("bullet") || object.name.equals("hazardRing")) {
        PVector difference = new PVector(object.location.x,object.location.y);
        difference.sub(location);
        
        int minDistance = 30;
        if (object.name.equals("bullet")) {
          minDistance += 1; 
        }
        else if (object.name.equals("hazardRing")) {
          minDistance += int(extractString(object.specifics,alphaID,endID));
        }
        else {
          minDistance += 10;
        }
        
        if (difference.mag() < minDistance && !(object.name.equals("hazardRing") && extractString(object.specifics,ownerID,endID).equals(name))) {
          if (object.name.equals("healthBox") && lastTaken.equals(nameID + object.name + endID + locationID + str(round(object.location.x)) + ',' + str(round(object.location.y)) + endID + object.specifics) == false) {
            health += 50;
            if (health > upgrade("health",100)) {
              health = round(upgrade("health",100));
            }
          }
          else if (object.name.equals("ammoBox") && lastTaken.equals(nameID + object.name + endID + locationID + str(round(object.location.x)) + ',' + str(round(object.location.y)) + endID + object.specifics) == false) {
            if (cpackage.equals("woodpecker")) {
              ammo1 = 50;
              ammo2 = 5;
            }
            else if (cpackage.equals("mole")) {
              ammo1 = 15;
            }
            else if (cpackage.equals("salamander")) {
              ammo1 = 7;
              ammo2 = 2;
            }
            else if (cpackage.equals("spider")) {
              ammo1 = 5;
            }
            else if (cpackage.equals("beaver")) {
              ammo1 = 6;
            }
            else if (cpackage.equals("turtle")) {
              ammo1 = 20;
            }
            else if (cpackage.equals("hedgehog")) {
              ammo1 = 5;
            }
            else if (cpackage.equals("termite")) {
              ammo1 = 3;
              ammo2 = 3;
            }
          }
          else if (object.name.equals("coin") && !lastTaken.equals(nameID + object.name + endID + locationID + str(int(object.location.x)) + ',' + str(int(object.location.y)) + endID + object.specifics)) {
            score += 1;
          }
          else if ((object.name.equals("bullet")|| object.name.equals("hazardRing")) && !lastTaken.equals(nameID + object.name + endID + locationID + str(object.location.x) + ',' + str(object.location.y) + endID + object.specifics)) {
            if (!extractString(object.specifics,ownerID,endID).equals(name) && (code.length() == 0 || !object.specifics.substring(object.specifics.indexOf(iconID)+iconID.length(),object.specifics.indexOf(endID+ownerID)).equals(code))) {
              health -= int(extractString(object.specifics,damageID,endID));
            }
            
            if (health < 0) {
              health = 0;
            }
          }
          
          if (!object.name.equals("hazardRing")) {
            if (object.name.equals("bullet")) {
              subtractions += nameID + object.name + endID + locationID + str(round(object.location.x)) + ',' + str(round(object.location.y)) + endID + object.specifics + splitID;
              lastTaken = nameID + object.name + endID + locationID + str(round(object.location.x)) + ',' + str(round(object.location.y)) + endID + object.specifics;
            }
            else {
              subtractions += nameID + object.name + endID + locationID + str(round(object.location.x)) + ',' + str(round(object.location.y)) + endID + object.specifics + splitID;
              lastTaken = nameID + object.name + endID + locationID + str(round(object.location.x)) + ',' + str(round(object.location.y)) + endID + object.specifics;
            }
          }
        }
      }
    }
    

    if (addition.length() > 0) {
      objects.add(new Object(addition, false));
    }

    if (subtractions.length() > 0) {
      broadcast(subtractions,deleteHD);
    }
  }
  
  void display() {
    if (cpackage.equals("woodpecker")) {
      if (bestGraphics && icon.length() == 0) {
        createButtonWoodpecker(int(location.x-camera.x+width/2),int(location.y-camera.y+height/2));
      }
      
      pushMatrix();
      fill(255);
      stroke(255);
      strokeWeight(1.5);
      translate(location.x-camera.x+width/2,location.y-camera.y+height/2);
      rotate(angle + PI/2);
      
      rectMode(CENTER);
      if (score >= 25) {
        translate(-20,0);
        if (ammo1 > 0 && switch1) {
            translate(0,5*coolTime1/100);
        }
        rect(0,-40,4,20);
        strokeWeight(2);
        line(-3,-53,3,-53);
        
        if (switch1) {
          translate(0,-5*coolTime1/100);
        }
        else if (ammo1 > 0 && switch1 == false) {
          translate(0,5*coolTime1/100);
        }
        translate(40,0);
        strokeWeight(1.5);
        rect(0,-40,4,20);
        strokeWeight(2);
        line(-3,-53,3,-53);
      }
      else {
        if (ammo1 > 0) {
          translate(0,5*coolTime1/100);
        }
        rect(0,-45,4,20);
        strokeWeight(2);
        line(-3,-58,3,-58);
      }
      popMatrix();
    }
    else if (cpackage.equals("mole")) {
      if (bestGraphics && z == 1 && icon.length() == 0) {
        createButtonMole(int(location.x-camera.x+width/2),int(location.y-camera.y+height/2));
      }
      
      pushMatrix();
      fill(255);
      stroke(255);
      strokeWeight(1);
      translate((z*location.x)-camera.x+width/2,(z*location.y)-camera.y+height/2);
      
      if (mousePressed && mouseButton == LEFT && ammo1 > 0) {
        animationAngle += 0.25;
      }
      else {
        animationAngle += 0.05;
      }
      
      if (animationAngle > 2*PI) {
          animationAngle = 0;
      }
      rotate(animationAngle);
      
      translate(0,z*-40);
      triangle(z*-7,z*7*1.75*.5,z*7,z*7*1.75*.5,0,z*-7*1.75*.5);
      translate(z*40,z*40);
      triangle(z*-7*1.75*.5,z*-7,z*-7*1.75*.5,z*7,z*7*1.75*.5,0);
      translate(z*-80,0);
      triangle(z*7*1.75*.5,z*-7,z*7*1.75*.5,z*7,z*-7*1.75*.5,0);
      translate(z*40,z*40);
      triangle(z*-7,z*-7*1.75*.5,z*7,z*-7*1.75*.5,0,z*7*1.75*.5);
      popMatrix();
    }
    else if (cpackage.equals("salamander")) {
      if (bestGraphics && icon.length() == 0) {
        createButtonSalamander(int(location.x-camera.x+width/2),int(location.y-camera.y+height/2));
      }
      
      animationAngle += 0.07;
      
      if (animationAngle > 2*PI) {
          animationAngle = 0;
      }
      
      pushMatrix();
      translate(location.x-camera.x+width/2,location.y-camera.y+height/2);
      
      if (animationAngle > PI) {
        fill(80);
      }
      else {
        fill(255);
      }
      stroke(255);
      strokeWeight(1.5);
      rotate(angle);
      translate(45,0);
      ellipseMode(CENTER);
      ellipse(0,0,10,10);
      popMatrix();
    }
    else if (cpackage.equals("spider")) {
      if (bestGraphics && z == 1 && icon.length() == 0) {
        createButtonSpider(int(location.x-camera.x+width/2),int(location.y-camera.y+height/2));
      }
      
      pushMatrix();
      fill(255);
      stroke(255);
      translate((z*location.x)-camera.x+width/2,(z*location.y)-camera.y+height/2);
      if ((mousePressed && mouseButton == RIGHT) || ammo1 == 0) {
        rotate(angle + PI/3);
      }
      else {
        rotate(angle + PI/2);
      }
      if (ammo1 > 0) {
        translate(0,z*5*coolTime1/100);
      }
      
      strokeWeight(1.5);
      line(0,z*-35,0,z*-70);
      line(z*-2,z*-66,z*2,z*-66);
      
      noStroke();
      rectMode(CENTER);
      rect(0,z*-40,z*6,z*10);
      rect(0,z*-52,z*3.5,z*14);
      popMatrix();
      
      pushMatrix();
      noFill();
      stroke(255);
      strokeWeight(1.5);
      translate((z*location.x)-camera.x+width/2,(z*location.y)-camera.y+height/2);
      if ((mousePressed && mouseButton == RIGHT) || ammo1 == 0) {
        rotate(angle);
      }
      else {
        rotate(angle + PI/6);
      }
      translate(z*5*coolTime2/100,0);
      
      beginShape();
        vertex(z*35,z*-5);
        vertex(z*45,0);
        vertex(z*35,z*5);
      endShape();
      popMatrix();
    }
    else if (cpackage.equals("beaver")) {
      if (bestGraphics && icon.length() == 0) {
        createButtonBeaver(int(location.x-camera.x+width/2),int(location.y-camera.y+height/2));
      }
      
      pushMatrix();
      fill(255);
      stroke(255);
      strokeWeight(1.5);
      translate(location.x-camera.x+width/2,location.y-camera.y+height/2);
      rotate(angle + PI/2);
      
      rectMode(CENTER);
      if (ammo1 > 0) {
        translate(0,5*coolTime1/100);
      }
      rect(0,-40,5,10);
      rect(0,-48,2,4);
      stroke(80);
      strokeWeight(1);
      line(-2.5,-37,2.5,-37);
      popMatrix();
    }
    else if (cpackage.equals("turtle")) {
      if (bestGraphics && icon.length() == 0) {
        createButtonTurtle(int(location.x-camera.x+width/2),int(location.y-camera.y+height/2));
      }
      
      animationAngle += 0.05;
      
      if (animationAngle > 2*PI) {
          animationAngle = 0;
      }
      
      pushMatrix();
      translate(location.x-camera.x+width/2,location.y-camera.y+height/2);
      noFill();
      stroke(255);
      strokeWeight(1.5);
      ellipseMode(CENTER);
      ellipse(0,0,70+(10*sin(animationAngle)),70+(10*sin(animationAngle)));
      
      if (mousePressed && mouseButton == RIGHT) {
        rotate(angle);
        strokeWeight(3);
        if (score >= 30) {
          line(55,-0.5*round(upgrade("shield",-30)),55,0.5*round(upgrade("shield",-30)));
        }
        else {
          line(55,-0.5*round(upgrade("shield",10)),55,0.5*round(upgrade("shield",10)));
        }
      }
      popMatrix();
    }
    else if (cpackage.equals("hedgehog")) {
      if (bestGraphics && z == 1 && icon.length() == 0) {
        createButtonHedgehog(int(location.x-camera.x+width/2),int(location.y-camera.y+height/2));
      }
      
      pushMatrix();
      translate(location.x-camera.x+width/2,location.y-camera.y+height/2);
      if (mousePressed && mouseButton == RIGHT) {
        fill(255,50);
        stroke(255,50);
      }
      else {
        fill(255);
        stroke(255);
      }
      strokeWeight(1.5);
      rotate(angle + PI/2);
      if (ammo1 > 0) {
        translate(0,5*coolTime1/100);
      }
      beginShape();
        vertex(-4,-35);
        vertex(4,-35);
        vertex(5,-60);
        vertex(-5,-60);
      endShape(CLOSE);
      stroke(80);
      line(-4.5,-40,4.5,-40);
      line(0,-41,0,-60);
      popMatrix();
    }
    else if (cpackage.equals("termite")) {
      if (bestGraphics && z == 1 && icon.length() == 0) {
        createButtonTermite(int(location.x-camera.x+width/2),int(location.y-camera.y+height/2));
      }
      
      if (coolTime1 > 0 || coolTime2 > 0) {
        animationAngle += 0.15;
      }
      else {
        animationAngle = 0;
      }
      
      if (animationAngle > 2*PI) {
          animationAngle = 0;
      }
      
      pushMatrix();
      translate(location.x-camera.x+width/2,location.y-camera.y+height/2);
      fill(255);
      stroke(255);
      strokeWeight(1.5);
      rotate(angle);
      translate(45,0);
      ellipseMode(CENTER);
      ellipse(0,0,10,10);
      fill(80);
      noStroke();
      ellipse(0,0,5,5);
      fill(255);
      stroke(255);
      rotate(animationAngle);
      beginShape();
        vertex(-2,-4);
        vertex(-1,-8);
        vertex(1,-8);
        vertex(2,-4);
      endShape(CLOSE);
      beginShape();
        vertex(4,-2);
        vertex(8,-1);
        vertex(8,1);
        vertex(4,2);
      endShape(CLOSE);
      beginShape();
        vertex(2,4);
        vertex(1,8);
        vertex(-1,8);
        vertex(-2,4);
      endShape(CLOSE);
      beginShape();
        vertex(-4,-2);
        vertex(-8,-1);
        vertex(-8,1);
        vertex(-4,2);
      endShape(CLOSE);
      popMatrix();
    }
    
    if (icon.length() > 0) {                                           // Format: location[X,Y]alpha[A]shape[x,y;x,y;x,y;x,y]$location[X,Y]alpha[A]ellipse[w,h]
      drawIcon(icon, location);
    }
    
    pushMatrix();
    noFill();
    if (mousePressed && mouseButton == RIGHT && cpackage.equals("hedgehog")) {
      stroke(255,50);
    }
    else {
      stroke(255);
    }
    strokeWeight(1.5);
    translate((z*location.x)-camera.x+width/2,(z*location.y)-camera.y+height/2);             //With panning camera
    ellipseMode(CENTER);
    ellipse(0,0,z*60,z*60);
    
    textFont(titleFont,int(z*12));
    textAlign(CENTER);
    if (mousePressed && mouseButton == RIGHT && cpackage.equals("hedgehog")) {
      fill(255,50);
    }
    else {
      fill(255);
    }
    translate(0,z*50);
    text(str(score),0,0);            //score
    translate(0,z*-90);
    text(name,0,0);                  //name
    popMatrix();
  }
  
    PVector sightLine() {
      PVector sightLine = new PVector((mouseX - width/2 + camera.x)/z, (mouseY - height/2 + camera.y)/z);
      sightLine.sub(location);
      
      float lineLength = sightLine.mag();
      sightLine.normalize();
      
      PVector beam = new PVector(0,0);
      int i=0;
      float skipCount = 2.5;
      boolean obstructed = false;
      
      while (obstructed == false && (i*skipCount)<lineLength) {
        beam.set(location);
        beam.x += (sightLine.x * i * skipCount);
        beam.y += (sightLine.y * i * skipCount);
        
        for (int j=0; j<objects.size(); j++) {        //Check if there is a wall/enemy/base/turret obstruction.
          if (obstructed == false) {
            Object object = objects.get(j);
            int objectRadius = 30;
            if (object.name.equals("wall")) {
              objectRadius = int(extractString(object.specifics,radiusID,endID));
            }
            
            if (object.name.equals("wall") || object.name.equals("enemy") || object.name.equals("base") || object.name.equals("turret")) {            
              PVector gap = new PVector(object.location.x,object.location.y);
              gap.sub(beam);
              
              if (!(gap.mag() > objectRadius+(skipCount))) {
                obstructed = true;
              }
            }
          }
        }
        
        for (int j=0; j<otherClients.size(); j++) {  //Check for client obstruction
          if (obstructed == false) {
            OtherPlayer other = otherClients.get(j);
            
            PVector gap = new PVector(other.location.x,other.location.y);
            gap.sub(beam);
            
            if (!(gap.mag() > 30+(skipCount))) {
              obstructed = true;
            }
          }
        }
        
        i += skipCount;
      }
      
      if (obstructed == false) {
        if (z < 0.8 && bestGraphics) {
          sightLine.mult(55);
          sightLine.add(location);
          
          pushMatrix();
          translate(0,0);
          stroke(255,255,255,70);
          strokeWeight(1);
          line((z*sightLine.x)-camera.x+width/2,(z*sightLine.y)-camera.y+height/2,mouseX,mouseY);
          popMatrix();
          
          sightLine.sub(location);
        }
        
        sightLine.normalize();
        sightLine.mult(lineLength);
        sightLine.add(location);
      }
      else {
        PVector startPoint = new PVector(location.x,location.y);
        sightLine.mult(55);
        startPoint.add(sightLine);
        
        sightLine.normalize();
        sightLine.mult(i*skipCount);
        sightLine.add(location);
        
        if (z < 0.8 && bestGraphics) {
          pushMatrix();
          translate(0,0);
          stroke(255,255,255,70);
          strokeWeight(1);
          line((z*startPoint.x)-camera.x+width/2,(z*startPoint.y)-camera.y+height/2,(z*sightLine.x)-camera.x+width/2,(z*sightLine.y)-camera.y+height/2);
          popMatrix(); 
        }
      }
      
      return sightLine;
    }
    
  void displayGraphs() {
    if (mouseX < 100 && mouseY < 100) {
      pushMatrix();
      textFont(infohelpFont,20);
      textAlign(LEFT);
      rectMode(LEFT);
      fill(180,0,0);
      noStroke();
      
      translate(25,25);
      rect(0,-15,health,5);
      text(str(health),health + 5,0);
      
      fill(80,220,0);
      translate(0,25);
      rect(0,-15,ammo1*6,5);
      text(str(ammo1),ammo1*6 + 5,0);
      
      translate(0,25);
      rect(0,-15,ammo2*6,5);
      text(str(ammo2),ammo2*6 + 5,0);
      
      fill(200);
      translate(0,25);
      text("fieldWidth:  " + fieldWidth,5,0);
      popMatrix();
    }
  }
}

class OtherPlayer {
  String name;
  int score;
  PVector location;
  float angle;
  String cpackage;
  int alpha;
  String otherIcon;
  
  OtherPlayer(String data) {
    name = extractString(data,nameID,endID);
    score = int(extractString(data,scoreID,endID));
    
    String locationString = extractString(data,locationID,endID);
    float[] locationFloat = float(split(locationString,','));
    location = new PVector(locationFloat[0],locationFloat[1]);
    
    angle = float(extractString(data,angleID,endID));
    cpackage = extractString(data,packageID,endID);
    
    alpha = int(extractString(data,alphaID,endID));
    
    otherIcon = data.substring(data.indexOf(iconID) + iconID.length(), data.indexOf(endID + ownerID));
  }
  
  void display() {
    if ((cpackage.equals("termite") || alpha > 0) && (((z*location.x)-myClient.camera.x+width/2 > -400 && (z*location.x)-myClient.camera.x+width/2 < width+400) && ((z*location.y)-myClient.camera.y+height/2 > -400 && (z*location.y)-myClient.camera.y+height/2 < height+400))) {
      if (cpackage.equals("woodpecker")) {
        if (bestGraphics && z == 1 && otherIcon.length() == 0) {
          createButtonWoodpecker(int(location.x)-int(myClient.camera.x)+width/2,int(location.y)-int(myClient.camera.y)+height/2);
        }
        
        pushMatrix();
        fill(255);
        stroke(255);
        strokeWeight(1.5);
        translate((z*location.x)-myClient.camera.x+width/2,(z*location.y)-myClient.camera.y+height/2);
        rotate(angle + PI/2);
        
        rectMode(CENTER);
        if (score >= 25) {
          translate(-20,0);
          rect(0,z*-40,z*4,z*20);
          strokeWeight(2);
          line(z*-3,z*-53,z*3,z*-53);
          
          translate(40,0);
          strokeWeight(1.5);
          rect(0,z*-40,z*4,z*20);
          strokeWeight(2);
          line(z*-3,z*-53,z*3,z*-53);
        }
        else {
          rect(0,z*-45,z*4,z*20);
          strokeWeight(2);
          line(z*-3,z*-58,z*3,z*-58); 
        }
        popMatrix();
      }
      else if (cpackage.equals("mole")) {
        if (bestGraphics && z == 1 && otherIcon.length() == 0) {
          createButtonMole(int(location.x)-int(myClient.camera.x)+width/2,int(location.y)-int(myClient.camera.y)+height/2);
        }
        
        pushMatrix();
        fill(255);
        stroke(255);
        strokeWeight(1);
        translate((z*location.x)-myClient.camera.x+width/2,(z*location.y)-myClient.camera.y+height/2);
        rotate(angle);
        
        translate(0,z*-40);
        triangle(z*-7,z*7*1.75*.5,z*7,z*7*1.75*.5,0,z*-7*1.75*.5);
        translate(z*40,z*40);
        triangle(z*-7*1.75*.5,z*-7,z*-7*1.75*.5,z*7,z*7*1.75*.5,0);
        translate(z*-80,0);
        triangle(z*7*1.75*.5,z*-7,z*7*1.75*.5,z*7,z*-7*1.75*.5,0);
        translate(z*40,z*40);
        triangle(z*-7,z*-7*1.75*.5,z*7,z*-7*1.75*.5,0,z*7*1.75*.5);
        popMatrix();
      }
      else if (cpackage.equals("salamander")) {
        if (bestGraphics && z == 1 && otherIcon.length() == 0) {
          createButtonSalamander(int(location.x)-int(myClient.camera.x)+width/2,int(location.y)-int(myClient.camera.y)+height/2);
        }
        
        pushMatrix();
        translate((z*location.x)-myClient.camera.x+width/2,(z*location.y)-myClient.camera.y+height/2);
        
        if (angle > PI) {
          fill(80);
        }
        else {
          fill(255);
        }
        stroke(255);
        strokeWeight(1.5);
        rotate(angle);
        translate(z*45,0);
        ellipseMode(CENTER);
        ellipse(0,0,z*10,z*10);
        popMatrix();
      }
      else if (cpackage.equals("spider")) {
        if (bestGraphics && z == 1 && otherIcon.length() == 0) {
          createButtonSpider(int(location.x)-int(myClient.camera.x)+width/2,int(location.y)-int(myClient.camera.y)+height/2);
        }
        
        pushMatrix();
        fill(255);
        stroke(255);
        translate((z*location.x)-myClient.camera.x+width/2,(z*location.y)-myClient.camera.y+height/2);
        rotate(angle + PI/2);
        
        strokeWeight(1.5);
        line(0,z*-35,0,z*-70);
        line(z*-2,z*-66,z*2,z*-66);
        
        noStroke();
        rectMode(CENTER);
        rect(0,z*-40,z*6,z*10);
        rect(0,z*-52,z*3.5,z*14);
        popMatrix();
      }
      else if (cpackage.equals("beaver")) {
        if (bestGraphics && z == 1 && otherIcon.length() == 0) {
          createButtonBeaver(int(location.x)-int(myClient.camera.x)+width/2,int(location.y)-int(myClient.camera.y)+height/2);
        }
        
        pushMatrix();
        fill(255);
        stroke(255);
        strokeWeight(1.5);
        translate((z*location.x)-myClient.camera.x+width/2,(z*location.y)-myClient.camera.y+height/2);
        rotate(angle + PI/2);
        
        rectMode(CENTER);
        rect(0,z*-40,z*5,z*10);
        rect(0,z*-48,z*2,z*4);
        
        stroke(80);
        strokeWeight(1);
        line(z*-2.5,z*-37,z*2.5,z*-37);
        popMatrix();
      }
      else if (cpackage.equals("turtle")) {
        if (bestGraphics && z == 1 && otherIcon.length() == 0) {
          createButtonTurtle(int(location.x)-int(myClient.camera.x)+width/2,int(location.y)-int(myClient.camera.y)+height/2);
        }
        
        pushMatrix();
        translate((z*location.x)-myClient.camera.x+width/2,(z*location.y)-myClient.camera.y+height/2);
        noFill();
        stroke(255);
        
        if (alpha < 10) {
          strokeWeight(1.5);
          ellipseMode(CENTER);
          ellipse(0,0,z*(70+(10*sin(angle))),z*(70+(10*sin(angle))));
        }
        else {
          rotate(angle);
          strokeWeight(z*3);
          line(z*55,z*-0.5*alpha,z*55,z*0.5*alpha);
        }
        popMatrix();
      }
      else if (cpackage.equals("hedgehog")) {
        if (bestGraphics && z == 1 && otherIcon.length() == 0) {
          createButtonHedgehog(int(location.x)-int(myClient.camera.x)+width/2,int(location.y)-int(myClient.camera.y)+height/2);
        }
        
        pushMatrix();
        translate(z*(location.x)-myClient.camera.x+width/2,z*(location.y)-myClient.camera.y+height/2);
        fill(255);
        stroke(255);
        strokeWeight(1.5);
        rotate(angle + PI/2);
  
        beginShape();
          vertex(z*-4,z*-35);
          vertex(z*4,z*-35);
          vertex(z*5,z*-60);
          vertex(z*-5,z*-60);
        endShape(CLOSE);
        
        stroke(80);
        line(z*-4.5,z*-40,z*4.5,z*-40);
        line(0,z*-41,0,z*-60);
        popMatrix();
      }
      else if (cpackage.equals("termite")) {
        if (bestGraphics && z == 1 && otherIcon.length() == 0) {
          createButtonTermite(int(location.x-myClient.camera.x+width/2),int(location.y-myClient.camera.y+height/2));
        }
        
        pushMatrix();
        translate(location.x-myClient.camera.x+width/2,location.y-myClient.camera.y+height/2);
        fill(255);
        stroke(255);
        strokeWeight(1.5);
        rotate(angle);
        translate(45,0);
        ellipseMode(CENTER);
        ellipse(0,0,z*10,z*10);
        fill(80);
        noStroke();
        ellipse(0,0,z*5,z*5);
        fill(255);
        stroke(255);
        rotate(alpha);
        beginShape();
          vertex(z*-2,z*-4);
          vertex(z*-1,z*-8);
          vertex(z*1,z*-8);
          vertex(z*2,z*-4);
        endShape(CLOSE);
        beginShape();
          vertex(z*4,z*-2);
          vertex(z*8,z*-1);
          vertex(z*8,z*1);
          vertex(z*4,z*2);
        endShape(CLOSE);
        beginShape();
          vertex(z*2,z*4);
          vertex(z*1,z*8);
          vertex(z*-1,z*8);
          vertex(z*-2,z*4);
        endShape(CLOSE);
        beginShape();
          vertex(z*-4,z*-2);
          vertex(z*-8,z*-1);
          vertex(z*-8,z*1);
          vertex(z*-4,z*2);
        endShape(CLOSE);
        popMatrix();
      }
      
      if (otherIcon.length() > 0 && z == 1) {                                           // Format: location[X,Y]alpha[A]shape[x,y;x,y;x,y;x,y]$location[X,Y]alpha[A]ellipse[w,h]
        drawIcon(otherIcon, location);
      }
  
      pushMatrix();
      noFill();
      stroke(255);
      strokeWeight(1.5);
      translate((z*location.x)-myClient.camera.x+width/2,(z*location.y)-myClient.camera.y+height/2);             //With panning camera
      ellipseMode(CENTER);
      ellipse(0,0,z*60,z*60);
      
      textFont(titleFont,int(z*12));
      textAlign(CENTER);
      fill(255);
      translate(0,z*50);
      text(str(score),0,0);            //score
      translate(0,z*-90);
      text(name,0,0);                  //name
      popMatrix();
    }
  }
}