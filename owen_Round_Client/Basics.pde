String extractString(String text, String begin, char end) {
  String extracted = "";
  int i = text.indexOf(begin);
  i += begin.length();

  if (i - begin.length() > -1) {
    int j = text.indexOf(end, i);                  //indexOf("",i) == first index of "" after index i.

    if (j > -1 && i > -1) {                        //just in case
      extracted = text.substring(i, j);
    }
  }

  return extracted;
}

String replaceString(String text, String newText, String begin, char end) {
  String replaced = "";

  int i = 0;
  i = text.indexOf(begin)+begin.length(); 

  if (newText.length() > 0 && i > -1) {
    int j = text.indexOf(end, i);
    String before = text.substring(0, i);
    String after = text.substring(j);
    replaced = before + newText + after;
  } 
  else {
    replaced = text;
  }

  return replaced;
}

String cleanString(String text, String silt) {
  String cleaned = "";
  
  for (int i=0; i<text.length(); i++) {
    char index = text.charAt(i);
    boolean removeIndex = false;
    
    for (int j=0; j<silt.length(); j++) {
      if (index == silt.charAt(j)) {
        removeIndex = true;
      }
    }
    
    if (!removeIndex) {
      cleaned += index;
    }
  }
  
  return cleaned;
}

void broadcast(String text, String heading) {
  if (text.length() > 0) {
    String broadcast = addressID + myAddress + endID + heading + text + endHD;
    client.write(broadcast);
  }
}

void drawSights() {
  pushMatrix();
  noFill();
  stroke(255);
  strokeWeight(1.5);
  ellipseMode(CENTER);
  translate(mouseX,mouseY);
  
  if (mousePressed && mouseButton != RIGHT) {
    scale(1.2);
  }
  else {
    scale(1);
  }
  
  ellipse(0,0,20,20);
  
  line(-12,0,-8,0);
  line(8,0,12,0);
  line(0,-12,0,-8);
  line(0,8,0,12);
  
  point(0,0);
  popMatrix();
}

void readServerMessage() {
  if (client.available() > 0) {
    String text = client.readString();
    //                                                                             println("serverBroadcast: " + text);
    String receiverAddress = extractString(text,receiverID,endID);
    //                                                                             println("receiverAddress: " + receiverAddress);
    if (receiverAddress.equals(myAddress) || receiverAddress.equals("all")) {
      
      if (text.indexOf(messageHD) > -1 && text.indexOf(endID,text.indexOf(messageHD)) > -1 && text.indexOf(endHD,text.indexOf(endID,text.indexOf(messageHD))) > -1) {
        String message = text.substring(text.indexOf(endID,text.indexOf(messageHD))+1,text.indexOf(endHD,text.indexOf(endID,text.indexOf(messageHD))));
        //                                                                         println("message: " + message);
        
        if (message.equals("TAKEN")) {                                                  // Name given is already on-file.
          username = "Sorry, the username you gave is already taken.";
        }
        else if (message.equals("NOTFOUND")) {                                          // Name given is not on file.
          username = "Sorry, the username you entered was not found on file.";    
          loadString = "";
        }
        else if (message.equals("ADDED")) {                                             // Name given is acceptable and has been added.
          username = "Great! Now switch to LOAD FILE and sign in.";
        }
        else if (message.equals("DUPLICATE")) {                                         // Name given already corresponds to a player in the game. Someone is using another client's alias.
          username = "Sorry, that name is already signed in for another player.";
          loadString = "";
        } 
        else if (message.indexOf("REGISTERED") > -1 && stage == 3) {                    // Name given is acceptable and is now playing.
          if (message.indexOf(codeCD) > -1) {
            icon = extractString(message,codeCD,endCD);
          }
          if (message.indexOf(radiusID) > -1) {
            fieldWidth = (floor((int(extractString(message,radiusID,endID)) * 2) * 0.1)) * 10;
            fieldConfirmed = true;
          }
          
          if (fieldConfirmed) {
            myClient.name = cleanString(username,"0123456789");
            stage = 4;
            loadString = "";
          }
        }
        else if (message.equals("DEATH [" + myClient.name + endID) && stage == 4) {
          stage = 5;
        }
        else if (message.equals("LOSS")) {
          myClient.score -= 1;
        }
        else if (message.equals("FULL")) {
          username = "Sorry, there are too many clients currently playing.";            // clientList.size() has reached its limit.
          loadString = "";
        }
        else if (message.indexOf(chatID) > -1) {
          chatList.append(message);
          
          if (extractString(message,nameID,endID).equals(myClient.name) == false) {
            reading = true;
          }
        }
      }
      
      if (stage == 4) {
        readServerLists(text);
      } 
    }
  }
}

void mouseWheel(MouseEvent event) {
  if (stage == 2) {
    float scroll = event.getCount();
    scrollVelocity = scroll*-2;
  }
  
  else if (stage == 4) {
    if (myClient.cpackage.equals("spider") && myClient.score > 40) {
      float scroll = event.getCount();
      
      z -= scroll/500;
      
      if (z < upgrade("zoom",85)/100) {
        z = upgrade("zoom",85)/100;
      }
      if (z > 1) {
        z = 1;
      }
    }
    
    else if (myClient.cpackage.equals("mole") && myClient.score > 170) {
      float scroll = event.getCount();
      
      z -= scroll/500;
      
      if (z < upgrade("zoom",99.9)/100) {
        z = upgrade("zoom",99.9)/100;
      }
      if (z > 1) {
        z = 1;
      }
    }
  }
}