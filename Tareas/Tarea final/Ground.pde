class Ground {
  float groundHeight;
  ArrayList<Grass> grassBlades;
  
  Ground() {
    groundHeight = 80;  // Altura del suelo
    grassBlades = new ArrayList<Grass>();
    // Genera un número aleatorio de briznas de césped entre 50 y 150
    int numGrass = int(random(50, 150));
    for (int i = 0; i < numGrass; i++) {
      float x = random(width);
      float baseY = height - groundHeight;
      float h = random(10, 25);
      grassBlades.add(new Grass(x, baseY, h));
    }
  }
  
  void display() {
    // Dibuja la base del suelo: un rectángulo negro en la parte inferior
    noStroke();
    fill(0);
    rect(0, height - groundHeight, width, groundHeight);
    
    // Dibuja cada brizna de césped, actualizándola para generar un movimiento suave
    stroke(20);
    for (Grass g : grassBlades) {
      g.update();
      g.display();
    }
  }
}

class Grass {
  float x;
  float baseY;
  float height;
  float swayPhase;
  float swayAmplitude;
  float swaySpeed;
  
  Grass(float x, float baseY, float height) {
    this.x = x;
    this.baseY = baseY;
    this.height = height;
    // Fase inicial aleatoria para variar el movimiento entre las briznas
    swayPhase = random(TWO_PI);
    // Amplitud de oscilación entre 1 y 3 píxeles
    swayAmplitude = random(1, 5);
    // Velocidad muy lenta para una oscilación suave
    swaySpeed = random(0.01, 0.05);
  }
  
  void update() {
    swayPhase += swaySpeed;
  }
  
  void display() {
    // Usa sin() para calcular el desplazamiento horizontal; 
    // si prefieres, puedes cambiar a cos() para una variación diferente:
    float sway = sin(swayPhase) * swayAmplitude;
    line(x, baseY, x + sway, baseY - height);
  }
}
