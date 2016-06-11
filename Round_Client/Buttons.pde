void createButtonInfo(int x, int y) {
  PVector difference = new PVector(mouseX,mouseY);
  difference.sub(x,y);
  
  if (difference.mag() < 35) {
    if (mousePressed) {
      stage = 1;
    }
    
    pushMatrix();
    stroke(255);
    noFill();
    ellipseMode(CENTER);
    ellipse(x,y,50,50);
    popMatrix();
  }
  
  pushMatrix();
  stroke(255);
  ellipseMode(CENTER);
  rectMode(CENTER);
  if (difference.mag() < 35 || stage == 1) { 
    fill(255);
  }
  else {
    noFill();
  }
  ellipse(x,y-9,6,6);
  rect(x,y+6,6,15);
  popMatrix();
}

void createButtonHelp(int x, int y) {
  PVector difference = new PVector(mouseX,mouseY);
  difference.sub(x,y);
  
  if (difference.mag() < 35) {
    if (mousePressed) {
      stage = 2;
      helpLocation = 0;
    }
    
    pushMatrix();
    stroke(255);
    noFill();
    ellipseMode(CENTER);
    ellipse(x,y,50,50);
    popMatrix();
  }
  
  pushMatrix();
  stroke(255);
  if (difference.mag() < 35 || stage == 2) {               
    fill(255);
  }
  else {
    noFill();
  }
  beginShape();
    vertex(x-10,y-13);
    vertex(x+10,y-13);
    vertex(x+10,y+5);
    vertex(x-3,y+5);
    vertex(x-3,y-1);
    vertex(x+4,y-1);
    vertex(x+4,y-7);
    vertex(x-10,y-7);
  endShape(CLOSE);
  ellipse(x,y+12,6,6);
  popMatrix();
}

void createButtonIcons(int x, int y) {
  PVector difference = new PVector(mouseX,mouseY);
  difference.sub(x,y);
  
  if (difference.mag() < 35) {
    if (mousePressed) {
      stage = 3;
    }
    
    pushMatrix();
    stroke(255);
    noFill();
    ellipseMode(CENTER);
    ellipse(x,y,50,50);
    popMatrix();
  }
  
  if (stage == 3 && teams.length() == 0) {
    broadcast("DATA",teamHD);
  }
  
  pushMatrix();
  stroke(255);
  if (difference.mag() < 35 || stage == 3) {
    fill(255);
  }
  else {
    fill(0);
  }
  translate(x,y-4);
  rectMode(CENTER);
  ellipseMode(CENTER);
  rect(0,0,24,19);
  ellipse(0,10,24,24);
  if (!(difference.mag() < 35 || stage == 3)) {
    noStroke();
    rect(0.5,0,22.5,17);
  }
  popMatrix();
}

void createButtonNew(int x, int y) {
  PVector difference = new PVector(mouseX,mouseY);
  difference.sub(width/2 + x,y-10);
  
  if (difference.mag() < 35) {
    pushMatrix();
    stroke(255);
    noFill();
    ellipseMode(CENTER);
    ellipse(width/2 + x,y-10,60,60);
    popMatrix();
    
    if (mousePressed) {
      requestingTeam = -2;
    }
  }
  
  pushMatrix();
  noStroke();
  fill(255);
  textAlign(LEFT);
  textFont(infohelpFont,20);
  if (requestingTeam == -2) {
    text(newTeam,x,y);
  }
  else if (requestingTeam == -3) {
    text("Sending request...",x,y);
  }
  else {
    text("Request new team",x,y);
  }
  
  stroke(255);
  strokeWeight(3);
  translate(width/2 + x, y-10);
  if (difference.mag() < 35) {
    line(-18,0,18,0);
    line(0,-18,0,18);
  }
  else {
    line(-12,0,12,0);
    line(0,-12,0,12);
  }
  popMatrix();
}

