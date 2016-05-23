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
  
New termite combat package        √√•
  stats                           º
    attack: creates turret        √
    special: creates base         √
    speed: fast                   √
    coolTime: very long           √
    upgrade info: ???             •
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
  otherClients.display()          √
  upgrade()                       √
  send in createButtonPlay()      √
  server-side                     •
    add termite clients           •
    read client sendData for      •
      termites (2 angles given)   •
    angle -> angle, animationA.   •
      -> alpha                    •
 introduce turrets and beacons    º
  
Only draw field when near bounds  √√√

Smokescreens lowers enemy agility √√√

Spawn new enemies faster          √√√

Improve server reading?           •••
  in respond()                    •
    compile multiple HD requests  •
    of each type before analyzing •
    them                          •
    
Increase box spawn quantity       •••

Autocomplete username             •••
  create owen_Round_Client.txt    √
  all past usernames that the     •
    client input in the past      •
    are stored in this file       •
  the sketch pulls these names    •
    and uses them for             •
    autocomplete                  •
    
Introduce turrets and beacons     º••
  client-side                     º
    add new object id tags        √
    termite requests              √
    display turrets               •
    display beacons               •
  server-side                     º
    add new object id tags        √
    make tower class              º
      turret class extends tower  º
      beacon class extends tower  º
    update turrets to aim for     •
      clients from other 'teams'  •
    update beacons to aim for     •
      client of the same 'team'   •
    
Highlight buttons                 √√√
  help, info                      √
  combat packages                 √
  
    
  
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
  Name taken, but not actually    •    (sometimes, it won't allow the user to make multiple name changes in one round?)
  Windows doesn't have font       ?    (solution: try to have have font data stored in sketch folder. current fonts imported: hanzipen, avenir-book)
  Projectiles explode prematurely √    (solution: check if projectiles are past target by checking if abs(vAngle-tAngle) < PI*0.5)
  Items spawn inside walls        √    (solution: when spawning new items AND when processing addition requests from clients [specifically beavers], check if items are in walls)
  Some enemies vibrate            •    (when confronted with projectiles, enemies trying to dodge vibrate. solution: ???)
  Client chatBox won't clear      √    (the chatBox doesn't clear when key pressed initially. solution: I had changed the default text, so conditions had to be changed as well)
  Too many additions              √    (when a new object is requested, too many result. solution: in server, compare stationary objects by location and moving objects by target)
  Enemies don't move              √    (when the enemy hasn't client nor coin in sight, it doesn't look for a random location. solution: set random location if coin isn't less than range)
\*****************************************************/