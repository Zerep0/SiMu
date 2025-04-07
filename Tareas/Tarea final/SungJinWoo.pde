class SungJinWoo {
  PImage imgNormal;
  PImage imgBright;
  
  float x;   // Posición horizontal
  float y;   // Posición "base" (donde estarán los pies)
  
  // Ancho y alto escalados de la imagen normal (para detección y posicionamiento)
  float w;
  float h;
  
  // Factor de escala para reducir el tamaño (por ejemplo, 0.5 para la mitad del tamaño original)
  float scaleFactor = 0.5;
  
  SungJinWoo(float x, float y) {
    // Carga de imágenes desde la carpeta "data/"
    imgNormal = loadImage("sungJinWoo.png");
    imgBright = loadImage("sungJinWooBright.png");
    
    // Calculamos las dimensiones escaladas
    w = imgNormal.width * scaleFactor;
    h = imgNormal.height * scaleFactor;
    
    // Redimensionamos las imágenes a las dimensiones escaladas
    imgNormal.resize(int(w), int(h));
    imgBright.resize(int(w), int(h));
    
        // Posición donde queremos colocar al personaje
    this.x = x - w/2;
    this.y = y - h;
  }
  
  void display() {
    // Si el ratón está sobre el sprite, se muestra la versión brillante; si no, la normal.
    if (isMouseOver()) {
      image(imgBright, x, y);
    } else {
      image(imgNormal, x, y);
    }
  }
  
  // Chequeo simple del bounding box de la imagen
  boolean isMouseOver() {
    float left   = x;
    float right  = x + w;
    float top    = y;
    float bottom = y + h;
    
    return (mouseX >= left && mouseX <= right &&
            mouseY >= top  && mouseY <= bottom);
  }
}
