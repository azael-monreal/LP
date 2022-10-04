class Ball {
  PVector position;
  PVector velocity;

  float radius, m;

  color c;

  Ball(float x, float y, float r_) {
    this.position = new PVector(x, y);
    this.velocity = PVector.random2D();
    this.velocity.mult(8);
    this.radius = r_;
    this.m = radius*.1;
    this.c = randomColor();
  }

  void update() {
    position.add(velocity);
  }

  void checkBoundaryCollision() {
    if (position.x > width-radius) {
      position.x = width-radius;
      velocity.x *= -1;
    } else if (position.x < radius) {
      position.x = radius;
      velocity.x *= -1;
    } else if (position.y > height-radius) {
      position.y = height-radius;
      velocity.y *= -1;
    } else if (position.y < radius) {
      position.y = radius;
      velocity.y *= -1;
    }
  }

  void checkCollision(Ball other) {

    PVector distanceVect = PVector.sub(other.position, this.position);
    float distanceVectMag = distanceVect.mag();
    float minDistance = this.radius + other.radius;

    if (distanceVectMag < minDistance) {

      float distanceCorrection = (minDistance-distanceVectMag)/2.0;
      PVector d = distanceVect.copy();
      PVector correctionVector = d.normalize().mult(distanceCorrection);
      other.position.add(correctionVector);
      this.position.sub(correctionVector);

      float theta  = distanceVect.heading();
      float sine = sin(theta);
      float cosine = cos(theta);

      PVector[] bTemp = { new PVector(), new PVector() };

      bTemp[1].x  = cosine * distanceVect.x + sine * distanceVect.y;
      bTemp[1].y  = cosine * distanceVect.y - sine * distanceVect.x;

      PVector[] vTemp = { new PVector(), new PVector() };

      vTemp[0].x  = cosine * this.velocity.x + sine * this.velocity.y;
      vTemp[0].y  = cosine * this.velocity.y - sine * this.velocity.x;
      vTemp[1].x  = cosine * other.velocity.x + sine * other.velocity.y;
      vTemp[1].y  = cosine * other.velocity.y - sine * other.velocity.x;

      PVector[] vFinal = {  new PVector(), new PVector() };

      vFinal[0].x = ((this.m - other.m) * vTemp[0].x + 2 * other.m * vTemp[1].x) / (this.m + other.m);
      vFinal[0].y = vTemp[0].y;

      vFinal[1].x = ((other.m - this.m) * vTemp[1].x + 2 * this.m * vTemp[0].x) / (this.m + other.m);
      vFinal[1].y = vTemp[1].y;

      bTemp[0].x += vFinal[0].x;
      bTemp[1].x += vFinal[1].x;

      PVector[] bFinal = { new PVector(), new PVector() };

      bFinal[0].x = cosine * bTemp[0].x - sine * bTemp[0].y;
      bFinal[0].y = cosine * bTemp[0].y + sine * bTemp[0].x;
      bFinal[1].x = cosine * bTemp[1].x - sine * bTemp[1].y;
      bFinal[1].y = cosine * bTemp[1].y + sine * bTemp[1].x;

      other.position = this.position.copy().add(bFinal[1]);

      this.position.add(bFinal[0]);

      this.velocity.x = cosine * vFinal[0].x - sine * vFinal[0].y;
      this.velocity.y = cosine * vFinal[0].y + sine * vFinal[0].x;
      other.velocity.x = cosine * vFinal[1].x - sine * vFinal[1].y;
      other.velocity.y = cosine * vFinal[1].y + sine * vFinal[1].x;

      this.c = randomColor();
      other.c = randomColor();

      this.radius *= .9;
      other.radius *= .9;

      this.m = this.radius*.1;
      other.m = other.radius*.1;
    }
  }

  void display() {

    noStroke();
    fill(c);
    ellipse(position.x, position.y, radius*2, radius*2);

    textAlign(CENTER, CENTER);
    fill(255);
    textSize(30);
    //text(nf(radius, 0, 2), position.x, position.y);
  }
}
