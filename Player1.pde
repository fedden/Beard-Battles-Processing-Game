class Player1 extends Actor {

  boolean keyEventSwitch;

  Player1() {
    super();
    lives = 3;
    // health = 100; 
    keyEventSwitch =  false;
  }
  
  void score() {
    if (theWorld.worldTileAt(player1.topSide) == World.tileKill ||
      theWorld.worldTileAt(player1.leftSideHigh) == World.tileKill ||
      theWorld.worldTileAt(player1.leftSideLow) == World.tileKill ||
      theWorld.worldTileAt(player1.rightSideHigh) == World.tileKill ||
      theWorld.worldTileAt(player1.rightSideLow) == World.tileKill ||
      theWorld.worldTileAt(player1.position) == World.tileKill) {
      //delete a life
      player2.score += 500;
    }
    if (health <= 0) {
      player2.score += 1000;
    }
  }

  void punchCheck(char _key) {
    //this is called in the KeyPressed method to prevent looping
    if (_key == 'r') {
      //if in range, and facing the correct way towards enemy
      if (punch(player2.position) && ((position.x < player2.position.x && keyEventSwitch == false) || (position.x > player2.position.x && keyEventSwitch == true))) {
        //punch sound can go here
        punchAudio.cue(0);
        punchAudio.play(0);
        player2.damage(3);
        player1.score += 300;
      } else {
        missAudio.cue(0);
        missAudio.play(0);
      }
    }
  }

  void inputCheck() {
    // keyboard flags are set by keyPressed/keyReleased in main .pde

    float speedHere = (isOnGround ? runSpeed : airRunSpeed);
    float frictionHere = (isOnGround ? friction : drag);

    if (theKeyboardWhisperer.holdingLeft1) {
      velocity.x += speedHere;
    } else if (theKeyboardWhisperer.holdingRight1) {
      velocity.x -= speedHere;
    }

    velocity.x *= frictionHere;
  }

  void jumpCheck(char _key) {
    if (_key == 'w') {

      if (isOnGround) {
        doubleJumpCounter = 0;
      }

      //player may only jump if on the ground or not double jumped already
      if (isOnGround || doubleJumpCounter < 2) { 

        doubleJumpCounter++;
        //println("this many jumps " + doubleJumpCounter);

        // should play sound here
        jumpAudio.cue(0);
        jumpAudio.play();
        velocity.y = -jumpPower; //change verticle speed
        isOnGround = false;
      }
    }
  }

  void hud() {
    score();
    fill(0);
    rect(23, 23, 204, 24);
    fill(204, 204, 0);
    rect(25, 25, 200, 20);
    fill(153, 0, 0);
    stroke(0);
    strokeWeight(0.2);
    rect(25, 25, health*2, 20);
    noStroke();
    fill(0);
    textSize(15);
    textAlign(LEFT);
    text(ceil(health), 30, 41);
    fill(255);
    textSize(15);
    text("lives    " + lives, 30, 60);   
    text("score    " + player1.score, 30, 80);
  }

  //member function not the main function
  void draw() {
    int actorWidth = player1Stand.width;
    int actorHeight = player1Stand.height;

    //useful for programming ai
    println("player1 pos.x = " + position.x);
    println("player1 pos.y = " + position.y);

    //use key events to control which way char faces, probably better
    //to remove bool switch and just do tranformation on keypressed
    if (keyPressed) {
      if (key == 'a') {
        keyEventSwitch = true;
      } else if (key == 'd') {
        keyEventSwitch = false;
      }
    }

    pushMatrix();
    translate(position.x, position.y);

    if (keyEventSwitch) {
      scale(-1, 1); //flip horizontally
    } else {
      scale(1, 1);
    }

    //drawing images centred on actor's feet
    translate(-actorWidth/2, -actorHeight);

    //if throwing (pressing e)
    if (keyPressed && key == 'e') {
      throwAnimationFrame = 0;
      if (throwAnimationFrame == 0) {
        image(player1Throw1, 0, 0);
        throwAnimationFrame = 1;   
        if (throwAnimationFrame == 1) {
          image(player1Throw2, 0, 0);
        }
      }
    } else if (keyPressed && key == 'r') {
      image(player1Punch, 0, 0);
    } else {
      if (isOnGround == false) { //falling or jumping?
        image(player1Run1, 0, 0);
      } else if (abs(velocity.x) < trivialSpeed) { //not much velocity so display standing
        image(player1Stand, 0, 0);
      } else { //running
        if (animationDelay-- < 0) {
          animationDelay = int(runAnimationDelay); // (3)
          if (animationFrame == 0) {
            animationFrame = 1;
          } else {
            animationFrame = 0;
          }
        }
        if (animationFrame == 0) {
          image(player1Run1, 0, 0);
        } else {
          image(player1Run2, 0, 0);
        }
      }
    }
    popMatrix();
  }
}
