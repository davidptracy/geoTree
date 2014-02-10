class Mover {

  PVector location, velocity, acceleration;
  float radius, mass;
  color c1;

  Mover() {
    location = new PVector(random(width), height/4);
    velocity = new PVector(random(2), random(3));
    acceleration = new PVector();
    radius = random(3,25);
    mass = 1;
    c1 = color(0);
  }

  void display() {

    noStroke();
    //stroke(0);
    fill(c1);
    ellipse(location.x, location.y, radius, radius);
  }

  void setColor(color _c1) { 
    c1 = _c1;
  }

  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
    velocity.limit(5);
  }

  void applyForce(PVector force) {
    PVector f = PVector.div(force, radius);
    acceleration.add(f);
  }

  void collisionDetection(Mover other) {
    //distance between the movers, then its magnitude
    PVector distVect = PVector.sub(other.location, location);
    float distVectMag = distVect.mag();
    color cTemp;
    
    

    //collision detection
    if (distVectMag < radius + other.radius) {
      float angle = distVect.heading();
      float sine = sin(angle);
      float cosine = cos(angle);
//      cTemp = color(255,255,0);
//      
//      c1 = cTemp;
//      other.setColor(cTemp);

      //get the location of the mover relative to the other mover
      PVector[] locTemp = { 
        new PVector(), new PVector()
        };

        locTemp[1].x = cosine * distVect.x + sine * distVect.y;
      locTemp[1].y = cosine * distVect.y - sine * distVect.x;

      //rotate temporary velocities
      PVector[] velTemp = { 
        new PVector(), new PVector()
        };

        velTemp[0].x  = cosine * velocity.x + sine * velocity.y;
      velTemp[0].y  = cosine * velocity.y - sine * velocity.x;
      velTemp[1].x  = cosine * other.velocity.x + sine * other.velocity.y;
      velTemp[1].y  = cosine * other.velocity.y - sine * other.velocity.x;

      PVector[] velFinal = {
        new PVector(), new PVector()
        };

        //final rotated velocity for current mover
        velFinal[0].x = ((mass - other.mass) * velTemp[0].x + 2 * other.mass * velTemp[1].x) / (mass + other.mass);
      velFinal[0].y = velTemp[0].y;

      //final rotated velocity for other movers
      velFinal[1].x = ((other.mass - mass) * velTemp[1].x + 2 * mass * velTemp[0].x) / (mass + other.mass);
      velFinal[1].y = velTemp[1].y;

      //clumping hack
      locTemp[0].x += velFinal[0].x;
      locTemp[1].x += velFinal[1].x;

      //Un-rotate the mover locations and velocities
      PVector[] locFinal = {
        new PVector(), new PVector()
        };

        locFinal[0].x = cosine * locTemp[0].x - sine * locTemp[0].y;
      locFinal[0].y = cosine * locTemp[0].y + sine * locTemp[0].x;
      locFinal[1].x = cosine * locTemp[1].x - sine * locTemp[1].y;
      locFinal[1].y = cosine * locTemp[1].y + sine * locTemp[1].x;

      other.location.x = location.x + locFinal[1].x;
      other.location.y = location.y + locFinal[1].y;

      location.add(locFinal[0]);

      velocity.x = cosine * velFinal[0].x - sine * velFinal[0].y;
      velocity.y = cosine * velFinal[0].y + sine * velFinal[0].x;
      other.velocity.x = cosine * velFinal[1].x - sine * velFinal[1].y;
      other.velocity.y = cosine * velFinal[1].y + sine * velFinal[1].x;
    }
  }


  void checkEdges() {
    if (location.x < radius) {
      location.x = radius;
      velocity.x *= -1;
    }
    if (location.x > width - radius) {
      location.x = width - radius;
      velocity.x *= -1;
    }
    if (location.y < radius) {
      location.y = radius;
      velocity.y *= -1;
    }
    if (location.y > height - radius) {
      location.y = height - radius;
      velocity.y *= -1;
    }
  }
}

