#include <Bluetooth.h>
#include <MotorOper.h>
#include "pitches.h"

//블루투스용 RX,TX 핀 설정
#define RX A1
#define TX A0

//모터 제어 핀
#define MotorA1 9
#define MotorA2 8
#define MotorAS 10

#define MotorB1 7
#define MotorB2 6
#define MotorBS 5

#define LED 4
#define melodyPin 12

unsigned long prevPlayTime = 0;
unsigned long playDuration = 0;
int currentMelody = 0;

int melodySize = 75;
int melody[] = {
  NOTE_E7, NOTE_E7, 0, NOTE_E7, 0, NOTE_C7, NOTE_E7, 0, NOTE_G7, 0, 0,  0, NOTE_G6, 0, 0, 0, 
  NOTE_C7, 0, 0, NOTE_G6, 0, 0, NOTE_E6, 0, 0, NOTE_A6, 0, NOTE_B6, 0, NOTE_AS6, NOTE_A6, 0, 
  NOTE_G6, NOTE_E7, NOTE_G7, NOTE_A7, 0, NOTE_F7, NOTE_G7, 0, NOTE_E7, 0,NOTE_C7, NOTE_D7, NOTE_B6, 0, 0,
  NOTE_C7, 0, 0, NOTE_G6, 0, 0, NOTE_E6, 0, 0, NOTE_A6, 0, NOTE_B6, 0, NOTE_AS6, NOTE_A6, 0, 
  NOTE_G6, NOTE_E7, NOTE_G7, NOTE_A7, 0, NOTE_F7, NOTE_G7, 0, NOTE_E7, 0,NOTE_C7, NOTE_D7, NOTE_B6, 0, 0
};
int tempo[] = {
  12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 
  12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 
  9, 9, 9, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12,
  12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12,
  9, 9, 9, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12,
};


Bluetooth BTSerial(RX,TX,9600);
MotorOper motor(MotorA1,MotorA2,MotorAS,MotorB1,MotorB2,MotorBS);

int fcnt = 0;
int total_angle = 0;
String pre_state = "";
int first_init = 0;
int melody_cnt = 0;

//부저 함수
void sing() {
    if(millis() < prevPlayTime + playDuration) {
        // music is playing. do nothing
        return;
    }
    // stop the tone playing:
    noTone(melodyPin);
    
    if(currentMelody >= melodySize)
    {   
        melody_cnt = 2;
        return;
    }
    // to calculate the note duration, take one second
    // divided by the note type.
    //e.g. quarter note = 1000 / 4, eighth note = 1000/8, etc.
    int noteDuration = 1000/tempo[currentMelody];
 
    tone(melodyPin, melody[currentMelody], noteDuration);
    prevPlayTime = millis();
    playDuration = noteDuration * 1.30;
    
    currentMelody++;
}

//방향 조절 함수
void direction(){
  
  String message = BTSerial.readLine();
  if (message != "")
  {
    Serial.println("message : " + message);
    Serial.println("====================");
    if(message == "forward")
    { 
      Serial.println("forward");
      motor.back(60);
      if (fcnt < 2)
      {
        motor.forward(90);
        fcnt ++;
      }
      else
      {
         motor.forward(70);
      }
      
      if (first_init == 0)
      {
        melody_cnt = 1;
        first_init = 1;
      }
    }
    else if(message =="back")
    {
      motor.back(120);
      if (first_init == 0)
      {
        melody_cnt = 1;
        first_init = 1;
      }
    }
     else if(message =="stop")
    {
      motor.stop();
      delay(5000);
      BTSerial.write("Stop\n");
    }
    else if(message =="turnleft")
    {
      motor.turnLeft(150);
      delay(150);
      motor.stop();
      if (first_init == 0)
      {
        melody_cnt = 1;
        first_init = 1;
      }
    }
    else if(message == "turnright")
    {
      motor.turnRight(150);
      delay(150);
      motor.stop();
      if (first_init == 0)
      {
        melody_cnt = 1;
        first_init = 1;
      }
    }
    else if(message == "trash")
    {
      motor.stop();
      int ix = 0;
      while (ix < 12)
      {
        motor.stop();
        digitalWrite(LED,HIGH);
        Serial.println("켜짐");
        delay(200);
        digitalWrite(LED,LOW);
        Serial.println("꺼짐");
        delay(200);
        ix++;
      }
    }
  }
}

void setup() {
  // put your setup code here, to run once:
   Serial.begin(9600);
   pinMode(LED,OUTPUT);
   pinMode(melodyPin, OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  if(melody_cnt == 1)
  {
    sing();
  }
  direction();
}
