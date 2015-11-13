import ddf.minim.*; //<>//

//COOL EXTENSIONS

//power ups could be random box = diff. character/hp+/speedboost/jumpboost/damageboost/flyingMode
//icon images for hud, + timer
//2 layers of snow, 50 of size 3-5 in front and 50 of 1-2 behind dude

//jump attack damage

//timer, timing and attack/combo scoring system that displays at winner stage

/*--------  B E A R D   B A T T L E S  --------*/
//pimages
PImage player1Stand, player1Run1, player1Run2, player1Throw1, player1Throw2, player1Punch, player2Stand, player2Run1, player2Run2;
PImage background, candle;

//booleans
boolean paused;
boolean player1Wins;
boolean aiMode = true;

//oh look! a stray PVector
PVector lightOrigin;

//class shizzle 'ere
Projectile beard;
Shadows shadow;
Snow snow;
AI ai;
Player1 player1;
Player2 player2;
World theWorld;
Light light;
Keyboard theKeyboardWhisperer;
Minim minim;
AudioPlayer themeAudio, jumpAudio, landAudio, punchAudio, missAudio, throwAudio, startAudio, johnnyAudio, zackAudio, dumbledoreAudio;

//arrayList of projectiles to handle both player 1's beards
ArrayList<Projectile> beards1 = new ArrayList<Projectile>();
ArrayList<Projectile> beards2 = new ArrayList<Projectile>();

//is it a bird? is it a plane? no its a..
PFont font;

//for a timer
int gameStartTime, gameCurrentTime;

//gamestate dictates what part of the game you are - intro, menu, main game, settings etc
int gameState = -1;

//difficulty state
int difficulty = 0;

//gravity for objects within game
final float gravity = 0.9;

void setup() {
  size(600, 420); //fairly self explanitory
  lightOrigin = new PVector(width/2, 0);
  paused = false;

  font = createFont("Mario-Kart-DS.ttf", 15, false);
  textFont(font); //nintendo font (fits quite well into the theme of the game) 

  imageBS(); //function that manages all of the images in the game
  audioBS(); //function that instantiates all the audio in the game
  classBS(); //function that instantiates all the classes in the game
  frameRate(24); //frame rate slower, 24 frames per second

  //sets up menu tile grid/map, which serves two purposes, one, to allow the player to choose between
  //play and settings, and two, to teach the player they are supposed to use double jump (you wont be
  //able to load a game with out it)
  resetGame(theWorld.menuGrid);
}

//I named my hard drive "dat ass" so once a month my computer asks if I want to 'back dat ass up'

void draw() {
  //if game is in intro, show control scheme
  if (gameState == -1) {
    instructions();

    //if player has pressed space, they will proceed to here, the menu
  } else if (gameState == 0) {

    //play OTT silly (yet great) theme music  
    themeAudio.play();

    //a bunch of commands to realise player 1, player 2 and the world etc..
    gameSlave();
    
    textSize(15);
    //if user tries to use mouse, instruct them they should be double jumping
    if (mousePressed) {    
      text("the mouse does not work here!", width/2, height-60);
    } else {
      text("double jump into boxes to choose", width/2, height-60);
    }

    //if player jumped into play tiles, then game state 1/DA GAME is ON!!!!
  } else if (gameState == 1) {   
    gameSlave();

    //if someone wins it will go to this screen
  } else if (gameState == 2) {

    //this announces which player won the game
    winningScreen();

    //this is the settings screen
  } else if (gameState == 3) {
    settings();
  }
  //tint over the top of the game to help tie all the shitty colours/awful graphics together
  fill(255, 0, 102, 20);
  rect(0, 0, width, height);
}

void keyPressed() {
  keyPressedSlave();
  fireBeard();
}

void keyReleased() {
  //magical class member function to transform key events into boolean switches
  theKeyboardWhisperer.releaseKey(key);
}

void fireBeard() {
  if ((gameState == 0) || (gameState == 1)) {
    if (key == 'e') {
      PVector player1BeardSpawn = new PVector(player1.topSide.x, player1.topSide.y + 10);
      beards1.add(new Projectile(player1BeardSpawn, player1.keyEventSwitch));
      throwAudio.cue(0);
      throwAudio.play();
    }
    if (key == 'o') {
      PVector player2BeardSpawn = new PVector(player2.topSide.x, player2.topSide.y + 10);
      beards2.add(new Projectile(player2BeardSpawn, player2.keyEventSwitch));
      throwAudio.cue(0);
      throwAudio.play();
    }
  }
}

