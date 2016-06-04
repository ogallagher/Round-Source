//Round_Server

// BEGUN:         July 18, 2015
// LAST UPDATED:  June 4, 2016
// VERSION:       8
// UPDATES:       
//    7 = Flexible field size, drawn boundaries, name changing, AI enemies
//    8 = Tags shortened to reduce lag [x], Round locations and velocities [x], Improve shooting protocols [x], Promote teaming [...], Improve enemies [x], Change scoring dynamics and upgrades [ ], Worsen spider package (dagger,speed) [ ], Termite combat package [...], Autocomplete username [x], Allow complex movement [x], Various bug fixes [...]

/*  
    Accounts Format Example
      name[player0]score[0]address[#]
      name[player1]score[1]address[#]
      
    Message Format Example
      name[player0]receiver[player1]chat[M] —— from client
      name[player2]icon[C]chat[M]           —— from client
      receiver[all]name[SERVER]chat[M]      —— from server
      receiver[player3]name[SERVER]MESSAGE  —— from server
      
    clientList Format Example
      name[N]score[S]location[X,Y]angle[T]package[P]health[H]alpha[A]zombie[Z]icon[C]owner[O]address[#]
      
    objectList Format Example                                                          REMEMBER: clients take away walls, healthBoxes, ammoBoxes, coins, and bullets, and change their own healths and scores
      name[field]radius[W/2]                                                                     I send radius so as not to create necessity for new tag
      name[wall]location[X,Y]radius[R]                                                           walls are circles; collision is simple between circles
      name[healthBox]location[X,Y]                                                               returns 50 health                                               
      name[ammoBox]location[X,Y]                                                                 completely refills ammo
      name[coin]location[X,Y]                                                                    always worth 1
      name[bullet]location[X,Y]velocity[Xv,Yv]target[Xt,Yt]damage[D]icon[C]owner[player0]        target helps show if bullet has gone too far
      name[detonator]location[X,Y]radius[R]alpha[A]damage[D]icon[C]owner[player1]                alpha corresponds to time till detonation
      name[smokescreen]location[X,Y]radius[R]alpha[A]                                            alpha corresponds to transparency
      name[hazardRing]location[X,Y]radius[R]alpha[A]damage[D]icon[C]owner[player2]               alpha corresponds to current radius, radius corresponds to final radius
      name[grenade]location[X,Y]velocity[Xv,Yv]target[Xt,Yt]radius[R]damage[D]icon[C]            target helps show if grenade has gone too far (like the bullet, but creates hazardRing)
        owner[player4]     
      name[demolition]location[X,Y]velocity[Xv,Yv]target[Xt,Yt]radius[R]damage[D]icon[C]         same as grenade, but shrinks/removes walls on contact
        owner[player5]  
      name[fanshot]location[X,Y]velocity[Xv,Yv]radius[R]alpha[A]damage[D]icon[C]owner[player6]   alpha corresponds to additional bullets to the original deviation angle of 0 ON EACH SIDE (decided not to use it...)
      name[laserPoint]location[X,Y]alpha[A]                                                      alpha corresponds to whether the sight should be deleted
      name[turret]location[X,Y]target[Xt,Yt]radius[R]damage[D]health[H]icon[C]owner[player7]     target used both to tell range and angle
      name[base]location[X,Y]radius[R]icon[C]owner[player8]                                      radius corresponds to how far health is distributed and how much health the base still has
    
    enemyList Format Example
      location[X,Y]angle[T]package[P]
      
    icons Format Example
      name[N]owner[player0]icon[C]location[X,Y]angle[T]alpha[A]shape[x,y;x,y;x,y;x,y]$location[X,Y]alpha[A]ellipse[W,H]
      name[N]owner[player1]icon[C]location[X,Y]alpha[A]shape[x,y;x,y;x,y;x,y]$alpha[A]shape[x,y;x,y;x,y;x,y;x,y]
*/

import processing.net.*;

Server server;
int serverPort = 44445;

