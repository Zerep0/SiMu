class LightningSystem {
  ArrayList<Lightning> bolts;
  
  LightningSystem() {
    bolts = new ArrayList<Lightning>();
  }
  
  void updateAndDisplay() {
    // Genera un nuevo rayo si no hay ninguno activo, con baja probabilidad
    if (bolts.size() < 1 && random(1) < 0.005) {
      bolts.add(new Lightning());
    }
    
    // Actualiza y dibuja cada rayo; elimina los que hayan expirado
    for (int i = bolts.size()-1; i >= 0; i--) {
      Lightning l = bolts.get(i);
      l.update();
      l.display();
      if (l.isDead()) {
        bolts.remove(i);
      }
    }
  }
}
