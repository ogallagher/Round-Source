void createButtonInfo(int locationX, int locationY) {
  PVector mLocation = new PVector(mouseX,mouseY);
  mLocation.x -= locationX;
  mLocation.y -= locationY;
  float distance = mLocation.mag();
  
  if (distance < 35) {
    if (mousePressed) {
      stage = 1;
    }
    
    pushMatrix();
    stroke(255);
    noFill();
    ellipseMode(CENTER);
    ellipse(locationX,locationY,50,50);
    popMatrix();
  }
  
  pushMatrix();
  stroke(255);
  ellipseMode(CENTER);
  rectMode(CENTER);
  if (distance < 35 || stage == 1) { 
    fill(255);
  }
  else {
    noFill();
  }
  ellipse(locationX,locationY-9,6,6);
  rect(locationX,locationY+6,6,15);
  popMatrix();
}

void createButtonHelp(int locationX, int locationY) {
  PVector mLocation = new PVector(mouseX,mouseY);
  mLocation.x -= locationX;
  mLocation.y -= locationY;
  float distance = mLocation.mag();
  
  if (distance < 35) {
    if (mousePressed) {
      stage = 2;
      helpLocation = 0;
    }
    
    pushMatrix();
    stroke(255);
    noFill();
    ellipseMode(CENTER);
    ellipse(locationX,locationY,50,50);
    popMatrix();
  }
  
  pushMatrix();
  stroke(255);
  if (distance < 35 || stage == 2) {               
    fill(255);
  }
  else {
    noFill();
  }
  beginShape();
    vertex(locationX-10,locationY-13);
    vertex(locationX+10,locationY-13);
    vertex(locationX+10,locationY+5);
    vertex(locationX-3,locationY+5);
    vertex(locationX-3,locationY-1);
    vertex(locationX+4,locationY-1);
    vertex(locationX+4,locationY-7);
    vertex(locationX-10,locationY-7);
  endShape(CLOSE);
  ellipse(locationX,locationY+12,6,6);
  popMatrix();
}

void createButtonScroll(int locationX, int locationY) {
  pushMatrix();
  if (mousePressed || abs(scrollVelocity) > 50) {
    fill(255,50);
  }
  else {
    fill(255,20);
  }
  noStroke();
  strokeWeight(1.5);
  rectMode(CENTER);
  rect(locationX,locationY,55,height);
  popMatrix();
  
  if (mouseX > locationX-35) {
    if (mouseY < locationY || round(scrollVelocity) > 0) {
      pushMatrix();
      noFill();
      if (mousePressed) {
        stroke(0);
        scrollVelocity = 3;
      }
      else if (abs(scrollVelocity) > 50) {
        stroke(0);
      }
      else {
        stroke(255);
      }
      strokeWeight(5);
      beginShape();
        vertex(locationX-15, locationY-80);
        vertex(locationX   , locationY-90);
        vertex(locationX+15, locationY-80);
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
      else if (abs(scrollVelocity) > 50) {
        stroke(0);
      }
      else {
        stroke(255);
      }
      strokeWeight(5);
      beginShape();
        vertex(locationX-15, locationY+80);
        vertex(locationX   , locationY+90);
        vertex(locationX+15, locationY+80);
      endShape();
      popMatrix();
    }
  }
}

