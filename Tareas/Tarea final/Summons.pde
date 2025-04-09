class Igris extends Summon {
  PImage img;
  float x, y;
  float speed;  // Velocidad horizontal
  float w, h;   // Para conocer el tamaño de su sprite

  Igris(PImage img, float x, float y) {
    this.img = img;
    this.x = x;
    this.y = y;
    this.speed = 0.7; // Se desplaza a la derecha
    w = img.width;
    h = img.height;
  }

  void update() {
    // Avanza horizontalmente
    x += speed;
    // Rebota si llega a los bordes
    if (x < 0 || x > width - w) {
      speed = -speed; // invierte dirección
    }
  }

  void display() {
    update();
    tint(255, alpha);
    image(img, x, y);
    noTint();
  }
}

class Iron extends Summon {
  PImage img;
  float x, y;
  float speed; // Velocidad horizontal
  float w, h;

  Iron(PImage img, float x, float y) {
    this.img = img;
    this.x = x;
    this.y = y;
    this.speed = -0.5; // Se desplaza hacia la izquierda
    w = img.width;
    h = img.height;
  }

  void update() {
    // Avanza horizontalmente a la izquierda
    x += speed;
    // Rebota si llega a los bordes
    if (x < 0 || x > width - w) {
      speed = -speed;
    }
  }

  void display() {
    update();
    tint(255, alpha);
    image(img, x, y);
    noTint();
  }
}

class Tank extends Summon {
  PImage img;
  float x, y;

  Tank(PImage img, float x, float y) {
    this.img = img;
    this.x = x;
    this.y = y;
  }

  void update() {
    // El oso no se mueve; permanece estático
  }

  void display() {
    update();
    tint(255, alpha);
    image(img, x, y);
    noTint();
  }
}

class Tusk extends Summon {
  PImage img;
  float x, y;
  float speedX, speedY;
  float w, h;
  float groundY; // top del suelo

  Tusk(PImage img, float x, float y, float groundY) {
    this.img = img;
    this.x = x;
    this.y = y;
    this.groundY = groundY;
    // Se mueve en diagonal con distinta velocidad
    this.speedX = 0.4;
    this.speedY = 0.2;
    w = img.width;
    h = img.height;
  }

  void update() {
    x += speedX;
    y += speedY;

    // Rebote lateral
    if (x < 0) {
      x = 0;
      speedX = -speedX;
    } else if (x > width - w) {
      x = width - w;
      speedX = -speedX;
    }

    // Rebote arriba
    if (y < 0) {
      y = 0;
      speedY = -speedY;
    }
    // Rebote en la tierra
    else if (y + h < groundY + 5) {
      y = groundY - h;
      speedY = -speedY;
    }
    else if(y + h >= height)
    {speedY = -speedY;}
    
  }

  void display() {
    update();
    tint(255, alpha);
    image(img, x, y);
    noTint();
  }
}
