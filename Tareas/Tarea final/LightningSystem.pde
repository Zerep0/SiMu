class LightningSystem {
  ArrayList<Lightning> bolts;
  
  LightningSystem() {
    bolts = new ArrayList<Lightning>();
  }
  
  void updateAndDisplay() {
    // Genera un nuevo rayo si no hay ninguno activo, con baja probabilidad
    if (bolts.size() < 1 && random(1) < 0.005) {
      bolts.add(new Lightning());
    }
    
    // Actualiza y dibuja cada rayo; elimina los que hayan expirado
    for (int i = bolts.size()-1; i >= 0; i--) {
      Lightning l = bolts.get(i);
      l.update();
      l.display();
      if (l.isDead()) {
        bolts.remove(i);
      }
    }
  }
}

class Lightning {
  ArrayList<PVector> points;
  ArrayList<Lightning> branches;
  int lifespan;     // Duración del rayo principal (por ejemplo, 5 frames)
  int glowTimer;    // Tiempo adicional para el glow (por ejemplo, 10 frames)
  int branchDepth;
  
  // Constructor sin parámetros: se asigna una profundidad de bifurcación por defecto
  Lightning() {
    this(1);
  }
  
  // Constructor que permite definir la profundidad de bifurcación.
  Lightning(int branchDepth) {
    this.branchDepth = branchDepth;
    points = new ArrayList<PVector>();
    branches = new ArrayList<Lightning>();
    
    // El rayo puede empezar en cualquier parte del ancho
    float startX = random(width);
    PVector start = new PVector(startX, 0);
    points.add(start);
    
    // Genera entre 20 y 30 segmentos para un rayo más largo
    int segments = int(random(10, 20));
    PVector prev = start;
    for (int i = 0; i < segments; i++) {
      float nextX = prev.x + random(-20, 20);
      float nextY = prev.y + random(15, 40);
      PVector next = new PVector(nextX, nextY);
      points.add(next);
      prev = next;
      
      // Con probabilidad baja (10%), y si se permite bifurcación, se genera una rama
      if (branchDepth > 0 && random(1) < 0.1) {
        Lightning branch = new Lightning(branchDepth - 1);
        branch.points.set(0, prev.copy());
        branches.add(branch);
      }
      
      // Se detiene si ya nos acercamos al suelo
      if (prev.y > height - 80) break;
    }
    
    // La parte principal del rayo dura pocos frames
    lifespan = 5;
    // El glow permanecerá durante unos frames adicionales
    glowTimer = 10;
  }
  
  void update() {
    if (lifespan > 0) {
      lifespan--;
    } else if (glowTimer > 0) {
      glowTimer--;
    }
    // Actualiza las ramas
    for (int i = branches.size()-1; i >= 0; i--) {
      Lightning b = branches.get(i);
      b.update();
      if (b.isDead()) {
        branches.remove(i);
      }
    }
  }
  
  void display() {
    // Primero dibujamos el glow si aún está activo (aunque el rayo principal haya desaparecido)
    if (glowTimer > 0) {
      // Calcula una opacidad que decrece conforme el glow se desvanece
      float glowAlpha = map(glowTimer, 0, 10, 0, 140);
      stroke(255, 255, 255, glowAlpha);  // Blanco con opacidad variable
      strokeWeight(6);
      noFill();
      beginShape();
      for (PVector p : points) {
        vertex(p.x, p.y);
      }
      endShape();
    }
    
    // Luego, si aún está vivo el rayo principal, lo dibujamos en blanco brillante
    if (lifespan > 0) {
      stroke(255);
      strokeWeight(3);
      noFill();
      beginShape();
      for (PVector p : points) {
        vertex(p.x, p.y);
      }
      endShape();
    }
    
    // Dibujamos las ramas
    for (Lightning b : branches) {
      b.display();
    }
  }
  
  boolean isDead() {
    return (lifespan <= 0 && glowTimer <= 0);
  }
}
