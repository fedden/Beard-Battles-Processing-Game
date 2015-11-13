//this abstract class cannot be instantiated, it will serve as a //<>//
//base for subclasses

abstract class Actor {
  PVector position, velocity; //contains two floats x and y
  PVector leftSideHigh, leftSideLow, rightSideHigh, rightSideLow, topSide; //for collision and shadows

  Boolean isOnGround; //is player on ground?
  Boolean facingRight; //is player image flipped?

  int doubleJumpCounter; //used to allow no more than two jumps
  float health; //actor health stat
  int lives; //actor lives stat
  int animationDelay; //countdown timer between animation updates - see player 1 & 2 sub class
  int animationFrame; //what animation frame is currently being shown for running? - see player 1 & 2 sub class
  int throwAnimationFrame; //what animation frame is currently being show for throwing a beard? - see player 1 & 2 sub class
  int savedTime;
  int score;
  
  static final float jumpPower = 10.0; //how powerful player jump is
  static final float runSpeed = 1.5; //force of player movement, pixels per cycle
  static final float airRunSpeed = 3.0; //like run speed but when in air
  static final float friction = 0.85; //friction from ground
  static final float drag = 0.6; //drag resistance from air
  static final float runAnimationDelay = 3; //amount of cycles to pass between animation updates
  static final float trivialSpeed = 1.0; //if under this speed, player is displayed as still

  Actor() {
    savedTime = millis();
    isOnGround = false;
    facingRight = true;
    position = new PVector();
    velocity = new PVector();
    reset();
    lives = 3;
    score = 0;
  }

  void reset() {
    animationDelay = 0;
    animationFrame = 0;
    throwAnimationFrame = 0;
    velocity.x = 0;
    velocity.y = 0;
    doubleJumpCounter = 0;
    savedTime = millis(); //resets the timer
    health = 100;
  }

  void checkWall() {
    //image size of player standing is players physical size
    //both players are same size so doesnt matter using player1 pic
    int actorWidth = player1Stand.width; 
    int actorHeight = player1Stand.height;

    int wallProbeDistance = int(actorWidth*0.5);
    int ceilingProbeDistance = int(actorHeight) + 3;

    //we draw the player with the "position" at the centre of feet/bottom
    //to detect wall/ceiling collisions, 5 new positions are made:

    //left of centre, at shoulder level
    leftSideHigh = new PVector();

    //right of centre, at shoulder level
    rightSideHigh = new PVector();

    //left of centre, shin level
    leftSideLow = new PVector();

    //right of centre, shin level
    rightSideLow = new PVector();

    //centre, tip of the head
    topSide = new PVector();

    //update wall probes
    leftSideHigh.x = leftSideLow.x = position.x - wallProbeDistance; //left edge of player
    rightSideHigh.x = rightSideLow.x = position.x + wallProbeDistance; //right edge of player
    leftSideLow.y = rightSideLow.y = position.y - actorHeight/2; //shin height both sides
    leftSideHigh.y = rightSideHigh.y = position.y - actorHeight; //shoulder height

      //centre of player
    topSide.x = position.x;

    //top of player
    topSide.y = position.y - ceilingProbeDistance;

    //if player is inside killblock, lose life and respawn() - found in main .pde
    if (theWorld.worldTileAt(topSide) == World.tileKill ||
      theWorld.worldTileAt(leftSideHigh) == World.tileKill ||
      theWorld.worldTileAt(leftSideLow) == World.tileKill ||
      theWorld.worldTileAt(rightSideHigh) == World.tileKill ||
      theWorld.worldTileAt(rightSideLow) == World.tileKill ||
      theWorld.worldTileAt(position) == World.tileKill) {
      //delete a life
      lives--;
      resetGame(theWorld.startGrid);
      return;
    }

    //these conditionals check for collisions with each probe
    //depending on which probe has collided, the player is pushed back  
    if (theWorld.worldTileAt(topSide) == World.tileSolid) {
      if (theWorld.worldTileAt(position) == World.tileSolid) {
        position.sub(velocity);
        velocity.x = 0.0;
        velocity.y = 0.0;
      } else {
        position.y = theWorld.bottomOfTile(topSide)+ceilingProbeDistance;
        if (velocity.y < 0) {
          velocity.y = 0.0;
        }
      }
    }

    if (theWorld.worldTileAt(leftSideLow) == World.tileSolid) {
      position.x = theWorld.rightOfTile(leftSideLow) + wallProbeDistance;
      if (velocity.x < 0) {     
        velocity.x = 0.0;
      }
    }

    if (theWorld.worldTileAt(leftSideHigh) == World.tileSolid) {
      position.x = theWorld.rightOfTile(leftSideHigh) + wallProbeDistance;
      if (velocity.x < 0) {
        velocity.x = 0.0;
      }
    }

    if (theWorld.worldTileAt(rightSideLow) == World.tileSolid) {
      position.x = theWorld.leftOfTile(rightSideLow) - wallProbeDistance;
      if (velocity.x > 0) {
        velocity.x = 0.0;
      }
    }

    if (theWorld.worldTileAt(rightSideHigh) == World.tileSolid) {
      position.x = theWorld.leftOfTile(rightSideHigh) - wallProbeDistance;
      if (velocity.x > 0) {
        velocity.x = 0.0;
      }
    }
  }

