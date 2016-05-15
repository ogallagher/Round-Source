// TITLE

void moveTitle() {
  if (keyPressed) {
    if (key == CODED) {
      if (keyCode == UP) {
        titleOrigin.y -= 2;
      }
      if (keyCode == DOWN) {
        titleOrigin.y += 2;
      }
      if (keyCode == LEFT) {
        titleOrigin.x -= 2;
      }
      if (keyCode == RIGHT) {
        titleOrigin.x += 2;
      }
    }
    
    else {
      if (key == 'w') {
        titleOrigin.y -= 2;
      }
      if (key == 's') {
        titleOrigin.y += 2;
      }
      if (key == 'a') {
        titleOrigin.x -= 2;
      }
      if (key == 'd') {
        titleOrigin.x += 2;
      }
    }
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
  titleSize = 25;
  textFont(titleFont,titleSize);
  textAlign(CENTER);
  fill(0);
  text("ROUND",titleOrigin.x,titleOrigin.y+10);
  popMatrix();
  
  strokeWeight(1.5);
}