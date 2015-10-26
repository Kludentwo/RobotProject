#include "EventHandler.h"

EventHandler::EventHandler(EventFunc func, char* Idstring)
{
  memcpy(id, Idstring, 2); 
  handle = func;
}


bool EventHandler::HandleEvent(char* Msgbuffer, byte count, SoftwareSerial& serial)
{
    if(Msgbuffer[0] == id[0] && Msgbuffer[1] == id[1])
    {
      handle(&Msgbuffer[2],count-2, serial);
      return true; 
    }
    else
    {
      return false;  
    }
}

