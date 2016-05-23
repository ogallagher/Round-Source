class Tower {
  PVector location;
  PVector target;   //Beacons don't really need targets, right? Beacons actually just need to sit still... like regular objects.
  int radius;
  String icon;
  
  Tower(int[] loc, String icn) {
    location = new PVector(loc[0],loc[1]);
    target = new PVector();
    icon = icn;
  }
}

class Turret extends Tower {
  int damage;
  
  Turret(int[] loc, int[] tar, int dam, String icn) {
    super(loc,icn);
    
    damage = dam;
    PVector magnitude = new PVector(tar[0],tar[1]);
    magnitude.sub(location);
    radius = round(magnitude.mag());
  }
  
  void aim() {
    for (int i=0; i<clientList.size(); i++) {
      String client = clientList.get(i);
      if (!extractString(client,iconID,endID).equals(icon)) {
        
      }
    }
  }

  void fire() {
    PVector bLocation = new PVector(target.x,target.y);
    bLocation.sub(location);
    bLocation.normalize();
    bLocation.mult(55);
    bLocation.add(location);

    String bullet = nameID + "bullet" + endID + locationID + str(round(bLocation.x)) + ',' + str(round(bLocation.y)) + endID;//...
  }
}

class Beacon extends Tower {
  Beacon(int[] loc, int rad, String icn) {
    super(loc,icn);
    
    radius = rad;
  }
  
  void aim() {
    for (int i=0; i<clientList.size(); i++) {
      String client = clientList.get(i);
      if (extractString(client,iconID,endID).equals(icon)) {
        
      }
    }
  }
}
