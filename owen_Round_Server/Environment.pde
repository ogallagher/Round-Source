void createEnvironment() {         
  for (int i=0; i < 100; i++) {
    String location = str(int(random(50,fieldWidth-50))) + ',' + str(int(random(50,fieldWidth-50)));
    String radius = str(int(random(10,120)));
    
    spawn(nameID + "wall" + endID + locationID + location + endID + radiusID + radius + endID);
  }
}

void spawn(String objectData) {
  boolean processed = false;
  int movedObject = -1;
  String name = extractString(objectData,nameID,endID);
  int[] location = int(split(extractString(objectData,locationID,endID),','));
  
  for (int i=0; i<objectList.size(); i++) {
    String testObject = objectList.get(i);
    String nameTest = extractString(testObject,nameID,endID);
    int[] locationTest = int(split(extractString(testObject,locationID,endID),','));
    
    if (name.equals(nameTest)) {
      if (name.equals("wall") || name.equals("hazardRing") || name.equals("detonator") || name.equals("smokeScreen") || name.equals("laserPoint") || name.equals("fanshot") || name.equals("base")) {
        if (location[0] == locationTest[0] && location[1] == locationTest[1]) {
          processed = true;
        }
      }
      else {
        int[] target = int(split(extractString(objectData,targetID,endID),','));
        int[] targetTest = int(split(extractString(testObject,targetID,endID),','));
        
        if (target.length > 1 && targetTest.length > 1 && target[0] == targetTest[0] && target[1] == targetTest[1]) {
          processed = true;
        }
      }
    }
    else if (name.equals("wall") && (nameTest.equals("ammoBox") || nameTest.equals("healthBox") || nameTest.equals("coin"))){
      int radius = int(extractString(objectData,radiusID,endID));
      PVector difference = new PVector(locationTest[0],locationTest[1]);
      difference.sub(location[0],location[1]);
      
      if (difference.mag() < radius + 20) {
        difference.normalize();
        difference.mult(radius + 20);
        
        difference.x += location[0];
        difference.y += location[1];
        objectList.set(i,replaceString(testObject,str(int(difference.x)) + ',' + str(int(difference.y)),locationID,endID));
        
        movedObject = i;
      }
    }
  }
  
  if (!processed) {
    if (name.equals("turret")) {
      for (int i=0; i<turretList.size() && !processed; i++) {
        if (location[0] == round(turretList.get(i).location.x) && location[1] == round(turretList.get(i).location.y)) {
          processed = true;
        }
      }
      
      if (!processed) {
        turretList.add(new Turret(location,int(split(extractString(objectData,targetID,endID),',')),int(extractString(objectData,damageID,endID)),int(extractString(objectData,healthID,endID)),objectData.substring(objectData.indexOf(iconID)+iconID.length(),objectData.indexOf(endID+ownerID)),extractString(objectData,ownerID,endID)));
      }
    }
    else {
      objectList.append(objectData);
    }
  }
  
  if (movedObject > -1) {
    location = int(split(extractString(objectList.get(movedObject),locationID,endID),','));
    boolean inWall = true;
    
    while (inWall) {
      boolean currentInWall = false;
      
      for (int i=0; i<objectList.size() && !currentInWall; i++) {
        if (extractString(objectList.get(i),nameID,endID).equals("wall")) {
          int[] difference = int(split(extractString(objectList.get(i),locationID,endID),','));
          difference[0] -= location[0];
          difference[1] -= location[1];
          
          if (sqrt(pow(difference[0],2) + pow(difference[1],2)) < int(extractString(objectList.get(i),radiusID,endID))) {
            currentInWall = true; 
            
            PVector change = new PVector(difference[0],difference[1]);
            change.mult(-1);
            change.normalize();
            change.mult(int(extractString(objectList.get(i),radiusID,endID)) + 20);
            
            location[0] += difference[0] + round(change.x);
            location[1] += difference[1] + round(change.y);
          }
        }
      }
      
      if (!currentInWall) {
        inWall = false;
      }
    }
    
    objectList.set(movedObject,replaceString(objectList.get(movedObject),str(location[0]) + ',' + str(location[1]),locationID,endID));
  }
}

