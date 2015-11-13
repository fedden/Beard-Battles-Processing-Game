//what started out as snow is now falling red embers 
//eye candy

class Snow {
  //how many flakes/squares of 'snow' on screen
  static final int quantity = 100;
  
  //fairly self explantory
  float [] xPosition = new float[quantity];
  float [] yPosition = new float[quantity];
  int [] flakeSize = new int[quantity];
  int [] direction = new int[quantity];
  
  //hoping this is still making sense ;)
  static final int minFlakeSize = 1;
  static final int maxFlakeSize = 5;
  
  Snow() {
    //no stroke!!! 
    noStroke();
    
    //loop through all snow 'flakes' and assign some values
    for (int i = 0; i < quantity; i++) {
      flakeSize[i] = round(random(minFlakeSize, maxFlakeSize));
      xPosition[i] = random(35, width-35);
      yPosition[i] = random(35, height-35);
      direction[i] = round(random(0, 1)); //lots of zeroes and ones
    }
  }

  void display() {
    //for all of snow
    for (int i = 0; i < quantity; i++) {
      
      //fades out snow only when it gets very close to floor tiles
      int alpha = round(map(yPosition[i], 0, height-35, 2000, 0));
      
      //random red value gives flickering effect
      fill(random(154, 255),0, 0, alpha);
      
      //varying size and positions
      rect(xPosition[i], yPosition[i], flakeSize[i], flakeSize[i]);
      
      //if 0 direction (in life)
      //go left, else right - not intended to be reflection on our democratic system
      
      //should be about half and half each way because round() was used in the constructor
      if (direction[i] == 0) {
        xPosition[i] -= map(flakeSize[i], minFlakeSize, maxFlakeSize, .1, .5);
      } else {
        xPosition[i] += map(flakeSize[i], minFlakeSize, maxFlakeSize, .1, .5);
      }
      
      //flake falling speed is tied in with size - bigger is faster
      yPosition[i] += (flakeSize[i] + direction[i])/2; 
      
      //if hittig walls, floors etc then send to top and repeat
      if (xPosition[i] > width-35 + flakeSize[i] || xPosition[i] < -flakeSize[i] + 35 || yPosition[i] > height-35 + flakeSize[i]) {
        xPosition[i] = random(0, width);
        yPosition[i] = -flakeSize[i];
      }
    }
  }
}
