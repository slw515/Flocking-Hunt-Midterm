Flock flock;
Vehicle v;
int rVoid = 3;
PVector mouse;

void setup() {
  size(640, 360);
  flock = new Flock();
  v = new Vehicle(0, 0);
  // Add an initial set of boids into the system
  for (int i = 0; i < 20; i++) {
    Boid b = new Boid(width/2, height/2);
    flock.addBoid(b);
  }
}

void draw() {
  mouse = new PVector(mouseX, mouseY);
  background(126, 200, 80);
  flock.run(v);
  for (int i = 0; i < flock.boids.size(); i++) {
    if (flock.boids.get(rVoid).fillColor <= 1) {
      flock.boids.remove(rVoid);
      rVoid = int(random(flock.boids.size()));
    }
  }     
  if (flock.boids.size() > 0) {
    if (v.position.x <= flock.boids.get(rVoid).position.x + 20 && v.position.x >= flock.boids.get(rVoid).position.x - 20 && flock.boids.get(rVoid).position.y <= v.position.y + 20 && flock.boids.get(rVoid).position.y >= v.position.y - 20) {
      v.seek(flock.boids.get(rVoid).position);
      flock.boids.get(rVoid).gFill = 70;
      flock.boids.get(rVoid).bFill = 60;
      flock.boids.get(rVoid).rFill = 255;
      println("hello");
      //println(
    } else {
      v.seek(flock.boids.get(rVoid).futurePosition);
      flock.boids.get(rVoid).gFill = 100;
      flock.boids.get(rVoid).bFill = 255;
      flock.boids.get(rVoid).rFill = 40;
    }
  } else {
    v.seek(mouse);
  }  

  //println("hello");
  //acceleration.x = v.acceleration.x *= -1;
  //acceleration.y = v.acceleration.y *= -1;
  //println(acceleration.x);


  //println(flock.boids.get(3).fillColor);
  //  println(flock.boids.get(4).fillColor);

  v.update();
  v.display();
  // Instructions
  fill(0);
  text("Drag the mouse to generate new deer.", 10, height-16);
}

// Add a new boid into the System
void mouseDragged() {
  flock.addBoid(new Boid(mouseX, mouseY));
}
