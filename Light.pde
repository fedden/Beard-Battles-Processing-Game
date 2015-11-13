//this is used in conjunction with the shadows class, if I was being a good little programmer i'd probably
//combine the two together or something but for now not to important. 

class Light {

  PVector location;    // Location of light
  PVector origin;      // Location of light 'arm' origin
  float r;             // Length of 'arm'
  float angle;         // light arm angle
  float aVelocity;     // Angle velocity
  float aAcceleration; // Angle acceleration
  float damping;       // damping amount

  // This constructor could be improved to allow a greater variety of pendulums
  Light(PVector origin_, float r_) {
    // Fill all variables
    origin = origin_;
    location = new PVector();
    r = r_;
    angle = PI/4;

    aVelocity = 0.0;
    aAcceleration = 0.0;
    damping = 0.995;   // Arbitrary damping
  }

  void go(int _size) {
    collide();
    update();
    display(_size);  
  }
  
  void collide() {
    if (((player1.position.x < location.x + 5) && (player1.position.x > location.x - 5)) && ((player1.position.y > location.y - 10) && (player1.position.y < location.y + 25))) {
      println("collided with light!");
      aVelocity += player1.velocity.x * 0.005;
    }
  }

  // Function to update location
  void update() {
    float gravity = 0.4;                              // Arbitrary constant
    aAcceleration = (-1 * gravity / r) * sin(angle);  // Calculate acceleration (see: http://www.myphysicslab.com/pendulum1.html)
    aVelocity += aAcceleration;                 // Increment velocity
    aVelocity *= damping;                       // Arbitrary damping
    angle += aVelocity;                         // Increment angle
    
    if (location.y <= 0) {
      aVelocity *= 0;
    }
  }

  void display(int _size) {
    location.set(r*sin(angle), r*cos(angle), 0);         // Polar to cartesian conversion
    location.add(origin);                              // Make sure the location is relative to the pendulum's origin
    
    int size = _size;
    size += round(random(-2, 2));
    fill(255, 255, 0, 10);
    ellipse(location.x, location.y, size*2, size*2);
    fill(255, 255, 0, 20);
    ellipse(location.x, location.y, size, size);
    fill(255, 255, 0, 10);
    ellipse(location.x, location.y, size-90, size-90);
    fill(255, 255, 0, 10);
    ellipse(location.x, location.y, size-150, size-150);
    fill(255, 255, 0, 80);
    ellipse(location.x, location.y, size-200, size-200);
    fill(255, 255, 0, 130);
    ellipse(location.x, location.y, 10, 10);
    image(candle, location.x-10, location.y-13);
  }
}
