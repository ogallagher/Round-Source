void printData() {
  background(50);
  
  pushMatrix();
  
  int textSize = 11;
  textFont(displayFont, textSize);
  fill(255);
  textAlign(LEFT);
  
  text("CURRENT CLIENTS (" + clientList.size() + ")", 5, textSize);
  for(int i=0; i<clientList.size(); i++) {
    String client = extractString(clientList.get(i),nameID,endID) + ' ' + extractString(clientList.get(i),scoreID,endID) + ": (" + extractString(clientList.get(i),locationID,endID) + ")";
    text(client, 5, 30 + ((textSize+5)*i));
  }
  
  text("ENEMIES (" + enemyList.size() + ")", 240, textSize);                      //Add a maximum entry length for these column displays.
  for(int i=0; i<enemyList.size(); i++) {
    Enemy enemy = enemyList.get(i);
    text('(' + str(enemy.location.x) + ',' + str(enemy.location.y) + ')', 240, 30 + ((textSize+5)*i));
  }
  
  text("OBJECTS (" + objectList.size() + ")", 425, textSize);
  int w = 0;
  for(int i=30; i<objectList.size(); i++) {
    if (extractString(objectList.get(i),nameID,endID).equals("wall") == false) {
      String object = extractString(objectList.get(i),nameID,endID) + ": (" + extractString(objectList.get(i),locationID,endID) + ')';
      text(object, 425, 30 + ((textSize+5)*(i-w-30)));
    }
    else {
      w++;
    }
  }
  
  popMatrix();
}

void textBoxChat(int locationX,int locationY) {
  if (keyPressed) {
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
      
      else if ((key == ENTER || key == RETURN) && chatBoxString.equals("[,],*,:,$,TAB = Not Permitted. Limit = 60 char.") == false && chatBoxString.length() > 0) {
        String chat = nameID + "SERVER" + endID + chatID + chatBoxString + endID;
        chatBoxString = "";
        
        broadcast(chat, messageHD, "all");
        chatList.append(chat);
      }
      
      keyPressed = false;
  }
  
  pushMatrix();
  fill(0,20);
  noStroke();
  rectMode(CORNER);
  rect(0,locationY-30,width,80);
  popMatrix();
  
  pushMatrix();
  textFont(chatFont,15);
  textAlign(LEFT);
  fill(255);
  translate(locationX,locationY);
  text(chatBoxString,0,0);
  popMatrix();
}

void displayChatLine() {
  if (chatList.size() > 7) {
    chatList.remove(0);
  }
  
  pushMatrix();
  fill(0,20);
  noStroke();
  rectMode(CORNER);
  rect(0,465,width,75);
  popMatrix();
  
  pushMatrix();
  textFont(chatFont,10);
  textAlign(LEFT);
  fill(255);
  translate(25,475);
  for (int i=0; i<chatList.size(); i++) {
    String name = extractString(chatList.get(i),nameID,endID);
    String chat = extractString(chatList.get(i),chatID,endID);
    text(name + ":  " + chat,0,i*10);
  }
  popMatrix();
}