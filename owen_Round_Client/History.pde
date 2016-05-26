                 //  HISTORY  \\
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
  cloud                           •

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
    fire' to promote teaming      •
    add special icon to owner     •
      info for each projectile    •
    decrease health subtraction   •
      if special icon is the same •
      as myClient's or client is  •
      the owner                   •
  new objects to promote grouping •
    health restorers (created by  •
      players w/ termite package) •
    foggers?                      •
      they create smokescreens    •
        which are transparent to  •
        players on its team       •
      to change a fogger to your  •
        team, touch it            •
  systems for team requests       • —— page lists all taken and available team icons. client requests team code or new team. clients can send private messages for team joining (default receiver is the team?)
      
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
  
New termite combat package        √√º
  stats                           º
    attack: creates turret        √
    special: creates base         √
    speed: fast                   √
    coolTime: very long           √
    upgrade: turrets shoot        •
      grenades                    •
  selection description           •
  createButtonTermite()           √
  create icon                     √
    castle front with jagged top  √
      rim and square doorway      √
  display                         √
    holds a gear in front which   √
    spins when building           √
  myClient functions              √
    getData()                     √
    control()                     √
    changeObjects()               √
    display()                     √ 
    sendData()                    √
  otherClients.display()          ?
    angle == angle, animationA.   √
      == alpha                    √
  upgrade()                       √
  send in createButtonPlay()      √
  server-side                     ?
    add termite clients           √
    read client sendData for      √
      termites (2 angles given)   √
 introduce turrets and bases      √
  
Only draw field when near bounds  √√√

Smokescreens lowers enemy agility √√√

Spawn new enemies faster          √√√

Improve server reading?           •••
  in respond()                    •
    compile multiple HD requests  •
    of each type before analyzing •
    them                          •
    
Increase boxes' spawn quantity    •••

Autocomplete username             √√√
  create usernames.txt            √
  all past usernames that the     √
    client input are stored in    √
    this file                     √
  the sketch pulls these names    √
    and uses them for             √
    autocomplete                  √
    
Introduce turrets and bases       √√√
  client-side                     √
    add new object id tags        √
    edit changeObjects() for the  √
      termite package             √
    display turrets               √
      looks like title frame      √
      diameter = 60               √
    display bases                 √
      looks like saturn?          √
      diameter = 60               √
    add to help menu              √
      TOWERS: the termite combat  √
      package was made to promote √
      teaming. It makes turrets   √
      (shoot at enemies and       √
      players on other teams) and √
      bases (restore health to    √
      players on their team)      √
    clients collide with bases    √
      and turrets                 √
    clients restore health when   √
      near bases they own or      √
      those of the same team      √
  server-side                     √
    add new object id tags        √
    edit respond()                √
        base                      √
        turret                    √
    make tower class              √
      turret class extends tower  √
      turret.time()               √
      turret.aim()                √
        for clients               √
        for enemies               √
        for enemy turrets         √
        for enemy bases           √
      turret.shoot()              √
      turret.collide()            √
        bullets                   √
        hazardRing                √
        coin                      √
        subtract health           √
        delete projectiles        √
    edit enemy.collide() to       √
      collide with turrets and    √
      bases                       √
    edit enemy.setTargetShoot()   √
      shoot bases and turrets     √
    updateTurrets()               √
    edit updateEnvironment()      √
      base                        √
        decrease radius           √
          for bullets and h.Rings √
        delete                    √
        delete otherObject        √
      other projectiles           √
        grenades: bases+turrets   √
        demolitions: ""           √
        detonators don't move :)  √ 
    edit broadcastObjectList()    √
      broadcast turrets           √
      broadcast bases             √
  incorporate owner[]             √
    adjust changeObjects()        √
    turrets                       √
      adjust initialization       √
      adjust turret.aim()         √
        
Highlight buttons                 √√√
  help, info                      √
  combat packages                 √
  
Give object information on hover  •••
  create hoverDialogue() function •
    when mouse is over an object  •
      (check every X ms) display  •
      explanation of that object  •
   ammo: "RELOAD SITE"            •
   health: "HEALTH BOX"           •
   coin: "COIN"                   •
   turret: "TURRET"               •
   base: "BASE"                   •
    
Move teaming explanation to help  √√√
  TEAMS: following the username   √
    in the sign-in, some code     √
    inputs in the format:         √
    _•••• correspond to special   √
    icons. For example, if a code √
    is "popcorn", then type       √`
    "yourName_popcorn" in the     √
    sign-in. To create a team,    √
    players who know the same     √
    icon code can sign in with    √
    that code and enjoy reduced   √
    damage from friendly fire.    √
    
  
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
  Pickup problem                  √    (U.J. can't pick up items. solution: use a different splitID (perhaps he doesn't have the diamond char in his OS) TRY: $) 
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
  Name taken, but not actually    √    (sometimes, it won't allow the user to make multiple name changes in one round. solution: server checks if filedList.get(i).address == askingClient.address to see if client didn't hear the answer before)
  Windows doesn't have font       ?    (solution: try to have have font data stored in sketch folder. current fonts imported: hanzipen, avenir-book)
  Projectiles explode prematurely √    (solution: check if projectiles are past target by checking if abs(vAngle-tAngle) < PI*0.5)
  Items spawn inside walls        √    (solution: when spawning new items AND when processing addition requests from clients [specifically beavers], check if items are in walls)
  Some enemies vibrate            •    (when confronted with projectiles, enemies trying to dodge vibrate. solution: ???)
  Client chatBox won't clear      √    (the chatBox doesn't clear when key pressed initially. solution: I had changed the default text, so conditions had to be changed as well)
  Too many additions              √    (when a new object is requested, too many result. solution: in server, compare stationary objects by location and moving objects by target)
  Enemies don't move              √    (when the enemy hasn't client nor coin in sight, it doesn't look for a random location. solution: set random location if coin isn't less than range)
  Client doesn't enter game       √    (solution: include i[] in REGISTERED response from server, make sure to add a h[100] datum in new client so the server can update it)
  Server sends empty death mess.  •    (reading out incoming messages, the server keeps sending "DEATH []". solution: ...?)
  Enemy collision is off          √    (solution: fix math where enemies collide with turrets)
  Turrets don't shoot correctly   √    (bullets have very short range, and have wrong targets. solution: fix bullet velocity to match trajectory)
  Enemies don't aim for termites  √    (solution: enemies now aim for clients with alpha>0 OR package.equals("termite"))
  Turrets.target flicker          √    (solution: have turrets store trueTarget (the object/enemy/client) and only change trueTarget when trueTarget is no longer within range)
  Termites move when building     √    (solution: movement disabled when coolTime > 0)
  Turrets don't display icons     √    (solition: account for the fact that an icon has splitID's within it)
  Turrets shoot at team players   √    (solution: server was storing icon codes for clients instead of icons)
  Other termites don't show up    √    (solution: clients used to only draw others if (other.alpha > 0), so I made an exception if (other.cpackage.equals("termite"))
\*****************************************************/