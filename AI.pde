/* ths is simply a collection of functions that can be called on player 2 if AI boolean is set to true */

class AI {

  int state;
  boolean throwingBeard, throwingPunch; // these booleans are used in Player2 class to trigger diffent animation frames
  boolean goingUp;
  boolean powerUpCollected;
  boolean move;

  AI() {
    goingUp = false;
    throwingBeard = false;
    throwingPunch = false;
    state = 1;
    powerUpCollected = false;
    move = true;
  }

  //this is the function called from void draw() in the main.pde
  void run() { 
    //this function decides what the ai state is
    stateManager();

    if (move) {
      move();
    } else {
      theKeyboardWhisperer.holdingLeft2 = false;
      theKeyboardWhisperer.holdingRight2 = false;
    }
  }

  void stateManager() {    
    /*
    this is the general gist of the state manager
    
     if (there are powerups left && health < player1) {
       ...getPowerUp();
     } else {
       if (in range) {
         ...fight();
       } else {
         if (not in range but near) {
           ...getInRange();
         } else {
           if (hiding on top platforms) {
             ...getToTopPlatform();
           } else {
             ...search();
           }
         }
       }
     }   
     */

    //location of left and right power up
    PVector leftPowerUp = new PVector(45, 106);
    PVector rightPowerUp = new PVector(556, 108);
    
    //if possible to chuck a beard at oppo, run the beard toss function
    if ((player2.position.y == player1.position.y) && (((!player2.keyEventSwitch) && (player1.position.x > player2.position.x)) || ((player2.keyEventSwitch) && (player1.position.x < player2.position.x)))) {
      beard();
    }

    //if losing health and not yet collected a powerup
    if ((player2.health + 20 < player1.health) && (!powerUpCollected)) {

      //if both powerups available, go for closest depending on which side
      if ((theWorld.worldTileAt(leftPowerUp) == World.tilePowerUp) && (theWorld.worldTileAt(rightPowerUp) == World.tilePowerUp)) {

        //if player 2 is on left side go for left power up
        if (player2.position.x < width/2) {
          move = true;
          getLeftPowerUp();
        } else {
          move = true;
          getRightPowerUp();
        }

        //if only left power up available, go for left
        if ((theWorld.worldTileAt(leftPowerUp) == World.tilePowerUp) && (theWorld.worldTileAt(rightPowerUp) != World.tilePowerUp)) {
          move = true;
          getLeftPowerUp();
        }

        //if only right power up available, go for right 
        if ((theWorld.worldTileAt(leftPowerUp) != World.tilePowerUp) && (theWorld.worldTileAt(rightPowerUp) == World.tilePowerUp)) {
          move = true;
          getRightPowerUp();
        }
      }
      
    } else { 

      //if in range and on ground, stop and fight
      if (player2.punch(player1.position) && player2.isOnGround) {
        
          //stop moving
          move = false;
        
          //fight!
          fight();

        
      } else {
        
        //if near-same y position but different x, get closer    
        if ((abs(player2.position.x - player1.position.x) <= 90) && (player2.position.y >= player1.position.y - 20) && (player2.position.y < player1.position.y + 20)) {
          
          //run instructions to get closer to player 1
          getCloser();

        } else { 
          
          //if player 1 is hiding/collecting powerups on top platforms
          //if player position is higher or equal to top platform (obviously y axis is inverse to game height)
          if (player1.position.y <= 120) {
            
            //if on top left platform
            if (player1.position.x < width/2) {
              getToTopLeftPlatform();
            } 
            
            //if on top right platform
            if (player1.position.x > width/2) {
              getToTopRightPlatform();
            }
            
          //else search for player
          } else {
            println("search");
            search();
            move = true;
          }
        }
      }
    }
  }
  
