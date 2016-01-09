import processing.serial.*;

Serial robotSerial;
Robot robot;
TextField xfield;
TextField yfield;
TextField zfield;

float rotX, rotY;//World rotation.
float scale = 0.75;//World scale.
int xball = 0,yball = 250,zball = 0;
String lastText = "";

//COM PORT SETTINGS//
final int baudRate = 9600;
final char parity = 'M';
final int dataBits = 8;
final float stopBits = 1.0;
/////////////////////



void setup() {
  size(1200, 800, OPENGL);
  surface.setTitle("Robotics Simulation - By: Paul Verhoeven");
  surface.setResizable(true);
  //Thanks to CoreTech
  robot = new Robot();
  sphereDetail(10);
  xfield = new TextField(10,160,80,30 , "x", "0");
  yfield = new TextField(10,120,80,30 , "y", "0");
  zfield = new TextField(10,80,80,30 , "z", "0");
  
  println("COM ports: ");
  printArray(Serial.list());
  if(Serial.list().length > 0){
    try{
      robotSerial = new Serial(this, Serial.list()[0], baudRate, parity, dataBits, stopBits);
    }catch (Exception e){
      println("Couldn't connect to " + Serial.list()[0]);
    }
  }
}

void draw() {
  background(32);  
  //----------DRAW 3D WORLD----------
  //Rotate/translate/scale/light world
  pushMatrix();
  translate(width/2,height/2);
  rotateX(rotX);
  rotateY(rotY);
  scale(scale);
  smooth();
  lights();
  directionalLight(51, 102, 126, -1, 0, 0);
  
  robot.update();
  drawTable(0, 220, 0, 800, 10, 800);
  drawBall(xball,yball,zball);
  noLights();
  drawOrigin();
  popMatrix();

  
    //----------DRAW HUD (2D)----------
  hint(DISABLE_DEPTH_TEST);
  //fill(255);
  //rect(0,height-100,width,height);
  xball =  xfield.updateInt();
  yball =  yfield.updateInt();
  zball =  zfield.updateInt();
  printText(lastText);
  //Others.
  //robot.inverseKinematics(xball,yball,zball);
  handleConnection();
  hint(ENABLE_DEPTH_TEST);
}

//---------Object drawing---------
void drawBall(int x, int y, int z){
  pushMatrix();
  translate(x,y,z);
  fill(color(255,0,0));
  sphere(20);
  fill(0);
  popMatrix();
}
void drawOrigin(){
//Draw origin (R/G/B xyz lines)
   strokeWeight(2);
   textSize(24);
   stroke(255,0,0);//x
   line(0,0,0,200,0,0);//x
   stroke(0,0,255);//y
   line(0,0,0,0,0,200);//y
   stroke(0,255,0);//z
   line(0,0,0,0,200,0);//z
   noFill();
   text("+X",200,0);
   text("+Z",0,0,200);
   text("+Y",0,200,0);
   textSize(32);
   noStroke();
}
void drawTable(int x, int y, int z, int w, int h, int b) {
  pushMatrix();
  translate(x, y, z);
  fill(180);
  box(w, h, b);//floor
  popMatrix();
}

//---------Printing text---------
void printText(String text){
  printText(text,32,64);
}
void printText(String text, int x, int y){
  fill(255);
  textSize(32);
  text(text,x,y,0);
}

//---------Mouse/Key input---------
void mouseDragged() {
  rotY += (mouseX - pmouseX) * 0.01;
  rotX -= (mouseY - pmouseY) * 0.01;
}

void mouseWheel(MouseEvent event) {
  float count = event.getCount();
  scale -= count/10;
  if(scale <0.1){
   scale = 0.1; 
  } else if(scale>3)
  {
    scale=3;
  }
}

void keyPressed() {
}

//---------Connection (serial/socket)---------
void handleConnection() {
  
}

void serialEvent(Serial p) { 
  print(p.readString()); 
}