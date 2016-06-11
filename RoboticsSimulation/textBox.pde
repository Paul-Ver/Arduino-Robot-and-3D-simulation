class TextBox {
  String[] messageList;
  int x, y, tSize, widht, spacing;
  TextBox(int x, int y, int widht, int spacing, int tSize, int tLines) {
    this.x = x;
    this.y = y;
    this.tSize = tSize;
    this.widht = widht;
    this.spacing = spacing;
    messageList = new String[tLines];
  }

  void Draw() {
    fill(0);
    textSize(tSize);
    smooth();
    rect(x-spacing,y+spacing,widht+spacing*2,(-tSize*(messageList.length+1))-spacing*2);
    fill(255);
    for (int i = 0; i<messageList.length; i++) {
      if (messageList[i] != null)
        text(messageList[i], x, y-i*12);
    }
  }
  void addToMessageList(String text) {
    int i = messageList.length-2;
    for (int j = messageList.length; j>1; j--) {
      messageList[i+1] = messageList[i];
      i--;
    }
    messageList[0] = text;
  }
}