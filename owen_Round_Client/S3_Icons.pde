// ICONS

void drawIcons(int x, int y) {    //Height of 1 icon description: ~145
  int minimum = -1 * (teamIcons.size()-3) * 142;

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
    
    for (int i=0; i<teamIcons.size(); i++) {
      drawIcon(teamIcons.get(i),new PVector(x,y + (142*i) - 320));
    }

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
    text("Waiting for team data...",x,y);
    popMatrix();
  }
  
  scrollVelocity *= 0.5;
}