  //used to hunt player if at top right platform
  void getToTopRightPlatform() {
    //ensure moving
    move = true;
    //ensure doesn't end up in lava blocks if travelling from left side
    jumpRight(240, 250, 260, player2.keyEventSwitch);
    //then use same commands to collect right power up
    getRightPowerUp();
    //fixing a glitch where player 2 stays still sometimes
    //if not moving, is on ground and not in range then move and search for player 1
    if (player2.velocity.x == 0 && !player2.punch(player1.position) && player2.isOnGround) {
      player2.velocity.x = -1;
    }
  }
  
  //used to hunt player if at top left platform
  void getToTopLeftPlatform() {
    //ensure moving
    move = true;
    //ensure doesn't end up in lava blocks if travelling from right side
    jumpLeft(240, 360, 370, player2.keyEventSwitch);
    //then use same commands to collect left power up
    getLeftPowerUp();
    //fixing a glitch where player 2 stays still sometimes
    //if not moving, is on ground and not in range then move and search for player 1
    if (player2.velocity.x == 0 && !player2.punch(player1.position) && player2.isOnGround) {
      player2.velocity.x = 1;
    }
  }
  
  //this will cause player two to 'chase' player one if close enough
  void getCloser() {
    //these jumps are for over the middle kill blocks
    //to ensure player 2 doesn't end up in lava
    jumpRight(240, 250, 260, player2.keyEventSwitch);    
    jumpLeft(240, 360, 370, player2.keyEventSwitch);
    
    //if oppo is to the right
    if (player2.position.x - player1.position.x < 0) {
      //face right
      player2.keyEventSwitch = false;
      //move
      move = true;
    
    //else if oppo is to the left
    } else if (player2.position.x - player1.position.x > 0) {
      //face left
      player2.keyEventSwitch = true;
      //move
      move = true;
    }
  }
  
  //get left power up at top left platform
  void getLeftPowerUp() {
    if (difficulty >= 1) {
        powerUpCollected = false; //if hardest or middle difficulty, player2 ultimately may pick up both powerups
    }
    //if at correct height
    if (player2.position.y == 240) {
      //look left
      player2.keyEventSwitch = true;
      //player 2 will now move left so once at (186-200,240) double jump to reach left power up
      jumpLeft(240, 130, 181, player2.keyEventSwitch);
    } else {
      search();
      //speeds up search
      goingUp = true;
      //if jumping left, height will be < 240 so now double jump to reach platform
      if (player2.position.y < 240) {
        jumpLeft(240, 100, 130, player2.keyEventSwitch);
      }
      if ((player2.position.y <= 120) && (player2.position.x < 70)) {
        powerUpCollected = true;
      }
    }
  }
  
  //collect right powerup at top right platform
  void getRightPowerUp() {
    if (difficulty >= 1) {
        powerUpCollected = false; //if hardest or middle difficulty, player2 ultimately may pick up both powerups
    }
    //if at correct height
    if (player2.position.y == 240) {
      if (player2.position.x < 390) {
        //look right
        player2.keyEventSwitch = false;
      }
      //player 2 will now move left so once at (186-200,240) double jump to reach left power up
      jumpRight(240, 380, 400, player2.keyEventSwitch);
    } else {
      search();
      //speeds up search
      goingUp = true;
      //if jumping right-ways, height will be < 240 so only double jump like this if trying to reach platform
      if (player2.position.y < 240) {
        //jumpLeft(240, 111, 130, player2.keyEventSwitch);
        jumpRight(240, 490, 500, player2.keyEventSwitch);
      }
      if ((player2.position.y <= 120) && (player2.position.x > 500)) {
        powerUpCollected = true;
      }
    }
  }
  
  //allows ai to punch
  void fight() {
    int m = int(random(0, 15));
    if (m == 0) {
      punchAudio.cue(0);
      punchAudio.play(0);
      player2.score += 300;
      int damage = 3;
      //difficulty is set in the main.pde in the method settings();
      if (difficulty == 0) {
        damage = 3;
      } else if (difficulty == 1) {
        damage = 8;
      } else if (difficulty == 2) {
        damage = 20;
      }
      player1.damage(damage);
      //prevents getting stuck in animationframe when jumping
      if (player2.isOnGround) {
        throwingPunch = true;
      } else {
        throwingPunch = false;
      }
    } else {
      throwingPunch = false;
    }
  }
  
