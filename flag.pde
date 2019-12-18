import peasy.*;

import toxi.audio.*;
import toxi.color.*;
import toxi.color.theory.*;
import toxi.data.csv.*;
import toxi.data.feeds.*;
import toxi.data.feeds.util.*;
import toxi.doap.*;
import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.geom.mesh.subdiv.*;
import toxi.geom.mesh2d.*;
import toxi.geom.nurbs.*;
import toxi.image.util.*;
import toxi.math.*;
import toxi.math.conversion.*;
import toxi.math.noise.*;
import toxi.math.waves.*;
import toxi.music.*;
import toxi.music.scale.*;
import toxi.net.*;
import toxi.newmesh.*;
import toxi.nio.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;
import toxi.physics2d.constraints.*;
import toxi.physics3d.*;
import toxi.physics3d.behaviors.*;
import toxi.physics3d.constraints.*;
import toxi.processing.*;
import toxi.sim.automata.*;
import toxi.sim.dla.*;
import toxi.sim.erosion.*;
import toxi.sim.fluids.*;
import toxi.sim.grayscott.*;
import toxi.util.*;
import toxi.util.datatypes.*;
import toxi.util.events.*;
import toxi.volume.*;

PeasyCam cam;
PImage rose;

//float eyeX, eyeY, eyeZ;
//float ang = 0;
//float angHorizontal = 0;
//int d = 1000;

int res = 2;
float w = 10 * res;
int rows = 60 / res;
int cols = 80 / res;
float zoff = 0;
Particle[][] particles = new Particle[cols][rows];
ArrayList<Spring> springs;
ArrayList<Balloon> balloons;
ArrayList<Spring> springs2;
ArrayList<Particle> balloonString;

float speed = -10;

VerletPhysics3D physics;
AttractionBehavior3D mouseAttractor;

Vec3D mousePos;

void setup(){
  size(1500,1000,P3D);
  //cam = new PeasyCam(this, width/2,height/2,0, 1000);
  rose = loadImage("1.jpg");
  //eyeX = width/2;
  //eyeY = height/2;
  //eyeZ = d;

  //physics.setDrag(0.05);
  //AABB world = new AABB(new Vec3D(),180);
  //physics.setWorldBounds(world);

  //particles = new ArrayList<Particle>();
  springs = new ArrayList<Spring>();
  springs2 = new ArrayList<Spring>();
  balloons = new ArrayList<Balloon>();
  balloonString = new ArrayList<Particle>();
  
  physics = new VerletPhysics3D();
  Vec3D gravity = new Vec3D(0,0.2,0);
  GravityBehavior3D gb = new GravityBehavior3D(gravity);
  physics.addBehavior(gb);
  
  float x = -cols*w/2 - 100;  
  for (int i = 0; i <cols;i++){
    float y = -rows*w/2;
    for (int j = 0; j <rows;j++){
      Particle p = new Particle(x,y,0);
      particles[i][j] = p;
      physics.addParticle(p);
      physics.addBehavior(new AttractionBehavior3D(p, w, -20, 0.01));
      y = y+w;
    }
    x = x+w;
  }
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      Particle a = particles[i][j];
      if (i != cols-1) {
        Particle b1 = particles[i+1][j];
        Spring s1 = new Spring(a, b1);
        springs.add(s1);
        physics.addSpring(s1);
      }
      if (j != rows-1) {
        Particle b2 = particles[i][j+1];
        Spring s2 = new Spring(a, b2);
        springs.add(s2);
        physics.addSpring(s2);
      }
    }
  }
  for (int i = 0; i<15 ; i++){
    Particle a = new Particle (i*50,height/2,0);
    balloonString.add(a);
    physics.addParticle(a);
    //physics.addBehavior(new AttractionBehavior3D(a, 20, -1.5, 0.01));
    //a.addForce(new Vec3D(0,-500,0));
  }
  
  for (int i = 0; i<14;i++){
    Particle a = balloonString.get(i);
    Particle b = balloonString.get(i+1);
    Spring s = new Spring(a,b,30,1);
    springs2.add(s);
    physics.addSpring(s);
  }
  
  Balloon b = new Balloon(480,height/2,0);
  balloons.add(b);
  physics.addParticle(b);
  physics.addBehavior(new AttractionBehavior3D(b, 50, -20, -0.01));

  //b.lock(); 
  Spring ss = new Spring(b,balloonString.get(balloonString.size()-1),50,1);
  //Particle a = new Particle(0,height/2,0);
  //balloonString.add(a);
  //Spring ss = new Spring(a,b,440,1);
  springs2.add(ss);
  physics.addSpring(ss);
  
  for (int i = 0; i<cols;i++){
    particles[i][0].lock();
  }
  
  balloonString.get(0).lock();
  //particles[0][0].lock();
  //particles[cols-1][0].lock();
  //printCamera();
  

 
}
float a = 0;
void draw(){
  background(51);
  translate(width/2,height/2,0);
  pointLight(255, 255, 255, mouseX-width/2, mouseY-height/2, 300);
  //ambientLight(255, 255, 255);
  lightSpecular(0, 0, 0);
  //ambient(237, 50, 181);
  shininess(0);

  //if (eyeZ<0)
  //  camera(eyeX, eyeY, eyeZ, width/2, height/2, 0, 0, -1, 0);
  //else
  //  camera(eyeX, eyeY, eyeZ, width/2, height/2, 0, 0, 1, 0);
  ////camera(eyeX, eyeY, eyeZ, width/2, height/2, 0, 0, 1, 0);
  //translate(width/2, height/2, 0);
  physics.update();
  
  //float xoff = 0;
  //for (int i = 0; i <cols;i++){
  //  float yoff = 0;
  //  for (int j = 0; j <rows;j++){
  //    float windx = map(noise(xoff,yoff,zoff),0,1,0,0.1);
  //    float windz = map(noise(xoff+300,yoff+300,zoff),0,1,-1,1);
      
  //    Vec3D wind = new Vec3D(windx,0,windz);
  //    particles[i][j].addForce(wind);
  //    balloons.get(0).addForce(wind);
  //    yoff+=0.1;
  //  }
  //  xoff+=0.1;
  //}
  //zoff+=0.1;



  strokeWeight(0);
  textureMode(NORMAL);
  for (int j = 0; j < rows-1; j++){
    beginShape(TRIANGLE_STRIP);
    texture(rose);
    for (int i = 0; i < cols; i++){
      float x1 = particles[i][j].x;
      float y1 = particles[i][j].y;
      float z1 = particles[i][j].z;
      float u = map(i,0,cols-1,0,1);
      float v1 = map(j,0,rows-1,0,1);
      vertex(x1,y1,z1,u,v1);
      float x2 = particles[i][j+1].x;
      float y2 = particles[i][j+1].y;
      float z2 = particles[i][j+1].z;
      float v2 = map(j+1,0,rows-1,0,1);
      vertex(x2,y2,z2,u,v2);
    }
    endShape();
  }

  //stroke(255);
  //strokeWeight(4);
  //line(-cols*w/2 - 100, -rows*w/2, -cols*w/2 - 100, height);
  //line(-cols*w/2 - 100 + cols*w, -rows*w/2, -cols*w/2 - 100 + cols*w,height);
  
  //for (Spring s: springs){
  //  s.display();
  //}
  
  for (Balloon b: balloons){
    b.display();
      b.addForce(new Vec3D(0,speed,0));
  }
  if (speed>-20)
    speed-=0.5;
  for (Spring s: springs2){
    s.display();
  }
  for (Particle p: balloonString){
    //physics.removeParticle(p);
  }
  //for (int i = 0; i<cols;i++){
  //  for (int j = 0; j<rows;j++){
  //    particles[i][j].display();
  //  }
  //}
  

}
void mousePressed() {
  mousePos = new Vec3D(mouseX-width/2, mouseY-height/2,0);
  mouseAttractor = new AttractionBehavior3D(mousePos, 100, -100);
  physics.addBehavior(mouseAttractor);
}
void mouseDragged() {
  mousePos.set(mouseX-width/2, mouseY-height/2,0);
}
void mouseReleased() {
  physics.removeBehavior(mouseAttractor);
}

