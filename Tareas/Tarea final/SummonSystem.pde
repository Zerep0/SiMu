class SummonSystem {

  float scaleFactor = 0.5;


  ArrayList<Summon> activeSummons;
  float[] offsets = { -250, -125, 150, 275 };

  SungJinWoo sung;
  boolean active = false;
  boolean fading = false;
  float fadeSpeed = 3;

  SummonSystem(SungJinWoo sung) {
    this.sung = sung;
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
    activeSummons.add(new Igris(sung.x + shuffled[0], sung.y + 20));
    activeSummons.add(new Iron(sung.x + shuffled[1], sung.y + 20));
    activeSummons.add(new Tank(sung.x + shuffled[2], sung.y + 20));
    float groundY = height - ground.groundHeight;
    activeSummons.add(new Tusk(sung.x + shuffled[3], sung.y + 20, groundY));
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
      if (s.isMouseOver()) {
        s.onClick();  // Ejecuta la habilidad de cada Summon que esté bajo el mouse
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
  PImage imgNormal;   // Versión normal
  PImage imgBright;   // Versión con brillo
  float x, y;         // Posición
  float w, h;         // Tamaño

  // Actualiza el estado interno (movimiento, etc.)
  abstract void update();

  // La mayoría de la lógica de display estará en la clase concreta, pero
  // si quieres un display base, puedes hacerlo también
  abstract void display();

  // Efecto fade (ya lo tenías)
  void startFade(float speed) {
    alpha -= speed;
    if (alpha < 0) alpha = 0;
  }

  boolean isFaded() {
    return alpha <= 0;
  }

  // Método para detectar si el mouse está dentro (simple bounding box)
  boolean isMouseOver() {
    return (mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h);
  }

  // Al hacer clic sobre el personaje, lanzará su habilidad
  // (sobrescribe en cada clase concreta si quieres distinto comportamiento)
  void onClick() {
    // Por defecto, no hace nada
  }
}
