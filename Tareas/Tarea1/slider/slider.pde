//CLASE
class Slider{
  //PROPIEDADES
  //Coordenadas x e y de la barra
  int barraX;
  int barraY;
  //Coordenadas x e y del manejador
  int sliderX;
  int sliderY;
  //Longitud de la barra
  int longitud;
 
  //¿Está el mouse sobre la barra?
  Boolean mouseSobreBarra;
  //¿Hemos hecho clic sobre la barra?
  Boolean isPressed;
 
  //Aquí almacenamos el valor del slider
  float valor;
 
  //CONSTRUCTOR
  //Parámetros: coordenadas x e y, longitud
  Slider(int _x, int _y, int _l){
    //Inicializamos todas las variables
      barraX = _x;
      barraY = _y;
      longitud = _l;
      sliderX = _x;
      sliderY = _y;
 
      mouseSobreBarra = false;
      isPressed = false;
    
      valor = 1;
  }
 
  //MÉTODOS
  void dibujar(){
    stroke(0);
    strokeWeight(2);
    fill(0);
    //barra
    rect(barraX, barraY, longitud, 1);
    noStroke(); 
    //manejador
    ellipse(sliderX, sliderY, 10, 10);
    
    mouseAccion();
  }
 
  void mouseAccion(){
    //invocamos todas las funciones
    mouseEncima();
    mousePresionado();
    mouseSuelto();
    
    //Modificamos el cursor cuando el mouse está sobre la barra
    if (mouseSobreBarra){
      cursor(HAND);
    } else {
      cursor(ARROW);
    }
  }
 
  //¿Está el mouse sobre la barra?
  void mouseEncima(){
    if(mouseX > barraX
      && mouseX < barraX + longitud
      && mouseY > barraY
      && mouseY < barraY + 10
      ){
        mouseSobreBarra = true;
      } else {
        mouseSobreBarra = false;
      }
  }
 
  //¿Hemos hecho clic sobre la barra?
  void mousePresionado(){
    if (mouseSobreBarra && mousePressed){
      sliderX = mouseX;
      valor = map(mouseX, barraX, barraX + longitud, 1, 100);
      isPressed = true;
    }
  }
 
  //¿Hemos soltado el botón del ratón?
  void mouseSuelto(){
    if(isPressed && mousePressed == false){
      isPressed = false;
    }
  }
  
  int getValor()
  {
      return (int)valor;
  }
}
