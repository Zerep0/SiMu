Slider s, r, t;

void setup() {
  size(400, 400);
  s = new Slider(50, 250, 200); // Slider para el ángulo de las cejas
  r = new Slider(50, 280, 200); // Slider para el color de la cara
  t = new Slider(50, 310, 200); // Slider para la posición de la boca
}

void draw() {
  background(255);
  
  // Obtener valores de los sliders
  float cejaAngulo = map(s.getValor(), 1, 100, -PI/4, PI/4);
  float colorCara = map(r.getValor(), 1, 100, 100, 255);
  float bocaPos = map(t.getValor(), 1, 100, 160, 200);
  
  // Dibujar la cara
  fill(colorCara, colorCara, 0);
  ellipse(200, 150, 150, 150);
  
  // Ojos
  fill(255);
  ellipse(180, 130, 30, 30);
  ellipse(220, 130, 30, 30);
  fill(0);
  ellipse(185, 130, 10, 10);
  ellipse(225, 130, 10, 10);
  
  // Cejas con ángulo más pronunciado
  stroke(0);
  strokeWeight(3);
  line(165, 110 + tan(cejaAngulo) * 10, 195, 110 - tan(cejaAngulo) * 10);
  line(205, 110 - tan(cejaAngulo) * 10, 235, 110 + tan(cejaAngulo) * 10);
  
  // Boca más abajo
  noFill();
  strokeWeight(2);
  arc(200, bocaPos, 40, 20, 0, PI);
  
  // Dibujar sliders
  s.dibujar();
  r.dibujar();
  t.dibujar();
}
