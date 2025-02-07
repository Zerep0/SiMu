Slider s, r, t;

void setup() {
  size(400, 400);
  s = new Slider(100, 250, 200, 50); // Slider para el ángulo de las cejas
  r = new Slider(100, 280, 200, 50); // Slider para el color de la cara
  t = new Slider(100, 310, 200, 50); // Slider para la posición de la boca
}

void draw() {
  background(255);
  
  // Obtener valores de los sliders
  float cejaAngulo = map(s.getValor(), 1, 100, -PI/4, PI/4);
  float colorValor = constrain(r.getValor(), 1, 100);

  
  // Interpolación de colores (amarillo -> azul -> rojo)
  float rColor, gColor, bColor;
  if (colorValor <= 50) {
    rColor = map(colorValor, 0, 50, 255, 0);
    gColor = map(colorValor, 0, 50, 255, 0);
    bColor = map(colorValor, 0, 50, 0, 255);
  } else {
    rColor = map(colorValor, 50, 100, 0, 255);
    gColor = 0;
    bColor = map(colorValor, 50, 100, 255, 0);
  }
  
  // Dibujar la cara
  stroke(1);
  fill(rColor, gColor, bColor);
  ellipse(200, 150, 150, 150);
  
  // Ojos
  fill(255);
  ellipse(180, 150, 40, 40);
  ellipse(220, 150, 40, 40);
  fill(0);
  ellipse(180, 150, 10, 10);
  ellipse(220, 150, 10, 10);
  
  // Cejas con ángulo más pronunciado
  stroke(0);
  strokeWeight(3);
  line(165, 100 + tan(cejaAngulo) * 10, 195, 100 - tan(cejaAngulo) * 10);
  line(205, 100 - tan(cejaAngulo) * 10, 235, 100 + tan(cejaAngulo) * 10);
  

  
  // Dibujar sliders
  s.dibujar();
  r.dibujar();
  t.dibujar();
}