void createButtonPlay(int locationX, int locationY) {
  PVector mLocation = new PVector(mouseX,mouseY);
  mLocation.x -= locationX;
  mLocation.y -= locationY;
  float distance = mLocation.mag();
  
  float iconK = 12;
  
  if (distance < 35) {
    if (mousePressed && stage < 3) {
      stage = 3;
      titleOrigin.set(width/2,60);
    }
    else if (mousePressed && stage == 3 && (username.equals("TYPE USERNAME ([,],*,TAB,: are not allowed)") == false && username.equals("Sorry, the username you gave is already taken.") == false && username.equals("Sorry, the name you gave is already signed in for another player.") == false && username.equals("Sorry, the username you entered was not found on file.") == false && username.equals("Great! Now switch to LOAD FILE and sign in.") == false && username.equals("Sorry, there are too many clients currently playing.") == false)) {
      String message = "";
      String code = "";
      
      if (username.indexOf(codeCD) > -1 && username.indexOf(endCD) > -1) {
        code = extractString(username,codeCD,endCD);
        username = username.substring(0,username.indexOf(codeCD));
        
        message += codeCD + code + endCD;
      }
      
      message += nameID + username + endID + packageID;
      
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
    else if (stage == 3 && mousePressed == false) {
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
    else if (stage == 5 && mousePressed) {
      myClient.restart();
      stage = 3;
    }
    
    pushMatrix();
    stroke(255);
    noFill();
    ellipseMode(CENTER);
    ellipse(locationX,locationY,50,50);
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
  locationX += 4;
  triangle(
             locationX - (.875*iconK), locationY - (iconK),
             locationX - (.875*iconK), locationY + (iconK),
             locationX + (.875*iconK), locationY
             );
  popMatrix();
}

void createButtonBack(int locationX, int locationY) {
  PVector mLocation = new PVector(mouseX,mouseY);
  mLocation.x -= locationX;
  mLocation.y -= locationY;
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
    ellipse(locationX,locationY,50,50);
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
  locationX -= 2;
  triangle(
             locationX + (.875*iconK), locationY - (iconK),
             locationX + (.875*iconK), locationY + (iconK),
             locationX - (.875*iconK), locationY
             );
  popMatrix();
}

void createButtonEscape(int locationX,int locationY) {
  if (mouseX > 700 && mouseY < 100) {
    PVector mLocation = new PVector(mouseX,mouseY);
    mLocation.x -= locationX;
    mLocation.y -= locationY;
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
      ellipse(locationX,locationY,40,40);
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
    rect(locationX,locationY,12,12);
    popMatrix();
  }
  else {
    escapeHover = false;
  }
}

void createButtonChat(int locationX, int locationY) {
  PVector mLocation = new PVector(mouseX,mouseY);
  mLocation.x -= locationX;
  mLocation.y -= locationY;
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
      ellipse(locationX,locationY,40,40);
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
    translate(locationX,locationY);
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

void createButtonName(int locationX, int locationY) {
  PVector mLocation = new PVector(mouseX,mouseY);
  mLocation.x -= locationX;
  mLocation.y -= locationY;
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
      ellipse(locationX,locationY,40,40);
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
    translate(locationX,locationY);
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
    translate(locationX,locationY);
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

void createButtonWoodpecker(int locationX, int locationY) {
  PVector mLocation = new PVector(mouseX,mouseY);
  mLocation.x -= locationX;
  mLocation.y -= locationY;
  float distance = mLocation.mag();
  
  if (distance < 40 && stage < 4) {
    if (mousePressed) {
      combatPackage = 1;
    }
    
    pushMatrix();
    stroke(255);
    noFill();
    ellipseMode(CENTER);
    ellipse(locationX,locationY,60,60);
    popMatrix();
  }
  
  pushMatrix();
  translate(2,0);
  stroke(255);
  if (distance < 40 || combatPackage == 1 || stage == 4) {                                      // 40 is the radius of the button's activation site
    fill(255);
  }
  else {
    noFill();
  }
  ellipse(locationX-6,locationY,24,24);
  triangle(locationX+10,locationY-4,
           locationX+22,locationY,
           locationX+10, locationY+4);
  ellipse(locationX-20, locationY-10,4,4);
           
  strokeWeight(3);
  if (stage < 4) {
    stroke(0);
  }
  else {
    stroke(80);
  }
  line(locationX-18,locationY,locationX-6,locationY-12);
  strokeWeight(1.5);
  popMatrix();
}

void createButtonMole(int locationX, int locationY) {
  PVector mLocation = new PVector(mouseX,mouseY);
  mLocation.x -= locationX;
  mLocation.y -= locationY;
  float distance = mLocation.mag();
  
  if (distance < 40 && stage < 4) {
    if (mousePressed) {
      combatPackage = 2;
    }
    
    pushMatrix();
    stroke(255);
    noFill();
    ellipseMode(CENTER);
    ellipse(locationX,locationY,60,60);
    popMatrix();
  }
  
  pushMatrix();
  if (distance < 40 || combatPackage == 2 || stage == 4) {
    fill(255);
  }
  else {
    noFill();
  }
  stroke(255);
  ellipse(locationX,locationY-8,20,20);
  if (stage < 4) {
    fill(0);
    noStroke();
    rect(locationX,locationY-2,20,10);
  }
  else {
    fill(80);
  }
  
  popMatrix();
  
  pushMatrix();
  if (distance < 40 || combatPackage == 2 || stage == 4) {
    fill(255);
  }
  else {
    noFill();
  }
  stroke(255);
  
  translate(0,-4);
  beginShape();
    vertex(locationX+10,locationY-4);
    vertex(locationX+10,locationY+20);
    vertex(locationX-10,locationY+20);
    vertex(locationX-10,locationY-4);
  if (distance < 40) {
    endShape(CLOSE);
  }
  else {
    endShape();
  }
  popMatrix();
  
  pushMatrix();
  if (stage < 4) {
    fill(0);
    stroke(0);
  }
  else {
    fill(80);
    stroke(80);
  }
  strokeWeight(3);
  line(locationX-10,locationY-2,locationX+10,locationY-2);
  strokeWeight(1.5);
  
  if (distance < 40 || combatPackage == 2 || stage == 4) {
    noStroke();
  }
  else {
    stroke(255);
  }
  ellipse(locationX,locationY-2,10,10);
  popMatrix();
}

void createButtonSalamander(int locationX, int locationY) {
  PVector mLocation = new PVector(mouseX,mouseY);
  mLocation.x -= locationX;
  mLocation.y -= locationY;
  float distance = mLocation.mag();
  
  pushMatrix();
  stroke(255);
  ellipseMode(CENTER);
  if (distance < 40 || combatPackage == 3 || stage == 4) {                                      // 40 is the radius of the button's activation site
    fill(255);
  }
  else {
    noFill();
  }
  ellipse(locationX,locationY,30,30);
  popMatrix();
  
  pushMatrix();
  if (stage < 4) {
    fill(0);
  }
  else {
    fill(80);
  }
  noStroke();
  translate(locationX,locationY-8);
  rectMode(CENTER);
  rect(0,0,35,15); 
  popMatrix();
  
  if (distance < 40 && stage < 4) {
    if (mousePressed) {
      combatPackage = 3;
    }
    
    pushMatrix();
    stroke(255);
    noFill();
    ellipseMode(CENTER);
    ellipse(locationX,locationY,60,60);
    popMatrix();
  }
  
  pushMatrix();
  if (distance < 40 || combatPackage == 3 || stage == 4) {
    fill(255);
  }
  else {
    noFill();
  }
  stroke(255);
  beginShape();
    vertex(locationX-15,locationY);
    vertex(locationX-14,locationY-7);
    vertex(locationX-4,locationY-2);
    vertex(locationX+2,locationY-16);
    vertex(locationX+10,locationY-3);
    vertex(locationX+14,locationY-5);
    vertex(locationX+15,locationY);
  if (distance < 40 || combatPackage == 3 || stage == 4) {
    endShape(CLOSE);
  }
  else {
    endShape();
  }
  popMatrix();
}

void createButtonSpider(int locationX, int locationY) {
  PVector mLocation = new PVector(mouseX,mouseY);
  mLocation.x -= locationX;
  mLocation.y -= locationY;
  float distance = mLocation.mag();
  
  if (distance < 40 && stage < 4) {
    if (mousePressed) {
      combatPackage = 4;
    }
    
    pushMatrix();
    stroke(255);
    strokeWeight(1.5);
    noFill();
    ellipseMode(CENTER);
    ellipse(locationX,locationY,60,60);
    popMatrix();
  }
  pushMatrix();
  if (distance < 40 || combatPackage == 4 || stage == 4) {
    fill(255);
  }
  else {
    noFill();
  }
  stroke(255);
  strokeWeight(1.5);
  beginShape();
    vertex(locationX,locationY+10);
    vertex(locationX-10,locationY);
    vertex(locationX+2,locationY-15);
    vertex(locationX+11,locationY+1);
  endShape(CLOSE);
  popMatrix();
  
  pushMatrix();
  stroke(255);
  strokeWeight(1.5);
  noFill();
  beginShape();
    vertex(locationX,locationY+10);
    vertex(locationX+14,locationY+9);
    vertex(locationX+18,locationY+15);
  endShape();
  beginShape();
    vertex(locationX,locationY+10);
    vertex(locationX-14,locationY+6);
    vertex(locationX-17,locationY+15);
  endShape();
  popMatrix();
  
  pushMatrix();
  stroke(255);
  if (distance < 40 || combatPackage == 4 || stage == 4) {
    fill(255);
  }
  else {
    fill(0);
  }
  ellipse(locationX,locationY+10,8,8);
  if (stage < 4) {
    stroke(0);
  }
  else {
    stroke(80);
  }
  strokeWeight(2.5);
  noFill();
  ellipse(locationX,locationY+10,12,12);
  strokeWeight(1.5);
  popMatrix();
}

void createButtonBeaver(int locationX, int locationY) {
  PVector mLocation = new PVector(mouseX,mouseY);
  mLocation.x -= locationX;
  mLocation.y -= locationY;
  float distance = mLocation.mag();
  
  if (distance < 40 && stage < 4) {
    if (mousePressed) {
      combatPackage = 5;
    }
    
    pushMatrix();
    stroke(255);
    noFill();
    ellipseMode(CENTER);
    ellipse(locationX,locationY,60,60);
    popMatrix();
  }
  
  pushMatrix();
  stroke(255);
  if (distance < 40 || combatPackage == 5 || stage == 4) {
    fill(255);
  }
  else {
    noFill();
  }
  beginShape();
    vertex(locationX-14,locationY-14);
    vertex(locationX+14,locationY-14);
    vertex(locationX+14,locationY-10);
    vertex(locationX+2,locationY-7);
    vertex(locationX+14,locationY-3);
    vertex(locationX+14,locationY+4);
    vertex(locationX+5,locationY+7);
    vertex(locationX+14,locationY+10);
    vertex(locationX+14,locationY+14);
    vertex(locationX-14,locationY+14);
    vertex(locationX-14,locationY+5);
    vertex(locationX,locationY);
    vertex(locationX-14,locationY-6);
  endShape(CLOSE);
  popMatrix();
}

void createButtonTurtle(int locationX, int locationY) {
  PVector mLocation = new PVector(mouseX,mouseY);
  mLocation.x -= locationX;
  mLocation.y -= locationY;
  float distance = mLocation.mag();
  
  pushMatrix();
  stroke(255);
  if (distance < 40 || combatPackage == 6 || stage == 4) {
    fill(255);
  }
  else {
    noFill();
  }
  ellipse(locationX,locationY+8,34,50);
  noStroke();
  if (stage < 4) {
    fill(0);
  }
  else {
    fill(80);
  }
  rectMode(CENTER);
  rect(locationX,locationY+25,40,30);
  popMatrix();
  
  pushMatrix();
  stroke(255);
  if (distance < 40 || combatPackage == 6 || stage == 4) {
    fill(255);
  }
  else {
    noFill();
  }
  translate(2,2);
  triangle(locationX-18,locationY+10,locationX-10,locationY+10,locationX-14,locationY+16);
  translate(-4,0);
  triangle(locationX+18,locationY+10,locationX+10,locationY+10,locationX+14,locationY+16);
  popMatrix();
  
  pushMatrix();
  stroke(255);
  if (distance < 40 || combatPackage == 6 || stage == 4) {
    fill(255);
  }
  else {
    fill(0);
  }
  ellipse(locationX,locationY+8,8,8);
  if (stage < 4) {
    stroke(0);
  }
  else {
    stroke(80);
  }
  strokeWeight(2.5);
  noFill();
  ellipse(locationX,locationY+8,12,12);
  strokeWeight(1.5);
  popMatrix();
  
  if (distance < 40 && stage < 4) {
    if (mousePressed) {
      combatPackage = 6;
    }
    
    pushMatrix();
    stroke(255);
    noFill();
    ellipseMode(CENTER);
    ellipse(locationX,locationY,60,60);
    popMatrix();
  }
}

void createButtonHedgehog(int locationX, int locationY) {
  PVector mLocation = new PVector(mouseX,mouseY);
  mLocation.x -= locationX;
  mLocation.y -= locationY;
  float distance = mLocation.mag();
  
  if (distance < 40 && stage < 4) {
    if (mousePressed) {
      combatPackage = 7;
    }
    
    pushMatrix();
    stroke(255);
    noFill();
    ellipseMode(CENTER);
    ellipse(locationX,locationY,60,60);
    popMatrix();
  }
  
  pushMatrix();
  stroke(255);
  if (distance < 40 || combatPackage == 7 || stage == 4) {
    fill(255);
  }
  else {
    noFill();
  }
  translate(0,5);
  triangle(locationX-7,locationY-(7*1.75*.5),locationX+7,locationY-(7*1.75*.5),locationX,locationY+(7*1.75*.5));
  translate(0,-17);
  triangle(locationX-7,locationY+(7*1.75*.5),locationX+7,locationY+(7*1.75*.5),locationX,locationY-(7*1.75*.5));
  translate(10,20);
  triangle(locationX-7,locationY+(7*1.75*.5),locationX+7,locationY+(7*1.75*.5),locationX,locationY-(7*1.75*.5));
  translate(-20,0);
  triangle(locationX-7,locationY+(7*1.75*.5),locationX+7,locationY+(7*1.75*.5),locationX,locationY-(7*1.75*.5));
  popMatrix();
}

void createButtonTermite(int locationX, int locationY) {
  PVector mLocation = new PVector(mouseX,mouseY);
  mLocation.x -= locationX;
  mLocation.y -= locationY;
  float distance = mLocation.mag();
  
  if (distance < 40 && stage < 4) {
    if (mousePressed) {
      combatPackage = 8;
    }
    
    pushMatrix();
    stroke(255);
    noFill();
    ellipseMode(CENTER);
    ellipse(locationX,locationY,60,60);
    popMatrix();
  }
  
  pushMatrix();
  stroke(255);
  if (distance < 40 || combatPackage == 8 || stage == 4) {
    fill(255);
  }
  else {
    noFill();
  }
  translate(locationX,locationY-2);
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

void createButtonSigned(int locationX,int locationY) {
  PVector mLocation = new PVector(mouseX,mouseY);
  mLocation.x -= locationX;
  mLocation.y -= locationY;
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
    ellipse(locationX,locationY,14,14);
  }
  else {
    ellipse(locationX,locationY,10,10);
  }
  popMatrix();
  
  pushMatrix();
  int textSize = 20;
  textFont(infohelpFont,textSize);
  textAlign(LEFT);
  fill(255);
  if (signed) {
    text("LOAD FILE (If you already have a name saved)",locationX+20,locationY+7);
  }
  else {
    text("NEW FILE (If you have never played before)",locationX+20,locationY+7);
  }
  popMatrix();
}

void createButtonGraphics(int locationX,int locationY) {
  PVector mLocation = new PVector(mouseX,mouseY);
  mLocation.x -= locationX;
  mLocation.y -= locationY;
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
    ellipse(locationX,locationY,14,14);
  }
  else {
    ellipse(locationX,locationY,10,10);
  }
  popMatrix();
  
  pushMatrix();
  int textSize = 20;
  textFont(infohelpFont,textSize);
  textAlign(LEFT);
  fill(255);
  if (bestGraphics) {
    text("HIGH QUALITY (Better graphics, but can be a bit slower)",locationX+20,locationY+7);
  }
  else {
    text("LOWER QUALITY (Worse graphics, but is faster)",locationX+20,locationY+7);
  }
  popMatrix();
}