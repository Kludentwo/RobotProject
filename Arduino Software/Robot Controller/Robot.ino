#include <Wire.h>
#include <SPI.h>
#include <ArduinoRobot.h> // import the robot library

#define ADDRESS 0x21

bool dobeeb; 

void setup(){
  InitMovment();
  ComStart();
}

void loop(){
  
  

    ServiceMovment();
    ServiceCom();

    if(Robot.keyboardRead() == BUTTON_RIGHT)
    {
      Robot.beep(BEEP_DOUBLE);
      calibrate();
      Robot.beep(BEEP_LONG);
    }

    /*
    if(dobeeb)
    {
      Robot.beep(BEEP_SIMPLE);
      dobeeb = false; 
    }*/
  
}

void calibrate(){

  
  delay(1000);  //1 second before starting
  Wire.beginTransmission(ADDRESS);
  Wire.write(0x43);
  Wire.endTransmission();
  for(int i=0;i<15;i++){        //15 seconds
   delay(1000);
  }
  Wire.beginTransmission(ADDRESS);
  Wire.write(0x45);
  Wire.endTransmission();  
}
