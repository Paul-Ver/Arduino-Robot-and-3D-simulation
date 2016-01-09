class TextField {
  int x, y, xsize, ysize;
  String text = "";
  String value = "";

  boolean edit = false;

  TextField(int x, int y, int xsize, int ysize, String text, String value) {
    this.x=x;
    this.y=y;
    this.xsize = xsize;
    this.ysize = ysize;
    this.value = value;
    this.text=text;
  }

  String update() {
    if (mousePressed) {
      if ((mouseX >= x && mouseX <= x+xsize) && (mouseY >= y && mouseY <= y+ysize) ) {//Clicked inside
        if (!edit) {
          edit = true;
          value = "";
        }
        mousePressed = false;
      } else {//Clicked outside
        if (edit) {
          edit = false;
        }
      }
    }
    if (keyPressed && edit) {
      if (key >= ',' && key <= 'Z') {
        value+= key;
        key = 0;
      }
      if (key == BACKSPACE) {
        value = value.substring(0, max(0, value.length()-1));
        key = 0;
      }
      if (key == ENTER) {
        edit = false;
        key = 0;
      }
    }

    if (edit) {
      fill(255);
    } else {
      fill(100);
    }


    rect(x, y, xsize, ysize);

    if (edit)
      fill(0);
    else
      fill(255);
    textSize(10);
    text(text + ": " + value, x+2, y+15);

    return value;
  }
  int updateInt() {
    String stringUpdate = update();
    int returnNumber =0;

    try {
      returnNumber = Integer.parseInt(stringUpdate);
    }
    catch(Exception e) {
      returnNumber = 0;
    }

    return returnNumber;
  }
  Boolean updateButton() {
    boolean returnValue = false;
    if (mousePressed) {
      if ((mouseX >= x && mouseX <= x+xsize) && (mouseY >= y && mouseY <= y+ysize) ) {//Clicked inside
        returnValue = true;
        mousePressed = false;
      }
    }  
    if (returnValue) {
      fill(255);
    } else {
      fill(100);
    }

    rect(x, y, xsize, ysize);

    if (returnValue)
      fill(0);
    else
      fill(255);
    textSize(10);
    text(text, x+2, y+15);

    return returnValue;
  }
}