  //generalised search function for ai to fall back on if it can't do anything else
  void search() {
    //if at bottom left corner, player 2 will need to travel up
    if (player2.position.y == 390 && player2.position.x < width/2) {
      //if player 2 position is same height but other side
      if (player2.position.y != player1.position.y || player1.position.x > width/2) {
        goingUp = true;
      } else {
        goingUp = false;
      }
    }
    
    //if at bottom right corner, player 2 will need to travel up
    if (player2.position.y == 390 && player2.position.x > width/2) {
      //if player2 position is same height but other side
      if (player2.position.y != player1.position.y || player1.position.x < width/2) {
        println("Right side going up");
        goingUp = true;
      } else {
        println("Right side staying down");
        goingUp = false;
      }
    }
    
    //if on 'middle' (not centre) platform, decide whether to go up or down depending on player 1 position
    if (player2.position.y == 300) {
      //if on 'left middle' platform, both players are on same side, and player 2 is 'higher up' in the game world, go down
      if (player2.position.x < width/2 && player1.position.x < width/2 && player2.position.y < player1.position.y) {
        //go down
        goingUp = false;
      }
      //if on 'left middle' platform, both players are on same side, and player 2 is 'lower down' in the game world, go up
      if (player2.position.x < width/2 && player1.position.x < width/2 && player2.position.y > player1.position.y) {
        //go up
        goingUp = true;
      }
      //if on 'left middle' platform, player 1 is on otherside, go up
      if (player2.position.x < width/2 && player1.position.x > width/2) {
        //go up
        goingUp = true;
      }
      //if on 'right middle' platform, both players are on same side, and player 2 is 'higher up' in the game world, go down
      if (player2.position.x > width/2 && player1.position.x > width/2 && player2.position.y < player1.position.y) {
        //go down
        goingUp = false;
      }
      //if on 'right middle' platform, both players are on same side, and player 2 is 'lower down' in the game world, go up
      if (player2.position.x > width/2 && player1.position.x > width/2 && player2.position.y > player1.position.y) {
        //go down
        goingUp = true;
      }
      //if on 'right middle' platform, player 1 is on otherside, go up
      if (player2.position.x > width/2 && player1.position.x < width/2) {
        //go down
        goingUp = true;
      }
    }
      
    //if on centre middle platforms 240 high, to continue player 2 needs to go down
    if (player2.position.y == 240) {
      goingUp = false;  
      //if at centre middle platforms, it is logical to face in direction of player 1
      if ((player1.position.x > player2.position.x) && (player1.position.y == player2.position.y) && (player2.isOnGround)) {
        //face right
        player2.keyEventSwitch = false;
      }
      if ((player1.position.x < player2.position.x) && (player1.position.y == player2.position.y) && (player2.isOnGround)) {
        //face left
        player2.keyEventSwitch = true;
      }
    }
    
    //if on top platforms ensure AI doesn't get stuck up there
    if (player2.position.y == 120) {
      goingUp = false;
    }

    //these jumps are for over the middle kill blocks
    jumpRight(240, 250, 260, player2.keyEventSwitch);    
    jumpLeft(240, 360, 370, player2.keyEventSwitch);

    if (goingUp) {
      //effectively a double jump to get up the first platform
      jumpLeft(390, 180, 190, player2.keyEventSwitch);
      jumpLeft(390, 190, 220, player2.keyEventSwitch);

      //prevent from hitting roof when collecting powerups
      if (player2.position.y > 240) {
        //first platform to the middle platforms
        jumpLeft(300, 480, 485, player2.keyEventSwitch);
        jumpRight(300, 95, 115, player2.keyEventSwitch);
      }
      //effectively a double jump to get up the first platform
      jumpRight(390, 380, 390, player2.keyEventSwitch);
      jumpRight(390, 375, 400, player2.keyEventSwitch);
    }
  }

