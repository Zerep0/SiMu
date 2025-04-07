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
