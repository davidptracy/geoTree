Mover[] movers;

void setup() {
  size(1000, 500);
  background(255);
  ellipseMode(RADIUS);
  movers = new Mover[200];
  for (int i=0; i<movers.length; i++) {
    movers[i] = new Mover();
  }
}

void draw() {

  noStroke();
  fill(255, 10);
  rect(0, 0, width, height);

  PVector gravity = new PVector(0, 800);
  PVector wind = new PVector(random(800), 0);  
  PVector mouse = new PVector(mouseX, mouseY);

  //friction

  for (Mover m : movers) {

    PVector dir = PVector.sub(mouse, m.location);
    dir.normalize();
    dir.mult(10);

    m.update();
    m.display();
    m.checkEdges();
    //    m.applyForce(gravity);
    m.applyForce(dir);

//    if (m.location.y > height/2) { 
//
//      PVector drag = m.velocity.get();
//      drag.normalize();
//
//      float c = -30;
//      float speed = m.velocity.mag();
//      
//      drag.mult(c*speed*speed);
//      m.applyForce(drag);
//    }


    if (mousePressed) {
      m.applyForce(wind);
    }
  }

  for (int i=0; i < movers.length; i++) {
    for (int j=0; j < movers.length; j++) {
      if ( movers[i] == movers[j]) { 
        continue;
      }      
      movers[i].collisionDetection(movers[j]);
    }
  }
}

