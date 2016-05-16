//Round_Client

// BEGUN:         July 18, 2015
// LAST UPDATED:  May 15, 2016
// VERSION:       8
// UPDATES:
//    7 = Flexible field size, drawn boundaries, name changing, AI enemies
//    8 = Tags shortened to reduce lag [x], Round locations and velocities [x], Improve shooting protocols [x], Promote teaming [ ], Improve enemies [x], Change scoring dynamics and upgrades [ ], Worsen spider package (dagger,speed) [ ], Termite combat package [ ]


                 //  ALL UPDATES  \\
/*****************************************************\ 
readServerMessage();              √√√
  messageHD                       √
  if (stage == 4) {
    readServerLists(text);        √√√
    if (clientHD found && endHD after clientHD are found) {
      otherClients.clear();       √
      myClient.getData();         √
      {otherClients.append();}    √
    }
    if (objectHD found && endHD after objectHD found) {
      objects.clear();            √
      {objects.append();}         √
    }
  }

myClient.control();               √√√
  movement                        √
  camera panning                  √
  mole(teleport)                  √
  spider(zoom)                    √
  ammunition                      √
  coolTime                        √

myClient.collision();             √√√
  with otherClients               √
  with walls                      √

myClient.sendData();              √√√
  send name                       √
  send score                      √
  send location                   √
  send angle                      √
  send health                     √
  
myClient.display();               √√√
  body                            √
  icon                            √
  name                            √
  score                           √
  weapon                          √
  health (hover-over)             √
  ammunition (hover-over)         √
  
myClient.displayGraphs();         √√√
  health                          √
  ammo1                           √
  ammo2                           √
  fix positions                   √
  
myClient.changeObjects            √√√
  attack/special actions          √
  send new objects                √
  send deleted objects            √
    walls                         √
    coins                         √
    health boxes                  √
    ammo boxes                    √
    bullets                       √
 score update                     √
 health update                    √
 ammunition update                √
  
otherClients.display();           √√√
  body                            √
  icon                            √
  name                            √
  score                           √
  weapon                          √

objects.display();                √√√
  walls                           √
  bullets                         √
  detonators                      √
  smokescreens                    √
  hazardRings                     √
  health boxes                    √
  coins                           √
  ammo boxes                      √
  
Object pickups only happen ONCE   √√√                  
                                                        
Factor in Score:                  √√√
speed increase                    √
  for movement                    √
  for bullets (slightly)          √
health increase                   √
damage increase                   √
range increase                    √
special increases:                √
  woodpecker                      √
  mole                            √
  salamander                      √
  spider                          √
  beaver                          √
  turtle                          √
  hedgehog                        √

In-game toggle for bestGraphics   √√√

Kill myClient                     √√√
  Server: myClient.score-1        √
  Server adds coin there          √
  Server deletes client           √
    client can't edit objects     √
    sends death message to client √
  create killscreen (stage 5)     √
    display username              √
    display score                 √
    playButton -» stage 0         √
      myClient.restart();         √
      
Server spawns over time           √√√
  health boxes                    √
  ammo boxes                      √
  
Escape button                     √√√
  createButtonEscape();           √
  Server deletes client           √
  Server sends message to client  √
  Client performs kill procedures √
  
Change help screen                √√√
  different info viewing          √
  new escape button               √
  score subtraction               √
  no more coin placing            √

Server.clientList.size() limit    √√√
  Client message reception        √
  Server message delivery         √
  
Teleport restriction within field √√√

Place-wall restriction "        " √√√

Create special icons              √√√
  add to info                     √
  server has code list            √
  server has icon list            √
  server sends code back          √
  draw icon from server           √
  TEST: send vertices             √
  Create drawing code             √  
  Draw icons for other players    √
  myClient.restart(icon);         √
  
Add chatline                      √√√
  add another ID tag (chat[)      √
  add functions to server         √
    under MESSAGE: functions      √
      receive chat                √
      send chat                   √
    new textBox                   √
      server can chat             √
    display chat-line             √
  add funcitions to client        √
    createButtonChat();           √
    display chat-line             √
    receive chat                  √
    send chat                     √
  change help menu                √
  
Add account security              √√√
  Server-side                     √
    create cleanString() function √
    secure client in clientList   √
  Client-side                     √
    create cleanString() function √
    cleanString(username)         √
  Change info menu                √
  
Shorten after-death transition    √√√

Increase address to 5-digits      √√√

Make fieldWidth expandable        √√√
  Server-Side                     √
    Expands/Contracts within      √
      boundaries based on client  √
      location extremes           √
      and number of clients       √
    Sends new bounds              √
    Creates new walls to fit new  √
      limits                      √
  Client-Side                     √
    Reads new bounds              √
    Sets fieldWidth to read value √
    
Draw field boundaries             √√√

Icons                             √••
  skull                           √
  present                         √
  bullet                          √
  crown                           √
  hammer                          √
  fruit-slice                     √
  info button                     √
  help button                     √
  stop button                     √
  continue button                 √
  radioactive symbol              •
  hexagon                         •
  star                            •
  leaf                            •
  feather                         •
  key                             •
  diamond                         •
  mountain                        •
  simple fish                     •
  dollar sign                     •
  bowling ball                    •

Create Enemies w/ A.I.            √√√
  Server-side                     √
    ArrayList of enemies          √
    create Enemy class            √
    create enemyHD                √
    implement Enemy spawning      √
    create Enemy functions        √
      set targetShoot             √
      set targetMove              √
      collision                   √
        with clients              √
        with walls                √
        with other enemies        √
      move                        √
        change angle              √
        walk                      √
      shoot                       √
      delete objects              √
      die                         √
    Send enemy data               √
    run enemy functions           √
  Client-side                     √
    create enemyHD                √
    read enemies from enemyList   √
    enemies are treated like      √
      objects                     √
    draw enemies                  √
    
Clients react to enemies          √√√
  Collision w/ enemies            √
  Lose health upon collision      √
  
Implement Enemy combat packages   √√√
  Choices                         √
    Woodpecker                    √
    Hedgehog                      √
    Salamander                    √
    Beaver                        √
    Turtle                        √
  Change appearance               √
    angle = animation for turtle  √
  Change speed                    √
  Change damage                   √
  Change bullet                   √
  Change coolTime                 √
  
Lessen enemy collision damage     √√√

Implement Name Changing           √√√
  Server Side                     √
    add owner[] to clientData     √
      reception                   √
    edit updateClient()           √
    send newname                  √
  Client Side                     √
    Add createButtonName()        √
      design button               √
      display button              √
      link button                 √
    Edit name (textBox)           √
    Send newname                  √
    Change name                   √
    
Add Help Screen Scrolling (so I   √√√
  can extend the instructions     √
  indefinitely)                   √
  createScrollButtons()           √
    design                        √
    display                       √
    link                          √
  edit drawHelp() function        √
    add horizontal shadow bar     √
    
Shorten ID Tags                   √√√

Round Locations and Velocities    √√√
  Client side                     √
    send                          √
      myClient.sendData()         √
      myClient.changeObjects()    √
        woodpecker                √
        mole                      √
        salamander                √
        spider                    √
        beaver                    √
        turtle                    √
        hedgehog                  √
        other objects             √
    read                          √
      myClient.getData()          √
      readServerLists()           √
      objects.location            √
  Server side                     √
    send                          √
      broadcastObjectList()       √
      updateEnvironment()         √
      spawnItems                  √
    read                          √
      clients                     √
      objects                     √
    updateClient()                √

Improve Shooting Protocols        √√√
  client-side                     √
    in changeObjects()            √
      create new object instead   √
        of just sending a message √
        woodpecker                √
        mole                      √
        salamander                √
        spider                    √
        beaver                    √
        turtle                    √
        hedgehog                  √
    create new verified var. for  √
      objects                     √
    in readServerLists()          √
      update objects.verified     √
    in object.display()           √
      only display if verified    √
    in myClient.sendData()        √
      for each object             √
        if (!object.verified)     √
        send mess. to add object  √
        again                     √
  server-side                     √
    edit spawn() to check of      √
      requested addition has      √
      already been processed      √
    edit respond() to process     √
      multiple spawn() requests   √
          
Systems for Cooperative Play      •••
  decrease damage from 'friendly  •
    fire'                         •
    add special icon to owner     •
      info for each projectile    •
    decrease health subtraction   •
      if special icon is the same •
      as myClient's               •
  new objects to promote grouping •
    health restorers?             •
    coin spawners?                •
    foggers?                      •
      they create smokescreens    •
        which are transparent to  •
        players on its team       •
      to change a fogger to your  •
        team, touch it            •
      
Improve Enemies                   √√√
  make aim less perfect           √
    delay speed (aimSpeed)        √
    miss mark  (accuracy)         √
  change # of enemies             √
    have constant # of players by √
      managing enemy #'s?         √
    only update fieldWidth once   √
      server sends field with     √
        loadHD request            √
      client sets field when      √
        given access to play      √  
      server doesn't update       √
        fieldWidth; it starts     √
        with fieldMaximum         √
  factor in smokescreens          √
    shortens range by 25%         √
    worsens accuracy              √
  factor in incoming projectiles  √
    and other dangers             √
    random amount of repulsion    √
      (agility)                   √
    
Scoring and Upgrades              •••
  make score loss a proportion    •
  upgrades more frequent          •
  
New termite combat package        •••
  create icon                     •
    castle front with jagged top  •
      rim and square doorway      •
  display                         •
    holds a gear in front which   •
    spins when building           •
  attack: creates turrets         •
  special: creates foggers?       •
  speed: fast                     •
  health: medium                  •
  coolTime: very long             •
  
Only draw field when near bounds  √√√

Smokescreens lowers enemy agility •••

Spawn new enemies faster          √√√

Improve server reading?           •••
  in respond()                    •
    compile multiple HD requests  •
    of each type before analyzing •
    them                          •

  
DEBUGGING:                        
  Show turtle's shield            √    (draw shield, expand alpha interpretation to include shieldLength)
    correct shieldlength error    √
  Adoption of other icons         √    (got REGISTERED message because we had the same address [maybe], so you can only receive the message now if stage == 3)
  Premature game-overs            √    (only die if stage == 4 [you're alive])
  Score stagnancy                 √    (clients w/o score don't drop coins...) HOW: if average client's score in playing field is less than 10 && there are 0 coins in the field, server places 1 coin every ## counter ticks.
  Spider range?                   √    (increases blast radius of sniper bullet too much)
  Turtle shield compatibility     √    
    with grenades                 √    (they aren't deleting properly)
    with demolition grenades      √    (they aren't compatible yet)
  Shotgun ghost bullets           √    (didn't do any damage)
  Machine gun lump                √    (don't draw properly)
  Pickup problem                  √    (U.J. can't pick up items) solution: use a different splitID (perhaps he doesn't have the diamond char in his OS) TRY: $ 
  Chatline                        √    (general user interface improvements)
  Server discards zombies         √    (make it possible for server to remove zombies somehow) HOW: add zombieness[Z] for every client; the server increments Z every loop. If the client updates, it is set back to zero. If it gets past 500, the client is eliminated from the list and a death message is sent.
  Clients w/ numbers die suddenly √    
  Impossible boxes                √
  Enemies get stuck               √    (enemies have a stuckTime to show when movement in a particular direction is futile)
  Bounds change with zoom         √    (factor in z for drawing field bounds)
  Same names; different passwords √
  Enemies + sniper sights         √
  Enemies + invisible players     √
  Enemies + sliding grenades      √
  Enemies + detonators            √
  Wall spawning                   √
  FieldWidth change with player # √
  Enemies don't drop coins        √
  TEST: Do enemies pick up coins? √
  Enemies delete hazardRings      √
  Enemies are coin-colored        √
  Visible walls outside field     √
  Enemies pass fieldBoundaries    √
  Can't pick up enemy coins       √
  Enemies get stuck at field edge √
  Enemies get stuck on each other √
  Same Names, different spacing   √
  Hedgehog Enemies don't shoot    √
  Turtle Enemies move weirdly     √
  Enemies die by own grenades     √
  Enemy grenades = too slow       √
  Items outside bounds            √    (when spawned @ edge, which changes depending on # of players)
  Bullet wasted to press button   √    (solution: don't shoot if mouse near a button)
  Can't press RETURN for newname  √
  Name taken, but not actually    •    (sometimes, it won't allow the user to make multiple name changes in one round)
  Windows doesn't have font       •    (solution: perhaps have font data stored in sketch folder?)
  Projectiles explode prematurely √    (solution: check if projectiles are past target by checking if abs(vAngle-tAngle) < PI*0.5)
  Items spawn inside walls        •    (solution: when spawning new items AND when processing addition requests from clients [specifically beavers], check if items are in walls)
  Some enemies vibrate            •    (when confronted with projectiles, enemies trying to dodge vibrate)
  Client chatBox won't clear      √    (the chatBox doesn't clear when key pressed initially. solution: I had changed the default text, so conditions had to be changed as well)
  Too many additions              √    (when a new object is requested, too many result. solution: in server, compare stationary objects by location and moving objects by target)
\*****************************************************/

