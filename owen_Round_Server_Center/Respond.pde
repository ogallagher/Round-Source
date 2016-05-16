void respond() {
  Client someClient = server.available();
  if (someClient != null) {
    String clientMessage = someClient.readString();
    String clientAddress = extractString(clientMessage,addressID,endID);
    
    if (clientMessage.indexOf(newHD) > -1) {                                            //*** Create new client
      String clientName = extractString(clientMessage,nameID,endID);
      boolean registered = false;
      
      for (int i=0; i<filedList.size(); i++) {
        String testName = extractString(filedList.get(i),nameID,endID);
        if (cleanString(testName,"0123456789 ").equals(cleanString(clientName,"0123456789 "))) {
          registered = true;
          broadcast("TAKEN", messageHD, clientAddress);      // Name given is already on-file
        }
      }
      
      if (registered == false) {
        broadcast("ADDED", messageHD, clientAddress);        // Name given is acceptable and has been added
        
        String newClient = nameID + clientName + endID + scoreID + "0" + endID;
        filedList.append(newClient);
        
        updateFile();
      }
    }
    
    if (clientMessage.indexOf(loadHD) > -1) {                                            //*** Load existing client
      if (clientList.size() < 10) {
        String clientName = extractString(clientMessage,nameID,endID);
        String code = "";
        boolean duplicated = false;
        boolean registered = false;
        
        if (clientMessage.indexOf(codeCD) > -1) {
          code = extractString(clientMessage,codeCD,endCD);
          
          int c=0;
          while (c < codeList.length - 1 && codeList[c].equals(code) == false) {
            c++; 
          }
          
          if (codeList[c].equals(code)) {
            code = codeCD + iconList[c] + endCD;
          }
          else if (code.equals("randomized")) {
            c = int(random(0,iconNumber-1));
            code = codeCD + iconList[c] + endCD;
          }
        }
        
        for (int i=0; i<clientList.size(); i++) {
          String testName = extractString(clientList.get(i),nameID,endID);
          String testAddress = extractString(clientList.get(i),addressID,endID);
          if (testName.equals(cleanString(clientName,"0123456789"))) {
            if (testAddress.equals(clientAddress)) {
              registered = true;
              
              broadcast("REGISTERED" + code + radiusID + str(round(fieldWidth/2)) + endID, messageHD, clientAddress);   // Name given is acceptable; the client just didn't receive the message the first time and is still in the menu screen.
            }
            else {
              duplicated = true;
              registered = true;
              broadcast("DUPLICATE", messageHD, clientAddress);   // Name given already corresponds to a player in the game. Someone is using another client's alias.
            }
          }
        }
        
        for (int i=0; i<filedList.size(); i++) {
          String testName = extractString(filedList.get(i),nameID,endID);
          if (testName.equals(clientName) && duplicated == false && registered == false) {
            registered = true;
            
            String clientLocation = str(round(random(0,fieldWidth))) + ',' + str(round(random(0,fieldWidth)));
            String clientAngle = "0";
            String clientPackage = extractString(clientMessage,packageID,endID);
            String clientHealth = "100";
            String clientZombie = "0"; 
            
            String securedName = extractString(filedList.get(i),nameID,endID);
            securedName = cleanString(securedName,"0123456789");
            String secureClientData = replaceString(filedList.get(i),securedName,nameID,endID);
            
            String signedClient = secureClientData + locationID + clientLocation + endID + angleID + clientAngle + endID + packageID + clientPackage + endID + healthID + clientHealth + endID + alphaID + "1" + endID + zombieID + clientZombie + endID + codeCD + code + endCD + ownerID + endID + addressID + clientAddress + endID;  
            clientList.append(signedClient);
            
            broadcast("REGISTERED" + code + radiusID + str(round(fieldWidth/2)) + endID, messageHD, clientAddress);            // Name given is acceptable and is now playing.
          }
        }
        
        if (registered == false) {
          broadcast("NOTFOUND", messageHD, clientAddress);        // Name given is not on file.
        }
      }
      else {
        broadcast("FULL", messageHD, clientAddress);              //There are too many clients already playing.
      }
    }
    
    if (clientMessage.indexOf(clientHD) > -1) {                                 //*** Update client's data
      String editMessage =    extractString(clientMessage,clientHD,endHD);
      
      String clientName =     extractString(editMessage,nameID,endID);
      String clientScore =    extractString(editMessage,scoreID,endID);
      String clientLocation = extractString(editMessage,locationID,endID);
      String clientAngle =    extractString(editMessage,angleID,endID);
      String clientAlpha =    extractString(editMessage,alphaID,endID);
      String clientHealth =   extractString(editMessage,healthID,endID);
      String clientOwner =    "";                                                //If client wants to change its name, the requested name is input like this: owner[NEW_NAME].
      
      if (editMessage.indexOf(ownerID) > -1) {
        clientOwner = extractString(editMessage,ownerID,endID);
      }
      
      updateClient(clientName,clientScore,clientLocation,clientAngle,clientHealth,clientAlpha,clientOwner,clientAddress);
    }
    
    if (clientMessage.indexOf(spawnHD) > -1) {                                           //*** Update environment data (create objects)
      int i=0;
      if (clientList.size() > 0) {
        while (extractString(clientList.get(i),addressID,endID).equals(clientAddress) == false && i<clientList.size()-1) {
          i++;
        }
        
        if (extractString(clientList.get(i),addressID,endID).equals(clientAddress)) {
          String spawn = extractString(clientMessage,spawnHD,endHD);
          i = 0;
          
          while (spawn.indexOf(nameID,i) > -1) {
            String subSpawn = spawn.substring(spawn.indexOf(nameID,i));
            String spawnObject = "";
            
            if (subSpawn.indexOf(splitID) > -1) {
              spawnObject = subSpawn.substring(0,subSpawn.indexOf(splitID));
            }
            else {
              spawnObject = subSpawn;
            }
            
            if (spawnObject.length() > 0) {
              spawn(spawnObject);
            }
            int newI = spawn.indexOf(nameID,i) + nameID.length() + 1;
            i = newI;
          }
        }
      }
    }
    
    if (clientMessage.indexOf(deleteHD) > -1) {                                          //*** Update environment data (destroy objects)
      int i=0;
      if (clientList.size() > 0) {
        while (extractString(clientList.get(i),addressID,endID).equals(clientAddress) == false && i<clientList.size()-1) {
          i++;
        }
        
        if (extractString(clientList.get(i),addressID,endID).equals(clientAddress)) {
          String delete = extractString(clientMessage,deleteHD,endHD);
          i=0;
          
          while (delete.indexOf(nameID,i) > -1) {
            String subDelete = delete.substring(delete.indexOf(nameID,i));
            String deleteObject = "";
            
            if (subDelete.indexOf(splitID) > -1) {
              deleteObject = subDelete.substring(0,subDelete.indexOf(splitID));
            }
            else {
              deleteObject = subDelete;
            }
            
            if (deleteObject.length() > 0) {
              delete(deleteObject);
            }
            int newI = delete.indexOf(nameID,i) + nameID.length() + 1;
            i = newI;
          }
        }
      }
    }
    
    if (clientMessage.indexOf(messageHD) > -1) {                                         //*** Kill existing client (only use for messageHD as of yet)
      String message = extractString(clientMessage,messageHD,endHD);
      String name = extractString(message,nameID,endID);
      int i=0;
      if (clientList.size() > 0) {
        while(extractString(clientList.get(i),nameID,endID).equals(name) == false && i<clientList.size()-1) {
          i++;
        }
      
        if (extractString(clientList.get(i),nameID,endID).equals(name)) {
          if (message.indexOf(chatID) > -1) {
            broadcast(message, messageHD, "all");
            chatList.append(message);
          }
          else {
            broadcast("DEATH [" + name + endID, messageHD, "all");
            clientList.remove(i);
          }
        }
        else {
         broadcast("DEATH [" + name + endID, messageHD, "all"); 
        }
      }
      else {
        broadcast("DEATH [" + name + endID, messageHD, "all");
      }
    }
  }
}