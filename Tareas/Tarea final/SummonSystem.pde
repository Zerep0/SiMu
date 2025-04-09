class SummonSystem {
  String[] summonFiles = { "igris.png", "iron.png", "tank.png", "tusk.png" };
  float scaleFactor = 0.5;
  PImage[] summonImages;

  ArrayList<Summon> activeSummons;
  float[] offsets = { -250, -125, 150, 275 };

  SungJinWoo sung;
  boolean active = false;
  boolean fading = false;
  float fadeSpeed = 3;

  SummonSystem(SungJinWoo sung) {
    this.sung = sung;
    summonImages = new PImage[summonFiles.length];
    for (int i = 0; i < summonFiles.length; i++) {
      summonImages[i] = loadImage(summonFiles[i]);
      summonImages[i].resize((int)(summonImages[i].width * scaleFactor), (int)(summonImages[i].height * scaleFactor));
    }
    activeSummons = new ArrayList<Summon>();
  }

  void invokeAll() {
    float[] shuffled = offsets.clone();
    for (int i = 0; i < shuffled.length; i++) {
      int r = (int) random(i, shuffled.length);
      float temp = shuffled[i];
      shuffled[i] = shuffled[r];
      shuffled[r] = temp;
    }

    activeSummons.clear();
    activeSummons.add(new Igris(summonImages[0], sung.x + shuffled[0], sung.y + 20));
    activeSummons.add(new Iron(summonImages[1], sung.x + shuffled[1], sung.y + 20));
    activeSummons.add(new Tank(summonImages[2], sung.x + shuffled[2], sung.y + 20));
    float groundY = height - ground.groundHeight;
    activeSummons.add(new Tusk(summonImages[3], sung.x + shuffled[3], sung.y + 20, groundY));
    activeSummons.add(new Beru(sung.x, sung.y - 200));
  }

  void toggleSummons() {
    if (active) {
      fading = true;
      active = false;
    } else {
      invokeAll();
      active = true;
      fading = false;
    }
  }

  void updateFade() {
    if (fading) {
      for (int i = activeSummons.size() - 1; i >= 0; i--) {
        Summon s = activeSummons.get(i);
        s.startFade(fadeSpeed);
        if (s.isFaded()) {
          activeSummons.remove(i);
        }
      }
      if (activeSummons.isEmpty()) {
        fading = false;
      }
    }
  }

  void display() {
    updateFade();
    for (Summon s : activeSummons) {
      s.display();
    }
  }

  void handleMousePressed() {
    for (Summon s : activeSummons) {
      if (s instanceof Beru && ((Beru)s).isMouseOver()) {
        ((Beru)s).startDrag();
      }
    }
  }

  void handleMouseDragged() {
    for (Summon s : activeSummons) {
      if (s instanceof Beru) {
        ((Beru)s).drag();
      }
    }
  }

  void handleMouseReleased() {
    for (Summon s : activeSummons) {
      if (s instanceof Beru) {
        ((Beru)s).stopDrag();
      }
    }
  }
}

// Clase base: Summon
abstract class Summon {
  float alpha = 255;

  abstract void update();
  abstract void display();

  void startFade(float speed) {
    alpha -= speed;
    if (alpha < 0) alpha = 0;
  }

  boolean isFaded() {
    return alpha <= 0;
  }
}