import processing.net.*;

Client client;

String clientHD = "C:";          //Data headings 
String objectHD = "O:";
String messageHD = "M:";
String newHD = "N:";
String loadHD = "L:";
String spawnHD = "S:";
String deleteHD = "D:";

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

String receiverID = ">[";         //The intended receiving client of the following data (for server -> client broadcast) tag

String codeCD = "_(";             //Special icon code tags
String shapeID = "#["; 
String ellipseID = "e[";

String chatID = "c[";

char endID = ']';
char endCD = ')';
char endHD = '*';

char splitID = '$';                //used only when necessary, which is when a client wants to delete multiple objects, add multiple objects, or split shapes in special icon instructions.

String myAddress = str(int(random(10000,99999)));    //random 5-digit number is the client's address — no need to use client's ip address :)

Player myClient;
ArrayList<OtherPlayer> otherClients = new ArrayList<OtherPlayer>();    //List of neighbor client objects
ArrayList<Object> objects = new ArrayList<Object>();

PFont titleFont;
int titleSize;

PVector titleOrigin;

PFont infohelpFont;
float scrollVelocity;
float helpLocation = 0;

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

int stage = 0;
boolean bestGraphics = true;
boolean escapeHover = false;
boolean fieldConfirmed = false;
int fieldWidth = 2000;                //Dimensions of the battlefield (a square) 
float z = 1;                          //Scale all locations and sizes for spider client & mole client

