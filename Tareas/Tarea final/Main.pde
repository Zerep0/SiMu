RainSystem rain;
Ground ground;
SungJinWoo sung;
LightningSystem lightning;
SummonSystem summonSystem;

PImage dialogo;
PImage guia;

void setup() {
  size(1000, 700);
  // Inicializa el sistema de lluvia
  rain = new RainSystem();
  ground = new Ground();
  
  float groundTop = height - ground.groundHeight; // Parte superior del suelo
  sung = new SungJinWoo(width/2, groundTop + 30);
  
  // Inicializa el sistema de rayos
  lightning = new LightningSystem();
  
  // sistema de invocación de sung jin woo
  summonSystem = new SummonSystem(sung);
  
  dialogo = loadImage("monologo1.png");
  dialogo.resize((int)(dialogo.width * 0.7), (int)(dialogo.height * 0.7));
  
  guia = loadImage("guia.png");
  guia.resize((int)(guia.width * 0.6), (int)(guia.height * 0.6));
  

}

void draw() {
  // Fondo oscuro para el cielo
  background(50);
  
  // Se ejecuta el sistema de lluvia (se extiende por todo el escenario)
  rain.run();
  
  // Se dibuja el suelo con césped oscuro en la parte inferior
  ground.display();
  
  // pintamos la luna
  pintarLuna();
  
  // Dibujamos a sung jin woo
  sung.display();
  
  // imprimimos el dialogo
  image(dialogo, sung.x - 20, sung.y + 160);
  
  // mostrar guia
  image(guia, 20, 20);
  
  // Actualiza y muestra los rayos (se dibujan sobre el resto de la escena)
  lightning.updateAndDisplay();
  
  // mostrar ejercito de sung jin woo
  summonSystem.display();

}

// Cuando se hace clic, comprobamos si está sobre Sung Jin Woo
void mousePressed() {
  if (sung.isMouseOver()) {
    summonSystem.toggleSummons();
  }
  
  // Delegar manejo de arrastre para Beru:
  summonSystem.handleMousePressed();
}

void mouseDragged() {
  summonSystem.handleMouseDragged();
}

void mouseReleased() {
  summonSystem.handleMouseReleased();
}

void pintarLuna()
{
    noStroke();
  // Dibujamos el glow: elipses concéntricas con mayor radio y opacidad decreciente
  for (int r = 110; r <= 150; r += 10) {
    // Mapear la opacidad: cuanto más grande el radio, menor la opacidad.
    // Ajustamos los valores de mapeo para este rango.
    float alpha = map(r, 110, 150, 50, 0);
    fill(255, 200, 100, alpha);
    ellipse(700, 200, r, r);
  }
  
  // Dibujamos la elipse principal (luz amarilla clara)
  fill(255, 200, 100);
  ellipse(700, 200, 100, 100);
}