//void keyPressed() {
//  switch(key) {
//    // Move camera
//  case CODED:
//    if (keyCode == UP) {
//      ang += 5;
//      eyeX = width/2+(d*(-sin(radians(ang)))*cos(radians(angHorizontal)));
//      eyeY = height/2+(d*(-sin(radians(ang))));
//      eyeZ = -d*cos(radians(ang))*cos(radians(angHorizontal));
//    }
//    if (keyCode == DOWN) {
//      ang -= 5;
//      eyeX = d*sin(radians(ang))*cos(radians(angHorizontal));
//      eyeY = d*(sin(radians(ang))*sin(radians(angHorizontal)));
//      eyeZ = d*cos(radians(ang));
//    }
//    if(keyCode == RIGHT){
//      eyeX+=100;
//      //eyeZ+=10;
//    }
//    if(keyCode == LEFT){
//      eyeX-=100;
//      //eyeZ-=10;
//    }
 
//  default:
//    break;
//  } 
//  println(eyeX,eyeY,eyeZ);
 
//  //if (ang>=360)
//  //  ang=0;
//  //if (angHorizontal>=360){
//  //  angHorizontal = 0;
//  //}
//}

//void keyPressed() {
//  switch(key) {
//    // Move camera
//  case CODED:
//    if (keyCode == UP) {
//      ang += 5;
//    }
//    if (keyCode == DOWN) {
//      ang -= 5;
//    }
//    if(keyCode == RIGHT){
//      angHorizontal+=5;

//    }
//    if(keyCode == LEFT){
//      angHorizontal-=5;

//    }
 
//  default:
//    break;
//  } 
  
//  eyeX = width/2+(d*(sin(radians(ang)))*cos(radians(angHorizontal)));
//  eyeY = height/2+(d*(sin(radians(ang))));
//  eyeZ = d*cos(radians(ang))*cos(radians(angHorizontal));
//  println(eyeX,eyeY,eyeZ);
 
  //if (ang>=360)
  //  ang=0;
  //if (angHorizontal>=360){
  //  angHorizontal = 0;
  //}
//}
