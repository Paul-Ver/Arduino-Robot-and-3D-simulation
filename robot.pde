class Robot { 
  ArrayList<Part> parts = new ArrayList<Part>();
  float F = 50;
  float T = 70;
  
  Robot () {
    //Create parts of which the robot is created. FULLY CONFIGURABLE!
    //                  file name,    rotation axis,     min/max rot,length,  use 3D style, color
    parts.add(new Part("base.obj",    rotationAxis.none ,0,0        ,4,       false,        color(100,100,100)));
    parts.add(new Part("shoulder.obj",rotationAxis.y    ,-150,150   ,25,      false,        color(255,255,255)));
    parts.add(new Part("upperArm.obj",rotationAxis.x    ,-60,120    ,50,      false,        color(255,255,0)));
    parts.add(new Part("lowerArm.obj",rotationAxis.x    ,-110,120   ,50,      false,        color(255,255,0)));
    parts.add(new Part("end.obj",     rotationAxis.x    ,-90,90     ,12,      false,        color(100,100,100)));
    parts.add(new Part("claw.obj",    rotationAxis.y    ,-200,200   ,12,      false,        color(255,255,255)));
  } 
  void update() { 
    pushMatrix();
    scale(4,-4,4);
    translate(0,-29,0);
    for(Part part: parts){
      part.update();
    }
    //box(10);
    popMatrix();
  }
  
  //---------Getters and Setters---------
  void setRotation(int partNumber, float rotation){
      parts.get(partNumber).setRotation = rotation;

  }
  void setRotationDirect(int partNumber, float rotation){
      parts.get(partNumber).setRotation = rotation;
      parts.get(partNumber).curRotation = rotation;
    
  }
  float getCurrentRotation(int partNumber){
    return parts.get(partNumber).curRotation;
  }
  float getSetRotation(int partNumber){
   return parts.get(partNumber).setRotation;
  }
  
  //---------Functions---------
  void inverseKinematics(float X, float Y, float Z){
    println("SORRY, THIS IS BROKEN!");
    float alpha;
    float beta;
    float gamma;
  
    float L = sqrt(Y*Y+X*X);
    float dia = sqrt(Z*Z+L*L);
  
    alpha = PI/2-(atan2(L, Z)+acos((T*T-F*F-dia*dia)/(-2*F*dia)));
    beta = -PI+acos((dia*dia-T*T-F*F)/(-2*F*T));
    gamma = atan2(Y, X);
    
    setRotation(1,degrees(alpha));
    setRotation(2,degrees(beta));
    setRotation(3,degrees(gamma));
  }
} 