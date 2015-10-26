#ifndef EventHandler_h
#define EventHandler_h
#include "Arduino.h"
#include<SoftwareSerial.h>

typedef void (*EventFunc)(char* buffer,byte count, SoftwareSerial& serial);

class EventHandler
{
 public:
  EventHandler(EventFunc func, char* Idstring);
  bool HandleEvent(char* Msgbuffer, byte count, SoftwareSerial& serial);
 private:  
  char id[2];
  EventFunc handle;
};

#endif
