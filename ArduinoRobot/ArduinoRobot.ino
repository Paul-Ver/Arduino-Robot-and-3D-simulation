#include <Servo.h>

Servo shoulder;
Servo base;
Servo upperArm;
Servo lowerArm;
String receiveBuffer = "";
bool receivedMessage = false;

void setup() {
  shoulder.attach(12);
  base.attach(11);
  upperArm.attach(10);
  lowerArm.attach(9);

  Serial.begin(115200);
}

void loop() {
  if(receivedMessage){
    handleMessage();
    receiveBuffer="";
    receivedMessage=false;
  }
}

void handleMessage(){
  int values[] = {0,0,0,0,0,0,0,0};
  int i = 0;
  int curPos  = receiveBuffer.indexOf('(')+1;
  while(receiveBuffer.indexOf(',',curPos) != -1){
    int second = receiveBuffer.indexOf(',',curPos);
    int val = (receiveBuffer.substring(curPos,second)).toInt();
    values[i] = val;
    curPos = receiveBuffer.indexOf(',',curPos)+1;
    i++;
  }
  int val = (receiveBuffer.substring(curPos,receiveBuffer.indexOf(')',curPos)).toInt());
  values[i] = val;

  Serial.print("(");
  for(int i = 0; i < 8; i++){
    Serial.print(String(values[i]));
    Serial.print(',');
  } 
  Serial.write("OK");
  Serial.println(')');
  base.write(values[0]);
  delay(1000);
  shoulder.write(values[1]);
  delay(1000);
  upperArm.write(values[2]);
  delay(1000);
  lowerArm.write(values[3]);
}

/*
  SerialEvent occurs whenever a new data comes in the
 hardware serial RX.  This routine is run between each
 time loop() runs, so using delay inside loop can delay
 response.  Multiple bytes of data may be available.
 */
void serialEvent() {
  while (Serial.available()) {
    char inChar = (char)Serial.read();
    if (inChar == '\n') {
      receivedMessage = true;
    }else{
      receiveBuffer += inChar;
    }
  }
}
/*
  shoulder.write(180);
  delay(1000);
  base.write(180);
  delay(1000);
  upperArm.write(180);
  delay(1000);
  lowerArm.write(180);
  delay(1000);
  shoulder.write(0);
  delay(1000);
  base.write(0);
  delay(1000);
  upperArm.write(0);
  delay(1000);
  lowerArm.write(0);
  delay(1000);
 */