void beardManager() {
  //extended loop to display and update both array lists of beards
  for (Projectile b: beards1) {
    b.update();
  }
  for (Projectile b: beards2) {
    b.update();
  }
  
  //looping backwards through both arraylists to delete beards if they hit a solid tile, kill tile or player
  for (int i = beards1.size()-1; i >= 0; i--) {
    //if hitting solid or kill tile, remove
    Projectile b = (Projectile) beards1.get(i);
    if ((theWorld.worldTileAt(b.location) == World.tileSolid) || (theWorld.worldTileAt(b.location) == World.tileKill)) {
      beards1.remove(i);
    } 
    //if hitting opponent, remove
    if ((b.location.x <= player2.rightSideHigh.x) && (b.location.x >= player2.leftSideHigh.x) && (b.location.y >= player2.topSide.y) && (b.location.y <= player2.position.y)) {
      beards1.remove(i);
      //deal damage
      player2.damage(1);
      //move player backwards a tiny bit
      player2.velocity.x *= -1;
      player1.score += 100;
    }
  }
  //second looping backwards here
  for (int i = beards2.size()-1; i >= 0; i--) {
    //if hitting solid or kill tile, remove
    Projectile b = (Projectile) beards2.get(i);
    if ((theWorld.worldTileAt(b.location) == World.tileSolid) || (theWorld.worldTileAt(b.location) == World.tileKill)) {
      beards2.remove(i);
    }
    //if hitting opponent, remove
    if ((b.location.x <= player1.rightSideHigh.x) && (b.location.x >= player1.leftSideHigh.x) && (b.location.y >= player1.topSide.y) && (b.location.y <= player1.position.y)) {
      beards2.remove(i);
      //deal damage
      player1.damage(1);
      //move player backwards a tiny bit
      player1.velocity.x *= -1;
      player2.score += 100;
    }
  }  
}

void settingsMouse() {
  if (mousePressed) {
    if ((mouseX < 225) && (mouseX > 175) && (mouseY < 150) && (mouseY > 100)) {
      //single player selected
      zackAudio.cue(0);
      zackAudio.play(0);
      aiMode = true;
    } else if ((mouseX < width-175) && (mouseX > width-225) && (mouseY < 150) && (mouseY > 100)) {
      //two player selected
      zackAudio.cue(0);
      zackAudio.play(0);
      aiMode = false;
    } else if ((mouseX < 115) && (mouseX > 85) && (mouseY < 305) && (mouseY > 275)) {
      //easy difficulty
      johnnyAudio.cue(0);
      johnnyAudio.play();
      difficulty = 0;
    } else if ((mouseX < 315) && (mouseX > 285) && (mouseY < 305) && (mouseY > 275)) {
      //medium difficulty
      zackAudio.cue(0);
      zackAudio.play(0);
      difficulty = 1;
    } else if ((mouseX < 515) && (mouseX > 485) && (mouseY < 305) && (mouseY > 275)) {
      //hard difficulty
      difficulty = 2;
      dumbledoreAudio.cue(0);
      dumbledoreAudio.play();
    }
  }
}

void settingsShapes() {
  //shapes
  fill(0);
  rect(0, 0, width, height);
  if (aiMode) {
    fill(153, 0, 0);
  } else {
    fill(204, 204, 0);
  }
  rect(175, 100, 50, 50);
  if (!aiMode) {
    fill(153, 0, 0);
  } else {
    fill(204, 204, 0);
  }
  rect(width-225, 100, 50, 50);
  if (difficulty == 0) {
    fill(153, 0, 0);
  } else {
    fill(204, 204, 0);
  }
  rect(85, 275, 30, 30);
  if (difficulty == 1) {
    fill(153, 0, 0);
  } else {
    fill(204, 204, 0);
  }
  rect(285, 275, 30, 30);
  if (difficulty == 2) {
    fill(153, 0, 0);
  } else {
    fill(204, 204, 0);
  }
  rect(485, 275, 30, 30);
}

void settingsText() {
  //text here
  textAlign(CENTER);
  fill(153, 0, 0);
  text("mode", width/2, 80);
  text("difficulty", width/2, height/2 + 50);

  text("single player", 200, 180);
  text("two players", 400, 180);

  text("johnny depp", 100, 330);
  text("zach galifianakis", 300, 330);
  text("dumbledore", 500, 330);

  //press space to exit
  text("press space to return to menu", width/2, height - 40);
}

void settings() {
  //mousey stuff
  settingsMouse();
  settingsShapes();
  settingsText();
  //exit criteria 
  if ((keyPressed) && (key == ' ')) {
    resetGame(theWorld.menuGrid); //reset grid
    gameState = 0;
  }
}

//these commands are loaded when game state = -1
void instructions() {
  fill(0);
  rect(0, 0, width, height);
  snow.display();
  textAlign(CENTER);
  text("this is a one or two player game", width/2, height/2 - 100);
  text("the next screen is the menu not the main game", width/2, height/2 - 80);
  text("select play or settings by jumping into the boxes", width/2, height/2 - 60);
  text("player  1  controls       a  left     d  right     w  jump     e  throw beard     r  punch", width/2, height/2);
  text("player  2  controls       j  left     l  right     i  jump     o  throw beard     p  punch", width/2, height/2+20);
  text("press space to continue", width/2, height/2 + 100);
  if ((keyPressed) && (key == ' ')) {
    gameState = 0;
    startAudio.cue(0);
    startAudio.play(0);
  }
}