void setup() {
  size(800,700);
  client = new Client(this, "74.71.101.15", 44445);      //For using internet connection — the ip is that of our home router, the port is the one I chose on which to allow incoming data requests. (test w/ canyouseeme.org)
  
  myClient = new Player();
  
  titleFont = createFont("HanziPenSC-W3", 25, true);    //I've found that windows computers don't have this font... 
  infohelpFont = createFont("Avenir-Book", 20, true);
  chatFont = createFont("Monospaced", 10, true);
  
  titleOrigin = new PVector(width/2,60);
  
  chatList = new StringList();
}

void draw() {
  noCursor();
  
  if (stage < 4) {
    background(0);
  }
  else {
    background(80);
  }
  
  if (stage == 1) {
    drawInfo(150,200);
  }
  
  if (stage == 2) {
    drawHelp(150,200);
    createButtonScroll(770,350);
  }
  
  if (stage > -1 && stage < 3) {
    moveTitle();
    drawTitle();
    
    createButtonInfo(50,200);
    createButtonHelp(50,400);
    createButtonPlay(50,600);
  }
  
  if (stage == 3) {
    createButtonPlay(700,600);    //If clicked, request to join is sent.
    createButtonBack(50,100);
    
    createButtonWoodpecker(100,220);
    createButtonMole(200,220);
    createButtonSalamander(300,220);
    createButtonSpider(400,220);
    createButtonBeaver(500,220);
    createButtonTurtle(600,220);
    createButtonHedgehog(700,220);
    
    drawTitle();
    
    drawPackageSelection(combatPackage);
    
    createButtonGraphics(60,500);
    createButtonSigned(60,540);
    textBoxUsername(100,620);
  }
  
  readServerMessage();
    
  if (stage == 4) {
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
    
    chatLine();                           //for the textBox and the displays
    rename();                             //"                              "
  }
  
  if (stage == 5) {
    displayKillscreen();
    createButtonPlay(width/2,height/2);    //If clicked, stage returns to 0.
  }
  
  drawSights();
}