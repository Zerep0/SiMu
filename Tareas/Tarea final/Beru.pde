class Beru {
  PImage img;
  float baseX, baseY;  // Posición base (se actualiza con arrastre o teclado)
  float x, y;          // Posición actual calculada
  float rotation;      // Rotación final
  
  // Variables para movimiento con noise
  float noiseOffsetX, noiseOffsetY;
  float time;
  
  // Parámetros para movimiento circular
  float circleRadius;
  float circleSpeed;
  
  // Variables para arrastre
  boolean dragging = false;
  float dragOffsetX, dragOffsetY;
  
  // Variable para control manual de rotación
  float manualRotation = 0;
  
  // Variable de transición para mezclar el movimiento directo (con teclado) y el efecto natural
  // 0: se usa solo el control directo; 1: se usa el efecto completo (noise+circular)
  float controlTransition;
  
  // Ancho y alto de la imagen
  float w, h;
  
  // Variables para fade
  float alpha;         // Opacidad actual (255 = completamente opaco)
  boolean fading;      // Indica si se está haciendo fade
  
  Beru(float startX, float startY) {
    img = loadImage("beru.png");
    float scaleFactor = 0.5;
    img.resize((int)(img.width * scaleFactor), (int)(img.height * scaleFactor));
    
    w = img.width;
    h = img.height;
    
    baseX = startX;
    baseY = startY;
    x = baseX;
    y = baseY;
    
    time = 0;
    noiseOffsetX = random(1000);
    noiseOffsetY = random(1000);
    
    circleRadius = 20;    // Radio reducido para suavizar
    circleSpeed = 0.05;
    
    rotation = 0;
    controlTransition = 1;  // Por defecto, efecto completo
    
    alpha = 255;  // Comienza opaco
    fading = false;
  }
  
  // Método para iniciar el fade (por ejemplo, al desactivar Beru en el toggle)
  void startFade() {
    fading = true;
  }
  
  // Detecta si el mouse está sobre Beru, asumiendo que la imagen se dibuja con su esquina superior izquierda en (x,y)
  boolean isMouseOver() {
    return (mouseX >= x && mouseX <= x + w &&
            mouseY >= y && mouseY <= y + h);
  }
  
  // Maneja la entrada de teclado para mover a Beru (WASD) y girar (flechas izquierda/derecha)
  void handleKeyboard() {

  if (keyPressed) {
    // Acumula la dirección según la tecla presionada
    if (key == 'w' || key == 'W') {
      baseY -= 3;
    }
    if (key == 's' || key == 'S') {
      baseY += 3;
    }
    if (key == 'a' || key == 'A') {
      baseX -= 3;
    }
    if (key == 'd' || key == 'D') {
      baseX += 3;
    }
    
    
    // Giro con las flechas izquierda y derecha
    if (keyCode == LEFT) {
      manualRotation -= 0.04;
    }
    if (keyCode == RIGHT) {
      manualRotation += 0.04;
    }
    manualRotation = constrain(manualRotation, -PI/8, PI/8);
    
    // Limita la posición base para que no se salga del mapa
    baseX = constrain(baseX, 0, width - w);
    baseY = constrain(baseY, 0, height - h);
  }
}


  
  void update() {
    if (dragging) {
      // Durante arrastre, la posición base se actualiza directamente desde el mouse
      baseX = constrain(mouseX - dragOffsetX, 0, width - w);
      baseY = constrain(mouseY - dragOffsetY, 0, height - h);
      x = baseX;
      y = baseY;
      controlTransition = 0;  // Mientras se arrastra, se usa el control directo
    } else {
      // Si se presionan teclas de movimiento o giro, se usa el control directo
      boolean movingKeys = keyPressed && 
        ((key == 'w' || key == 'W') || (key == 'a' || key == 'A') ||
         (key == 's' || key == 'S') || (key == 'd' || key == 'D') ||
         (keyCode == LEFT) || (keyCode == RIGHT));
      if (movingKeys) {
        handleKeyboard();
        controlTransition = 0;  // Fuerza el control directo
      } else {
        // Si no se presionan teclas, la transición vuelve lentamente a 1 (efecto natural)
        controlTransition = lerp(controlTransition, 1, 0.01);
      }
      
      time += 0.01;  // Incremento suave
      
      // Movimiento basado en noise: rangos reducidos para suavidad
      float noiseX = map(noise(noiseOffsetX, time), 0, 1, -30, 30);
      float noiseY = map(noise(noiseOffsetY, time), 0, 1, -15, 15);
      
      // Movimiento circular
      float circX = circleRadius * cos(time * circleSpeed * TWO_PI);
      float circY = circleRadius * sin(time * circleSpeed * TWO_PI);
      
      // La posición final combina la posición base más el efecto de noise y circular, multiplicado por controlTransition.
      x = baseX + controlTransition * (noiseX + circX);
      y = baseY + controlTransition * (noiseY + circY);
      
      // Rotación: se suma el giro generado por noise al giro manual, mezclado por controlTransition.
      float noiseRot = map(noise(noiseOffsetX, time * 1.5), 0, 1, -PI/8, PI/8);
      rotation = constrain(noiseRot * controlTransition + manualRotation, -PI/4, PI/4);
    }
    
     // Si se ha iniciado el fade, se reduce gradualmente la opacidad
    if (fading) {
      alpha -= 3;  // Ajusta este valor para controlar la velocidad de fade
      if (alpha < 0) {
        alpha = 0;
      }
    }
  }
  
  void display() {
     update();
    pushMatrix();
    translate(x + w/2, y + h/2);
    rotate(rotation);
    tint(255, alpha);  // Aplica el tinte con el valor actual de alpha
    image(img, -w/2, -h/2);
    noTint();
    popMatrix();
  }
  
  // Métodos para arrastrar a Beru
  void startDrag() {
    if (isMouseOver()) {
      dragging = true;
      dragOffsetX = mouseX - baseX;
      dragOffsetY = mouseY - baseY;
    }
  }
  
  void drag() {
    if (dragging) {
      baseX = mouseX - dragOffsetX;
      baseY = mouseY - dragOffsetY;
    }
  }
  
  void stopDrag() {
    dragging = false;
  }
}
