// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Flock class
// Does very little, simply manages the ArrayList of all the boids

class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids
  Flock() {
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
  }

  void run(Vehicle v) {
    for (Boid b : boids) {
      b.run(boids, v);  // Passing the entire list of boids to each boid individually
      b.dead(v);
      b.chase(v);
    }
  }

  void addBoid(Boid b) {
    boids.add(b);
  }
}
