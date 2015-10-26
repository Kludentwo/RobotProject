#define BUFFERLEN 10

unsigned char messageBuffer[BUFFERLEN];
byte count = 0;

bool HasPacket = false; 

void ComStart()
{   
  Wire.begin(8);
  Wire.onReceive(receiveEvent);

  Robot.beginSpeaker();//Initialize the sound module
}

void ServiceCom()
{
  if(HasPacket)
  {
     if(count == 9 && messageBuffer[0] == 'M' && messageBuffer[1] == 'O')
     {
        dobeeb = true;
        int motor1 = 0 + (messageBuffer[2]<<8) + messageBuffer[3];
        int motor2 = 0 + (messageBuffer[4]<<8) + messageBuffer[5];
        
        unsigned int runtime =   (messageBuffer[6]<<8)+messageBuffer[7];
        
        runtime = runtime > 10000 ? 10000: runtime;
        MoveRobot(motor1,motor2, runtime); 
     }
     else if(count == 5 && messageBuffer[0] == 'T' && messageBuffer[1] == 'U')
     {
        dobeeb = true;
        int deg = (messageBuffer[2]<<8)+messageBuffer[3];
        deg  = deg > 179 ? 179 : deg; 
        deg  = deg < -179 ? -179 : deg; 
        TurnRobot(deg); 
     }
     else if(count == 5 && messageBuffer[0] == 'S' && messageBuffer[1] == 'T')
     {
        dobeeb = true;
        MoveStop();
     }
     
     count = 0;
     HasPacket = false; 
     receiveEvent(0); 
    }
}


void receiveEvent(int howMany)
{
  if(!HasPacket)
  {
    while(Wire.available())
    {
        byte data = Wire.read(); 
        messageBuffer[count] = data;
        count++;
  
        if(data == '\n' && count > 1)
        {
           HasPacket = true; 
           return; 
           
        }
        else if(count == BUFFERLEN || data == '\n' || data == '\r')
        {
            count = 0;
        }
    }  
  }
  
}

