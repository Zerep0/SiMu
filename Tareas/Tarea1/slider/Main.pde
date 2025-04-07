Slider s, r, t;

void setup() {
  size(400, 400);
  s = new Slider(100, 250, 200, 50); // Slider para el ángulo de las cejas
  r = new Slider(100, 280, 200, 50); // Slider para el color de la cara
  t = new Slider(100, 310, 200, 50); // Slider para la posición de la boca
}

void draw() {
  background(255);
  
  // Dibujar sliders
  s.dibujar();
  r.dibujar();
  t.dibujar();
  
  // Obtener valores de los sliders, Quiero que vaya de -45 grados a 45 grados
  float cejaAngulo = map(s.getValor(), 1, 100, -PI/4, PI/4);
  float colorValor = constrain(r.getValor(), 1, 100);
  float gestoBoca = map(t.getValor(), 1, 100, -15, 15); // -15 (triste) a 15 (feliz)

  
  // Interpolación de colores (amarillo -> azul -> rojo)
  float rColor, gColor, bColor;
  // Si colorValor es menor o igual a 50, el color cambia de amarillo (255,255,0) a azul (0,0,255).
  if (colorValor <= 50) {
    rColor = map(colorValor, 0, 50, 255, 0);
    gColor = map(colorValor, 0, 50, 255, 0);
    bColor = map(colorValor, 0, 50, 0, 255);
  } else {
    // Mayor a 50, cambia de azul a rojo (255,0,0).
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
  line(165, 120 + tan(cejaAngulo) * 10, 195, 120 - tan(cejaAngulo) * 10);
  line(205, 120 - tan(cejaAngulo) * 10, 235, 120 + tan(cejaAngulo) * 10);
  
  // Boca
  float x1 = 170, y1 = 190; // Extremo izquierdo (fijo)
  float x3 = 230, y3 = 190; // Extremo derecho (fijo)
  float x2 = 200, y2 = 190 + gestoBoca; // Punto medio (se mueve según el slider)

  beginShape();
  curveVertex(x1, y1); 
  curveVertex(x1, y1); // Extremo izquierdo
  curveVertex(x2, y2); // Punto medio (se mueve con el slider)
  curveVertex(x3, y3); // Extremo derecho
  curveVertex(x3, y3); 
  endShape();
}
