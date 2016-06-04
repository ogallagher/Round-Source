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

int getIndexOf(StringList list, String search) {
  int index = -1;
  
  if (list.size() > 0 && search.length() > 0) {
    for (int i=0; i<list.size() && index < 0; i++) {
      if (list.get(i).equals(search)) {
        index = i;
      }
    }
  }
  
  return index;
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

void drawIcon(String icon, PVector location) {
  String[] shapes = split(icon,splitID);
      
  for (int i=0; i<shapes.length; i++) {
    pushMatrix();
    translate((z*location.x)-myClient.camera.x+width/2,(z*location.y)-myClient.camera.y+height/2);
    
    float rotation = 0;
    if (shapes[i].indexOf(angleID) > -1) {
      rotation = float(extractString(shapes[i],angleID,endID));
    }
    rotate(rotation);
    
    if (shapes[i].indexOf(locationID) > -1) {
      float[] translation = float(split(extractString(shapes[i],locationID,endID),','));
      translate(z*translation[0],z*translation[1]);
    }
    
    int fillColor = int(extractString(shapes[i],alphaID,endID));
    if (stage == 3) {
      if (fillColor < 255) {
        fillColor = 0;
      }
    }
    fill(fillColor);
    stroke(fillColor);
    strokeWeight(z*1.5);
    
    if (shapes[i].indexOf(shapeID) > -1) {
      String[] vertices = split(extractString(shapes[i],shapeID,endID),';');
      
      beginShape();
        for (int j=0; j<vertices.length; j++) {
          float[] vertex = float(split(vertices[j],','));
          vertex(z*vertex[0],z*vertex[1]);
        }
      endShape(CLOSE);
    }
    else if (shapes[i].indexOf(ellipseID) > -1) {
      float[] dimensions = float(split(extractString(shapes[i],ellipseID,endID),','));
      ellipseMode(CENTER);
      ellipse(0,0,z*dimensions[0],z*dimensions[1]);
    }
    popMatrix();
  }
}

void readServerMessage() {
  if (client.available() > 0) {
    String text = client.readString();
    String receiverAddress = extractString(text,receiverID,endID);
    //                                                                             println("receiverAddress: " + receiverAddress);
    if (receiverAddress.equals(myAddress) || receiverAddress.equals(code) || receiverAddress.equals("all")) {
      if (text.indexOf(messageHD) > -1 && text.indexOf(endID,text.indexOf(messageHD)) > -1 && text.indexOf(endHD,text.indexOf(endID,text.indexOf(messageHD))) > -1) {
        String message = text.substring(text.indexOf(endID,text.indexOf(messageHD))+1,text.indexOf(endHD,text.indexOf(endID,text.indexOf(messageHD))));
        println("  message: " + message);
        
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
        else if (message.indexOf("REGISTERED") > -1 && stage == 4) {                    // Name given is acceptable and is now playing.
          if (message.indexOf(iconID) > -1 && message.indexOf(radiusID) > -1) {
            icon = message.substring(message.indexOf(iconID) + iconID.length(), message.indexOf(endID + radiusID));
            fieldWidth = (floor((int(extractString(message,radiusID,endID)) * 2) * 0.1)) * 10;
            fieldConfirmed = true;
          }
          
          if (fieldConfirmed) {
            stage = 5;
            loadString = "";
            
            String[] newList = pastUsernames.array();
            
            if (username.indexOf('_') > -1) {
              if (!pastUsernames.hasValue(username.substring(0,username.indexOf('_')))) {
                pastUsernames.clear();
                pastUsernames.append(username.substring(0,username.indexOf('_')));
              }
              else {
                pastUsernames.remove(getIndexOf(pastUsernames,username.substring(0,username.indexOf('_'))));
                newList = pastUsernames.array();
                pastUsernames.clear();
                pastUsernames.append(username.substring(0,username.indexOf('_')));
              }
            }
            else {
              if (!pastUsernames.hasValue(username)) {
                pastUsernames.clear();
                pastUsernames.append(username);
              }
              else {
                pastUsernames.remove(getIndexOf(pastUsernames,username));
                newList = pastUsernames.array();
                pastUsernames.clear();
                pastUsernames.append(username);
              }
            }
            
            pastUsernames.append(newList);
            updateFile();
          }
        }
        else if (message.equals("DEATH [" + myClient.name + endID) && stage == 5) {
          stage = 6;
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
      
      if ((teams.length() == 0 || requestingTeam > -1 || requestingTeam == -3) && text.indexOf(teamHD) > -1 && text.indexOf(endID,text.indexOf(teamHD)) > -1 && text.indexOf(endHD,text.indexOf(endID,text.indexOf(teamHD))) > -1) {
        teams = text.substring(text.indexOf(endID,text.indexOf(teamHD))+1,text.indexOf(endHD,text.indexOf(endID,text.indexOf(teamHD))));
        teamIcons.clear();
        newTeam = "Type team name, then press ENTER";
        requestingTeam = -1;
        
        String newTeams = "";
        int i=0;
        
        while(i < teams.length()) {
          String team = teams.substring(i);
          int teamEnd = team.indexOf('\n');
          
          String teamName = extractString(team,nameID,endID);
          String teamOwner = extractString(team,ownerID,endID);
          String teamCode = extractString(team,iconID,endID);
          String teamIcon = team.substring(team.indexOf(iconID + teamCode + endID) + iconID.length() + teamCode.length() + 1, teamEnd);
          
          newTeams += "Name: " + teamName + "\nOwner: ";
          if (teamOwner.length() > 0) {
            newTeams += cleanString(teamOwner,"0123456789");
          }
          else {
            newTeams += "N/A";
          }
          if (teamCode.length() > 0) {
            String myName = "";
            if (username.indexOf('_') > -1) {
               myName = username.substring(0,username.indexOf('_'));
             }
             else {
               myName = username;
             }
             
            if (teamOwner.equals(myName)) {
              ownTeam = true;
              newTeams += "\nCode: " + teamCode;
            }
            else {
              newTeams += "\nCode: " + "•••••";
            }
          }
          newTeams += "\n\n";
          
          if (teamIcon.length() > 0) {
            teamIcons.append(teamIcon);
          }
          
          i += teamEnd + 1;
        }
        
        teams = newTeams;
      }
      
      if (stage == 5) {
        readServerLists(text);
      } 
    }
  }
}

void updateFile() {
  String[] newFile = new String[pastUsernames.size()];
  
  for (int i=0; i<newFile.length; i++) {
    newFile[i] = pastUsernames.get(i);
  }

  // Writes the strings to a file, each on a separate line
  saveStrings("usernames.txt", newFile);
}

void updateKeys() {
  if (keyPressed) {
    if (key == 'w' || keyCode == UP) {
      keys[0] = true;
    }
    if (key == 'a' || keyCode == LEFT) {
      keys[1] = true;
    }
    if (key == 's' || keyCode == DOWN) {
      keys[2] = true;
    }
    if (key == 'd' || keyCode == RIGHT) {
      keys[3] = true;
    }
  }
}

void keyReleased() {
  if (key == 'w' || keyCode == UP) {
    keys[0] = false;
  }
  if (key == 'a' || keyCode == LEFT) {
    keys[1] = false;
  }
  if (key == 's' || keyCode == DOWN) {
    keys[2] = false;
  }
  if (key == 'd' || keyCode == RIGHT) {
    keys[3] = false;
  }
}

void mouseWheel(MouseEvent event) {
  if (stage == 2 || stage == 3) {
    float scroll = event.getCount();
    scrollVelocity = scroll*-4;
  }
  
  else if (stage == 5) {
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