  void jumpLeft(float _height, float _locLeft, float _locRight, boolean _facing) {
    //if in position and facing right way
    if (((player2.position.y == _height) || (!player2.isOnGround)) && (player2.position.x > _locLeft) && (player2.position.x < _locRight) && (_facing)) {
      //jump - player 2
      player2.velocity.y = -Actor.jumpPower;
    }
  }

  void jumpRight(float _height, float _locLeft, float _locRight, boolean _facing) {
    //if in position and facing right way
    if (((player2.position.y == _height) || (!player2.isOnGround)) && (player2.position.x > _locLeft) && (player2.position.x < _locRight) && (!_facing)) {
      //jump - player 2
      player2.velocity.y = -Actor.jumpPower;
    }
  }

  
  void beard() {
    if (gameState == 1) {
      int bd = int(random(0, 7));
      if (bd == 0) {
        //if meeting criteria in stateManager(), send 'player 2 beard throw' character
        PVector player2BeardSpawn = new PVector(player2.topSide.x, player2.topSide.y + 10);
        beards2.add(new Projectile(player2BeardSpawn, player2.keyEventSwitch));
        throwAudio.cue(0);
        throwAudio.play();
        //prevents getting stuck in animationframe when jumping
        if (player2.isOnGround) {
          throwingBeard = true;
        } else {
          throwingBeard = false;
        }
      } else {
        throwingBeard = false;
      }
    }
  }

  void move() {    
    //accessed in static way (World > theWorld)
    PVector toTheLeft = new PVector(player2.position.x - World.gridSize, player2.position.y - player1Stand.height/2 );
    PVector toTheRight = new PVector(player2.position.x + World.gridSize, player2.position.y - player1Stand.height/2 );

    //the long println()'s were really helpful for making me realise i'm an idiot

    if ((player2.keyEventSwitch) && ((theWorld.worldTileAt(toTheLeft) == World.tileEmpty)) || (theWorld.worldTileAt(toTheLeft) == World.tilePowerUp)) {
      //if facing left and tile to left is empty or power up, move left. 
      theKeyboardWhisperer.holdingLeft2 = false;
      //println("going left");
    } else {
      theKeyboardWhisperer.holdingLeft2 = true;
    }

    if (((theWorld.worldTileAt(toTheLeft) == World.tileSolid) || (theWorld.worldTileAt(toTheLeft) == World.tileKill)) && (player2.isOnGround)) {
      //if left tile is solid or kill and not in air, face right.
      player2.velocity.x *= 0.4;
      player2.keyEventSwitch = false;
      //println("grid Y = " + int(toTheLeft.y / World.gridSize) + ", grid X = " + int(toTheLeft.x / World.gridSize) + ", tile to the left = " + theWorld.worldTileAt(toTheLeft) + " so facing right");
    }

    if (((theWorld.worldTileAt(toTheRight) == World.tileSolid) || (theWorld.worldTileAt(toTheRight) == World.tileKill)) && (player2.isOnGround)) {
      //if right tile is solid or kill and not in air, face left
      player2.velocity.x *= 0.4;
      player2.keyEventSwitch = true;
      //println("grid Y = " + int(toTheRight.y / World.gridSize) + ", grid X = " + int(toTheRight.x / World.gridSize) + ", tile to the right = " + theWorld.worldTileAt(toTheRight) + " so facing left");
    }

    if (((!player2.keyEventSwitch) && (theWorld.worldTileAt(toTheRight) == World.tileEmpty)) || (theWorld.worldTileAt(toTheRight) == World.tilePowerUp)) {
      //if facing right and tile to right is empty or power up, move right. 
      theKeyboardWhisperer.holdingRight2 = false;
      //println("going right");
    } else {
      theKeyboardWhisperer.holdingRight2 = true;
    }
  }
}