void createButtonScroll(int x, int y, float s) {
  pushMatrix();
  if (mousePressed) {
    fill(255,50);
  }
  else {
    fill(255,20);
  }
  noStroke();
  strokeWeight(1.5);
  rectMode(CENTER);
  if (stage == 2) {
    rect(x,map(s,-1280,0,height-200,200),55,400);
  }
  else if (stage == 3) {
    rect(x,map(s,-1 * (teamIcons.size()-3) * 122,0,height-200,200),55,400);
  }
  popMatrix();
  
  if (mouseX > x-35) {
    if (mouseY < y) {
      pushMatrix();
      noFill();
      if (mousePressed) {
        stroke(0);
        scrollVelocity = 3;
      }
      else {
        stroke(255);
      }
      strokeWeight(5);
      beginShape();
        vertex(x-15, y-80);
        vertex(x   , y-90);
        vertex(x+15, y-80);
      endShape();
      popMatrix();
    }
    else {
      pushMatrix();
      noFill();
      if (mousePressed) {
        stroke(0);
        scrollVelocity = -3;
      }
      else {
        stroke(255);
      }
      strokeWeight(5);
      beginShape();
        vertex(x-15, y+80);
        vertex(x   , y+90);
        vertex(x+15, y+80);
      endShape();
      popMatrix();
    }
  }
}

void createButtonPlay(int x, int y) {
  PVector mLocation = new PVector(mouseX,mouseY);
  mLocation.x -= x;
  mLocation.y -= y;
  float distance = mLocation.mag();
  
  float iconK = 12;
  
  if (distance < 35) {
    if (mousePressed && stage < 4) {
      stage = 4;
      titleOrigin.set(width/2,60);
      
      teams = "";
      teamIcons.clear();
      requestingTeam = -1;
      newTeam = "Type team name, then press ENTER";
    }
    else if (mousePressed && stage == 4 && username.length() > 0 && !(username.equals("TYPE USERNAME ([,],*,TAB,: are not allowed)")) && !(username.equals("Sorry, the username you gave is already taken.")) && !(username.equals("Sorry, the name you gave is already signed in for another player.")) && !(username.equals("Sorry, the username you entered was not found on file.")) && !(username.equals("Great! Now switch to LOAD FILE and sign in.")) && !(username.equals("Sorry, there are too many clients currently playing."))) {
      String message = "";
      
      if (username.indexOf('_') > -1) {
        code = username.substring(username.indexOf('_')+1);
        
        message += iconID + code + endID + nameID + username.substring(0,username.indexOf('_')) + endID + packageID;
      }
      else {
        message += nameID + username + endID + packageID;
      }
      
      if (combatPackage == 1) {
        message += "woodpecker";
      }
      else if (combatPackage == 2) {
        message += "mole";
      }
      else if (combatPackage == 3) {
        message += "salamander";
      }
      else if (combatPackage == 4) {
        message += "spider";
      }
      else if (combatPackage == 5) {
        message += "beaver";
      }
      else if (combatPackage == 6) {
        message += "turtle";
      }
      else if (combatPackage == 7) {
        message += "hedgehog";
      }
      else if (combatPackage == 8) {
        message += "termite";
      }
      
      message += endID;
      
      if (signed) {
        broadcast(message,loadHD);
        loadString = message;
      }
      else {
        broadcast(message,newHD);
      }
      
      mousePressed = false;
    }
    else if (stage == 4 && mousePressed == false) {
      if (loadString.length() > 0) {
        broadcast(loadString,loadHD);
      }
      else {
        pushMatrix();
        textFont(infohelpFont,15);
        textAlign(CENTER);
        fill(255);
        text("** If absolutely nothing happens when you press this button, TRY IT AGAIN. **",width/2,690);
        popMatrix();
      }
    }
    else if (stage == 6 && mousePressed) {
      myClient.restart();
      stage = 4;
    }
    
    pushMatrix();
    stroke(255);
    noFill();
    ellipseMode(CENTER);
    ellipse(x,y,50,50);
    popMatrix();
  }
  
  pushMatrix();
  stroke(255);
  if (distance < 35) {
    fill(255);
  }
  else {
    noFill();
  }
  x += 4;
  triangle(
             x - (.875*iconK), y - (iconK),
             x - (.875*iconK), y + (iconK),
             x + (.875*iconK), y
             );
  popMatrix();
}

void createButtonBack(int x, int y) {
  PVector mLocation = new PVector(mouseX,mouseY);
  mLocation.x -= x;
  mLocation.y -= y;
  float distance = mLocation.mag();
  
  float iconK = 12;
  
  if (distance < 35) {
    if (mousePressed) {
      stage = 0;
    }
    
    pushMatrix();
    stroke(255);
    noFill();
    ellipseMode(CENTER);
    ellipse(x,y,50,50);
    popMatrix();
  }
  
  pushMatrix();
  stroke(255);
  if (distance < 35) {
    fill(255);
  }
  else {
    noFill();
  }
  x -= 2;
  triangle(
             x + (.875*iconK), y - (iconK),
             x + (.875*iconK), y + (iconK),
             x - (.875*iconK), y
             );
  popMatrix();
}

