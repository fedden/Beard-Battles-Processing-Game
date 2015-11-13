class World { //<>//

  int powerUpTimer;
  int counter;
  PImage wall, wallfloor, powerup, play, settings;
  PImage[] lava;

  //by making a static variable final, once it is declared
  //its value can never be changed, reducing risk of bugs
  static final int tileEmpty = 0; //empty tile
  static final int tileSolid = 1; //solid tile to stand on
  static final int tilePowerUp = 2; //powerup
  static final int tileKill = 3; //kill block/lava?
  static final int tileStart1 = 4; //player 1 start
  static final int tileStart2 = 5; //player 2 start
  static final int tilePlay = 6; //for menu grid, hitting this will start game
  static final int tileSettings = 7; //for menu grid, hitting this will open settings

  static final int gridSize = 30; //size in pixels of each world tile
  static final int gridAmtWide = 20; //screen width is 20*30=600
  static final int gridAmtHigh = 15; //screen height is 14*30=420

  int[][] worldGrid = new int[gridAmtHigh][gridAmtWide];

  //this is the playing grid, for battles
  int[][] startGrid = { 
    {
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    }
    , 
    {
      1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
    }
    , 
    {
      1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
    }
    , 
    {
      1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1
    }
    , 
    {
      1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1
    }
    , 
    {
      1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
    }
    , 
    {
      1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
    }
    , 
    {
      1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
    }
    , 
    {
      1, 0, 0, 0, 0, 0, 1, 1, 1, 3, 3, 1, 1, 1, 0, 0, 0, 0, 0, 1
    }
    , 
    {
      1, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 1
    }
    , 
    {
      1, 1, 1, 1, 0, 0, 0, 0, 0, 3, 3, 0, 0, 0, 0, 0, 1, 1, 1, 1
    }
    , 
    {
      1, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 1
    }
    , 
    {
      1, 4, 0, 0, 0, 0, 0, 0, 0, 3, 3, 0, 0, 0, 0, 0, 0, 0, 5, 1
    }
    , 
    {
      1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1
    }
    , 
    {
      1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1
    }
  };

  //this is the menu grid to teach players to double jump and to choose settings or play game
  int[][] menuGrid = { 
    {
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    }
    , 
    {
      1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
    }
    , 
    {
      1, 0, 6, 6, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 7, 7, 0, 1
    }
    , 
    {
      1, 0, 6, 6, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 7, 7, 0, 1
    }
    , 
    {
      1, 0, 6, 6, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 7, 7, 0, 1
    }
    , 
    {
      1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
    }
    , 
    {
      1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
    }
    , 
    {
      1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
    }
    , 
    {
      1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
    }
    , 
    {
      1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1
    }
    , 
    {
      1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
    }
    , 
    {
      1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
    }
    , 
    {
      1, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 1
    }
    , 
    {
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    }
    , 
    {
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    }
  };

  World() {
    powerUpTimer = 0; //reseting the timer to start value
    imageLoader(); //load my textures
    counter = 0; //for iterating through lava textures
  }

  void imageLoader() {
    //i load my images here
    lava = new PImage[5];
    for (int i = 0; i < lava.length; i++) {
      lava[i] = loadImage("lava" + (i+1) + ".png");
    }
    wall = loadImage("stonewalldark.png");
    wallfloor = loadImage("stonewalldarkfloor.png");
    powerup = loadImage("powerup.png");
    play = loadImage("play.png");
    settings  = loadImage("settings.png");
  }

  //returns type of tile at a given pixel coordinate
  int worldTileAt (PVector _thisPosition) {
    float gridX = _thisPosition.x/gridSize;
    float gridY = _thisPosition.y/gridSize;

    //boundary collision here for edges
    if (gridX <= 0) {
      return tileSolid;
    }
    if (gridX >= gridAmtWide) {
      return tileSolid;
    }
    if (gridY <= 0) {
      return tileSolid;
    }
    if (gridY >= gridAmtHigh) {
      return tileSolid;
    }

    return worldGrid[int(gridY)][int(gridX)];
  }

  //changes the tile at a given pixel coordinate to be new tile type
  //used for powerups to become empty
  void setTile(PVector _thisPosition, int _newTile) {
    int gridX = int(_thisPosition.x/gridSize);
    int gridY = int(_thisPosition.y/gridSize);

    //cannot change tiles outside the world
    if (gridX<0||gridX>gridAmtWide||gridY<0||gridY>gridAmtHigh) {
      return;
    }
    //otherwise change tile at x,y position to new tile
    worldGrid[gridY][gridX] = _newTile;
  }

  //these functions correct the player moving onto a world tile
  float topOfTile(PVector _thisPosition) {
    int thisY = int(_thisPosition.y);
    thisY /= gridSize;
    return float(thisY*gridSize);
  }

  float bottomOfTile(PVector _thisPosition) {
    if (_thisPosition.y<0) {
      return 0;
    }
    return topOfTile(_thisPosition) + gridSize; //call member function and add 1 tile
  }

  float leftOfTile(PVector _thisPosition) {
    int thisX = int(_thisPosition.x);
    thisX /= gridSize;
    return float(thisX*gridSize);
  }

  float rightOfTile(PVector _thisPosition) {
    if (_thisPosition.x<0) {
      return 0;
    }
    return leftOfTile(_thisPosition)+gridSize;
  }

  void reload(int[][] _grid) {
    for (int i = 0; i < gridAmtWide; i++) {
      for (int j = 0; j < gridAmtHigh; j++) {
        if (_grid[j][i] == tileStart1) { //player 1 start position

          worldGrid[j][i] = tileEmpty; //replace with empty tile

          //update player1 to centre of the tile
          player1.position.x = i*gridSize+(gridSize/2);
          player1.position.y = j*gridSize+(gridSize/2);
        } else if (_grid[j][i] == tileStart2) {

          worldGrid[j][i] = tileEmpty;

          //update player2 to centre of the tile
          player2.position.x = i*gridSize+(gridSize/2);
          player2.position.y = j*gridSize+(gridSize/2);
        } else {
          worldGrid[j][i] = _grid[j][i];
        }
      }
    }
  }

  //here we display the world
  void display() {

    //next few lines SHOULD handle powerup rotating/animation

    //handling colours
    for (int i = 0; i < gridAmtWide; i++) {
      for (int j = 0; j < gridAmtHigh; j++) {
        noStroke();
        switch(worldGrid[j][i]) {   
        case tileSolid:
          //if tile above is empty or powerup, use different tile texture (looks subtley better)
          PVector tileAbove = new PVector(i*gridSize, j*gridSize - gridSize);

          if ((worldTileAt(tileAbove) == 0) || (worldTileAt(tileAbove) == 2)) {
            image(wallfloor, i*gridSize, j*gridSize);
          } else {
            image(wall, i*gridSize, j*gridSize);
          }
          break;

        case tileKill:
          //do some counting here to iterate though lava images
          float k = frameCount % 5;
          if (k == 0) {
            counter++;
            if (counter == 4) {
              counter = 0;
            }
          }
          image(lava[counter], i*gridSize, j*gridSize);  
          break;

        case tilePowerUp:
          //black background
          fill(0);
          rect(i*gridSize, j*gridSize, gridSize, gridSize);
          //layer image on top
          image(powerup, i*gridSize, j*gridSize);  
          break;

        case tilePlay:
          //image(settings, i*gridSize, j*gridSize);
          fill(60);
          rect(i*gridSize, j*gridSize, gridSize, gridSize);
          break;

        case tileSettings:
          //image(settings, i*gridSize, j*gridSize);
          fill(60);
          rect(i*gridSize, j*gridSize, gridSize, gridSize);
          break;

        default:
          //nothing
          break;
        }
      }
    }
  }
}
