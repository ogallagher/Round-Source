// SELECTION

void drawPackageSelection(int selection) {
  pushMatrix();
  
  int textSize = 20;
  textFont(infohelpFont,textSize);
  textAlign(LEFT);
  fill(255);
  translate(50,300);
  
  if (selection == 1) {
    text("WOODPECKER\n  SPEED: 5\n  ATTACK: mid-range machine gun (low cool-down time)\n  SPECIAL: temporary smokescreen\n  INFO: unlock dual machine guns after 150",0,0);
  }
  if (selection == 2) {
    text("MOLE\n  SPEED: 1\n  ATTACK: short-range rotating blades\n  SPECIAL: mid-range teleportation\n  INFO: unlock limited zoom after 170 (scroll up and down)",0,0);
  }
  if (selection == 3) {
    text("SALAMANDER\n  SPEED: 10\n  ATTACK: remote detonators (activate if touched, otherwise within a time limit.)\n  SPECIAL: long-range grenades\n  INFO: unlock demolition grenades after 200",0,0); //Shrink walls
  }
  if (selection == 4) {
    text("SPIDER\n  SPEED: 8\n  ATTACK: long-range sniper\n  SPECIAL: short-range dagger\n  INFO: unlock zoom after 40 (scroll up and down)",0,0);
  }
  if (selection == 5) {
    text("BEAVER\n  SPEED: 7\n  ATTACK: mid-range pistol\n  SPECIAL: move walls (# of walls you can hold at once depends on your score)\n  INFO: unlock grenades after 150",0,0);
  }
  if (selection == 6) {
    text("TURTLE\n  SPEED: 2\n  ATTACK: mid-range 360˚ shockwave \n  SPECIAL: shield (blocks slower, non-sniper bullets)\n  INFO: unlock shield bullet deflection after 200",0,0); 
  }
  if (selection == 7) {
    text("HEDGEHOG\n  SPEED: 4\n  ATTACK: mid-range fan shotgun\n  SPECIAL: static invisibility\n  INFO: unlock slow invisibility after 230",0,0);
  }
  if (selection == 8) {
    text("TERMITE\n  SPEED: 8\n  ATTACK: create mid-range turret\n SPECIAL: create short-range base\n INFO: turrets shoot bullets (grenades after 250), bases shoot health.",0,0);
  }
  
  popMatrix();
}

String usernameSuggestion(int x, int y) {
  String check = "";
  
  if (username.length() > 0 && !(username.equals("TYPE USERNAME ([,],*,TAB,: are not allowed)") || username.equals("Sorry, the username you gave is already taken.") || username.equals("Sorry, that name is already signed in for another player.") || username.equals("Sorry, the username you entered was not found on file.") || username.equals("Great! Now switch to LOAD FILE and sign in.") || username.equals("Sorry, there are too many clients currently playing."))) {
    int suggestion = -1;
    
    for (int i=0; i<pastUsernames.size() && suggestion < 0; i++) {
      if (username.length() <= pastUsernames.get(i).length()) {
        check = pastUsernames.get(i).substring(0,username.length());
        
        if (check.equals(username)) {
          suggestion = i;
        }
      }
    }
    
    if (suggestion > -1) {
      pushMatrix();
      int textSize = 25;
      textFont(titleFont,textSize);
      textAlign(LEFT);
      fill(255,80);
      translate(x+4,y+2);
      text(pastUsernames.get(suggestion),0,0);
      popMatrix();
      
      return pastUsernames.get(suggestion);
    }
    else {
      return "";
    }
  }
  else if (username.length() == 0 && pastUsernames.size() > 0) {
    pushMatrix();
    int textSize = 25;
    textFont(titleFont,textSize);
    textAlign(LEFT);
    fill(255,80);
    translate(x+4,y+2);
    text(pastUsernames.get(0),0,0);
    popMatrix();
    
    return pastUsernames.get(0);
  }
  else {
    return "";
  }
}

void textBoxUsername(int x,int y) {
  String autocomplete = usernameSuggestion(x,y);
  
  if (autocomplete.length() > 0) {
    if (keyPressed && (key == ENTER || key == RETURN)) {
      username = autocomplete;
    }
  }
  
  if (keyPressed) {
      if ((key == DELETE || key == BACKSPACE) && username.length() > 0) {
        username = username.substring(0,username.length()-1);
      }
      
      else if (key != CODED && key != BACKSPACE && key != ENTER && key != RETURN && key != '*' && key != '[' && key != ']' && key != ':' && key != '\t') {
        if (username.equals("TYPE USERNAME ([,],*,TAB,: are not allowed)") || username.equals("Sorry, the username you gave is already taken.") || username.equals("Sorry, that name is already signed in for another player.") || username.equals("Sorry, the username you entered was not found on file.") || username.equals("Great! Now switch to LOAD FILE and sign in.") || username.equals("Sorry, there are too many clients currently playing.")) {
          username = str(key);
        }
        else {
          username = username + key;
        }
      }
      
      keyPressed = false;
  }
  
  pushMatrix();
  int textSize = 25;
  textFont(titleFont,textSize);
  textAlign(LEFT);
  fill(255);
  translate(x,y);
  text(username,0,0);
  popMatrix();
}