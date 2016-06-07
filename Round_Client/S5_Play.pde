// PLAY

void readServerLists(String text) {  
  if (text.indexOf(clientHD) > -1 && text.indexOf(endHD,text.indexOf(clientHD)) > -1) {                    // Go through string, finding instances of "name[". if client matches myClient.name — myClient.getData(); else — otherClients.append();.
    otherClients.clear();
    
    String clientText = extractString(text,clientHD,endHD);
    int i = -1;
    
    while (clientText.indexOf(nameID,i) > -1) {
      int j = clientText.indexOf(nameID,i) + 1;
      String clientData;
      
      if (clientText.indexOf(nameID,j) < 0) {
        clientData = clientText.substring(clientText.indexOf(nameID,i));
      }
      else {
        clientData = clientText.substring(clientText.indexOf(nameID,i),clientText.indexOf(nameID,j));      //from start of first nameID after index i to start of second nameID after index i 
      }
      
      String clientName = extractString(clientData,nameID,endID);
      
      if (clientName.equals(myClient.name) || myAddress.equals(extractString(clientData,addressID,endID))) {
        myClient.getData(clientData);
      }
      else if (clientData.length() > 0) {
        otherClients.add(new OtherPlayer(clientData));
      }
      
      i = clientText.indexOf(nameID,i) + nameID.length() + clientName.length() + 1;                         //move i forward until the end of name[NAME] to find next client in string.
    }    
  }
  
  if (text.indexOf(objectHD) > -1 && text.indexOf(endHD,text.indexOf(objectHD)) > -1) {                     // Go through string, finding instances of "name[". objects.append();.
    objects.clear();
    
    String objectText = extractString(text,objectHD,endHD);
    int i = -1;
    
    while (objectText.indexOf(nameID,i) > -1) {
      int j = objectText.indexOf(nameID,i) + 1;
      String objectData;
      
      if (objectText.indexOf(nameID,j) < 0) {
        objectData = objectText.substring(objectText.indexOf(nameID,i));
      }
      else {
        objectData = objectText.substring(objectText.indexOf(nameID,i),objectText.indexOf(nameID,j));      //from start of first nameID after index i to start of second nameID after index i 
      }
      
      String objectName = extractString(objectData,nameID,endID);
      boolean myAddition = false;
      
      if (objectData.length() > 0) {
        for (int k=0; k<objects.size(); k++) {
          if (objects.get(k).name.equals(objectName)) {
            int[] objectLocation = int(split(extractString(objectData,locationID,endID),','));
            
            if (round(objects.get(k).location.x) == objectLocation[0] && round(objects.get(k).location.y) == objectLocation[1]) {
              myAddition = true;
              objects.get(k).verified = true;
            }
          }
        }
        
        if (!myAddition) {
          objects.add(new Object(objectData, true));
        }
      }
      
      i = objectText.indexOf(nameID,i) + nameID.length() + objectName.length() + 1;                         //move i forward until the end of name[NAME] to find next object in string.
    }
  }
}

void displayField() {
  if (!(myClient.location.x > 750 && myClient.location.x < fieldWidth-750) || !(myClient.location.y > 750 && myClient.location.y < fieldWidth-750)) {
    pushMatrix();
    noFill();
    stroke(255,50);
    strokeWeight(1.5);
    rectMode(CORNER);
    translate(0-myClient.camera.x+width/2,0-myClient.camera.y+height/2);
    rect(0,0,z*fieldWidth,z*fieldWidth);
    popMatrix();
  }
}

void chat() {
  if (chatting && chatAlpha < 255) {
    chatAlpha += 1.5;
  }
  else if (chatting == false && chatAlpha > 0) {
    chatAlpha -= 1.5;
  }
  
  if ((chatting ||reading) && readAlpha < 255) {
    readAlpha += 1.5;
  }
  else if (!(chatting ||reading) && readAlpha > 0){ 
    readAlpha -= 1.5;
  }
  
  if (chatAlpha > 0) {
    textBoxChat(25,height-25);
  }
  if (readAlpha > 0) {
    displayChatLine();
  }
  
  if (keyPressed && (key == ENTER || key == RETURN)) {
    if (reading && !renaming) {
      reading = false;
      keyPressed = false;
    }
    else if (chatting == false && !renaming){
      chatting = true;
      reading = true;
      keyPressed = false;
    }
  }
}