void createButtonEscape(int x,int y) {
  if (mouseX > 700 && mouseY < 100) {
    PVector mLocation = new PVector(mouseX,mouseY);
    mLocation.x -= x;
    mLocation.y -= y;
    float distance = mLocation.mag();
    
    if (distance < 30) {
      escapeHover = true;
      if (mousePressed) {
        broadcast(nameID + myClient.name + endID + "ESCAPE",messageHD); 
      }
      
      pushMatrix();
      stroke(255);
      strokeWeight(1.5);
      noFill();
      ellipseMode(CENTER);
      ellipse(x,y,40,40);
      popMatrix();
    }
    else {
      escapeHover = false; 
    }
    
    pushMatrix();
    stroke(255);
    strokeWeight(1.5);
    if (distance < 30) {
      fill(255);
    }
    else {
      noFill();
    }
    rectMode(CENTER);
    rect(x,y,12,12);
    popMatrix();
  }
  else {
    escapeHover = false;
  }
}

void createButtonChat(int x, int y) {
  PVector mLocation = new PVector(mouseX,mouseY);
  mLocation.x -= x;
  mLocation.y -= y;
  float distance = mLocation.mag(); 
  
  if (distance < 30) {
    chatHover = true;
    if (!renaming) {
      if (mousePressed) {
        if (chatting) {
          chatting = false;
        }
        else if (!renaming) {
          chatting = true;
        }
        if (reading) {
          reading = false;
        }
        mousePressed = false;
      }
      
      pushMatrix();
      stroke(255);
      strokeWeight(1.5);
      noFill();
      ellipseMode(CENTER);
      ellipse(x,y,40,40);
      popMatrix();
    }
  }
  else {
    chatHover = false;
  }
  
  if (((mouseX > 700 && mouseY > 600) || reading || chatting) && !renaming) {
    pushMatrix();
    stroke(255);
    strokeWeight(1.5);
    if (distance < 30 || chatting) {
      fill(255);
    }
    else {
      noFill();
    }
    translate(x,y);
    beginShape();
      vertex(-9,-8);
      vertex(9,-8);
      vertex(9,6);
      vertex(-1,6);
      vertex(-5,10);
      vertex(-5,6);
      vertex(-9,6);
    endShape(CLOSE);
    popMatrix();
  }
}

void createButtonName(int x, int y) {
  PVector mLocation = new PVector(mouseX,mouseY);
  mLocation.x -= x;
  mLocation.y -= y;
  float distance = mLocation.mag(); 
  
  if (distance < 30) {
    nameHover = true;
    if (!chatting) {
      if (mousePressed) {
        if (renaming) {
          renaming = false;
        }
        else {
          renaming = true;
        }
        mousePressed = false;
      }
      
      pushMatrix();
      stroke(255);
      strokeWeight(1.5);
      noFill();
      ellipseMode(CENTER);
      ellipse(x,y,40,40);
      popMatrix();
    }
  }
  else {
    nameHover = false;
  }
  
  if ((mouseX < 100 && mouseY > 600 && !chatting) || renaming) {
    pushMatrix();
    stroke(255);
    strokeWeight(1.5);
    if (distance < 30 || renaming) {
      fill(255);
    }
    else {
      noFill();
    }
    translate(x,y);
    rotate(PI * -0.25);
    rectMode(CENTER);
    rect(0,-1,9,14);
    popMatrix();
    
    pushMatrix();
    stroke(255);
    strokeWeight(1.5);
    if (distance < 30 || renaming) {
      fill(255);
    }
    else {
      noFill();
    }
    translate(x,y);
    rotate(PI * -0.25);
    beginShape();
      vertex(4,-10);
      vertex(3,-14);
      vertex(0,-15);
      vertex(-3,-14);
      vertex(-4,-10);
    endShape();
    beginShape();
      vertex(4.5,9);
      vertex(0,15);
      vertex(-4.5,9);
    endShape();
    stroke(80);
    fill(80);
    strokeWeight(1);
    line(8,-10,-8,-10);
    popMatrix();
  }
}

