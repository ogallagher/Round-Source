// HELP

void drawHelp(int x, int y) {
  helpLocation += scrollVelocity;
  
  if (helpLocation > 0) {
    helpLocation = 0;
  }
  if (helpLocation < -300) {
    helpLocation = -300; 
  }
  
  y += helpLocation;
  
  pushMatrix();
  int textSize = 20;
  textFont(infohelpFont,textSize);
  textAlign(LEFT);
  fill(255);
  text("MOVEMENT: w,a,s,d or arrow keys (try it!) \nATTACK: Left-click \nSPECIAL: Right-click \nESCAPE: Move mouse to upper-right corner for stop button. \nCHAT: Move mouse to lower-right corner for chat button. \n            Click and type to communicate or press ENTER. Click \n            again or press ENTER to close.\nCOINS: Get coins to automatically upgrade personal \n              statistics, which is done by eliminating other \n              players and/or enemies. You lose each time you die. \nDISPLAY: Your player will be displayed with 2 pieces of information: \n                your name (above) and your score (below) at all times. \n                To see your ammunitions for both weapons and your\n                health, move the mouse into the top-left corner.\nUSERNAME: To edit your username, go to the lower left-hand corner.\n                      Press ENTER to send name change request.\n                     Numbers in a username will not be shown, so they can be\n                     used as a sort of password.\nAI ENEMIES: There are now enemies with some rudimentary\n                      artificial intelligence. They will drop a coin 30%\n                      of the time if you kill them.",x,y);
  popMatrix();
  
  pushMatrix();
  fill(0);
  noStroke();
  rectMode(CORNER);
  rect(0,0,width,160);
  popMatrix();
  
  scrollVelocity *= 0.5;
}