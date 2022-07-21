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
String strStatus;

void setup(){
    pinMode(trigPin,    OUTPUT);
    pinMode(echoLeft,   INPUT); pinMode(echoFront,  INPUT); pinMode(echoRight,  INPUT); pinMode(ldrPin,     INPUT);
    pinMode(motorPin1,  OUTPUT); pinMode(motorPin2,  OUTPUT); pinMode(motorPin3,  OUTPUT); pinMode(motorPin4,  OUTPUT);
    setStatus("stopped");
    Serial.begin(9600);
}

void loop(){
  if(javino.availablemsg()){
    String strMsg = javino.getmsg();
    if(strMsg=="getPercepts"){
      javino.sendmsg(getStatus()+perceptObstacule()+perceptLight());
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
}

String perceptObstacule(){
  int l = hc.dist(0);
  int f = hc.dist(1);
  int r = hc.dist(2);

  if(l==0) l=1024;
  if(f==0) f=1024;
  if(r==0) r=1024;
  
  return  "obstLeft("+String(l)+");"+
          "obstFront("+String(f)+");"+
          "obstRight("+String(r)+");";
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
    delay(150);
    digitalWrite(motorPin1, LOW);
    digitalWrite(motorPin2, LOW);
    digitalWrite(motorPin3, LOW);
    digitalWrite(motorPin4, LOW);    
    setStatus("running");
}


void stopRightNow(){
  digitalWrite(motorPin1, LOW);
  digitalWrite(motorPin2, LOW);
  digitalWrite(motorPin3, LOW);
  digitalWrite(motorPin4, LOW);
  setStatus("stopped");
}

void turnLeft(){
  digitalWrite(motorPin1, HIGH);
  digitalWrite(motorPin2, LOW);
  digitalWrite(motorPin3, LOW);
  digitalWrite(motorPin4, HIGH);
  delay(150);
  digitalWrite(motorPin1, LOW);
  digitalWrite(motorPin2, LOW);
  digitalWrite(motorPin3, LOW);
  digitalWrite(motorPin4, LOW);
  setStatus("turningLeft");
}


void turnRight(){
  digitalWrite(motorPin1, LOW);
  digitalWrite(motorPin2, HIGH);
  digitalWrite(motorPin3, HIGH);
  digitalWrite(motorPin4, LOW);
  delay(150);
  digitalWrite(motorPin1, LOW);
  digitalWrite(motorPin2, LOW);
  digitalWrite(motorPin3, LOW);
  digitalWrite(motorPin4, LOW);
  setStatus("turningRight");
}

/*void safeMode(){
  if(getSafeMode()){
    int x = hc.dist(1);
    if((x > 1) && (x < 10)){
      stopRightNow();
 //     javino.sendmsg("safeMode(on)");  
    }
  }
}
*/
String getStatus(){
  return "status("+strStatus+");";
}

void setStatus(String newValue){
  strStatus=newValue;
}