void createButtonWoodpecker(int x, int y) {
  PVector mLocation = new PVector(mouseX,mouseY);
  mLocation.x -= x;
  mLocation.y -= y;
  float distance = mLocation.mag();
  
  if (distance < 40 && stage < 5) {
    if (mousePressed) {
      combatPackage = 1;
    }
    
    pushMatrix();
    stroke(255);
    noFill();
    ellipseMode(CENTER);
    ellipse(x,y,60,60);
    popMatrix();
  }
  
  pushMatrix();
  translate(2,0);
  stroke(255);
  if (distance < 40 || combatPackage == 1 || stage == 5) {                                      // 40 is the radius of the button's activation site
    fill(255);
  }
  else {
    noFill();
  }
  ellipse(x-6,y,24,24);
  triangle(x+10,y-4,
           x+22,y,
           x+10, y+4);
  ellipse(x-20, y-10,4,4);
           
  strokeWeight(3);
  if (stage < 5) {
    stroke(0);
  }
  else {
    stroke(80);
  }
  line(x-18,y,x-6,y-12);
  strokeWeight(1.5);
  popMatrix();
}

void createButtonMole(int x, int y) {
  PVector mLocation = new PVector(mouseX,mouseY);
  mLocation.x -= x;
  mLocation.y -= y;
  float distance = mLocation.mag();
  
  if (distance < 40 && stage < 5) {
    if (mousePressed) {
      combatPackage = 2;
    }
    
    pushMatrix();
    stroke(255);
    noFill();
    ellipseMode(CENTER);
    ellipse(x,y,60,60);
    popMatrix();
  }
  
  pushMatrix();
  if (distance < 40 || combatPackage == 2 || stage == 5) {
    fill(255);
  }
  else {
    noFill();
  }
  stroke(255);
  ellipse(x,y-8,20,20);
  if (stage < 5) {
    fill(0);
    noStroke();
    rect(x,y-2,20,10);
  }
  else {
    fill(80);
  }
  
  popMatrix();
  
  pushMatrix();
  if (distance < 40 || combatPackage == 2 || stage == 5) {
    fill(255);
  }
  else {
    noFill();
  }
  stroke(255);
  
  translate(0,-4);
  beginShape();
    vertex(x+10,y-4);
    vertex(x+10,y+20);
    vertex(x-10,y+20);
    vertex(x-10,y-4);
  if (distance < 40) {
    endShape(CLOSE);
  }
  else {
    endShape();
  }
  popMatrix();
  
  pushMatrix();
  if (stage < 5) {
    fill(0);
    stroke(0);
  }
  else {
    fill(80);
    stroke(80);
  }
  strokeWeight(3);
  line(x-10,y-2,x+10,y-2);
  strokeWeight(1.5);
  
  if (distance < 40 || combatPackage == 2 || stage == 5) {
    noStroke();
  }
  else {
    stroke(255);
  }
  ellipse(x,y-2,10,10);
  popMatrix();
}

void createButtonSalamander(int x, int y) {
  PVector mLocation = new PVector(mouseX,mouseY);
  mLocation.x -= x;
  mLocation.y -= y;
  float distance = mLocation.mag();
  
  pushMatrix();
  stroke(255);
  ellipseMode(CENTER);
  if (distance < 40 || combatPackage == 3 || stage == 5) {                                      // 40 is the radius of the button's activation site
    fill(255);
  }
  else {
    noFill();
  }
  ellipse(x,y,30,30);
  popMatrix();
  
  pushMatrix();
  if (stage < 5) {
    fill(0);
  }
  else {
    fill(80);
  }
  noStroke();
  translate(x,y-8);
  rectMode(CENTER);
  rect(0,0,35,15); 
  popMatrix();
  
  if (distance < 40 && stage < 5) {
    if (mousePressed) {
      combatPackage = 3;
    }
    
    pushMatrix();
    stroke(255);
    noFill();
    ellipseMode(CENTER);
    ellipse(x,y,60,60);
    popMatrix();
  }
  
  pushMatrix();
  if (distance < 40 || combatPackage == 3 || stage == 5) {
    fill(255);
  }
  else {
    noFill();
  }
  stroke(255);
  beginShape();
    vertex(x-15,y);
    vertex(x-14,y-7);
    vertex(x-4,y-2);
    vertex(x+2,y-16);
    vertex(x+10,y-3);
    vertex(x+14,y-5);
    vertex(x+15,y);
  if (distance < 40 || combatPackage == 3 || stage == 5) {
    endShape(CLOSE);
  }
  else {
    endShape();
  }
  popMatrix();
}

