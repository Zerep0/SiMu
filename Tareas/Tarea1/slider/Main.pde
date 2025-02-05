Slider s, r, t;



void setup()
{
  size(400,400);
  s = new Slider(10, 10, 200);
  r = new Slider(10, 40, 200);
  t = new Slider(10, 70, 200);
    
}

void draw(){
  //Invocamos sus métodos
  background(255);
  
  s.dibujar();
  r.dibujar();
  t.dibujar();
  
  
 
  
 

}
