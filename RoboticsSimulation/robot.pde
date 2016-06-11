class Robot { 
  ArrayList<Part> parts = new ArrayList<Part>();
  float F = 50;
  float T = 70;

  Robot () {
    //Create parts of which the robot is created. FULLY CONFIGURABLE!
    //                  file name,    rotation axis,     min/max rot,length,  use 3D style, color
    parts.add(new Part("base.obj",     'n', 0, 0, 4, false, color(100, 100, 100)));
    parts.add(new Part("shoulder.obj", 'y', -150, 150, 25, false, color(255, 255, 255)));
    parts.add(new Part("upperArm.obj", 'x', -60, 120, 50, false, color(255, 255, 0)));
    parts.add(new Part("lowerArm.obj", 'x', -110, 120, 50, false, color(255, 255, 0)));
    parts.add(new Part("end.obj",      'x', -90, 90, 12, false, color(100, 100, 100)));
    parts.add(new Part("claw.obj",     'y', -200, 200, 12, false, color(255, 255, 255)));
  } 
  void update() { 
    pushMatrix();
    scale(4, -4, 4);
    translate(0, -29, 0);
    for (Part part : parts) {
      part.update();
    }
    //box(10);
    popMatrix();
  }

  //---------Getters and Setters---------
  void setRotation(int partNumber, float rotation) {
    parts.get(partNumber).setRotation = rotation;
  }
  void setRotationDirect(int partNumber, float rotation) {
    parts.get(partNumber).setRotation = rotation;
    parts.get(partNumber).curRotation = rotation;
  }
  float getCurrentRotation(int partNumber) {
    return parts.get(partNumber).curRotation;
  }
  float getSetRotation(int partNumber) {
    return parts.get(partNumber).setRotation;
  }

  //---------Functions---------
  void inverseKinematics(float X, float Y, float Z) {
    strokeWeight(1);
    /*float alpha;
     float beta;
     float gamma;
     
     float L = sqrt(Y*Y+X*X);
     float dia = sqrt(Z*Z+L*L);
     
     alpha = PI/2-(atan2(L, Z)+acos((T*T-F*F-dia*dia)/(-2*F*dia)));
     beta = -PI+acos((dia*dia-T*T-F*F)/(-2*F*T));
     gamma = atan2(Y, X);
     println("Alpha: " + alpha + " Beta: " + beta + " Gamma: " + gamma);
     
     setRotation(1,degrees(alpha));
     setRotation(2,degrees(beta));
     setRotation(3,degrees(gamma));*/

    //The rotation of the base is quite easy.
    //atan2 for the X,Z will work.
    //http://www.raywenderlich.com/35866/trigonometry-for-game-programming-part-1
    float baseRotation = atan2(X, Z);
    stroke(255);
    line(0, 0, 0, X, 0, Z);

    if (!Float.isNaN(baseRotation))
      setRotation(1, baseRotation);


    //We get a new triangle.
    //        (x,-y,z)
    //         /| 
    //hypoten/  | opposite
    //     /    |
    // BASE-----+(x,0,z)
    //       adjecent
    float adjecent = sqrt(sq(X)+sq(Z));
    float opposite = -Y;
    float hypotenuse = sqrt(sq(opposite)+sq(adjecent)); 
    float angle = atan2(opposite, adjecent)-radians(90);
    //
    //    elbow
    //      .
    //Arm1 /|\  Arm2
    //    / | \
    //   +-----+
    //   distance
    float distance = hypotenuse/2;
    float arm = 200;
    float angle2 = acos(distance/arm);

    float angle3 = asin(distance/arm);

    if (!Float.isNaN(angle) && !Float.isNaN(angle2) && !Float.isNaN(angle3) ) {

      if (angle+angle2 != Float.NaN)
        setRotation(2, angle+angle2);//The angle from base should be added to our local angle.
      if ((radians(90)-angle3)*-1-angle2 != Float.NaN)
        setRotation(3, (radians(90)-angle3)*-1-angle2);//This angle is the inverted angle of 3, I guess?
    }

    noStroke();
  }
} 