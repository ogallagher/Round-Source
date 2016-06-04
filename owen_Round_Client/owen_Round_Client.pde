//Round_Client

// BEGUN:         July 18, 2015
// LAST UPDATED:  June 4, 2016
// VERSION:       8

/* UPDATES:
     v.7        
        Flexible field size [x] 
        Drawn boundaries [x]
        Name changing [x]
        AI enemies [x]
     v.8        
        Lag reduction (tags shortened, rounded data) [x]
        Improve shooting protocols [x]
        Promote teaming [x]
        Improve enemies [x]
        Change scoring dynamics and upgrades [ ]
        Worsen spider package (dagger,speed) [x]
        Termite combat package [x]
        Autocomplete username [x]
        Allow complex movement [x]
        Various bug fixes [...]
*/

import processing.net.*;

Client client;

String[] fileEntries;            //Replica of usernames.txt (each entry is a new line)
StringList pastUsernames;        //Past usernames

String clientHD = "C:";          //Data headings 
String objectHD = "O:";
String messageHD = "M:";
String newHD = "N:";
String loadHD = "L:";
String spawnHD = "S:";
String deleteHD = "D:";
String teamHD = "T:";

String addressID = "@[";        //Shared client data tags (some used in object data)
String nameID = "n[";              
String scoreID = "s[";
String angleID = "<[";
String locationID = "l[";
String packageID = "p[";
String alphaID = "a[";

String healthID = "h[";           //Private client data tags

String velocityID = "v[";         //Object-specific tags
String radiusID = "r[";
String targetID = "t[";
String damageID = "d[";
String ownerID = "o[";

String receiverID = ">[";         //The intended receiving client of the following data (for server -> client broadcast and client -> otherClients chat) tag

String iconID = "i[";             //Special icon tags
String shapeID = "#["; 
String ellipseID = "e[";

String chatID = "c[";

char endID = ']';
char endHD = '*';

char splitID = '$';                //used only when necessary: delete objects, add objects, send angles for termite, split shapes for special icon

String myAddress = "";             //random 5-digit number is the client's address — no need to use client's ip address :)

Player myClient;
ArrayList<OtherPlayer> otherClients = new ArrayList<OtherPlayer>();    //List of neighbor client objects
ArrayList<Object> objects = new ArrayList<Object>();

PFont titleFont;
int titleSize;
PVector titleOrigin;

PFont infohelpFont;
float scrollVelocity;
float helpLocation = 0;

float iconLocation = 0;              //For scrolling
String teams = "";
StringList teamIcons;
int requestingTeam = -1;             // -3: Request new team | -2: Type new team name | -1: Nothing | >0: Request team code
String newTeam = "Type team name, then press ENTER";
boolean ownTeam = false;

PFont chatFont;
String chatBoxString = "[,],*,:,$,TAB = Not Permitted. Limit = 60 char.";
boolean chatting = false;                                          //For editor
boolean reading = false;                                           //For reader
StringList chatList;
float chatAlpha = 0;                                               //For transition animations in editor
float readAlpha = 0;                                               //For transition animations in reader
boolean chatHover = false;

String newname = "TYPE USERNAME ([,],*,TAB,: are not allowed)";
boolean newNamePending = false;
boolean renaming = false;                                          //whether the player is changing its name  
float nameAlpha = 0;
boolean nameHover = false;

int combatPackage = 1;
boolean signed = false;                                            //For NEW vs. LOAD
String loadString = "";                                            //For sending after button is pressed

String username = "TYPE USERNAME ([,],*,TAB,: are not allowed)";
String icon = "";
String code = "";

Boolean[] keys = {false,false,false,false};                        //To keep track of multiple keys at once

int stage = 0;                        //Determines what functions should be executed in draw: 0=Title | 1=Info | 2=Help | 3=Icons | 4=Selection | 5=Play | 6=Killscreen
boolean bestGraphics = true;
boolean escapeHover = false;
boolean fieldConfirmed = false;
int fieldWidth = 2000;                //Dimensions of the battlefield (a square) 
float z = 1;                          //Scale all locations and sizes for spider client & mole client

void setup() {
  size(800,700);
  noCursor();
  
  client = new Client(this, "74.71.101.15", 44445);      //For using internet connection — the ip is that of our home router, the port is the one I chose on which to allow incoming data requests. (test w/ canyouseeme.org)
  
  fileEntries = loadStrings("usernames.txt");
  pastUsernames = new StringList();
  for (int i=0; i<fileEntries.length; i++) {
    pastUsernames.append(fileEntries[i]);
  }
  if (fileEntries.length > 0) {
    signed = true;
  }
  
  for (int i=0; i<6; i++) {
    myAddress += str(round(random(9)));
  }
  println("ID Number: " + myAddress);
  myClient = new Player();
  
  titleFont = createFont("HanziPenSC-W3",50,true);    //I've found that windows computers don't have this font... 
  infohelpFont = createFont("Avenir-Book",50,true);
  chatFont = createFont("Monospaced", 10, true);
  
  titleOrigin = new PVector(width/2,60);
  
  teamIcons = new StringList();
  chatList = new StringList();
}

void draw() {  
  if (stage < 5) {
    background(0);
  }
  else {
    background(80);
  }
  
  if (stage == 1) {
    drawInfo(150,240);
  }
  
  if (stage == 2) {
    drawHelp(130,200);
    createButtonScroll(770,350,helpLocation);
  }
  
  if (stage == 3) {
    drawIcons(140,220);
    createButtonScroll(770,350,iconLocation);
    
    createButtonNew(140,int(142*teamIcons.size() - 120 + height/2 + iconLocation));
    newTeam();
    
    teamRequests();
  }
  
  if (stage > -1 && stage < 4) {
    moveTitle();
    drawTitle();
    
    createButtonInfo(50,200);
    createButtonHelp(50,350);
    createButtonIcons(50,500);
    createButtonPlay(50,650);
  }
  
  if (stage == 4) {
    createButtonPlay(750,630);    //If clicked, request to join is sent.
    createButtonBack(50,100);
    
    createButtonWoodpecker(50,220);
    createButtonMole(150,220);
    createButtonSalamander(250,220);
    createButtonSpider(350,220);
    createButtonBeaver(450,220);
    createButtonTurtle(550,220);
    createButtonHedgehog(650,220);
    createButtonTermite(750,220);
    
    drawTitle();
    
    drawPackageSelection(combatPackage);
    
    createButtonGraphics(60,500);
    createButtonSigned(60,540);
    textBoxUsername(100,620);
  }
  
  readServerMessage();
    
  if (stage == 5) {
    myClient.changeObjects();
    myClient.control();
    myClient.collision();
    myClient.sendData();
    myClient.display();
    
    for (int i=0; i<otherClients.size(); i++) {
      OtherPlayer otherClient = otherClients.get(i);
      otherClient.display();
    }
    
    for (int i=0; i<objects.size(); i++) {
      Object object = objects.get(i);
      
      object.display();
    }
    
    myClient.displayGraphs();
    
    createButtonEscape(760,40);
    createButtonChat(760,660);
    createButtonName(40,660);
    
    displayField();
    
    chat();                               //for the textBox and the displays
    rename();                             //"   "
  }
  
  if (stage == 6) {
    displayKillscreen();
    createButtonPlay(width/2,height/2);    //If clicked, stage returns to 0.
  }
  
  drawSights();
}