void delete(String objectData) {
  for (int i=0; i<objectList.size(); i++) {
    String testObject = objectList.get(i);
    if ((extractString(objectData,nameID,endID).equals("bullet") && extractString(testObject,nameID,endID).equals("bullet")) || (extractString(objectData,nameID,endID).equals("grenade") && extractString(testObject,nameID,endID).equals("grenade")) || (extractString(objectData,nameID,endID).equals("demolition") && extractString(testObject,nameID,endID).equals("demolition"))) {
      String objectVelocity = extractString(objectData,velocityID,endID);
      String testVelocity = extractString(testObject,velocityID,endID);
      String objectTarget = extractString(objectData,targetID,endID);
      String testTarget = extractString(testObject,targetID,endID);
      String objectOwner = extractString(objectData,ownerID,endID);
      String testOwner = extractString(testObject,ownerID,endID);
      
      if (objectVelocity.equals(testVelocity) && objectTarget.equals(testTarget) && objectOwner.equals(testOwner)) {
        objectList.remove(i);
      }
    }
    else if (testObject.equals(objectData)) {
      objectList.remove(i);
    }
  }
}

void updateEnvironment() {
  for (int i=0; i<objectList.size(); i++) {
    String object = objectList.get(i);
    String objectName = extractString(object,nameID,endID);
    
    if (objectName.equals("bullet")) {                                                //Move bullets. Delete bullets which hit walls.
      int[] location = int(split(extractString(object,locationID,endID),','));
      int[] velocity = int(split(extractString(object,velocityID,endID),','));
      int[] target =   int(split(extractString(object,targetID,endID),','));

      boolean touching = false;
                                            //Check if bullet has gone past target point.
      target[0] -= location[0];
      target[1] -= location[1];
      PVector PTarget = new PVector(target[0],target[1]);
      PVector PVelocity = new PVector(velocity[0],velocity[1]);
      
      PTarget.normalize();
      PVelocity.normalize();
      float tAngle = PTarget.heading();
      float vAngle = PVelocity.heading();
      
      if (abs(tAngle-vAngle) > PI*0.5) {
        touching = true;
      }
      else {
        for (int j=0; j<objectList.size(); j++) {  //Check if bullet hits a wall.
          if (touching == false) {
            String other = objectList.get(j);
            String otherName = extractString(other,nameID,endID);
            
            if (otherName.equals("wall")) {
              int[] otherLocation = int(split(extractString(other,locationID,endID),','));
              int otherRadius = int(extractString(other,radiusID,endID));
              
              PVector bLocation = new PVector(location[0],location[1]);
              PVector wLocation = new PVector(otherLocation[0],otherLocation[1]);
              wLocation.sub(bLocation);
              
              float bwDistance = wLocation.mag();
              
              if (bwDistance < otherRadius) {
                touching = true;
              }
            }
          }
        }
      }
      
      if (touching == false) {
        location[0] += velocity[0];
        location[1] += velocity[1];
        
        object = replaceString(object,str(location[0]) + ',' + str(location[1]),locationID,endID);
        objectList.set(i,object);
      }
      else {
        objectList.remove(i);
        i--;
      }
    }
    
    if (objectName.equals("smokescreen")) {
      int alpha = int(extractString(object,alphaID,endID));
      if (alpha > 10) {
        alpha --;
        object = replaceString(object,str(alpha),alphaID,endID);
        objectList.set(i,object);
      }
      else {
        objectList.remove(i);
        i--;
      }
    }
    
    if (objectName.equals("detonator")) {                      
      int alpha = int(extractString(object,alphaID,endID));
      String owner = extractString(object,ownerID,endID);
      int radius = int(extractString(object,radiusID,endID));
      int[] locationInt = int(split(extractString(object,locationID,endID),','));
      
      for (int j=0; j<objectList.size(); j++) { 
        if (alpha > -1) {
          String other = objectList.get(j);
          String otherName = extractString(other,nameID,endID);
          
          if (otherName.equals("bullet") || otherName.equals("grenade") || otherName.equals("demolition") || otherName.equals("hazardRing")) {         //Detonate if touching bullet or grenade or hazardRing
            int otherRadius = 1;
            if (otherName.equals("hazardRing")) {
              otherRadius = int(extractString(other,alphaID,endID));
            }
            
            int[] otherLocation = int(split(extractString(other,locationID,endID),','));
            PVector difference = new PVector(otherLocation[0],otherLocation[1]);
            difference.sub(locationInt[0],locationInt[1]);
            
            if (difference.mag() < 15 + otherRadius) {
              alpha = -1;
            }
          }
        }
      }
      for (int j=0; j<clientList.size(); j++) {                                                                     //Detonate if touching client
        if (alpha > -1) {
          String other = clientList.get(j);
          int[] otherLocation = int(split(extractString(other,locationID,endID),','));
          
          PVector difference = new PVector(otherLocation[0],otherLocation[1]);
          difference.sub(locationInt[0],locationInt[1]);
                    
          if (difference.mag() < 33) {
            alpha = -1;
          }
        }
      }
      for (int j=0; j<enemyList.size(); j++) {                                                                     //Detonate if touching enemy
        if (alpha > -1) {
          Enemy other = enemyList.get(j);
          
          PVector difference = new PVector(other.location.x,other.location.y);
          difference.sub(locationInt[0],locationInt[1]);
                    
          if (difference.mag() < 33) {
            alpha = -1;
          }
        }
      }
      
      if (alpha > -1) {                                              //Detonate
        alpha--;
   
        object = replaceString(object,str(alpha),alphaID,endID);
        objectList.set(i,object);
      }
      else {
        objectList.remove(i);
        
        String newObject = "";
        PVector location = new PVector(locationInt[0],locationInt[1]);
        PVector target = new PVector(0,0);
        PVector velocity = new PVector(0,0);
        
        target.set(location);
        target.y -= radius;
        velocity.set(0,-7);
        
        newObject = nameID + "bullet" + endID + locationID + str(round(location.x)) + ',' + str(round(location.y)) + endID + velocityID + str(round(velocity.x)) + ',' + str(round(velocity.y)) + endID + targetID + str(round(target.x)) + ',' + str(round(target.y)) + endID + damageID + extractString(object,damageID,endID) + endID + ownerID + owner + endID;
        spawn(newObject);
        
        target.set(location);
        target.x += radius;
        velocity.set(7,0);
        
        newObject = replaceString(newObject,str(round(location.x)) + ',' + str(round(location.y)),locationID,endID);
        newObject = replaceString(newObject,str(round(velocity.x)) + ',' + str(round(velocity.y)),velocityID,endID);
        newObject = replaceString(newObject,str(round(target.x)) + ',' + str(round(target.y)),targetID,endID);
        spawn(newObject);
        
        target.set(location);
        target.y += radius;
        velocity.set(0,7);
        
        newObject = replaceString(newObject,str(round(location.x)) + ',' + str(round(location.y)),locationID,endID);
        newObject = replaceString(newObject,str(round(velocity.x)) + ',' + str(round(velocity.y)),velocityID,endID);
        newObject = replaceString(newObject,str(round(target.x)) + ',' + str(round(target.y)),targetID,endID);
        spawn(newObject);
        
        target.set(location);
        target.x -= radius;
        velocity.set(-7,0);
        
        newObject = replaceString(newObject,str(round(location.x)) + ',' + str(round(location.y)),locationID,endID);
        newObject = replaceString(newObject,str(round(velocity.x)) + ',' + str(round(velocity.y)),velocityID,endID);
        newObject = replaceString(newObject,str(round(target.x)) + ',' + str(round(target.y)),targetID,endID);
        spawn(newObject);
      }
    }
    
    if (objectName.equals("grenade") || objectName.equals("demolition")) {
      String owner = extractString(object,ownerID,endID);
      int radius = int(extractString(object,radiusID,endID));
      int[] locationInt = int(split(extractString(object,locationID,endID),','));
      int[] velocityInt = int(split(extractString(object,velocityID,endID),','));
      int[] targetInt =   int(split(extractString(object,targetID,endID),','));
      
      boolean touching = false;
      
      targetInt[0] -= locationInt[0];                                                  //Explode if grenade passes target range
      targetInt[1] -= locationInt[1];
      PVector PTarget = new PVector(targetInt[0],targetInt[1]);
      PVector PVelocity = new PVector(velocityInt[0],velocityInt[1]);
      
      PTarget.normalize();
      PVelocity.normalize();
      float tAngle = PTarget.heading();
      float vAngle = PVelocity.heading();
      
      if (abs(tAngle-vAngle) > PI*0.5) {
        touching = true;
      }
      
      if (touching == false) {
        PVector location = new PVector(locationInt[0],locationInt[1]);
        
        for (int j=0; j<objectList.size(); j++) { 
          if (touching == false) {
            String other = objectList.get(j);
            String otherName = extractString(other,nameID,endID);
            
            if (otherName.equals("bullet") || otherName.equals("wall") || otherName.equals("hazardRing") || otherName.equals("base")) {                     //Explode if touching bullet or wall
              int[] otherLocation = int(split(extractString(other,locationID,endID),','));
              int otherRadius;
              
              if (otherName.equals("base")) {
                otherRadius = 30;
              }
              else if (otherName.equals("hazardRing")) {
                otherRadius = int(extractString(other,alphaID,endID));
              }
              else if (otherName.equals("wall")) {
                otherRadius = int(extractString(other,radiusID,endID));
              }
              else {
                otherRadius = 2;
              }
              
              PVector oLocation = new PVector(otherLocation[0],otherLocation[1]);
              oLocation.sub(location);
              
              float distance = oLocation.mag();
              if (distance < 15 + otherRadius) {
                touching = true;
                if (otherName.equals("wall") && objectName.equals("demolition")) {
                  if (otherRadius > 15) {
                    otherRadius -= 10;
                    other = replaceString(other,str(otherRadius),radiusID,endID);
                    objectList.set(j,other);
                  }
                  else {
                    objectList.remove(j);
                  }
                }
              }
            }
          }
        }
        for (int j=0; j<clientList.size(); j++) {                                           //Explode if touching client
          if (touching == false) {
            String other = clientList.get(j);
            int[] otherLocation = int(split(extractString(other,locationID,endID),','));
            
            PVector oLocation = new PVector(otherLocation[0],otherLocation[1]);
            oLocation.sub(location);
            
            float distance = oLocation.mag();
            
            if (distance < 33) {
              touching = true;
            }
          }
        }
        for (int j=0; j<enemyList.size(); j++) {                                             //Detonate if touching enemy
          if (touching == false) {
            Enemy other = enemyList.get(j);
            
            PVector difference = new PVector(other.location.x,other.location.y);
            difference.sub(locationInt[0],locationInt[1]);
                        
            if (difference.mag() < 33) {
              touching = true;
            }
          }
        }
        for (int j=0; j<turretList.size(); j++) {                                            //Detonate if touching turret
          if (touching == false) {
            Turret other = turretList.get(j);
            
            PVector difference = new PVector(other.location.x,other.location.y);
            difference.sub(locationInt[0],locationInt[1]);
            
            if (difference.mag() < 33) {
              touching = true;
            }
          }
        }
      }
      
      if (touching && objectList.size() > i) {
        objectList.remove(i);
        i--;

        String newObject = nameID + "hazardRing" + endID + locationID + extractString(object,locationID,endID) + endID + radiusID + str(radius) + endID + alphaID + str(10) + endID + damageID + extractString(object,damageID,endID) + endID + ownerID + owner + endID;
        spawn(newObject);
      }
      else {
        locationInt[0] += velocityInt[0];
        locationInt[1] += velocityInt[1];
        
        object = replaceString(object,str(locationInt[0]) + ',' + str(locationInt[1]),locationID,endID);
        objectList.set(i,object);
      }
    }
    
    if (objectName.equals("laserPoint")) {
      int alpha = int(extractString(object,alphaID,endID));
      
      if (alpha == 1) {
        alpha++;
        
        object = replaceString(object,str(alpha),alphaID,endID);
        objectList.set(i,object);
      }
      else {
        objectList.remove(i);
        i--;
      }
    }
    
    if (objectName.equals("hazardRing")) {  //name[hazardRing]location[X,Y]radius[R]alpha[A]owner[player2]
      int alpha = int(extractString(object,alphaID,endID));
      int radius = int(extractString(object,radiusID,endID));
      
      if (alpha > radius) {
        objectList.remove(i);
        i--;
      }
      else {
        if (radius < 11) {
          alpha += 1;
        }
        else {
          alpha += 3;
        }
        object = replaceString(object,str(alpha),alphaID,endID);
        objectList.set(i,object);
      }
    }
    
    if (objectName.equals("fanshot")) {
      int[] locationInt = int(split(extractString(object,locationID,endID),','));
      int[] velocityInt = int(split(extractString(object,velocityID,endID),','));
      int alpha = int(extractString(object,alphaID,endID));
      int radius = int(extractString(object,radiusID,endID));
      String damage = extractString(object,damageID,endID);
      String owner = extractString(object,ownerID,endID);
      
      PVector location = new PVector(locationInt[0],locationInt[1]);
      PVector velocity = new PVector(0,0);
      PVector target = new PVector(0,0);
      
      for (int j = -1*alpha; j < alpha+1; j++) {
        velocity.set(velocityInt[0],velocityInt[1]);
        velocity.rotate(j * (PI/8)/(alpha+1));
        
        target.set(velocity);
        target.normalize();
        target.mult(radius);
        target.add(location);
        
        String bullet = nameID + "bullet" + endID + locationID + extractString(object,locationID,endID) + endID + velocityID + str(round(velocity.x)) + ',' + str(round(velocity.y)) + endID + targetID + str(round(target.x)) + ',' + str(round(target.y)) + endID + damageID + damage + endID + ownerID + owner + endID;
        
        spawn(bullet);
      }
      
      objectList.remove(i);
      i--;
    }
    
    if (objectName.equals("base")) {
      int[] locationInt = int(split(extractString(object,locationID,endID),','));
      int radius = int(extractString(object,radiusID,endID));
      
      for (int j=0; j<objectList.size(); j++) {
        if (i != j) {
          String otherObject = objectList.get(j);
          String otherName = extractString(otherObject,nameID,endID);
          
          if (otherName.equals("bullet") || otherName.equals("hazardRing")) {
            int[] otherLocation = int(split(extractString(otherObject,locationID,endID),','));
            int maxDistance = 30;
            
            if (otherName.equals("bullet")) {
              maxDistance += 4;
            }
            else {
              maxDistance += int(extractString(object,alphaID,endID));
            }
            
            PVector difference = new PVector(otherLocation[0],otherLocation[1]);
            difference.sub(locationInt[0],locationInt[1]);
            
            if (difference.mag() < maxDistance) {
              radius -= int(extractString(otherObject,damageID,endID));
              if (otherName.equals("bullet")) {
                objectList.remove(j);
                j--;
              }
            }
          }
        }
      }
      
      object = replaceString(object,str(radius),radiusID,endID);
      objectList.set(i,object);
      
      if (radius < 30) {
        objectList.remove(i);
        i--;
      }
    }
  }
}

