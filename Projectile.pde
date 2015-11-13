class Projectile {
  
  //projectiles location
  PVector location;
  //projectile is a dangerous flying beard and thefore needs graphics
  PImage beard;
  //direction to fly in
  boolean directionLeft;
  int angle;
  
  Projectile(PVector _location, boolean _direction) {
    location = new PVector(_location.x, _location.y);
    beard = loadImage("beard.png");
    directionLeft = _direction;
    angle = 0;
  }
  
  void update() {
    move();
    display();
  }
  
  //function to move beard along x axis depending on players direction
  void move() {
    if (directionLeft) {
      location.x -= 10;
    } else {
      location.x += 10;
    }
  }
  
  //display beard (flip horizontally depending on direction)
  void display() {
    pushMatrix();
    translate(0,0);
    angle = int((angle + 0.5)%360);
    rotate(radians(angle));
    //imageMode(CENTER);
    image(beard, location.x, location.y);
    //rectMode(CENTER);
    popMatrix();
  }
}
    
    
    
   
