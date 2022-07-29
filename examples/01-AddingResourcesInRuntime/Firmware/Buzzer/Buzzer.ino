#include <Javino.h>

#define buzzerPin 11

Javino javino;
String strStatus;

void setup(){
    pinMode(buzzerPin,    OUTPUT);
    setStatus("off");
    Serial.begin(9600);
}

void loop(){
  if(javino.availablemsg()){
    String strMsg = javino.getmsg();
    if(strMsg=="getPercepts"){
      javino.sendmsg(getStatus());
    }else if(strMsg=="buzzer"){
      buzzer();
    }
  }
}


void buzzer(){
    digitalWrite(buzzerPin, HIGH);
    delay(200);
    digitalWrite(buzzerPin, LOW);
}

String getStatus(){
  return "buzzerStatus("+strStatus+");";
}

void setStatus(String newValue){
  strStatus=newValue;
}