void textBoxChat(int locationX,int locationY) {
  if (chatting && keyPressed) {
      if ((key == DELETE || key == BACKSPACE) && chatBoxString.length() > 0) {
        if (chatBoxString.equals("[,],*,:,$,TAB = Not Permitted. Limit = 60 char.")) {
          chatBoxString = "";
        }
        else {
          chatBoxString = chatBoxString.substring(0,chatBoxString.length()-1);
        }
      }
      else if (key != CODED && key != BACKSPACE && key != ENTER && key != RETURN && key != '*' && key != '[' && key != ']' && key != ':' && key != '\t' && key != '$' && key != '˜' && key != '´' && chatBoxString.length() < 60) {
        if (chatBoxString.equals("[,],*,:,$,TAB = Not Permitted. Limit = 60 char.")) {
          chatBoxString = str(key);
        }
        else {
          chatBoxString = chatBoxString + key;
        }
      }
      else if (key == ENTER || key == RETURN) {
        chatting = false;
        reading = false;
        
        if (chatBoxString.equals("[,],*,:,$,TAB = Not Permitted. Limit = 60 char.") == false && chatBoxString.length() > 0) {
          String receiver = "";
          if (chatBoxString.indexOf('-') > -1) {
            receiver = receiverID + chatBoxString.substring(chatBoxString.indexOf('-')+1) + endID;
            chatBoxString = chatBoxString.substring(0,chatBoxString.indexOf('-'));
          }
          else if (code.length() > 0) {
            receiver = iconID + code + endID;
          }
          
          String chat = nameID + myClient.name + endID + receiver + chatID + chatBoxString + endID;
          chatBoxString = "";
          
          broadcast(chat, messageHD);
        }
      }
      
      keyPressed = false;
  }
  
  pushMatrix();
  fill(0,chatAlpha/4);
  noStroke();
  rectMode(CORNER);
  rect(0,locationY-30,width-100,80);
  popMatrix();
  
  pushMatrix();
  textFont(chatFont,15);
  textAlign(LEFT);
  fill(255,chatAlpha);
  translate(locationX,locationY);
  text(chatBoxString,0,0);
  popMatrix();
}

void displayChatLine() {
  if (chatList.size() > 7) {
    chatList.remove(0);
  }
  
  pushMatrix();
  fill(0,readAlpha/4);
  noStroke();
  rectMode(CORNER);
  rect(0,565,width-100,75);
  popMatrix();
  
  pushMatrix();
  textFont(chatFont,10);
  textAlign(LEFT);
  fill(255,readAlpha);
  translate(25,575);
  for (int i=0; i<chatList.size(); i++) {
    String name = extractString(chatList.get(i),nameID,endID);
    String chat = extractString(chatList.get(i),chatID,endID);
    text(name + ":  " + chat,0,i*10);
  }
  popMatrix();
}

void rename() {
  if (renaming && nameAlpha < 255) {
    nameAlpha += 5;
  }
  else if (renaming == false && nameAlpha > 0) {
    nameAlpha = 0;
  }
  
  if (nameAlpha > 0) {
    textBoxName(125,height-25);
  }
}

