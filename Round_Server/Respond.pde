void respond() {
  Client someClient = server.available();
  if (someClient != null) {
    String clientMessage = someClient.readString();
    String clientAddress = extractString(clientMessage,addressID,endID);
    
    if (clientMessage.indexOf(newHD) > -1) {                                            //*** Create new client
      String clientName = extractString(clientMessage,nameID,endID);
      boolean registered = false;
      
      for (int i=0; i<accountList.size(); i++) {
        String testName = extractString(accountList.get(i),nameID,endID);
        if (cleanString(testName,"0123456789 ").equals(cleanString(clientName,"0123456789 "))) {
          registered = true;
          broadcast("TAKEN", messageHD, clientAddress);      // Name given is already on-file
        }
      }
      
      if (registered == false) {
        broadcast("ADDED", messageHD, clientAddress);        // Name given is acceptable and has been added
        
        String newClient = nameID + clientName + endID + scoreID + "0" + endID + addressID + clientAddress + endID;
        accountList.append(newClient);
        
        updateAccounts();
      }
    }
    
    if (clientMessage.indexOf(loadHD) > -1) {                                            //*** Load existing client    
      if (clientList.size() < 10) {
        String clientName = extractString(clientMessage,nameID,endID);
        String code = "";
        String icon = "";
        boolean duplicated = false;
        boolean registered = false;
        
        if (clientMessage.indexOf(iconID) > -1) {
          code = clientMessage.substring(clientMessage.indexOf(iconID)+iconID.length(),clientMessage.indexOf(endID+nameID));
          
          int c=0;
          while (c < codeList.size() - 1 && codeList.get(c).equals(code) == false) {
            c++; 
          }
          
          if (codeList.get(c).equals(code)) {
            icon = iconID + iconList.get(c) + endID;
          }
          else {
            icon = iconID + endID;
          }
        }
        else {
          icon = iconID + endID;
        }
        
        for (int i=0; i<clientList.size(); i++) {
          String testName = extractString(clientList.get(i),nameID,endID);
          String testAddress = extractString(clientList.get(i),addressID,endID);
          if (testName.equals(cleanString(clientName,"0123456789"))) {
            if (testAddress.equals(clientAddress)) {
              registered = true;
              
              broadcast("REGISTERED" + icon + radiusID + str(round(fieldWidth/2)) + endID + nameID + cleanString(clientName,"0123456789") + endID, messageHD, clientAddress);   // Name given is acceptable; the client just didn't receive the message the first time and is still in the menu screen.
            }
            else {
              duplicated = true;
              registered = true;
              broadcast("DUPLICATE", messageHD, clientAddress);   // Name given already corresponds to a player in the game. Someone is using another client's alias.
            }
          }
        }
        
        for (int i=0; i<accountList.size(); i++) {
          String testName = extractString(accountList.get(i),nameID,endID);
          if (testName.equals(clientName) && !duplicated && !registered) {            
            registered = true;
            
            String clientLocation = str(round(random(0,fieldWidth))) + ',' + str(round(random(0,fieldWidth)));
            String clientAngle = "0";
            String clientPackage = extractString(clientMessage,packageID,endID);
            String clientZombie = "0"; 
            
            String securedName = extractString(accountList.get(i),nameID,endID);
            securedName = cleanString(securedName,"0123456789");
            String secureClientData = replaceString(accountList.get(i),securedName,nameID,endID);
            
            String signedClient = secureClientData.substring(0,secureClientData.indexOf(addressID)) + locationID + clientLocation + endID + angleID + clientAngle + endID + packageID + clientPackage + endID + healthID + "100" + endID + alphaID + "1" + endID + zombieID + clientZombie + endID + icon + ownerID + endID + addressID + clientAddress + endID;  
            clientList.append(signedClient);
            
            accountList.set(i,replaceString(accountList.get(i),clientAddress,addressID,endID));
            updateAccounts();
            
            broadcast("REGISTERED" + icon + radiusID + str(round(fieldWidth/2)) + endID + nameID + cleanString(clientName, "0123456789") + endID, messageHD, clientAddress);            // Name given is acceptable and is now playing.
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
    
    if (clientMessage.indexOf(teamHD) > -1) {                                   //*** Administrate teams
      String message = extractString(clientMessage,teamHD,endHD);
      String response = "";
      
      if (message.equals("DATA")) {
        for (int i=0; i<icons.length; i++) {
          response += idList.get(i) + iconID + codeList.get(i) + endID + iconList.get(i) + '\n';
        }
        
        broadcast(response, teamHD, clientAddress);
      }
      else if (message.indexOf("CODE") > -1) {
        String icon = message.substring(message.indexOf(iconID)+iconID.length(),message.length()-1);
        
        int foundIcon = -1;
        boolean owned = false;
        boolean clientFound = false;
        
        for (int i=0; i<icons.length && foundIcon == -1; i++) {
          if (iconList.get(i).equals(icon)) {
            foundIcon = i;
            
            if (extractString(idList.get(i),ownerID,endID).length() > 0) {
              owned = true;
            }
          }
        }
        
        if (foundIcon > -1 && !owned) {
          String clientName = extractString(message,nameID,endID);
          
          for (int i=0; i<accountList.size() && !clientFound; i++) {
            if (clientName.equals(extractString(accountList.get(i),nameID,endID))) {
              clientFound = true; 
            }
          }
          
          if (clientFound) {
            idList.set(foundIcon,replaceString(idList.get(foundIcon),clientName,ownerID,endID));
            updateIcons();
          }
        }
        
        for (int i=0; i<icons.length; i++) {
          response += idList.get(i) + iconID + codeList.get(i) + endID + iconList.get(i) + '\n';
        }
        broadcast(response, teamHD, clientAddress);
      }
      else if (message.indexOf("NEW") > -1) {
        chatList.append(nameID + "N/A" + endID + chatID + extractString(message,nameID,endID) + endID);
        
        for (int i=0; i<icons.length; i++) {
          response += idList.get(i) + iconID + codeList.get(i) + endID + iconList.get(i) + '\n';
        }
        broadcast(response, teamHD, clientAddress);
      }
    }
    
    if (clientMessage.indexOf(clientHD) > -1) {                                 //*** Update client's data
      String editMessage =    extractString(clientMessage,clientHD,endHD);
      
      String clientName =     extractString(editMessage,nameID,endID);
      String clientLocation = extractString(editMessage,locationID,endID);
      String clientScore =    extractString(editMessage,scoreID,endID);
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
            
            if (subSpawn.indexOf(splitID+nameID) > -1) {
              spawnObject = subSpawn.substring(0,subSpawn.indexOf(splitID+nameID));
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
    
    if (clientMessage.indexOf(messageHD) > -1) {                                         //*** Chat, Kill existing client upon request
      String message = extractString(clientMessage,messageHD,endHD);
      String name = extractString(message,nameID,endID);
      int i=0;
      if (clientList.size() > 0) {
        while(extractString(clientList.get(i),nameID,endID).equals(name) == false && i<clientList.size()-1) {
          i++;
        }
      
        if (extractString(clientList.get(i),nameID,endID).equals(name)) {
          if (message.indexOf(chatID) > -1) {
            if (message.indexOf(iconID) > -1) {
              String receivers = "";
              receivers = message.substring(message.indexOf(iconID)+iconID.length(),message.indexOf(endID+chatID));
              
              broadcast(message, messageHD, receivers);
              chatList.append(message);
            }
            else if (message.indexOf(receiverID) > -1) {
              String receiver = "";
              
              for (int j=0; j<clientList.size() && receiver.length() == 0; j++) {
                if (extractString(clientList.get(j),nameID,endID).equals(extractString(message,receiverID,endID))) {
                  receiver = extractString(clientList.get(j),addressID,endID);
                }
              }
              
              if (receiver.length() > 0) {
                message = message.substring(0,message.indexOf(receiverID)) + message.substring(message.indexOf(endID,message.indexOf(receiverID))+1);
                broadcast(message, messageHD, receiver);
                chatList.append(message);
              }
              else {
                message = nameID + "SERVER" + endID + chatID + name + ", your chat to " + extractString(message,receiverID,endID) + " was not sent." + endID;
                broadcast(message,messageHD,clientAddress);
                chatList.append(message);
              }
            }
            else {
              broadcast(message, messageHD, "all");
              chatList.append(message);
            }
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