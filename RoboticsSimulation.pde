import processing.serial.*;

Serial robotSerial;
Robot robot;
TextField xfield;
TextField yfield;
TextField zfield;
TextField comfield;

float rotX, rotY;//World rotation.
float scale = 0.75;//World scale.
int xball, yball, zball, comPortNumber = 0;

int xx = 200,yy = 200,zz = 200;

int messageListLength = 10;
String[] messageList = new String[messageListLength];
int messageListAlpha = 255;

//COM PORT SETTINGS//
final int baudRate = 115200;
final char parity = 'N';
final int dataBits = 8;
final float stopBits = 1.0;
/////////////////////



void setup() {
  size(1200, 800, OPENGL);
  surface.setTitle("Robotics Simulation - By: Paul Verhoeven");
  surface.setResizable(true);
  frameRate(30);
  //Thanks to CoreTech
  robot = new Robot();
  sphereDetail(10);
  xfield = new TextField(10, 160, 80, 30, "x: ", "200");
  yfield = new TextField(10, 120, 80, 30, "y: ", "0");
  zfield = new TextField(10, 80, 80, 30, "z: ", "200");
  comfield = new TextField(10, 40, 80, 30, "COM", "-port");
}

void draw() {
  background(32);  
  //----------DRAW 3D WORLD----------
  //Rotate/translate/scale/light world
  pushMatrix();
  translate(width/2, height/2);
  rotateX(rotX);
  rotateY(rotY);
  scale(scale);
  smooth();
  lights();
  directionalLight(51, 102, 126, -1, 0, 0);

  robot.update();
  drawTable(0, 220, 0, 800, 10, 800);
  drawBall(xball, yball, zball);
  
      robot.inverseKinematics(xx,yy,zz);
    pushMatrix();
    translate(xx,yy,zz);
    fill(color(255, 0, 0));
  sphere(20);
  fill(0);
    popMatrix();
  
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
  handleComPortButton();
  drawMessageList(10, height-2);
  //Others.
  hint(ENABLE_DEPTH_TEST);
  key = 0;
}

//---------Object drawing---------
void drawBall(int x, int y, int z) {
  pushMatrix();
  translate(x, y, z);
  fill(color(255, 0, 0));
  sphere(20);
  fill(0);
  popMatrix();
}
void drawOrigin() {
  //Draw origin (R/G/B xyz lines)
  strokeWeight(2);
  textSize(24);
  stroke(255, 0, 0);//x
  line(0, 0, 0, 200, 0, 0);//x
  stroke(0, 0, 255);//y
  line(0, 0, 0, 0, 0, 200);//y
  stroke(0, 255, 0);//z
  line(0, 0, 0, 0, 200, 0);//z
  noFill();
  text("+X", 200, 0);
  text("+Z", 0, 0, 200);
  text("+Y", 0, 200, 0);
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
void printText(String text) {
  printText(text, 32, 64);
}
void printText(String text, int x, int y) {
  fill(255);
  textSize(32);
  text(text, x, y, 0);
}
void drawMessageList(int x, int y) {
  if(messageListAlpha>0)
    messageListAlpha-=2;
  else
    messageListAlpha = 0;

  fill(255, messageListAlpha);
  textSize(12);
  smooth();
  for (int i = 0; i<messageList.length; i++) {
    if (messageList[i] != null)
      text(messageList[i], x, y-i*12);
  }
}
void addToMessageList(String text) {
  messageListAlpha = 255;
  int i = messageList.length-2;
  for (int j = messageList.length; j>1;j--) {
    messageList[i+1] = messageList[i];
    i--;
  }
  messageList[0] = text;
}
//---------Mouse/Key input---------
void mouseDragged() {
  rotY += (mouseX - pmouseX) * 0.01;
  rotX -= (mouseY - pmouseY) * 0.01;
}

void mouseWheel(MouseEvent event) {
  float count = event.getCount();
  scale -= count/10;
  if (scale <0.1) {
    scale = 0.1;
  } else if (scale>3)
  {
    scale=3;
  }
}

void keyPressed() {
  switch(key){
   case 'w':
   zz+=50;
   break;
   case 's':
   zz-=50;
   break;
   case 'd':
   xx+=50;
   break;
   case 'a':
   xx-=50;
   break;
   case 'q':
   yy+=50;
   break;
   case 'e':
   yy-=50;
   break;
  }
}

//---------Connection (serial/socket)---------
void serialEvent(Serial p) { 
  print(p.readString());
}
void handleComPortButton() {
  int newComPortNumber = comfield.updateInt();
  if (newComPortNumber != comPortNumber) {
    addToMessageList("COM ports: ");
    printArray(Serial.list());
    if (Serial.list().length > 0) {
      if (robotSerial != null)
        robotSerial.stop();
      try {
        robotSerial = new Serial(this, "COM"+newComPortNumber, baudRate, parity, dataBits, stopBits);
        //robotSerial = new Serial(this, "COM"+newComPortNumber, baudRate);
      }
      catch (Exception e) {
        addToMessageList("Couldn't connect to " + "COM"+newComPortNumber);
        robotSerial = null;
        comfield.value = "-port";
        comfield.edit = false;
        comPortNumber = newComPortNumber;
        return;
      }
      addToMessageList("com port changed to COM" + newComPortNumber);
      comPortNumber = newComPortNumber;
    } else {
      addToMessageList("No COM devices found");
      comfield.value= "-port";
      comfield.edit = false;
    }
  }
}