void createButtonSpider(int x, int y) {
  PVector mLocation = new PVector(mouseX,mouseY);
  mLocation.x -= x;
  mLocation.y -= y;
  float distance = mLocation.mag();
  
  if (distance < 40 && stage < 5) {
    if (mousePressed) {
      combatPackage = 4;
    }
    
    pushMatrix();
    stroke(255);
    strokeWeight(1.5);
    noFill();
    ellipseMode(CENTER);
    ellipse(x,y,60,60);
    popMatrix();
  }
  pushMatrix();
  if (distance < 40 || combatPackage == 4 || stage == 5) {
    fill(255);
  }
  else {
    noFill();
  }
  stroke(255);
  strokeWeight(1.5);
  beginShape();
    vertex(x,y+10);
    vertex(x-10,y);
    vertex(x+2,y-15);
    vertex(x+11,y+1);
  endShape(CLOSE);
  popMatrix();
  
  pushMatrix();
  stroke(255);
  strokeWeight(1.5);
  noFill();
  beginShape();
    vertex(x,y+10);
    vertex(x+14,y+9);
    vertex(x+18,y+15);
  endShape();
  beginShape();
    vertex(x,y+10);
    vertex(x-14,y+6);
    vertex(x-17,y+15);
  endShape();
  popMatrix();
  
  pushMatrix();
  stroke(255);
  if (distance < 40 || combatPackage == 4 || stage == 5) {
    fill(255);
  }
  else {
    fill(0);
  }
  ellipse(x,y+10,8,8);
  if (stage < 5) {
    stroke(0);
  }
  else {
    stroke(80);
  }
  strokeWeight(2.5);
  noFill();
  ellipse(x,y+10,12,12);
  strokeWeight(1.5);
  popMatrix();
}

void createButtonBeaver(int x, int y) {
  PVector mLocation = new PVector(mouseX,mouseY);
  mLocation.x -= x;
  mLocation.y -= y;
  float distance = mLocation.mag();
  
  if (distance < 40 && stage < 5) {
    if (mousePressed) {
      combatPackage = 5;
    }
    
    pushMatrix();
    stroke(255);
    noFill();
    ellipseMode(CENTER);
    ellipse(x,y,60,60);
    popMatrix();
  }
  
  pushMatrix();
  stroke(255);
  if (distance < 40 || combatPackage == 5 || stage == 5) {
    fill(255);
  }
  else {
    noFill();
  }
  beginShape();
    vertex(x-14,y-14);
    vertex(x+14,y-14);
    vertex(x+14,y-10);
    vertex(x+2,y-7);
    vertex(x+14,y-3);
    vertex(x+14,y+4);
    vertex(x+5,y+7);
    vertex(x+14,y+10);
    vertex(x+14,y+14);
    vertex(x-14,y+14);
    vertex(x-14,y+5);
    vertex(x,y);
    vertex(x-14,y-6);
  endShape(CLOSE);
  popMatrix();
}

void createButtonTurtle(int x, int y) {
  PVector mLocation = new PVector(mouseX,mouseY);
  mLocation.x -= x;
  mLocation.y -= y;
  float distance = mLocation.mag();
  
  pushMatrix();
  stroke(255);
  if (distance < 40 || combatPackage == 6 || stage == 5) {
    fill(255);
  }
  else {
    noFill();
  }
  ellipse(x,y+8,34,50);
  noStroke();
  if (stage < 5) {
    fill(0);
  }
  else {
    fill(80);
  }
  rectMode(CENTER);
  rect(x,y+25,40,30);
  popMatrix();
  
  pushMatrix();
  stroke(255);
  if (distance < 40 || combatPackage == 6 || stage == 5) {
    fill(255);
  }
  else {
    noFill();
  }
  translate(2,2);
  triangle(x-18,y+10,x-10,y+10,x-14,y+16);
  translate(-4,0);
  triangle(x+18,y+10,x+10,y+10,x+14,y+16);
  popMatrix();
  
  pushMatrix();
  stroke(255);
  if (distance < 40 || combatPackage == 6 || stage == 5) {
    fill(255);
  }
  else {
    fill(0);
  }
  ellipse(x,y+8,8,8);
  if (stage < 5) {
    stroke(0);
  }
  else {
    stroke(80);
  }
  strokeWeight(2.5);
  noFill();
  ellipse(x,y+8,12,12);
  strokeWeight(1.5);
  popMatrix();
  
  if (distance < 40 && stage < 5) {
    if (mousePressed) {
      combatPackage = 6;
    }
    
    pushMatrix();
    stroke(255);
    noFill();
    ellipseMode(CENTER);
    ellipse(x,y,60,60);
    popMatrix();
  }
}

