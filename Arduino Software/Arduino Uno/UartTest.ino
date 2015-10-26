#include "Lidar.h"

Lidar lidar; 

void setup() {
  Serial.begin(115200);
  
  lidar.Start(); 
  ComStart();
}

void loop() {
  // put your main code here, to run repeatedly:
  ComService();
  
}

void serialEvent(){
    lidar.OnSerialEvent();
}

