// TITLE

void moveTitle() {
  updateKeys();
  if (keys[0] && titleOrigin.y > 47) {
    titleOrigin.y -= 2;
  }
  if (keys[2] && titleOrigin.y < 160-47) {
    titleOrigin.y += 2;
  }
  if (keys[1] && titleOrigin.x > 47) {
    titleOrigin.x -= 2;
  }
  if (keys[3] && titleOrigin.x < width-47) {
    titleOrigin.x += 2;
  }
}

void drawTitle() {
  PVector compass = new PVector(mouseX,mouseY);
  compass.sub(titleOrigin);
  
  pushMatrix();
  fill(255);
  noStroke();
  rectMode(CENTER);
  translate(titleOrigin.x,titleOrigin.y);
  rotate(compass.heading() + PI/2);
  rect(0,-30,30,70);
  
  ellipseMode(CENTER);
  ellipse(0,0,90,90);
  
  stroke(255);
  strokeWeight(5);
  line(-15,-65,15,-65);
  
  stroke(0);
  strokeWeight(3);
  line(-15,-55,15,-55);
  popMatrix();
  
  pushMatrix();
  titleSize = 22;
  textFont(titleFont,titleSize);
  textAlign(CENTER);
  fill(0);
  text("ROUND",titleOrigin.x,titleOrigin.y+10);
  popMatrix();
  
  strokeWeight(1.5);
}