void createButtonHedgehog(int x, int y) {
  PVector mLocation = new PVector(mouseX,mouseY);
  mLocation.x -= x;
  mLocation.y -= y;
  float distance = mLocation.mag();
  
  if (distance < 40 && stage < 5) {
    if (mousePressed) {
      combatPackage = 7;
    }
    
    pushMatrix();
    stroke(255);
    noFill();
    ellipseMode(CENTER);
    ellipse(x,y,60,60);
    popMatrix();
  }
  
  pushMatrix();
  stroke(255);
  if (distance < 40 || combatPackage == 7 || stage == 5) {
    fill(255);
  }
  else {
    noFill();
  }
  translate(0,5);
  triangle(x-7,y-(7*1.75*.5),x+7,y-(7*1.75*.5),x,y+(7*1.75*.5));
  translate(0,-17);
  triangle(x-7,y+(7*1.75*.5),x+7,y+(7*1.75*.5),x,y-(7*1.75*.5));
  translate(10,20);
  triangle(x-7,y+(7*1.75*.5),x+7,y+(7*1.75*.5),x,y-(7*1.75*.5));
  translate(-20,0);
  triangle(x-7,y+(7*1.75*.5),x+7,y+(7*1.75*.5),x,y-(7*1.75*.5));
  popMatrix();
}

void createButtonTermite(int x, int y) {
  PVector mLocation = new PVector(mouseX,mouseY);
  mLocation.x -= x;
  mLocation.y -= y;
  float distance = mLocation.mag();
  
  if (distance < 40 && stage < 5) {
    if (mousePressed) {
      combatPackage = 8;
    }
    
    pushMatrix();
    stroke(255);
    noFill();
    ellipseMode(CENTER);
    ellipse(x,y,60,60);
    popMatrix();
  }
  
  pushMatrix();
  stroke(255);
  if (distance < 40 || combatPackage == 8 || stage == 5) {
    fill(255);
  }
  else {
    noFill();
  }
  translate(x,y-2);
  beginShape();
    vertex(-14,-14);
    vertex(-8,-14);
    vertex(-8,-8);
    vertex(-3,-8);
    vertex(-3,-14);
    vertex(3,-14);
    vertex(3,-8);
    vertex(8,-8);
    vertex(8,-14);
    vertex(14,-14);
    vertex(14,18);
    vertex(5,18);
    vertex(5,10);
    vertex(-5,10);
    vertex(-5,18);
    vertex(-14,18);
  endShape(CLOSE);
  popMatrix();
}

void createButtonSigned(int x,int y) {
  PVector mLocation = new PVector(mouseX,mouseY);
  mLocation.x -= x;
  mLocation.y -= y;
  float distance = mLocation.mag();
  
  if (distance < 17) {
    if (mousePressed) {
      if (signed) {
        signed = false;
      }
      else {
        signed = true;
      }
      mousePressed = false;
    }
  }
  
  pushMatrix();
  stroke(255);
  if (signed) {
    fill(255);
  }
  else {
    noFill();
  }
  ellipseMode(CENTER);
  if (distance < 17) {
    ellipse(x,y,14,14);
  }
  else {
    ellipse(x,y,10,10);
  }
  popMatrix();
  
  pushMatrix();
  int textSize = 20;
  textFont(infohelpFont,textSize);
  textAlign(LEFT);
  fill(255);
  if (signed) {
    text("LOAD FILE (If you already have a name saved)",x+20,y+7);
  }
  else {
    text("NEW FILE (If you have never played before)",x+20,y+7);
  }
  popMatrix();
}

void createButtonGraphics(int x,int y) {
  PVector mLocation = new PVector(mouseX,mouseY);
  mLocation.x -= x;
  mLocation.y -= y;
  float distance = mLocation.mag();
  
  if (distance < 17) {
    if (mousePressed) {
      if (bestGraphics) {
        bestGraphics = false;
      }
      else {
        bestGraphics = true;
      }
      mousePressed = false;
    }
  }
  
  pushMatrix();
  stroke(255);
  if (bestGraphics) {
    fill(255);
  }
  else {
    noFill();
  }
  ellipseMode(CENTER);
  if (distance < 17) {
    ellipse(x,y,14,14);
  }
  else {
    ellipse(x,y,10,10);
  }
  popMatrix();
  
  pushMatrix();
  int textSize = 20;
  textFont(infohelpFont,textSize);
  textAlign(LEFT);
  fill(255);
  if (bestGraphics) {
    text("HIGH QUALITY (Better graphics, but can be a bit slower)",x+20,y+7);
  }
  else {
    text("LOWER QUALITY (Worse graphics, but is faster)",x+20,y+7);
  }
  popMatrix();
}