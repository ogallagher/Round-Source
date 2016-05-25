class Tower {        //Turrets and ¿Foggers?
  PVector location;
  PVector target;
  int radius;
  int health;
  String icon;
  
  Tower(int[] loc, int hth, String icn) {
    location = new PVector(loc[0],loc[1]);
    target = new PVector();
    icon = icn;
    health = hth;
    radius = 0;
  }
}

class Turret extends Tower {
  int damage;
  int timer;
  String owner;
  boolean targetFound;
  
  Turret(int[] loc, int[] tar, int dam, int hth, String icn, String own) {
    super(loc,hth,icn);
    
    target.set(tar[0],tar[1]);
    damage = dam;
    timer = 0;
    owner = own;
    targetFound = false;
    
    PVector magnitude = new PVector(tar[0],tar[1]);
    magnitude.sub(location);
    radius = round(magnitude.mag());
  }
  
  void aim() {
    target.sub(location);
    targetFound = false;
    
    for (int i=0; i<clientList.size(); i++) {
      String client = clientList.get(i);
      
      if ((!extractString(client,iconID,endID).equals(icon) || extractString(client,iconID,endID).length() == 0) && !extractString(client,nameID,endID).equals(owner)) {
        PVector difference = new PVector();
        int[] clientL = int(split(extractString(client,locationID,endID),','));
        
        difference.set(clientL[0],clientL[1]);
        difference.sub(location);
        
        if (difference.mag() < target.mag()) {
          target.set(difference);
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
          targetFound = true;
        }
      }
    }
    
    if (targetFound) {
      target.normalize();
      target.mult(radius);
      target.add(location);
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

    String bullet = nameID + "bullet" + endID + locationID + str(round(bLocation.x)) + ',' + str(round(bLocation.y)) + endID + velocityID + str(round(velocity.x)) + ',' + str(round(velocity.y)) + endID + targetID + str(round(target.x)) + ',' + str(round(target.y)) + endID + damageID + str(damage) + endID + iconID + icon + endID;
    objectList.append(bullet);
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
    for (int i=0; i<objectList.size(); i++) {                                           // react with and delete coins/ammoBoxes/healthBoxes/bullets/hazardRings
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
          if (extractString(object,nameID,endID).equals("bullet") || extractString(object,nameID,endID).equals("hazardRing")) {
            health -= int(extractString(object,damageID,endID));
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