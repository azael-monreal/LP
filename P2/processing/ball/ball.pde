ArrayList<Ball> balls = new ArrayList<Ball>();

void settings() {
  size(min(displayWidth, 1920) ,min(displayHeight,1080));
}

void draw() {
  background(51);
  
  int bsize = balls.size();
  
  fill(255);
  textSize(100);
  textAlign(CENTER, CENTER);
  text(str(bsize), width/2, height/2);

  if (balls.size() > 0) {
    for (Ball b : balls) {
      b.update();
      b.display();
      b.checkBoundaryCollision();
    }

    for (int i = 0; i<bsize-1; i++)
    {
      for (int j = i+1; j<bsize; j++)
      {
        if (balls.get(i).radius < 10) {
          balls.remove(i);
          bsize-=1;
          continue;
        }
        balls.get(i).checkCollision(balls.get(j));
      }
    }
  }
  
}

void mouseClicked() {
  addB();
}


color randomColor() {
  return color(random(255), random(255), random(255));
}

void addB() {
  float x = mouseX;
  float y = mouseY;
  float r = random(50, 100);

  r = maxSpace(x, y, r);
  if (r>50)
    balls.add(new Ball(x, y, r));
}

float maxSpace(float x, float y, float r) {
  float max = r;
  PVector pos = new PVector(x, y);
  for (Ball b : balls) {
    float dist = b.position.dist(pos);
    if (dist <= (b.radius+max+30)) {
      max = dist-10;
    }
  }
  return max;
}
