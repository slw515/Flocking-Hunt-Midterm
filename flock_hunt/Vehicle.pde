// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// The "Vehicle" class

class Vehicle {
    ArrayList<PVector> history = new ArrayList<PVector>();

  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    

  Vehicle(float x, float y) {
    acceleration = new PVector(0,0);
    velocity = new PVector(-1,1);
    position = new PVector(x,y);
    r = 9;
    maxspeed = 4;
    maxforce = 0.1;
  }

  // Method to update position
  void update() {
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    position.add(velocity);
    acceleration.mult(0);
    
        history.add(position.get());
    if (history.size() > 100) {
      history.remove(0);
    }
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // A method that calculates a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  void seek(PVector target) {
    PVector desired = PVector.sub(target,position); 
    
    desired.normalize();
    desired.mult(maxspeed);
    // Steering = Desired minus velocity
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxforce + 0.2); 
    
    applyForce(steer);
  }
    
  void display() {
    
    
    float theta = velocity.heading2D() + PI/2;
    fill(180, 134, 72);
    strokeWeight(1);
    noStroke();
    pushMatrix();
    translate(position.x,position.y);
    rotate(theta);
    beginShape();
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape(CLOSE);
    popMatrix();
    
    if (position.x < -r) velocity.x *= -1;
    if (position.y < -r) velocity.y *= -1;
    if (position.x > width+r) velocity.x *= -1;
    if (position.y > height+r) velocity.y *= -1;
    
    
  }
}
