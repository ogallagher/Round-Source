// HELP

void drawHelp(int x, int y) {
  helpLocation += scrollVelocity;
  
  if (helpLocation > 0) {
    helpLocation = 0;
  }
  if (helpLocation < -1280) {
    helpLocation = -1280; 
  }
  
  y += helpLocation;
  
  pushMatrix();
  int textSize = 20;
  textFont(infohelpFont,textSize);
  textAlign(LEFT);
  fill(255);
  text("MOVEMENT: w,a,s,d or arrow keys (try it!) \n\nATTACK: Left-click \n\nSPECIAL: Right-click \n\nESCAPE: Move mouse to upper-right corner for stop button. \n\nCHAT: Move mouse to lower-right corner for chat button. \n            Click and type to communicate or press ENTER. Click \n            again or press ENTER to close.\n            If you are on a team (see TEAMS), messages are sent to\n            those on your team by default. To send to a specific\n            player, type: \"yourMessage-playerName\".\n\nCOINS: Get coins to automatically upgrade personal \n              statistics, which is done by eliminating other \n              players and/or enemies. You lose some points when you die. \n\nDISPLAY: Your player will be displayed with 2 pieces of information: \n                your name (above) and your score (below) at all times. \n                To see your ammunitions for both weapons and your\n                health, move the mouse into the top-left corner.\n\nUSERNAME: To edit your username, go to the lower left-hand corner.\n                      Press ENTER to send name change request.\n                     Numbers in a username will not be shown, so they can be\n                     used as a sort of password.\n\nAI ENEMIES: There are now enemies with some rudimentary\n                      artificial intelligence. They will drop a coin 60%\n                      of the time if you kill them.\n\nTEAMS: Following username in sign-in, some code inputs in format:\n              \"_••••\" correspond to special icons. For example, if a code is \n              \"popcorn\", then type \"yourName_popcorn\" to sign in. To \n              create a team, players who sign in with the same code can't\n              damage each other.\n              Go to the teams menu (shield button) to request new\n              icons and to get codes for them.\n              To request an icon code, click one that is unowned. This is\n              only possible after giving a username in the sign-in, and\n              you can only own one.\n              To request a new icon, scroll down, click the add button, and\n              follow the directions.\n\nTOWERS: the termite package was made specially to promote teaming.\n                 It makes turrets (shoot at enemies and players of other\n                 teams) and bases (heal players on their team).",x,y);
  popMatrix();
  
  pushMatrix();
  fill(0,90);
  noStroke();
  rectMode(CORNER);
  rect(0,0,width,160);
  popMatrix();
  
  scrollVelocity *= 0.5;
}