float upgrade(String type, float initial) {
  float constant = 0;
  float root = 1;
  int ceiling = -1;
  float newStat = -1;
  
  if (type.equals("health")) {
    constant = 40;
    root = 2.5;
  }
  else if (type.equals("time")) {
    constant = 0.1;
    root = 1.1;
    ceiling = round(initial + 5);
  }
  else if (type.equals("damage")) {
    constant = 1.3;
    root = 2.5;
  }
  else if (type.equals("range")) {
    if (myClient.cpackage.equals("spider")) {
      constant = 15;
      root = 3.4;
      ceiling = 100;
    }
    else {
      constant = 30;
      root = 2.3;
      ceiling = 750;
    }
  }
  else if (type.equals("speed1")) {
    constant = .6;
    root = 1.8;
    ceiling = int(1.6*initial);
  }
  else if (type.equals("speed2")) {
    constant = 0.1;
    root = 1.1;
    ceiling = round(2*initial);
  }
  else if (type.equals("zoom")) {     
    root = 1.7;
    
    if (myClient.cpackage.equals("spider")) {
      constant = -3;
      ceiling = 40;
    }
    else if (myClient.cpackage.equals("mole")) {
      constant = -2.5;
      ceiling = 60;
    }
  }
  else if (type.equals("shield")) {
     constant = 3;
     root = 1.1;
     ceiling = 250;
  }
  else {
    println("CLIENT: statistic type " + type + " is not compatible for upgrades.");
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