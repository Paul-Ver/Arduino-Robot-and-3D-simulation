enum rotationAxis{
  none,
  x,
  y,
  z
};

class Part { 
  float partLength = -10;
  PShape shape;
  float curRotation;
  float setRotation = 0;
  float minRotation = -300;
  float maxRotation = 300;
  rotationAxis rotAxis;
  float speed;
  color colour;
  String partName;

  Part (String partName, rotationAxis rot, float minRotation, float maxRotation, float Length, boolean useStyle, color drawColor) {  
    shape = loadShape(partName);
    this.partName = partName;
    partLength = Length;
    rotAxis = rot;
    this.minRotation = minRotation;
    this.maxRotation = maxRotation;
    speed = 0.05;
    colour = drawColor;
    if(!useStyle)
    shape.disableStyle();
  } 
  void update() {
    fill(colour); 
    noStroke();
    
    switch(rotAxis){
     case x:
       rotateX(-curRotation);
     break;
     case y:
       rotateY(curRotation);
     break;
     case z:
       rotateZ(curRotation);
     break;
     case none:
     break;
    }
    shape(shape);
    translate(0, partLength, 0);
  }
} 