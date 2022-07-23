#include <Javino.h>
#include <HCSR04.h>

#define trigPin   2
#define echoLeft  3
#define echoFront 4
#define echoRight 5
#define ldrPin    6
#define motorPin1 7
#define motorPin2 8
#define motorPin3 9
#define motorPin4 10

Javino javino;
HCSR04 hc(trigPin, new int[3]{echoLeft, echoFront, echoRight}, 3); //initialisation class HCSR04 (trig pin , echo pin, number of sensor)
boolean safe;

void setup(){
    pinMode(trigPin,    OUTPUT);
    pinMode(echoLeft,   INPUT);
    pinMode(echoFront,  INPUT);
    pinMode(echoRight,  INPUT);
    pinMode(ldrPin,     INPUT);
    pinMode(motorPin1,  OUTPUT); pinMode(motorPin2,  OUTPUT); pinMode(motorPin3,  OUTPUT); pinMode(motorPin4,  OUTPUT);
    Serial.begin(9600);
}

void loop(){
  if(javino.availablemsg()){
    String strMsg = javino.getmsg();
    if(strMsg=="getPercepts"){
      javino.sendmsg(perceptObstacule()+perceptLight());
    }else if(strMsg=="stopRightNow"){
      stopRightNow();
    }else if(strMsg=="turnLeft"){
      turnLeft(); 
    }else if(strMsg=="turnRight"){
      turnRight(); 
    }else if(strMsg=="goAhead"){
      goAhead();
    }
  }
  safeMode();
}

String perceptObstacule(){
  return  "obstLeft("+String(int(hc.dist(0)))+");"+
          "obstFront("+String(int(hc.dist(1)))+");"+
          "obstRight("+String(int(hc.dist(2)))+");";
}

String perceptLight(){
  if(digitalRead(ldrPin)==0){
    return "lightSensor(yes)";
  }else{
    return "lightSensor(no)";
  }
}

void goAhead(){
    digitalWrite(motorPin1, HIGH);
    digitalWrite(motorPin2, LOW);
    digitalWrite(motorPin3, HIGH);
    digitalWrite(motorPin4, LOW);  
    setSafeMode(true);
}


void stopRightNow(){
  digitalWrite(motorPin1, LOW);
  digitalWrite(motorPin2, LOW);
  digitalWrite(motorPin3, LOW);
  digitalWrite(motorPin4, LOW);
  setSafeMode(false);
}

void turnLeft(){
  digitalWrite(motorPin1, HIGH);
  digitalWrite(motorPin2, LOW);
  digitalWrite(motorPin3, LOW);
  digitalWrite(motorPin4, HIGH);
}


void turnRight(){
  digitalWrite(motorPin1, LOW);
  digitalWrite(motorPin2, HIGH);
  digitalWrite(motorPin3, HIGH);
  digitalWrite(motorPin4, LOW);
}

void safeMode(){
  if(getSafeMode()){
    int x = hc.dist(1);
    if((x > 1) && (x < 10)){
      stopRightNow();
      javino.sendmsg("safeMode(on)");  
    }
  }
}

boolean getSafeMode(){
  return safe;
}

boolean setSafeMode(boolean newValue){
  safe=newValue;
}
