//INFO

void drawInfo(int x, int y) {
  pushMatrix();
  textFont(infohelpFont,20);
  textAlign(LEFT);
  fill(255);
  text("TITLE: Round\nAUTHOR: Owen Gallagher\nVERSION: 8\nBEGUN: July 18, 2015\nLATEST UPDATE: June 9, 2016\nDESCRIPTION: Online top-down view shooter.\n                          Pick your combat package.\n                          Gain coins to improve your abilities.\n                          Sharpen your skills.\n                          Survive another Round.",x,y);
  popMatrix();
}