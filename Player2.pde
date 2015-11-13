class Player2 extends Actor {
  
  boolean keyEventSwitch;
  
  Player2() {
    super();
    lives = 3;
    keyEventSwitch = true;
  }
  
  void score() {
    if (theWorld.worldTileAt(player2.topSide) == World.tileKill ||
      theWorld.worldTileAt(player2.leftSideHigh) == World.tileKill ||
      theWorld.worldTileAt(player2.leftSideLow) == World.tileKill ||
      theWorld.worldTileAt(player2.rightSideHigh) == World.tileKill ||
      theWorld.worldTileAt(player2.rightSideLow) == World.tileKill ||
      theWorld.worldTileAt(player2.position) == World.tileKill) {
      //delete a life
      player2.score += 500;
    }
    if (health <= 0) {
      player1.score += 1000;
    }
  }
  
  void punchCheck(char _key) {
    if (_key == 'p') {
      if (punch(player1.position) && ((position.x < player1.position.x && keyEventSwitch == false) || (position.x > player1.position.x && keyEventSwitch == true))) {
        //punch sound can go here
        punchAudio.cue(0);
        punchAudio.play(0);
        player1.damage(3);
        player2.score += 300;
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
    
    if (theKeyboardWhisperer.holdingLeft2) {
      velocity.x += speedHere;
    } else if (theKeyboardWhisperer.holdingRight2) {
      velocity.x -= speedHere;
    }
    velocity.x *= frictionHere;
    
  }
  
  void jumpCheck(char _key) {
    if (_key == 'i') {
      if (isOnGround) {
        doubleJumpCounter = 0;
      }

      //player may only jump if on the ground or not double jumped already
      if (isOnGround || doubleJumpCounter < 2) { 
          doubleJumpCounter++;
          println("this many jumps " + doubleJumpCounter);
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
    pushMatrix();
    translate(947, 70);
    rotate(PI);
    rect(width-229, 23, 204, 24);
    fill(204, 204, 0);
    rect(width-227, 25, 200, 20);
    fill(153, 0, 0);
    stroke(0);
    strokeWeight(0.2);
    rect(width-227, 25, health*2, 20);
    fill(0);
    noStroke();
    
    popMatrix();
    textSize(15);
    textAlign(RIGHT);
    text(ceil(health), width-30, 41);
    fill(255);
    textSize(15);

    text("lives    " + lives, width-30, 60);   
    text("score    " + player2.score, width-30, 80);
  }
  
  //member function not the main function DUHHHHH!
  void draw() {
    int actorWidth = player1Stand.width;
    int actorHeight = player1Stand.height;
    if (keyPressed) {
      if (key == 'j') {
        keyEventSwitch = true;
      } else if (key == 'l') {
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
    if ((keyPressed && key == 'o') || (ai.throwingBeard)) {
      throwAnimationFrame = 0;
      if (throwAnimationFrame == 0) {
        image(player1Throw1, 0, 0);
        throwAnimationFrame = 1;
        if (throwAnimationFrame == 1) {
          image(player1Throw2, 0, 0);
        }
      }
    } else if ((keyPressed && key == 'p') || (ai.throwingPunch)) {
      image(player1Punch, 0, 0);
    } else {
      if (isOnGround == false) { //falling or jumping?
        image(player2Run1, 0, 0);
      } else if (abs(velocity.x) < trivialSpeed) { //not much velocity so display standing
        image(player2Stand, 0, 0);
      } else { //running
        if (animationDelay-- < 0) {
          animationDelay = int(runAnimationDelay); // (3)
          if (animationFrame == 0) {
            animationFrame = 1;
          } else {
            animationFrame = 0;
          }
        }
        if(animationFrame == 0) {
          image(player2Run1, 0, 0);
        } else {
          image(player2Run2, 0, 0);
        }
      }
    }
    popMatrix();
  }
}
