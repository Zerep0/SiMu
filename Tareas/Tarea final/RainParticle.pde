class RainParticle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  
  RainParticle(PVector loc) {
    location = loc.copy();
    // Aceleración suave hacia abajo (gravidez ligera)
    acceleration = new PVector(0, 0.05);
    // Velocidad inicial moderada para un efecto de lluvia ligera
    velocity = new PVector(0, random(2, 4));
  }
  
  void run() {
    update();
    display();
  }
  
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
  }
  
  void display() {
    stroke(0, 150, 255, 200);  // Color azul con algo de transparencia
    strokeWeight(2);
    // Se dibuja una línea corta que simula una gota de lluvia
    line(location.x, location.y, location.x, location.y + 10);
  }
  
  // La gota se considera "muerta" si sale de la pantalla
  boolean isDead() {
    return location.y > height + 10;
  }
}