void spawnItems() {
  String location = "";
  
  int h = 0;                //To make sure the environment is up-to-date, we must first check our HACE.
  int a = 0;
  int c = 0;
  int e = 0;
  
  for (int i=0; i<objectList.size(); i++) {
    if (extractString(objectList.get(i),nameID,endID).equals("healthBox")) {
      h++;
    }
    
    else if (extractString(objectList.get(i),nameID,endID).equals("ammoBox")) {
      a++;
    }
    
    else if (extractString(objectList.get(i),nameID,endID).equals("coin")) {
      c++;
    }
  }
  e = enemyList.size();
  
  if (h < ceil(clientList.size()/2) + 1) {
    int x = 0;
    int y = 0;
    boolean inWall = true;
    
    while (inWall) {
      boolean currentInWall = false;
      x = int(random(50,fieldWidth-50));
      y = int(random(50,fieldWidth-50));
      
      for (int i=0; i<objectList.size() && !currentInWall; i++) {
        if (extractString(objectList.get(i),nameID,endID).equals("wall")) {
          int[] difference = int(split(extractString(objectList.get(i),locationID,endID),','));
          difference[0] -= x;
          difference[1] -= y;
          
          if (sqrt(pow(difference[0],2) + pow(difference[1],2)) < int(extractString(objectList.get(i),radiusID,endID)) + 20) {
            currentInWall = true; 
          }
        }
      }
      
      if (!currentInWall) {
        inWall = false;
      }
    }
    
    location = str(x) + ',' + str(y);
    spawn(nameID + "healthBox" + endID + locationID + location + endID);
  }
  
  if (a < ceil(clientList.size()/2) + 1) {
    int x = 0;
    int y = 0;
    boolean inWall = true;
    
    while (inWall) {
      boolean currentInWall = false;
      x = int(random(50,fieldWidth-50));
      y = int(random(50,fieldWidth-50));
      
      for (int i=0; i<objectList.size() && !currentInWall; i++) {
        if (extractString(objectList.get(i),nameID,endID).equals("wall")) {
          int[] difference = int(split(extractString(objectList.get(i),locationID,endID),','));
          difference[0] -= x;
          difference[1] -= y;
          
          if (sqrt(pow(difference[0],2) + pow(difference[1],2)) < int(extractString(objectList.get(i),radiusID,endID)) + 20) {
            currentInWall = true; 
          }
        }
      }
      
      if (!currentInWall) {
        inWall = false;
      }
    }
    
    location = str(x) + ',' + str(y);
    spawn(nameID + "ammoBox" + endID + locationID + location + endID);
  }
  
  if (coinTimer > 3000) {          //Waits approximately 30 seconds
    coinTimer = 0;
    
    if (c < 2 && clientList.size() > 0) {
      int averageScore = 0;
      
      for (int i=0; i<clientList.size(); i++) {
        averageScore += int(extractString(clientList.get(i),scoreID,endID));
      }
      averageScore = round(averageScore / clientList.size());
      
      if (averageScore < 50) {
        location = str(int(random(50,fieldWidth-50))) + ',' + str(int(random(50,fieldWidth-50)));
        spawn(nameID + "coin" + endID + locationID + location + endID);
      }
    }
  }
  
  if (enemyTimer > 500) {
    enemyTimer = 0;
    
    if (e + clientList.size() < playerMaximum) {
      float packageSelect = random(1);
      String randomPackage = "";
      int speed = 0;
      int damage = 0;
      
      if (packageSelect < 0.2) {
        randomPackage = "turtle";
        speed = 2;
        damage = 5;
      }
      else if (packageSelect < 0.4) {
        randomPackage = "salamander";
        speed = 9;
        damage = 3;
      }
      else if (packageSelect < 0.6) {
       randomPackage = "hedgehog"; 
       speed = 4;
       damage = 30;
      }
      else if (packageSelect < 0.8) {
        randomPackage = "beaver";
        speed = 6;
        damage = 15;
      }
      else {
        randomPackage = "woodpecker";
        speed = 5;
        damage = 10;
      }
      
      enemyList.add(new Enemy(round(random(30,fieldWidth-30)),round(random(30,fieldWidth-30)),randomPackage,speed,damage));
    }
  }
  
  coinTimer++;
  enemyTimer++;
}

void adjustLimits() {
  viewLimits[0] = fieldWidth + clientScope;        //Xmin                                                     
  viewLimits[1] = 0 - clientScope;                 //Xmax
  viewLimits[2] = fieldWidth + clientScope;        //Ymin
  viewLimits[3] = 0 - clientScope;                 //Ymax
   
  for (int i=0; i<clientList.size(); i++) {
    float[] location = float(split(extractString(clientList.get(i),locationID,endID),','));
    if (location[0] - clientScope < viewLimits[0]) {
      viewLimits[0] = location[0] - clientScope;
    }
    if (location[0] + clientScope > viewLimits[1]) {
      viewLimits[1] = location[0] + clientScope;
    }
    if (location[1] - clientScope < viewLimits[2]) {
      viewLimits[2] = location[1] - clientScope;
    }
    if (location[1] + clientScope > viewLimits[3]) {
      viewLimits[3] = location[1] + clientScope;
    }
  }
  
  if (fieldWidth < viewLimits[1]) {
    viewLimits[1] = fieldWidth;
  }
  if (fieldWidth < viewLimits[3]) {
    viewLimits[3] = fieldWidth;
  }
}