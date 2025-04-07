class SummonSystem {
  // Nombres de archivo para los sprites de invocación (excepto Beru)
  String[] summonFiles = {
    "igris.png", 
    "iron.png", 
    "tank.png", 
    "tusk.png"
  };
  
  float scaleFactor = 0.5;
  
  Beru beru = null;
  
  // Array de imágenes cargadas
  PImage[] summonImages;
  
  // Listas para almacenar las invocaciones activas: cada imagen, su posición x y su progreso de aparición.
  ArrayList<PImage> activeSummonImages;
  ArrayList<Float> activeSummonX;  // Coordenada x fija para cada summon.
  ArrayList<Float> activeSummonProgress; // Progreso de aparición: 0 = altura 0, 1 = tamaño completo.
  ArrayList<Float> activeSummonAlpha;    // Opacidad actual para el fade (inicia en 255)
  
  // Posiciones fijas relativas al eje x que se asignarán aleatoriamente.
  float[] offsets = { -250, -125, 150, 275 };
  
  // Referencia al objeto SungJinWoo (para usar sus coordenadas)
  SungJinWoo sung;
  
  // Booleano toggle: true si los summons están activos, false si no.
  boolean active = false;
  // Booleano para indicar que se está en proceso de fade al desactivar.
  boolean fading = false;
  
  // Incremento del progreso por frame (controla la velocidad de aparición)
  float progressIncrement = 0.02;
  
  // Velocidad de desvanecimiento (fade) por frame
  float fadeSpeed = 3;
  
  SummonSystem(SungJinWoo sung) {
    this.sung = sung;
    
    // Cargamos las imágenes y las redimensionamos a la mitad
    summonImages = new PImage[summonFiles.length];
    for (int i = 0; i < summonFiles.length; i++) {
      summonImages[i] = loadImage(summonFiles[i]);
      summonImages[i].resize((int)(summonImages[i].width * scaleFactor), (int)(summonImages[i].height * scaleFactor));
    }
    
    activeSummonImages = new ArrayList<PImage>();
    activeSummonX = new ArrayList<Float>();
    activeSummonProgress = new ArrayList<Float>();
    activeSummonAlpha = new ArrayList<Float>();
  }
  
  // Invoca los summons usando 4 posiciones fijas relativas a Sung.
  // Se reordena aleatoriamente el array de offsets para asignar la posición x.
  // El "suelo" se define como sung.y + sung.h, y los summons crecerán desde allí hasta su tamaño completo.
  void invokeAll() {
    // Reordena aleatoriamente el arreglo de offsets
    float[] shuffled = offsets.clone();
    for (int i = 0; i < shuffled.length; i++) {
      int r = (int) random(i, shuffled.length);
      float temp = shuffled[i];
      shuffled[i] = shuffled[r];
      shuffled[r] = temp;
    }
    
    activeSummonImages.clear();
    activeSummonX.clear();
    activeSummonProgress.clear();
    activeSummonAlpha.clear();
    
    // Para cada imagen, asigna su posición x (sung.x + offset) y un progreso inicial 0.
    // También inicializa su alpha a 255.
    for (int i = 0; i < summonImages.length; i++) {
      activeSummonImages.add(summonImages[i]);
      activeSummonX.add(sung.x + shuffled[i]);
      activeSummonProgress.add(0.0);
      activeSummonAlpha.add(255.0);
    }
    
    // Crea a Beru para que aparezca volando por encima de Sung.
    // Por ejemplo, la posición base de Beru se define en (sung.x, sung.y - 200).
    // (Esto permanece igual en tu código)
    beru = new Beru(sung.x, sung.y - 200);
  }
  
  // Alterna la visibilidad de los summons.
  // Si están activos, en lugar de borrarlos inmediatamente, se activa el fade.
  // Si no están activos, se invocan normalmente.
  void toggleSummons() {
    if (active) {
      // En lugar de limpiar las listas inmediatamente, iniciamos el fade.
      fading = true;
      active = false;
    } else {
      invokeAll();
      active = true;
      fading = false;
    }
  }
  
  // Actualiza el valor alpha de cada summon para crear el efecto de fade.
  // Se llama en cada frame.
  void updateFade() {
    // Solo ejecuta si se está en modo fading (al desactivar)
    if (fading) {
      beru.startFade();
      for (int i = activeSummonAlpha.size()-1; i >= 0; i--) {
        float a = activeSummonAlpha.get(i);
        a -= fadeSpeed;
        if (a < 0) a = 0;
        activeSummonAlpha.set(i, a);
      }
      // Si todos han desaparecido, limpia las listas y finaliza el fade.
      boolean allFaded = true;
      for (float a : activeSummonAlpha) {
        if (a > 0) {
          allFaded = false;
          break;
        }
      }
      if (allFaded) {
        activeSummonImages.clear();
        activeSummonX.clear();
        activeSummonProgress.clear();
        activeSummonAlpha.clear();
        fading = false;
      }
    }
  }
  
  // Dibuja los summons haciendo que se extiendan desde el suelo hasta su tamaño completo,
  // aplicando también un efecto fade si se está en modo de desvanecimiento.
  void display() {
    // Definimos el nivel del suelo como la base de Sung.
    float groundY = sung.y + sung.h;
    
    // Actualizamos el fade (si se está en modo fading)
    updateFade();
    
    for (int i = 0; i < activeSummonImages.size(); i++) {
      // Actualiza el progreso de aparición si no se está fading (o incluso durante fade, puede seguir creciendo)
      float prog = activeSummonProgress.get(i);
      if (prog < 1) {
        prog += progressIncrement;
        if (prog > 1) prog = 1;
        activeSummonProgress.set(i, prog);
      }
      PImage img = activeSummonImages.get(i);
      // Calcula la altura actual a partir del progreso.
      float currentH = img.height * prog;
      float currentW = img.width;
      // Centra la imagen en x, manteniendo la base fija.
      float currentX = activeSummonX.get(i) - currentW / 2;
      float currentY = groundY - currentH;
      tint(255, activeSummonAlpha.get(i));
      image(img, currentX, currentY, currentW, currentH);
      noTint();
    }
    
    if (beru != null) {
      beru.display();
    }
  }
  
  // Métodos para gestionar el arrastre de Beru. Estos se llaman desde el sketch principal.
  void handleMousePressed() {
    if (beru != null && beru.isMouseOver()) {
      beru.startDrag();
    }
  }
  
  void handleMouseDragged() {
    if (beru != null) {
      beru.drag();
    }
  }
  
  void handleMouseReleased() {
    if (beru != null) {
      beru.stopDrag();
    }
  }
}
