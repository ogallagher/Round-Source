// KILLSCREEN

void displayKillscreen () {
  int textSize = 50;
  pushMatrix();
  textFont(titleFont,textSize);
  textAlign(CENTER);
  fill(250,0,0);
  translate(width/2,100);
  text("GAME OVER",0,0); 
  popMatrix();
  
  textSize = 20;
  pushMatrix();
  textFont(infohelpFont,textSize);
  textAlign(LEFT);
  fill(255);
  translate(100,550);
  text("You were signed in as " + myClient.name + ", \nusing the " + myClient.cpackage.toUpperCase() + " combat package.\nYour score when alive was " + str(myClient.score) + '.',0,0); 
  popMatrix();
}