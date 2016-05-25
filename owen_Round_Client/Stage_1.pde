//INFO

void drawInfo(int x, int y) {
  pushMatrix();
  int textSize = 20;
  textFont(infohelpFont,textSize);
  textAlign(LEFT);
  fill(255);
  text("TITLE: Round\nAUTHOR: Owen G.\nVERSION: 8\nBEGUN: July 18, 2015\nLATEST UPDATE: May 24, 2016\nDESCRIPTION: Online top-down view shooter.\n                          Pick your combat package.\n                          Gain coins to improve your abilities.\n                          Sharpen your skills.\n                          Survive another Round.\nICONS: Following username in sign-in, some code inputs in format:\n             \"_••••\" correspond to special icons.\n             For example, try: \"YOURNAME_delta\"",x,y);
  popMatrix();
}