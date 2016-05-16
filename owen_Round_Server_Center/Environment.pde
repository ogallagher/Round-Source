void spawn(String objectData) {
  boolean processed = false;
  
  for (int i=0; i<objectList.size(); i++) {
    String testObject = objectList.get(i);
    String nameTest = extractString(testObject,nameID,endID);
    int[] locationTest = int(split(extractString(testObject,locationID,endID),','));
    
    if (extractString(objectData,nameID,endID).equals(nameTest)) {
      if (nameTest.equals("wall") || nameTest.equals("hazardRing") || nameTest.equals("detonator") || nameTest.equals("smokeScreen") || nameTest.equals("laserPoint") || nameTest.equals("fanshot")) {
        int[] location = int(split(extractString(objectData,locationID,endID),','));
        
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
  }
  
  if (!processed) {
    objectList.append(objectData);
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
            
            PVector dLocation = new PVector(locationInt[0],locationInt[1]);
            PVector bLocation = new PVector(otherLocation[0],otherLocation[1]);
            bLocation.sub(dLocation);
            
            float dbDistance = bLocation.mag();
            if (dbDistance < 15 + otherRadius) {
              alpha = -1;
            }
          }
        }
      }
      for (int j=0; j<clientList.size(); j++) {                                                                     //Detonate if touching client
        if (alpha > -1) {
          String other = clientList.get(j);
          int[] otherLocation = int(split(extractString(other,locationID,endID),','));
          
          PVector dLocation = new PVector(locationInt[0],locationInt[1]);
          PVector cLocation = new PVector(otherLocation[0],otherLocation[1]);
          cLocation.sub(dLocation);
          
          float dcDistance = cLocation.mag();
          
          if (dcDistance < 27) {
            alpha = -1;
          }
        }
      }
      for (int j=0; j<enemyList.size(); j++) {                                                                     //Detonate if touching enemy
        if (alpha > -1) {
          Enemy other = enemyList.get(j);
          
          PVector dLocation = new PVector(locationInt[0],locationInt[1]);
          PVector eLocation = new PVector(other.location.x,other.location.y);
          eLocation.sub(dLocation);
          
          float deDistance = eLocation.mag();
          
          if (deDistance < 27) {
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
            
            if (otherName.equals("bullet") || otherName.equals("wall")) {                     //Explode if touching bullet or wall
              int[] otherLocation = int(split(extractString(other,locationID,endID),','));
              int otherRadius;
              if (other.indexOf(radiusID) > -1) {
                otherRadius = int(extractString(other,radiusID,endID));
              }
              else {
                otherRadius = 1;
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
            
            if (distance < 27) {
              touching = true;
            }
          }
        }
        for (int j=0; j<enemyList.size(); j++) {                                                                     //Detonate if touching enemy
          if (touching == false) {
            Enemy other = enemyList.get(j);
            
            PVector dLocation = new PVector(locationInt[0],locationInt[1]);
            PVector eLocation = new PVector(other.location.x,other.location.y);
            eLocation.sub(dLocation);
            
            float deDistance = eLocation.mag();
            
            if (deDistance < 27) {
              touching = true;
            }
          }
        }
      }
      
      if (touching && objectList.size() > i) {
        objectList.remove(i);

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
      }
    }
    
    if (objectName.equals("hazardRing")) {  //name[hazardRing]location[X,Y]radius[R]alpha[A]owner[player2]
      int alpha = int(extractString(object,alphaID,endID));
      int radius = int(extractString(object,radiusID,endID));
      
      if (alpha > radius) {
        objectList.remove(i);
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
    }
    
    //if (objectName.equals("healthBox") || objectName.equals("ammoBox") || objectName.equals("coin")) {       ——THIS WAS USED WHEN THE FIELD HAD DYNAMIC BOUNDARIES——
    //  int[] locationInt = int(split(extractString(object,locationID,endID),','));
    //  if (locationInt[0] < 30) {
    //    locationInt[0] += abs(30-locationInt[0]);
    //  }
    //  if (locationInt[0] > fieldWidth - 30) {
    //    locationInt[0] -= abs(locationInt[0] - (fieldWidth-30));
    //  }
    //  if (locationInt[1] < 30) {
    //    locationInt[1] += abs(30-locationInt[1]);
    //  }
    //  if (locationInt[1] > fieldWidth - 30) {
    //    locationInt[1] -= abs(locationInt[1] - (fieldWidth-30));
    //  }
      
    //  object = replaceString(object,str(locationInt[0]) + ',' + str(locationInt[1]),locationID,endID);
    //  objectList.set(i,object);
    //}
    
  }
}

void spawnItems() {
  String location;
  
  int h = 0;                //To make sure the environment is up-to-date, we must first check our HACWE.
  int a = 0;
  int c = 0;
  int w = 0;
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
    
    else if (extractString(objectList.get(i),nameID,endID).equals("wall")) {
      w++;
    }
  }
  e = enemyList.size();
  
  if (h < ceil(clientList.size()/2) + 1) {
    location = str(int(random(50,fieldWidth-50))) + ',' + str(int(random(50,fieldWidth-50)));
    spawn(nameID + "healthBox" + endID + locationID + location + endID);
  }
  
  if (a < ceil(clientList.size()/2) + 1) {
    location = str(int(random(50,fieldWidth-50))) + ',' + str(int(random(50,fieldWidth-50)));
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
  
  //int maxFieldClientNumber = fieldMinimum * (clientList.size()+1);      ——THIS WAS USED FOR CREATING NEW WALLS WHEN MORE CLIENTS JOINED——
  //if (maxFieldClientNumber > fieldMaximum) {
  //  maxFieldClientNumber = fieldMaximum;
  //}
  //if (w < round(pow(maxFieldClientNumber,2)/100000)) {  
  //  float section = random(1);                    //Place walls anywhere within the L-shaped area outside of default
  //  location = "";
    
  //  if (section < 0.3333) {
  //      location = str(int(random(0,fieldMinimum))) + ',' + str(int(random(fieldMinimum,maxFieldClientNumber-50)));
  //  }
  //  else if (section > 0.3333 && section < 0.6666) { 
  //      location = str(int(random(fieldMinimum,maxFieldClientNumber-50))) + ',' + str(int(random(0,fieldMinimum)));
  //  }
  //  else {
  //      location = str(int(random(fieldMinimum,maxFieldClientNumber-50))) + ',' + str(int(random(fieldMinimum,maxFieldClientNumber-50)));
  //  }
  //  String radius = str(int(random(10,120)));
    
  //  spawn(nameID + "wall" + endID + locationID + location + endID + radiusID + radius + endID);
  //}
  
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
  
  int diameter = round(viewLimits[1]);
  if (viewLimits[3] > viewLimits[1]) {
    diameter = round(viewLimits[3]);
  }
  //if (diameter > fieldMinimum && diameter < fieldMinimum * (clientList.size()+1) && diameter < fieldMaximum) {
  //  fieldWidth = diameter;
  //}
  
  if (fieldWidth < viewLimits[1]) {
    viewLimits[1] = fieldWidth;
  }
  if (fieldWidth < viewLimits[3]) {
    viewLimits[3] = fieldWidth;
  }
}