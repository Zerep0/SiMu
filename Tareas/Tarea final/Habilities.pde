class Sword extends Summon {
  PImage img;             // Imagen de la espada
  float x, y;             // Posición actual (esquina sup. izq. para referencia)
  float w, h;             // Dimensiones de la imagen
  float speedX, speedY;   // Velocidad lineal
  float angle;            // Ángulo de rotación
  float angularVel;       // Velocidad de rotación

  // Para el rastro de la espada
  ArrayList<PVector> trail;
  int maxTrail = 15; // Cuántos puntos guarda el rastro

  Sword(PImage img, float startX, float startY, float vx, float vy) {
    this.img = img;
    this.x = startX;
    this.y = startY;
    this.speedX = vx;
    this.speedY = vy;

    this.w = img.width;
    this.h = img.height;

    // Ángulo inicial y velocidad angular
    this.angle = 0;
    this.angularVel = 0.1;

    // Inicializa la lista para el rastro
    trail = new ArrayList<PVector>();
  }

  void update() {
    // Mueve la espada
    x += speedX;
    y += speedY;

    // Gira la espada
    angle += angularVel;

    // Agrega un punto al trail (usa el centro de la espada para el rastro)
    trail.add(new PVector(x + w/2, y + h/2));
    // Si se excede la longitud máxima, elimina el más antiguo
    if (trail.size() > maxTrail) {
      trail.remove(0);
    }

    // Si quieres eliminarla cuando salga de pantalla:
     if (x < -100 || x > width+100 || y < -100 || y > height+100) {
      alpha = 0; // se desvanece
     }
  }

  void display() {
    update();
    // Dibuja el rastro con una línea
    noFill();
    stroke(0, 255, 255, 80); // un color cian translúcido
    strokeWeight(3);
    beginShape();
    for (PVector p : trail) {
      vertex(p.x, p.y);
    }
    endShape();

    // Dibuja la espada rotada en su centro
    pushMatrix();
    translate(x + w/2, y + h/2);
    rotate(angle);
    tint(255, alpha);
    image(img, -w/2, -h/2);
    noTint();
    popMatrix();
  }
}

class FireBeam {
  float x, y;
  int duration = 30;  // frames que dura

  FireBeam(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void update() {
    duration--;
  }

  void display() {
    pushMatrix();
    translate(x, y);
    noStroke();
    for (int i = 0; i < 100; i++) {
      float w = random(8, 30);  // mayor grosor
      float h = random(30, 60); // más altura
      float ox = random(-20, 20);
      float oy = -i * 35;
      color intenseRed = color(255, 0, 0);
      color brightYellow = color(255, 255, 200);
      fill(lerpColor(intenseRed, brightYellow, random(1)), 180);
      ellipse(ox, oy, w, h);
    }
    popMatrix();
  }

  boolean isFinished() {
    return duration <= 0;
  }
}

class ClawStrike {
  PImage img;
  PVector pos;
  float angle;
  int duration = 40;

  ClawStrike() {
    // Carga aleatoria de una de las tres garras
    int choice = (int)random(3);
    if (choice == 0) img = loadImage("garra1.png");
    else if (choice == 1) img = loadImage("garra2.png");
    else img = loadImage("garra3.png");

    img.resize((int)(img.width * 0.5), (int)(img.height * 0.5));

    // Posición aleatoria en pantalla
    float x = random(200, width - 200);
    float y = random(100, height - 200);
    pos = new PVector(x, y);

    // Ángulo aleatorio
    angle = random(-PI / 8, PI / 8);
  }

  void update() {
    duration--;
  }

  void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(angle);
    tint(255, map(duration, 0, 40, 0, 255));
    image(img, 0, 0);
    noTint();
    popMatrix();
  }

  boolean isFinished() {
    return duration <= 0;
  }
}
