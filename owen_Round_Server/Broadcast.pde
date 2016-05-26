void broadcastClientList() {
  String broadcast = "";
  
  for (int i=0; i<clientList.size(); i++) {
    broadcast += clientList.get(i);
  }
  
  broadcast(broadcast , clientHD, "all");
}

void broadcastObjectList() {
  String broadcast = "";
  
  for (int i=0; i<objectList.size(); i++) {
    int[] location = int(split(extractString(objectList.get(i),locationID,endID),','));
    
    if ((location[0] > viewLimits[0] && location[0] < viewLimits[1]) && (location[1] > viewLimits[2] && location[1] < viewLimits[3])) {
      broadcast += objectList.get(i);
    }
  }
  
  for (int i=0; i<enemyList.size(); i++) {
    Enemy enemy = enemyList.get(i);
    
    if ((enemy.location.x > viewLimits[0] && enemy.location.x < viewLimits[1]) && (enemy.location.y > viewLimits[2] && enemy.location.y < viewLimits[3])) {
      String angle = str(enemy.angle);
      
      if (enemy.cpackage.equals("turtle")) {
        angle = str(enemy.animationAngle);
      }
      
      broadcast += nameID + "enemy" + endID + locationID + str(round(enemy.location.x)) + ',' + str(round(enemy.location.y)) + endID + angleID + angle + endID + packageID + enemy.cpackage + endID;
    }
  }
  
  for (int i=0; i<turretList.size(); i++) {
    Turret turret = turretList.get(i);
    
    if ((turret.location.x > viewLimits[0] && turret.location.x < viewLimits[1]) && (turret.location.y > viewLimits[2] && turret.location.y < viewLimits[3])) {
      broadcast += nameID + "turret" + endID + locationID + str(round(turret.location.x)) + ',' + str(round(turret.location.y)) + endID + targetID + str(turret.target.x) + ',' + str(turret.target.y) + endID + iconID + turret.icon + endID + ownerID + turret.owner + endID;
    }
  }
  
  broadcast(broadcast, objectHD, "all");
}