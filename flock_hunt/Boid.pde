// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Boid class
// Methods for Separation, Cohesion, Alignment added

class Boid {
  PVector futurePosition;
  PVector position;
  PVector velocity;
  PVector acceleration;
  PVector addFuture;
  float r;
  float fillColor = 200;
  float rFill = 255;
  float gFill = 255;
  float bFill = 255;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  Boid(float x, float y) {
    acceleration = new PVector(x, y);
    futurePosition = new PVector(0, 0);
    velocity = new PVector(random(-1, 1), random(-1, 1));
    position = new PVector(x, y);
    addFuture = new PVector(5, 5);
    r = random(2, 8);
    maxspeed = 3;
    maxforce = 0.05;
  }

  void run(ArrayList<Boid> boids, Vehicle v) {
    flock(boids);
    update();
    borders();
    render();

  }

  void applyForce(PVector force) {

    PVector f = PVector.div(force, r);
    acceleration.add(f);
    if (v.position.x <= position.x + 300 && v.position.x >= position.x - 300 && v.position.y <= position.y + 300 && v.position.y >= position.y - 300) {
      acceleration.x *= -2;
      acceleration.y *= -2;
    }
  }

  void flock(ArrayList<Boid> boids) {
    PVector sep = separate(boids);   // Separation
    PVector ali = align(boids);      // Alignment
    PVector coh = cohesion(boids);   // Cohesion
    sep.mult(1.5);
    ali.mult(1.0);
    coh.mult(1.0);
    
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }

  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    position.add(velocity);
    //futurePosition = position;
    //futurePosition.add(velocity);
    futurePosition.x = position.x + 12;
    futurePosition.y = position.y + 12;


    acceleration.mult(0);
  }

  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, position);  
    PVector desiredFuture = PVector.sub(target, position);
    desired.normalize();
    desired.mult(maxspeed);
    desiredFuture.normalize();
    desiredFuture.mult(maxspeed);
    PVector steer = PVector.sub(desired, velocity);
    PVector steerFuture = PVector.sub(desiredFuture, velocity);

    steer.limit(maxforce);  // Limit to maximum steering force
    steerFuture.limit(maxforce);  // Limit to maximum steering force

    return steer;
  }

  void render() {
    float theta = velocity.heading2D() + radians(90);
    fill(rFill, gFill, bFill, fillColor);

    noStroke();
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();
    popMatrix();
  }

  // Wraparound
  void borders() {
    if (position.x < -r) velocity.x *= -1;
    if (position.y < -r) velocity.y *= -1;
    if (position.x > width+r) velocity.x *= -1;
    if (position.y > height+r) velocity.y *= -1;
  }

  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList<Boid> boids) {
    float desiredseparation = 130.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  PVector align (ArrayList<Boid> boids) {
    float neighbordist = 100;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      return steer;
    } else {
      return new PVector(0, 0);
    }
  }

  // Cohesion
  PVector cohesion (ArrayList<Boid> boids) {
    float neighbordist = 100;
    PVector sum = new PVector(0, 0);   
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.position); // Add position
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the position
    } else {
      return new PVector(0, 0);
    }
  }

  void dead(Vehicle v) {
    if (v.position.x <= position.x + 5 && v.position.x >= position.x - 5 && v.position.y <= position.y + 5 && v.position.y >= position.y - 5) {
      fillColor-=10;
    } else {
    }
  }

  void chase(Vehicle v) {
    if (v.position.x <= position.x + 300 && v.position.x >= position.x - 300 && v.position.y <= position.y + 300 && v.position.y >= position.y - 300) {
      //println("hello");
      //acceleration.x = v.acceleration.x *= -1;
      //acceleration.y = v.acceleration.y *= -1;
      //println(acceleration.x);
    }
  }
}
