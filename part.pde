//enum rotationAxis{ //Not using enums, for backward compatibility with processing 2.2.1
//  none,
//  x,
//  y,
//  z
//};

class Part { 
  float partLength = -10;
  PShape shape;
  float curRotation;
  float setRotation = 0;
  float minRotation = -300;
  float maxRotation = 300;
  char rotAxis;
  float currentSpeed = 0;
  float maxSpeed = 0.05;
  float acceleration = maxSpeed/(frameRate*10);//10 is the seconds to get on max speed.
  float decelerationfactor = 7;//Difference in rotation (radians) * this factor = the speed to add.
  color colour;
  String partName;

  Part (String partName, char rot, float minRotation, float maxRotation, float Length, boolean useStyle, color drawColor) {  
    shape = loadShape(partName);
    this.partName = partName;
    partLength = Length;
    rotAxis = rot;
    this.minRotation = minRotation;
    this.maxRotation = maxRotation;
    maxSpeed = 0.05;
    colour = drawColor;
    if(!useStyle)
    shape.disableStyle();
  } 
  void update() {
    fill(colour); 
    noStroke();
    
    if(curRotation > maxRotation){
     curRotation = maxRotation;
     addToMessageList("Collision! " + partName + " exceeded max rotation (" + curRotation + "/" + maxRotation + ")");
    }else if(curRotation < minRotation){
      curRotation = minRotation;
      addToMessageList("Collision! " + partName + " exceeded min rotation (" + curRotation + "/" + minRotation + ")");
    }

    if(int(curRotation*100) == int(setRotation*100)){
     currentSpeed = 0;
     curRotation = setRotation;
    }else if(curRotation < setRotation){
      curRotation += currentSpeed;
    }else if(curRotation > setRotation){
      curRotation -= currentSpeed;
    }
    currentSpeed *= (abs(curRotation-setRotation)*decelerationfactor);
    
    if(currentSpeed < maxSpeed){
      currentSpeed+=acceleration;
    }else if(currentSpeed > maxSpeed){
      currentSpeed = maxSpeed;
    }
    
    //println("CurRot: " + curRotation + " SetRot " + setRotation + " | curSpeed " + currentSpeed + " maxSpeed " + maxSpeed + " factor = " +  abs(curRotation-setRotation));
    
    switch(rotAxis){
     case 'x':
       rotateX(-curRotation);
     break;
     case 'y':
       rotateY(curRotation);
     break;
     case 'z':
       rotateZ(curRotation);
     break;
     case 'n':
     break;
    }
    shape(shape);
    translate(0, partLength, 0);
  }
} 