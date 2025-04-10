class Igris extends Summon {
  float speed;
  // ArrayList para las distintas espadas que Igris puede usar
  ArrayList<PImage> swordImages;
  // ArrayList para las instancias de Sword (cuando se lanza una)
  ArrayList<Sword> swords;

  Igris(float x, float y) {
    this.imgNormal = loadImage("igris.png");
    this.imgNormal.resize((int)(imgNormal.width * 0.5), (int)(imgNormal.height * 0.5));

    this.imgBright = loadImage("igrisBright.png");
    this.imgBright.resize((int)(imgBright.width * 0.5), (int)(imgBright.height * 0.5));
    this.x = x;
    this.y = y;
    w = imgNormal.width;  // asumimos que normal y bright tienen mismas dims
    h = imgNormal.height;

    this.speed = 0.7;
    swords = new ArrayList<Sword>();
    swordImages = new ArrayList<PImage>();
    
    PImage sword1 = loadImage("sword.png");
    sword1.resize((int)(sword1.width * 0.1), (int)(sword1.height * 0.1));
    swordImages.add(sword1);
    
    sword1 = loadImage("sword1.png");
    sword1.resize((int)(sword1.width * 0.1), (int)(sword1.height * 0.1));
    swordImages.add(sword1);
    
  }

  void update() {
    // Movimiento horizontal con rebote
    x += speed;
    if (x < 0 || x > width - w) {
      speed = -speed;
    }
    // Actualizar espadas
    for (int i = swords.size()-1; i >= 0; i--) {
      Sword s = swords.get(i);
      s.update();
      if (s.x < -50 || s.x > width+50 || s.y < -50 || s.y > height+50) {
        swords.remove(i);
      }
    }
  }

  void display() {
    update();
    // Si el mouse está encima, dibujas la versión bright, si no, la normal
    tint(255, alpha);
    if (isMouseOver()) {
      image(imgBright, x, y);
    } else {
      image(imgNormal, x, y);
    }
    noTint();

    // Dibuja las espadas
    for (Sword s : swords) {
      s.display();
    }
  }

  // Sobrescribimos onClick() para que lance la espada
  void onClick() {
    // p.ej. lanza espada en dirección aleatoria
    PImage chosenSwordImg = swordImages.get((int)random(swordImages.size()));
    
    float sx = x + w/2;
    float sy = y + h/2;
    
    // Dirección aleatoria con preferencia hacia arriba
    float angle = random(-PI, 0); 
    float speed = random(3, 6); // velocidad variable

    float vx = cos(angle) * speed;
    float vy = sin(angle) * speed;
    // Requerimos la imagen de la espada en SummonSystem o global
    Sword newSword = new Sword(chosenSwordImg, sx, sy, vx, vy);
    swords.add(newSword);
  }
}

class Iron extends Summon {
  PImage img;
  float speed; // Velocidad horizontal
  
  int glowTimer = 0;

  Iron(float x, float y) {
    this.imgNormal = loadImage("iron.png");
    this.imgNormal.resize((int)(imgNormal.width * 0.5), (int)(imgNormal.height * 0.5));

    this.imgBright = loadImage("ironBright.png");
    this.imgBright.resize((int)(imgBright.width * 0.5), (int)(imgBright.height * 0.5));
    
    this.x = x;
    this.y = y;
    this.speed = -0.5; // Se desplaza hacia la izquierda
    this.w = imgNormal.width;
    this.h = imgNormal.height;

  }

  void update() {
    // Avanza horizontalmente a la izquierda
    x += speed;
    // Rebota si llega a los bordes
    if (x < 0 || x > width - w) {
      speed = -speed;
    }
  }

  void display() {
    update();
    tint(255, alpha);
    if (isMouseOver()) {
       image(imgBright, x, y);
    } else {
      image(imgNormal, x, y);
    }
    noTint();
    
  if (glowTimer > 0) {
    glowTimer--;
  
    float centerX = x + w / 2;
    float centerY = y + h / 2;
  
    float baseWidth = w * 1.2;
    float baseHeight = h * 1.6; // Más alto = forma ovalada
    float pulse = sin(frameCount * 0.2) * 10;
  
    for (int i = 0; i < 3; i++) {
      float wOval = baseWidth + i * 15 + pulse;
      float hOval = baseHeight + i * 20 + pulse * 1.2;
      float alpha = map(i, 0, 2, 80, 20);
      noFill();
      stroke(100, 200, 255, alpha);
      strokeWeight(2);
      ellipse(centerX, centerY, wOval, hOval);
    }
  
    // Núcleo del escudo
    noStroke();
    fill(100, 150, 255, 60);
    ellipse(centerX, centerY, baseWidth, baseHeight);
  }
  }
  
  void onClick()
  {
    glowTimer = 60;
  }
}

class Tank extends Summon {
  PImage img;
  ArrayList<ClawStrike> claws = new ArrayList<ClawStrike>();

  Tank(float x, float y) {
    this.imgNormal = loadImage("tank.png");
    this.imgNormal.resize((int)(imgNormal.width * 0.5), (int)(imgNormal.height * 0.5));

    this.imgBright = loadImage("tankBright.png");
    this.imgBright.resize((int)(imgBright.width * 0.5), (int)(imgBright.height * 0.5));
    this.x = x;
    this.y = y;
    this.w = imgNormal.width;  // asumimos que normal y bright tienen mismas dims
    this.h = imgNormal.height;
  }

  void update() {
    // El oso no se mueve; permanece estático
  }

  void display() {
    update();
    tint(255, alpha);
    if (isMouseOver()) {
    image(imgBright, x, y);
    } else {
      image(imgNormal, x, y);
    }
    noTint();
    for (int i = claws.size() - 1; i >= 0; i--) {
    claws.get(i).display();
    claws.get(i).update();
    if (claws.get(i).isFinished()) claws.remove(i);
  }
  }
  
  void onClick()
  {
     claws.add(new ClawStrike());
     claws.add(new ClawStrike());
     claws.add(new ClawStrike());
  }
}

class Tusk extends Summon {
  PImage img;
  float speedX, speedY;
  float groundY; // top del suelo
  
  ArrayList<FireBeam> beams = new ArrayList<FireBeam>();

  Tusk(float x, float y, float groundY) {
    this.imgNormal = loadImage("tusk.png");
    this.imgNormal.resize((int)(imgNormal.width * 0.5), (int)(imgNormal.height * 0.5));

    this.imgBright = loadImage("tuskBright.png");
    this.imgBright.resize((int)(imgBright.width * 0.5), (int)(imgBright.height * 0.5));
    this.x = x;
    this.y = y;
    this.groundY = groundY;
    // Se mueve en diagonal con distinta velocidad
    this.speedX = 0.4;
    this.speedY = 0.2;
    this.w = imgNormal.width;
    this.h = imgNormal.height;
  }

  void update() {
    
  }

  void display() {
    update();
    tint(255, alpha);
    if (isMouseOver()) {
    image(imgBright, x, y);
    } else {
      image(imgNormal, x, y);
    }
    noTint();
    for (int i = beams.size()-1; i >= 0; i--) {
    FireBeam b = beams.get(i);
    b.display();
    b.update();
    if (b.isFinished()) beams.remove(i);
  }
  }
  
   void onClick() {
    beams.add(new FireBeam(x + w/2, y));
    rain.makeRedRain();  // <- debe tener acceso a `rain` global
  }
}
