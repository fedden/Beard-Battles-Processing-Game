class Keyboard {
  //used to track keyboard input
  Boolean holdingDown1, holdingRight1, holdingLeft1, holdingDown2, holdingRight2, holdingLeft2, punch1, punch2, kick1, kick2;
  
  Keyboard() {
    holdingDown1 = holdingRight1 = holdingLeft1 = holdingDown2 = holdingRight2 = holdingLeft2 = punch1 = punch2 = kick1 = kick2 = false;
  }
  
  //processing deals with keys like events and we want to treat keys as buttons
  //that can be held, so pressed and released update true/false values
  
  void pressKey(int key) {
    if (key == 's') {
      holdingDown1 = true;
    }
    if (key == 'k') {
      holdingDown2 = true;
    }
    if (key == 'a') {
      holdingRight1 = true;
    }
    if (key == 'd') {
      holdingLeft1 = true;
    }
    if (key == 'j') {
      holdingRight2 = true;
    }
    if (key == 'l') {
      holdingLeft2 = true;
    }
    if (key == 'e') {
      punch1 = true;
    }
    if (key == 'o') {
      punch2 = true;
    }
    if (key == 'r') {
      kick1 = true;
    }
    if (key == 'p') {
      kick2 = true;
    }
  }
  
  void releaseKey(int key) {
    if (key == 's') {
      holdingDown1 = false;
    }
    if (key == 'a') {
      holdingRight1 = false;
    }
    if (key == 'd') {
      holdingLeft1 = false;
    }
    if (key == 'k') {
      holdingDown2 = false;
    }
    if (key == 'j') {
      holdingRight2 = false;
    }
    if (key == 'l') {
      holdingLeft2 = false;
    }
    if (key == 'e') {
      punch1 = false;
    }
    if (key == 'o') {
      punch2 = false;
    }
    if (key == 'r') {
      kick1 = false;
    }
    if (key == 'p') {
      kick2 = false;
    }
  }
}
    
    
