public RainSystem rain;
Ground ground;
SungJinWoo sung;
LightningSystem lightning;
SummonSystem summonSystem;

PImage dialogo;
PImage dialogo1;
PImage guia;

void setup() {
  size(1000, 720);
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
  
  dialogo1 = loadImage("monologo2.png");
  dialogo1.resize((int)(dialogo1.width * 0.7), (int)(dialogo1.height * 0.7));
  
  guia = loadImage("guia.png");
  guia.resize((int)(guia.width * 0.7), (int)(guia.height * 0.7));
  

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
  if (summonSystem.active) {
    image(dialogo1, sung.x - 20, sung.y + 160);
  } else {
    image(dialogo, sung.x - 20, sung.y + 160);
  }
  
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
  
  // Delegar manejo de arrastre
  summonSystem.handleMousePressed();
}

void mouseDragged() {
  summonSystem.handleMouseDragged();
}

void mouseReleased() {
  summonSystem.handleMouseReleased();
}

float lunaLatido = 0;
boolean lunaExpande = true;

void pintarLuna() {
  noStroke();
  float centerX = 700;
  float centerY = 200;

  // Latido más suave y lento
  float latidoVelocidad = 0.1;  // más lento
  float latidoMax = 6;

  if (lunaExpande) {
    lunaLatido += latidoVelocidad;
    if (lunaLatido > latidoMax) lunaExpande = false;
  } else {
    lunaLatido -= latidoVelocidad;
    if (lunaLatido < -latidoMax) lunaExpande = true;
  }

  // Glow dinámico, suave
  for (int r = 110; r <= 150; r += 10) {
    float alpha = map(r, 110, 150, 50, 0);
    fill(255, 220, 150, alpha + random(-5, 5));  // ligera variación
    ellipse(centerX, centerY, r + lunaLatido, r + lunaLatido);
  }

  // Núcleo de la luna
  fill(255, 240, 180);
  ellipse(centerX, centerY, 100 + lunaLatido * 0.4, 100 + lunaLatido * 0.4);
}
