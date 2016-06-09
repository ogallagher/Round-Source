// ICONS

void drawIcons(int x, int y) {    //Height of 1 icon description: ~122
  int minimum = -1 * (teamIcons.size()-3) * 122;

  iconLocation += scrollVelocity;
  
  if (iconLocation > 0) {
    iconLocation = 0;
  }
  if (iconLocation < minimum) {
    iconLocation = minimum; 
  }
  
  y += iconLocation;
  
  if (teams.length() > 0) {
    pushMatrix();
    textFont(infohelpFont,20);
    textAlign(LEFT);
    fill(255);
    text(teams,x,y);
    popMatrix();
    
    for (int i=0; i<teamIcons.size(); i++) {
      drawIcon(teamIcons.get(i),new PVector(x,y + (122*i) - 320));
      
      if (!ownTeam) {
        PVector origin = new PVector(x,y+(122*i)-320);
        PVector difference = new PVector(mouseX,mouseY);
        difference.sub((z*origin.x)-myClient.camera.x+width/2,(z*origin.y)-myClient.camera.y+height/2);
        
        if (difference.mag() < 30) {
          pushMatrix();
          ellipseMode(CENTER);
          stroke(255);
          strokeWeight(1.5);
          noFill();
          ellipse((z*origin.x)-myClient.camera.x+width/2,(z*origin.y)-myClient.camera.y+height/2,60,60);
          popMatrix();
          
          if (mousePressed) {
            requestingTeam = i;
          }
        }
      }
    }
    
    pushMatrix();
    fill(0,90);
    noStroke();
    rectMode(CORNER);
    rect(0,0,width,160);
    popMatrix();
  }
  else {
    pushMatrix();
    textFont(infohelpFont,20);
    textAlign(LEFT);
    fill(255);
    text("Waiting for team data...",width/3,height/2);
    popMatrix();
  }
  
  scrollVelocity *= 0.5;
}

void newTeam() {
  if (keyPressed && requestingTeam == -2) {
      if ((key == DELETE || key == BACKSPACE) && newTeam.length() > 0) {
        newTeam = newTeam.substring(0,newTeam.length()-1);
      }
      
      else if (key != CODED && key != BACKSPACE && key != ENTER && key != RETURN && key != '*' && key != '[' && key != ']' && key != ':' && key != '\t') {
        if (newTeam.equals("Type team name, then press ENTER")) {
          newTeam = str(key);
        }
        else {
          newTeam = newTeam + key;
        }
      }
      
      newTeam = newTeam.toUpperCase();
      
      if (key == ENTER || key == RETURN) {
        requestingTeam = -3;
      }
      
      keyPressed = false;
  }
}

void teamRequests() {
  if (requestingTeam > -1) {
    String request = "CODE";
    
    if (username.length() > 0 && !(username.equals("TYPE USERNAME ([,],*,TAB,: are not allowed)")) && !(username.equals("Sorry, the username you gave is already taken.")) && !(username.equals("Sorry, the name you gave is already signed in for another player.")) && !(username.equals("Sorry, the username you entered was not found on file.")) && !(username.equals("Great! Now switch to LOAD FILE and sign in.")) && !(username.equals("Sorry, there are too many clients currently playing."))) {
      if (username.indexOf('_') > -1) {
        request += nameID + username.substring(0,username.indexOf('_')) + endID;
      }
      else {
        request += nameID + username + endID;
      }
      
      request += iconID + teamIcons.get(requestingTeam) + endID;
      
      broadcast(request,teamHD);
    }
  }
  else if (requestingTeam == -3) {
    String request = "NEW";
    
    if (!newTeam.equals("Type team name, then press ENTER") && newTeam.length() > 0) {
      request += nameID + newTeam + endID;
      
      broadcast(request,teamHD);
    }
  }
}