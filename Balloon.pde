class Balloon extends Particle{
  Balloon(float x, float y,float z){
    super(x,y,z);
  }
  
  void display(){
    pushMatrix();
    translate(x,y,z);
    //fill(255,0,0);
    sphere(50);
    //ambient(0,0,255);
    popMatrix();
  }
  
}
