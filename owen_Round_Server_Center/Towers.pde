class Tower {        //Turrets and ¿Foggers? and ¿Coiners?
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
  boolean targetFound;
  
  Turret(int[] loc, int[] tar, int dam, int hth, String icn) {
    super(loc,hth,icn);
    
    damage = dam;
    timer = 0;
    targetFound = false;
    
    PVector magnitude = new PVector(tar[0],tar[1]);
    magnitude.sub(location);
    radius = round(magnitude.mag());
  }
  
  void aim() {
    targetFound = false;
    
    for (int i=0; i<clientList.size(); i++) {
      String client = clientList.get(i);
      
      if (!extractString(client,iconID,endID).equals(icon)) {
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
    
    if (targetFound) {
      target.normalize();
      target.mult(radius);
    }
  }

  void shoot() {
    PVector bLocation = new PVector(target.x,target.y);
    bLocation.sub(location);
    bLocation.normalize();
    bLocation.mult(55);
    bLocation.add(location);

    String bullet = nameID + "bullet" + endID + locationID + str(round(bLocation.x)) + ',' + str(round(bLocation.y)) + endID + velocityID + str(6) + ',' + str(6) + endID + targetID + str(round(target.x)) + ',' + str(round(target.y)) + endID + damageID + str(damage) + endID + iconID + icon + endID;
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
    
  }
}

void updateTurrets() {
  for (int i=0; i<turretList.size(); i++) {
    Turret turret = turretList.get(i);
    
    turret.aim();
    if (turret.timer == 0 && turret.targetFound) {
      turret.shoot();
    }
    turret.time();
  }
}