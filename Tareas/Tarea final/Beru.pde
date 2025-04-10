class Beru extends Summon {
  PImage img;
  float baseX, baseY;
  float x, y;
  float rotation;

  float noiseOffsetX, noiseOffsetY;
  float time;

  float circleRadius;
  float circleSpeed;

  boolean dragging = false;
  float dragOffsetX, dragOffsetY;

  float manualRotation = 0;
  float controlTransition;

  float w, h;

  Beru(float startX, float startY) {
    img = loadImage("beru.png");
    float scaleFactor = 0.5;
    img.resize((int)(img.width * scaleFactor), (int)(img.height * scaleFactor));

    w = img.width;
    h = img.height;

    baseX = startX;
    baseY = startY;
    x = baseX;
    y = baseY;

    time = 0;
    noiseOffsetX = random(1000);
    noiseOffsetY = random(1000);

    circleRadius = 20;
    circleSpeed = 0.05;

    rotation = 0;
    controlTransition = 1;
  }

  boolean isMouseOver() {
    return (mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h);
  }

  void handleKeyboard() {
    if (keyPressed) {
      if (key == 'w' || key == 'W') baseY -= 3;
      if (key == 's' || key == 'S') baseY += 3;
      if (key == 'a' || key == 'A') baseX -= 3;
      if (key == 'd' || key == 'D') baseX += 3;
      if (keyCode == LEFT) manualRotation -= 0.04;
      if (keyCode == RIGHT) manualRotation += 0.04;

      manualRotation = manualRotation % TWO_PI;
      baseX = constrain(baseX, 0, width - w);
      baseY = constrain(baseY, 0, height - h);
    }
  }

  void startDrag() {
    if (isMouseOver()) {
      dragging = true;
      dragOffsetX = mouseX - baseX;
      dragOffsetY = mouseY - baseY;
    }
  }

  void drag() {
    if (dragging) {
      baseX = mouseX - dragOffsetX;
      baseY = mouseY - dragOffsetY;
    }
  }

  void stopDrag() {
    dragging = false;
  }

  void update() {
    if (dragging) {
      baseX = constrain(mouseX - dragOffsetX, 0, width - w);
      baseY = constrain(mouseY - dragOffsetY, 0, height - h);
      x = baseX;
      y = baseY;
      controlTransition = 0;
    } else {
      boolean movingKeys = keyPressed &&
        ((key == 'w' || key == 'W') || (key == 'a' || key == 'A') ||
         (key == 's' || key == 'S') || (key == 'd' || key == 'D') ||
         (keyCode == LEFT) || (keyCode == RIGHT));
      if (movingKeys) {
        handleKeyboard();
        controlTransition = 0;
      } else {
        controlTransition = lerp(controlTransition, 1, 0.01);
      }

      time += 0.01;
      float noiseX = map(noise(noiseOffsetX, time), 0, 1, -30, 30);
      float noiseY = map(noise(noiseOffsetY, time), 0, 1, -15, 15);
      float circX = circleRadius * cos(time * circleSpeed * TWO_PI);
      float circY = circleRadius * sin(time * circleSpeed * TWO_PI);
      x = baseX + controlTransition * (noiseX + circX);
      y = baseY + controlTransition * (noiseY + circY);

      float noiseRot = map(noise(noiseOffsetX, time * 1.5), 0, 1, -PI/8, PI/8);
      float autoRotation = constrain(noiseRot * controlTransition, -PI/4, PI/4);
      rotation = autoRotation + manualRotation;
    }
  }

  void display() {
    update();
    pushMatrix();
    translate(x + w/2, y + h/2);
    rotate(rotation);
    tint(255, alpha);
    image(img, -w/2, -h/2);
    noTint();
    popMatrix();
  }
}
