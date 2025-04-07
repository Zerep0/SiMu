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
