// Upgrade Player Stat Var's

float upgrade(String type, float initial) {
  float constant = 0;
  float root = 1;
  int ceiling = -1;
  float newStat = -1;
  
  if (type.equals("health")) {
    constant = 20;
    root = 2.5;
  }
  else if (type.equals("time")) {
    constant = 0.03;
    root = 1.08;
    ceiling = round(initial + 5);
  }
  else if (type.equals("damage")) {
    constant = 5;
    root = 2.8;
  }
  else if (type.equals("range")) {
    if (myClient.cpackage.equals("spider")) {
      constant = 8;
      root = 3.4;
      ceiling = 300;
    }
    else {
      constant = 22;
      root = 2.7;
      ceiling = 750;
    }
  }
  else if (type.equals("speed1")) {
    constant = .45;
    root = 2;
    ceiling = int(1.6*initial);
  }
  else if (type.equals("speed2")) {
    constant = 0.020;
    root = 1.1;
    ceiling = round(2*initial);
  }
  else if (type.equals("zoom")) {     
    root = 1.7;
    
    if (myClient.cpackage.equals("spider")) {
      constant = -1.4;
      ceiling = 40;
    }
    else if (myClient.cpackage.equals("mole")) {        //Check this balance
      constant = -1;
      ceiling = 60;
    }
  }
  else if (type.equals("shield")) {
     constant = 1;
     root = 1;
     ceiling = 250;
  }
  else {
    println("CLIENT: statistic type " + type + " is not compatible.");
  }
  
  newStat = (constant * pow(myClient.score,1/root)) + initial;
  
  if (type.equals("zoom")) {
    if (newStat < ceiling) {
      newStat = ceiling;
    }
  }
  else {
    if (ceiling > -1 && newStat > ceiling) {
      newStat = ceiling;
    }
  }
  
  return newStat;
}