  //in menu mode check if players hit play tiles
  boolean checkPlay() {
    PVector centreOfPlayer;
    //check for powerup overlap with centre of player
    //"position" is bottom centre of feed

    centreOfPlayer = new PVector(position.x, position.y-player1Stand.height/2);
    if (theWorld.worldTileAt(centreOfPlayer) == World.tilePlay) {
      return true;
    } else {
      return false;
    }
  }

  //in menu mode check if players hit settings tiles
  boolean checkSettings() {
    PVector centreOfPlayer;
    //check for powerup overlap with centre of player
    //"position" is bottom centre of feed

    centreOfPlayer = new PVector(position.x, position.y-player1Stand.height/2);
    if (theWorld.worldTileAt(centreOfPlayer) == World.tileSettings) {
      return true;
    } else {
      return false;
    }
  }

  void checkPowerUp() {
    PVector centreOfPlayer;
    //check for powerup overlap with centre of player
    //"position" is bottom centre of feed

    centreOfPlayer = new PVector(position.x, position.y-player1Stand.height/2);
    
    if (theWorld.worldTileAt(centreOfPlayer) == World.tilePowerUp) {
      theWorld.setTile(centreOfPlayer, World.tileEmpty);
      if (health >= 70) {
        health = 100;
      } else {
        health += 30;
      }
    }
  }  

  void checkFalling() {
    //if standing on empty or powerup tile, we're not standing on anything
    if ((theWorld.worldTileAt(position) == World.tileEmpty) || (theWorld.worldTileAt(position) == World.tilePowerUp)) {
      isOnGround = false;
    }

    if (isOnGround == false) {
      if (theWorld.worldTileAt(position) == World.tileSolid) { //if landed on solid
        isOnGround = true;
        //make a noise
        landAudio.cue(0);
        landAudio.play();
        position.y = theWorld.topOfTile(position);
        velocity.y = 0.0;
      } else {
        velocity.y += gravity;
      }
    }
  }

  boolean punch(PVector _enemyPosition) {
    //calculate distance between 
    float distance = position.dist(_enemyPosition);
    int reach = 40;
    if (distance <= reach) {
      println("in range!");
      return true;
    } else {
      println("out of range");
      return false;
    }
  }

  void damage(int _damage) {
    health -= _damage;
    println(health);
    if (health <= 0) {
      lives--;
      resetGame(theWorld.startGrid);
    }
  }

  void move() {
    position.add(velocity);
    checkWall();
    checkPowerUp();
    checkFalling();
  }
}
