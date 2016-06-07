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
  melon                           √
  i                               √
  ?                               √
  stop                            √
  play                            √
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
  shield                          •
  ellipses                        •
  plus                            •

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
          
Promote teaming                   √√√
  decrease damage from 'friendly  √
    fire' to promote teaming      √
    add icon code to info         √
      for each projectile         √
      myClient.changeObjects()    √
      turrets.shoot()             √
      updateEnvironment()         √
        detonators                √
        grenades+demolition       √
        fanshots                  √
    decrease damage (client)      √
      if special icon is the same √
      as myClient's or client is  √
      the owner                   √
    decrease damage (turret)      √
      if special icon is the same √
      as turrets's or turret is   √
      the owner through client    √
      master                      √
  new objects to promote grouping √
    health restorers (created by  √
      players w/ termite package) √
    foggers? - for now, no.       x
      they create smokescreens    x
        which are transparent to  x
        players on its team       x
      to change a fogger to your  x
        team, touch it            x
  systems for team requests       √
    page lists all taken and      √
      available team icons        √
    explain in help menu          √
    client-side                   √
      new icons menu button and   √
        corresponding stage #     √
      createButtonIcons()         √
        logo is a shield          √
      icons menu contents         √
        list (scrollable)         √
        icons function as buttons √
          edit drawing            √
        team()                    √
          broadcast @[#]T:NEW*    √
          broadcast @[#]T:CODE*   √
            with name             √
      edit readServerMessage() to √
        update if requestingTeam  √
      broadcast @[#]T:DATA* to    √
        get taken and available   √
        list                      √
      whenever playButton pressed √
        clear teams and teamIcons √
    server-side                   √
      respond to teamHD requests  √
        data                      √
        code                      √
          check that name on file √
          check that icon on file √
        new                       √
      create icons.txt            √
      method to read txt to       √
        codeList + iconList       √
      updateIcons()               √
  clients can send private        √
    messages to specific players  √
    (default receiver is the      √
    team)                         √
    explain in HELP menu          √
    
Weaken spider package             √√√
  make slower                     √
  worsen dagger                   √
      
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
    
Scoring and Upgrades              √√√
  make score loss score/15        √
  more coins                      √
  upgrades more attainable        √
  change stat upgrades            √
    health                        √
    time                          √
    damage                        √
    range                         √
    speed1                        √
    speed2                        √
    zoom                          √
    shield                        √
  highscores()                    √
    loop through all clients      √
    two variables:                √
      topPlayer                   √
      topTeam                     √
    display topPlayer             √
    display topTeam icon          √
    
  
New termite combat package        √√√
  stats                           √
    attack: creates turret        √
    special: creates base         √
    speed: fast                   √
    coolTime: very long           √
    upgrade: turrets shoot        √
      grenades                    √
      turrets not affected by     √
        their own grenades        √
  selection description           √
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
    angle == angle, animationA.   √
      == alpha                    √
  upgrade()                       √
  send in createButtonPlay()      √
  server-side                     √
    add termite clients           √
    read client sendData for      √
      termites                    √
 introduce turrets and bases      √
  
Only draw field when near bounds  √√√

Smokescreens lowers enemy agility √√√

Spawn new enemies faster          √√√

Improve server reading?           xxx
  in respond()                    x
    compile multiple HD requests  x
    of each type before analyzing x
    them?                         x
    
Increase boxes' spawn quantity    √√√

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
  
Give object information on hover? xxx
  create hoverDialogue() function x
    when mouse is over an object  x
      (check every X ms) display  x
      explanation of that object  x
   ammo: "RELOAD SITE"            x
   health: "HEALTH BOX"           x
   coin: "COIN"                   x
   turret: "TURRET"               x
   base: "BASE"                   x
    
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
    
Allow complex movement            √√√
  use function to store           √
    pressed keys in an array      √  
  get the function from           √
    owen_Complex_Client           √
    
Version 8 testing                 √ºº
  font across systems             º
    check titleFont               º
    check infohelpFont            º
    check chatFont                º
  otherClients (termites)         √
    change otherClients' name     √
      displays to titleFont       √
  chatting with receivers         √
  teams                           √
  java application                √
    the client java application   √
      doesn't support external    √
      data files as-is.           √
    test-solution:                √
      move usernames.txt to /data √
      write to Round_Client.app/  √
        Contents/Java/data        √
  enemies drop coins too scarcely √
    make probability 60%          √
  glitch with highscores()        ?
  glitch with REGISTERED message: √
    send name[player0] at end of  √
    message                       √
  enemies dodge fanshots too well √
    
  
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
  Windows doesn't have font       √    (solution: try to have have font data stored in sketch folder)
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
  Bases aren't affected by rings  √    (solution: simple typo meant radius of hazardRing was nil)
  Chat messages are often lost    •    (clients don't always receive messages sent by the server. solution: change server.chatList to store receivers, and send chatList on every X ms?)
  Clients can others' codes       √    (a client can just type another's name without numbers and see their code. solution: server sends full name as owner, client displays cleaned name but checks with full)
  Glitch with highscores          ?    (the logic in highscores() was off for calculation of topTeam score)
  REGISTERED received wrong       √    (other clients registered when they should not have)
  
\*****************************************************/