void textBoxName(int locationX, int locationY) {
  if (renaming && keyPressed) {
      if ((key == DELETE || key == BACKSPACE) && newname.length() > 0) {
        if (newname.equals("TYPE USERNAME ([,],*,TAB,: are not allowed)")) {
          newname = "";
        }
        else {
          newname = newname.substring(0,newname.length()-1);
        }
      }
      
      else if (key != CODED && key != BACKSPACE && key != ENTER && key != RETURN && key != '*' && key != '[' && key != ']' && key != ':' && key != '\t' && key != '$' && newname.length() < 60) {
        if (newname.equals("TYPE USERNAME ([,],*,TAB,: are not allowed)")) {
          newname = str(key);
        }
        else {
          newname = newname + key;
        }
      }
      
      if (key == ENTER || key == RETURN) {
        renaming = false;
        
        if (!(newname.equals("TYPE USERNAME ([,],*,TAB,: are not allowed)")) && newname.length() > 0) {
          newNamePending = true;
        }
      }
      
      keyPressed = false;
  }
  
  else if (!renaming) {
    newname = "TYPE USERNAME ([,],*,TAB,: are not allowed)";
  }
  
  if (renaming) {
    pushMatrix();
    fill(0,nameAlpha/4);
    noStroke();
    rectMode(CORNER);
    rect(100,locationY-30,width-100,80);
    popMatrix();
  
    pushMatrix();
    textFont(chatFont,15);
    textAlign(LEFT);
    fill(255,nameAlpha);
    translate(locationX,locationY);
    text(newname,0,0);
    popMatrix();
  }
}

void highscores() {
  int[] topPlayer = {myClient.score,-1};  //{score,index}
  int[] topTeam = {-1,-1};
  
  StringList currentTeams = new StringList();
  if (icon.length() > 0) {
    currentTeams.append(icon + ":" + str(myClient.score));
    topTeam[0] = myClient.score;
    topTeam[1] = 0;
  }
  
  for (int i=0; i<otherClients.size(); i++) {
    if (otherClients.get(i).score > topPlayer[0]) {
      topPlayer[0] = otherClients.get(i).score;
      topPlayer[1] = i;
    }
    
    if (otherClients.get(i).otherIcon.length() > 0) {
      boolean teamKnown = false;
      int teamScore = -1;
      int j = 0;
      
      while (j<currentTeams.size() && !teamKnown) {
        if (currentTeams.get(j).substring(0,currentTeams.get(j).indexOf(":")).equals(otherClients.get(i).otherIcon)) {
          teamKnown = true;
          
          teamScore = int(currentTeams.get(j).substring(currentTeams.get(j).indexOf(":")+1)) + otherClients.get(i).score;
          currentTeams.set(j,currentTeams.get(j).substring(0,currentTeams.get(j).indexOf(":")) + ":" + str(teamScore));
        }
        else {
          teamKnown = true;
          teamScore = otherClients.get(i).score;
          currentTeams.append(otherClients.get(i).otherIcon + ":" + str(teamScore));
        }
        
        j++;
      }
      
      if (teamKnown) {
        if (teamScore > topTeam[0]) {
          topTeam[0] = teamScore;
          topTeam[1] = j;
        }
      }
      else {
        teamScore = otherClients.get(i).score;
        currentTeams.append(otherClients.get(i).otherIcon + ":" + str(teamScore));
        if (teamScore > topTeam[0]) {
          topTeam[0] = teamScore;
          topTeam[1] = j;
        }
      }
    }
  }
  
  pushMatrix();
  textFont(infohelpFont,20*z);
  textAlign(CENTER);
  fill(255);
  if (topTeam[0] > -1) {
    text("TOP TEAM:",width/3,20);
  }
  if (topPlayer[1] > -1) {
    text("TOP PLAYER:\n" + otherClients.get(topPlayer[1]).name + " (" + str(topPlayer[0]) + ")",2*width/3,20);
  }
  else {
    text("TOP PLAYER:\n" + myClient.name + " (" + str(myClient.score) + ")",2*width/3,20);
  }
  popMatrix();
  
  if (topTeam[0] > -1) {
    PVector l = new PVector(((width/3)-width/2+myClient.camera.x)/z,((30*z)+20+myClient.camera.y-height/2)/z);
    
    if (topTeam[1] > -1) {
      drawIcon(currentTeams.get(topTeam[1]), l);
    }
    else {
      drawIcon(icon,l);
    }
  }
}