void updateClient(String name, String score, String location, String angle, String health, String alpha, String owner, String address) {
  int i=0;
  if (clientList.size() > 0) {
    while(extractString(clientList.get(i),nameID,endID).equals(name) == false && i<clientList.size()-1) {
      i++;
    }
  
    if (extractString(clientList.get(i),nameID,endID).equals(name)) {
      clientList.set(i, replaceString(clientList.get(i),"0",zombieID,endID));
      
      if (int(score) > -1) {
        clientList.set(i, replaceString(clientList.get(i),score,scoreID,endID));
      }
      
      clientList.set(i, replaceString(clientList.get(i),location,locationID,endID));
      clientList.set(i, replaceString(clientList.get(i),alpha,alphaID,endID));
      clientList.set(i, replaceString(clientList.get(i),angle,angleID,endID));
      
      if (int(health) > 0) {
        clientList.set(i, replaceString(clientList.get(i),health,healthID,endID));
        
        i=0;
        while(cleanString(extractString(filedList.get(i),nameID,endID),"0123456789").equals(name) == false && i<filedList.size()-1) {
          i++;
        }
        if (!score.equals(extractString(filedList.get(i),scoreID,endID))) {
          String newFiledClient = replaceString(filedList.get(i),score,scoreID,endID);
          filedList.set(i,newFiledClient);
          
          updateFile();
        }
      }
      
      if (int(health) == 0) {
        int newScore = int(score);
        if (newScore > 0) {
          newScore -= 1;
          clientList.set(i, replaceString(clientList.get(i),str(newScore),scoreID,endID));
          
          int[] locationInt = int(split(location,','));
          objectList.append(nameID + "coin" + endID + locationID + str(locationInt[0]) + ',' + str(locationInt[1]) + endID);
        }
        
        int j=0;
        while(cleanString(extractString(filedList.get(j),nameID,endID),"0123456789").equals(name) == false && j<filedList.size()-1) {
          j++;
        }
        String newFiledClient = replaceString(filedList.get(j),str(newScore),scoreID,endID);
        filedList.set(j,newFiledClient);
        
        updateFile();
        
        broadcast("DEATH [" + name + endID, messageHD, "all");
        clientList.remove(i);
      }
      
      if (owner.length() > 0) {
        boolean nameTaken = false; 
        
        for (int j=0; j<filedList.size(); j++) {
          String testName = extractString(filedList.get(j),nameID,endID);
          if (cleanString(testName,"0123456789 ").equals(cleanString(owner,"0123456789 "))) {
            nameTaken = true;      // Name given is already on-file
          }
        }
        
        i = 0;
        while(extractString(clientList.get(i),nameID,endID).equals(name) == false && i<clientList.size()-1) {
          i++;
        }
        
        if (!nameTaken) {
          clientList.set(i, replaceString(clientList.get(i),"APPROVED",ownerID,endID));
          
          i=0;
          while(cleanString(extractString(filedList.get(i),nameID,endID),"0123456789").equals(name) == false && i<filedList.size()-1) {
            i++;
          }
          
          if (cleanString(extractString(filedList.get(i),nameID,endID),"0123456789").equals(name)) {
            String newFiledClient = replaceString(filedList.get(i),owner,nameID,endID);
            filedList.set(i,newFiledClient);
            
            updateFile();
          }
        }
        else {
          clientList.set(i, replaceString(clientList.get(i),"TAKEN",ownerID,endID));
        }
      }
    }
    else if (extractString(clientList.get(i),addressID,endID).equals(address)) {
      clientList.set(i, replaceString(clientList.get(i),"0",zombieID,endID));
      clientList.set(i, replaceString(clientList.get(i),name,nameID,endID));
      clientList.set(i, replaceString(clientList.get(i),"",ownerID,endID));
    }
    else {
      if (int(health) == 0) {
        broadcast("DEATH [" + name + endID, messageHD, "all");
      }
    }
  }
  
  if (int(health) == 0) {
    broadcast("DEATH [" + name + endID, messageHD, "all");
  }
}

void checkZombies() {
  for (int i=0; i<clientList.size(); i++) {
    int zombieness = int(extractString(clientList.get(i),zombieID,endID));
    
    if (zombieness < 250) {
      zombieness += 1;
      clientList.set(i, replaceString(clientList.get(i),str(zombieness),zombieID,endID));
    }
    else {
      broadcast("DEATH [" + extractString(clientList.get(i),nameID,endID) + endID, messageHD, "all");
      clientList.remove(i);
    }
  }
}