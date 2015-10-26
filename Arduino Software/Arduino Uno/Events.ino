

void DataEvent(char* Msgbuffer, byte count, SoftwareSerial& serial)
{
  
  if(count == 1)
  { 
    lidar.GetMessurement(serial,(DataType)Msgbuffer[0]); 
  }
}

void UpdatingEvent(char* Msgbuffer, byte count, SoftwareSerial& serial)
{
  if(count == 0) 
    serial.write(lidar.IsUpdating());    
}

void OnOFfEvent(char* Msgbuffer, byte count, SoftwareSerial& serial)
{
  if(count == 1)
  {
     if(Msgbuffer[0] == '1')
     {
        lidar.Start();  
     }
     else
     {
        lidar.Stop(); 
     }
  }
}
