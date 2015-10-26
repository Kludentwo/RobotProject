#include <SoftwareSerial.h>
#include <Wire.h>
#include "EventHandler.h"

#define RxBT 7 
#define TxBT 6

#define BUFFERLEN 9

SoftwareSerial btSerial(RxBT, TxBT); 

EventHandler events[] = {EventHandler(DataEvent, "LD"), EventHandler(UpdatingEvent, "UP"), EventHandler(OnOFfEvent, "OF")};

char messageBuffer[BUFFERLEN];
byte count = 0; 

void ComStart()
{
   btSerial.begin(38400);
   pinMode(RxBT, INPUT);
   pinMode(TxBT, OUTPUT);  

   Wire.begin();
}

void ComService()
{
  if(Wire.available())
  {
    btSerial.write(Wire.read());
  }
  
  if(btSerial.available())
  {
      byte data = btSerial.read(); 
      messageBuffer[count] = data;
      count++;

      if(data == '\n' && count > 1)
      {
         bool handled = false; 
         
         for(int i = 0; i<sizeof(events)/sizeof(EventHandler); i++)
         {
            if(events[i].HandleEvent(messageBuffer,count-1, btSerial))
            {
                handled = true; 
                break; 
            }
         }

         if(!handled)
         {
            Wire.beginTransmission(8); 
            for(int i = 0; i<count; i++)
              Wire.write(messageBuffer[i]);             
            Wire.endTransmission();
         }
         
         count = 0;
      }
      else if(count == BUFFERLEN || data == '\n' || data == '\r')
      {
          count = 0;
      }
  }
}
