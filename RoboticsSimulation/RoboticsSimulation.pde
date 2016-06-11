import processing.net.*;
import processing.serial.*;


Client client;
TextBox receiveBox;
Button connectButton;
Button ipButton;
Button portButton;

Serial serial;
Button connectComButton;
Button comPortButton;
Robot robot;

int mb = 0;
int hudYoffset = 0;
float rotX, rotY;//World rotation.
float scale = 0.75;//World scale.
int xx = 200,yy = 200,zz = 200;

//Ethernet settings//
String ethernetBuffer = "";
String ip = "192.168.126.254";
int port = 4001;
//COM PORT SETTINGS//
final int baudRate = 115200;
final char parity = 'N';
final int dataBits = 8;
final float stopBits = 1.0;
int comPort = 0;
/////////////////////
String receiveBuffer = "";



void setup() {
  size(1200, 800, OPENGL);
  frame.setTitle("Robotics Simulation - By: Paul Verhoeven");  //Using frame. instead of surface. for backward compatibility with processing 2.2.1
  frame.setResizable(true);                                    //Using frame. instead of surface. for backward compatibility with processing 2.2.1
  frameRate(30);
  //Thanks to CoreTech
  robot = new Robot();
  sphereDetail(10);
  
  hudYoffset = height-100;

  receiveBox = new TextBox(270, 90+hudYoffset, 300, 0, 10, 7);

  connectButton = new Button(10, 10+hudYoffset, 120, 20, "Connect TCP/IP", "");
  ipButton = new Button(10, 40+hudYoffset, 120, 20, "IP: ", ip);
  portButton = new Button(10, 70+hudYoffset, 120, 20, "Port: ", str(port));

  connectComButton = new Button(140, 10+hudYoffset, 120, 20, "Connect COM-Port", "");
  comPortButton = new Button(140, 40+hudYoffset, 120, 20, "COM-", str(comPort));
  
  
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
  drawBall(xx, yy, zz);
  robot.inverseKinematics(xx,yy,zz);
  
  noLights();
  drawOrigin();
  popMatrix();


  //----------DRAW HUD (2D)----------
  hint(DISABLE_DEPTH_TEST);
  
  receiveBox.Draw();
  ip = ipButton.update();
  port = portButton.updateInt();
  if (connectButton.updateButton()) {
    clientSetup();
  }

  comPort = comPortButton.updateInt();
  if (connectComButton.updateButton()) {
    comSetup();
  }
  
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

//---------Mouse/Key input---------
void mouseDragged() {
  if(mousePressed){
  switch(mb){
    case LEFT:
    rotY += (mouseX - pmouseX) * 0.01;
    rotX -= (mouseY - pmouseY) * 0.01;
    break;
    case RIGHT:
    xx += (mouseX - pmouseX)*cos(rotY);
    zz += (mouseX - pmouseX)*sin(rotY);
    yy += (mouseY - pmouseY);
    break;
  }
  }
}
void mousePressed(){
  mb=mouseButton;
}
void mouseWheel(MouseEvent event) {
  float count = event.getCount(); 
  if(mousePressed){
    if(mb == RIGHT){
      robot.setRotation(4,robot.getSetRotation(4)+count/10);
    }else if(mb == LEFT){
      robot.setRotation(5,robot.getSetRotation(5)+count/10);
    }
  }else{
    scale -= count/10;
    if (scale <0.1) {
      scale = 0.1;
    } else if (scale>3)
    {
      scale=3;
    }
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

void sendCurrentPositions(){
  String text =( "(" +(round(degrees(robot.getSetRotation(1)))+90)
               + "," +(round(degrees(robot.getSetRotation(2)))+90)
               + "," +(round(degrees(robot.getSetRotation(3)))+90)
               + "," +(round(degrees(robot.getSetRotation(4)))+90)
               + "," +(round(degrees(robot.getSetRotation(5)))+90)
               + ")\n" );
  send(text);
  print(text);
}

void clientEvent(Client someClient) {
  if (someClient!=null) {
    if (someClient.available() > 0) {
      char charIn = someClient.readChar();
      print(charIn);
      ethernetBuffer+= charIn;
      if (charIn == '\n') {
        receiveBox.addToMessageList(ethernetBuffer);
        receiveBuffer = ethernetBuffer;
        ethernetBuffer ="";
      }
    }
  }
}

void clientSetup() {
  client = new Client(this, ip, port);
  
  
  if (client != null) {
    if (client.active()) {
      receiveBox.addToMessageList("Connected to: " + ip + ":" + str(port));
    } else {
      receiveBox.addToMessageList("Couldn't connect to: " + ip + ":" + str(port));
    }
  }
}

void serialEvent(Serial p) {
  String receive = p.readString();
  print(receive);
  receiveBuffer = receive;
  receiveBox.addToMessageList(receive);
}

void comSetup() {
  try {
    serial = new Serial(this, "COM"+comPort, baudRate, parity, dataBits, stopBits);
  }
  catch (Exception E) {
    receiveBox.addToMessageList("Couldn't connect to " + "COM"+comPort);
    serial = null;

    if (Serial.list().length > 0) {
      receiveBox.addToMessageList("Available ports:");
      for (String t : Serial.list()) {
        receiveBox.addToMessageList(t);
      }
    } else {
      receiveBox.addToMessageList("No COM-ports available.");
    }
    printArray(Serial.list());
  }
}

void send(String text) {
  boolean any = false;
  if (serial!=null) {
    serial.write(text);
    println("Written to serial.");
    any = true;
  }
  if (client != null) {
    if (client.active()) {
      client.write(text);
      println("Written to client.");
      any = true;
    } else {
      println("Client inactive!");
    }
  }
  if(!any)
    receiveBox.addToMessageList("Not connected!");
}