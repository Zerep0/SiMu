class RainSystem {
  ArrayList<RainParticle> particles;
  float spawnRate = 0.5; // Probabilidad de generar una gota cada frame (baja intensidad)

  RainSystem() {
    particles = new ArrayList<RainParticle>();
  }
  
  void run() {
    // Cada frame, con cierta probabilidad, se agrega una nueva gota en una posición aleatoria en la parte superior
    if (random(1) < spawnRate) {
      particles.add(new RainParticle(new PVector(random(width), -10)));
    }
    
    // Se actualizan y dibujan las partículas, eliminando las que han salido de la pantalla
    for (int i = particles.size()-1; i >= 0; i--) {
      RainParticle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}