//this is the winning screen for gamestate == 2
void winningScreen() {
  fill(0);
  rect(0, 0, width, height);
  snow.display();
  textAlign(CENTER);
  if (player1Wins) {    
    text("player 1 wins!", width/2, height/2 - 20);
    text("player 1 score   " + player1.score, width/2, height/2 + 20);
  } else {
    text("player 2 wins!", width/2, height/2 - 20);
    text("player 2 score   " + player2.score, width/2, height/2 + 20);
  }
  text("press space to return to menu", width/2, height/2 + 60);
  //replenish lives for future battles
  player1.lives = 3;
  player2.lives = 3;
  if ((keyPressed) && (key == ' ')) {
    resetGame(theWorld.menuGrid);
    themeAudio.cue(0);
    startAudio.cue(0);
    startAudio.play(0);
    gameState = 0;
  }
}

//display at the end of a match!
void winnerCheck() {
  //if playing a game and either player loses, change to winner game state (2)
  if (gameState == 1) {
    if (player1.lives == 0) {
      player1Wins = false;
      gameState = 2;
    } else if (player2.lives == 0) {
      player1Wins = true;
      gameState = 2;
    }
  }
}

//resets game, used for two states, menu and play (0 & 1)
void resetGame(int[][] _grid) {
  player1.reset();
  player2.reset();
  theWorld.reload(_grid);
  gameCurrentTime = gameStartTime = millis()/1000; //milliseconds to seconds!
  ai.powerUpCollected = false;
  light.angle = PI/4;
}

void respawn() {
  player1.reset();
  player2.reset();
}

//this is the method that manages most of the game assets, methods and variables depending on the state
//whilst in draw()
void gameSlave() {
  //background rect(um)
  fill(0);
  rect(0, 0, width, height);

  if (aiMode) {
    ai.run();
  }

  //put cool background graphics where rect is
  theWorld.display();
  player1.inputCheck();
  player2.inputCheck();
  player1.move();
  player2.move();
  winnerCheck();

  //if fighting a match.. do this!
  if (gameState == 1) {
    shadow.drawShadow(light.location, player1.topSide, player1.position);
    shadow.drawShadow(light.location, player2.topSide, player2.position);
    player1.draw();
    player2.draw();  
    light.go(200);
  } else {
    player1.draw();
    player2.draw();
  }
  
  //various loops to manage both arraylists here
  beardManager();

  //cool foreground graphics go here
  if (gameState == 0) {
    //check player hitting play or settings tiles
    if (player1.checkPlay() || player2.checkPlay()) {
      //new game!
      gameState = 1;
      //load map
      resetGame(theWorld.startGrid);
      //reset scores
      player1.score = 0;
      player2.score = 0;
    }
    //check if player has chose settings
    if (player1.checkSettings() || player2.checkSettings()) {
      //load settings
      gameState = 3;
    }
    //here i prevent a bug that allows the game map to be loaded with out the game actually starting
    if ((player1.health <= 50) || (player2.health <= 50)) {
      player1.health = 100;
      player2.health = 100;
    }
    
    fill(random(154, 255),0, 0);
    textSize(20);
    textAlign(CENTER);
    text("fight", 105, 107);
    text("settings", width-105, 107);
  }

  snow.display();  
  if (gameState == 1) {
    player1.hud();
    player2.hud();
  }
}

//organisation of code
void keyPressedSlave() {
  theKeyboardWhisperer.pressKey(key);
  player1.punchCheck(key);
  player2.punchCheck(key);
  player1.jumpCheck(key);
  player2.jumpCheck(key);
}

//i've probably got OCD
void imageBS() {
  player1Stand = loadImage("guygreen.png");
  player1Run1 = loadImage("run1green.png");
  player1Run2 = loadImage("run2green.png");
  player1Throw1 = loadImage("guygreenthrow.png");
  player1Throw2 = loadImage("guygreenthrow2.png");
  player1Punch = loadImage("guygreenpunch.png");
  player2Stand = loadImage("guygreen.png");
  player2Run1 = loadImage("run1green.png");
  player2Run2 = loadImage("run2green.png");
  background = loadImage("background.png");
  background.resize(width, height);
  candle = loadImage("candle.png");
}

//yes i'm that anal
void audioBS() {
  minim = new Minim(this);
  jumpAudio = minim.loadFile("jump.wav");
  landAudio = minim.loadFile("land.wav");
  punchAudio = minim.loadFile("punch.wav");
  missAudio = minim.loadFile("miss.wav");
  missAudio.setGain(6);
  themeAudio = minim.loadFile("theme.mp3");
  themeAudio.setGain(-6);
  throwAudio = minim.loadFile("throw.wav");
  throwAudio.setGain(6);
  // singlePlayerAudio
  // doublePlayerAudio
  startAudio = minim.loadFile("start.wav");
  startAudio.setGain(-8);
  johnnyAudio = minim.loadFile("johnny.wav");
  zackAudio = minim.loadFile("menu.wav");
  zackAudio.setGain(-12);
  dumbledoreAudio = minim.loadFile("dumbledore.wav");
}

//Lazy People Fact #5812672793
//You were too lazy to read that number.
void classBS() {
  player1 = new Player1();
  player2 = new Player2();
  theKeyboardWhisperer = new Keyboard();
  theWorld = new World();
  snow = new Snow();
  shadow = new Shadows();
  light = new Light(lightOrigin, 120);
  ai = new AI();
}
