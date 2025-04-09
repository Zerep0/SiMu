class Sword extends Summon {
  PImage img;
  float x, y;
  float speedX, speedY;
  float w, h;

  Sword(PImage img, float startX, float startY, float vx, float vy) {
    this.img = img;
    this.x = startX;
    this.y = startY;
    this.speedX = vx; // velocidad horizontal
    this.speedY = vy; // velocidad vertical
    w = img.width;
    h = img.height;
  }

  void update() {
    x += speedX;
    y += speedY;
    // Podrías añadirle colisión con bordes o un fade tras cierto tiempo
  }

  void display() {
    update();
    tint(255, alpha);
    image(img, x, y);
    noTint();
  }
}