String[] accounts;                                      //Replica of the accounts.txt file. (each entry is a new line)
StringList accountList;                                 //Saved clients
StringList clientList;                                  //Signed clients
StringList objectList;                                  //List of objects
ArrayList<Enemy> enemyList = new ArrayList<Enemy>();    //List of enemies, like objects, but more complicated
ArrayList<Turret> turretList = new ArrayList<Turret>(); //List of turrets, "                                "

String[] icons;                                         //Replica of the icons.txt file. (each entry is a new line)
StringList idList;                                      //List of names and owners
StringList codeList;                                    //List of acceptable icon codes
StringList iconList;                                    //List of icon drawing instructions
    
String clientHD = "C:";          //Data headings
String objectHD = "O:";
String messageHD = "M:";
String newHD = "N:";
String loadHD = "L:";
String spawnHD = "S:";
String deleteHD = "D:";
String teamHD = "T:";

String addressID = "@[";        //Shared client data tags (some used in object/enemy data)
String nameID = "n[";              
String scoreID = "s[";
String angleID = "<[";
String locationID = "l[";
String packageID = "p[";
String alphaID = "a[";

String healthID = "h[";          //Private client data tags
String zombieID = "z[";

String velocityID = "v[";      //Object-specific tags
String radiusID = "r[";
String targetID = "t[";
String damageID = "d[";
String ownerID = "o[";

String receiverID = ">[";         //The intended receiving client of the following data (for server -> client broadcast) tag
String iconID = "i[";             //Special icon code tag

String chatID = "c[";              //Tag for chat-line strings.
StringList chatList;               //Chat-Line

char endID = ']';
char endHD = '*';

char splitID = '$';                //used only when necessary: delete objects, add objects, split shapes for special icon

int fieldMaximum = 3160;
int fieldWidth = fieldMaximum;        //Dimensions of the battlefield (field is a square, so width & height) (how far a client can go)
int playerMaximum = 10;
int coinTimer = 0;                    //Timer for placing coins randomly throughout the battlefield
int enemyTimer = 0;                   //"               " enemies "                               ".

int clientScope = 750;                //Variables for managing how much information if sent to the clients
float[] viewLimits = new float[4];    // [0] = minX  [1] = maxX  [2] = minY  [3] = maxY

PFont displayFont;
PFont chatFont;

String chatBoxString = "[,],*,:,$,TAB = Not Permitted. Limit = 60 char.";  //Initial string for textBoxChat();

void setup() {
  size(600,600);
  server = new Server(this,serverPort);
  
  accounts = loadStrings("accounts.txt");
  accountList = new StringList();
  clientList = new StringList();
  objectList = new StringList();
  chatList = new StringList();
  
  for(int i=0; i<accounts.length; i++) {
    accountList.append(accounts[i]);
  }
  
  createIcons();
  createEnvironment();                  //Can fieldWidth be changed w/o changing the client-side? —— NO
  
  displayFont = createFont("Chalkboard", 12, true);
  chatFont = createFont("Monospaced", 10, true);
  
  println("Server Device IP:  " + Server.ip());
}

void draw() {  
  printData();                                //Display filed clients, signed clients, and/or objects lists.
  
  textBoxChat(25,height-25);                  //Enable server to send chat to all players.
  
  displayChatLine();                          //Show chat history.
  
  respond();                                  //Read and respond to client messages (can be for newHD, loadHD, clientHD, spawnHD, deleteHD, and messageHD.)
  
  checkZombies();                             //Function for dealing with zombie clients (who quit w/o using the ESCAPE button).
  
  updateEnvironment();                        //Update environment outside of direct client initiation. (moving bullets and grenades, creating explosions, etc.)
  
  spawnItems();                               //Create healthBoxes, ammoBoxes, coins, walls, and enemies depending upon #items, #clients, #score, and #coinTimer.
  
  updateEnemies();                            //Run enemy functions for every enemy in the enemyList
  
  updateTurrets();                            //Run turret functions for every turret in the turretList
  
  adjustLimits();                             //Adjust limits of view for clients and stretch fieldWidth
  
  broadcastClientList();                      //Send all client data
  
  broadcastObjectList();                      //Send visible environment data (items and enemies)
}