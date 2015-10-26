#include "Lidar.h"

#define PWMPin 3

Lidar::Lidar()
{
  pinMode(0, INPUT);
  pinMode(1, OUTPUT);
  pinMode(PWMPin, OUTPUT);
}

void Lidar::OnSerialEvent()
{
  byte value = Serial.read();
  byte startIndex = endIndex == PacketSize ? 0 : (endIndex+1);
  packet[endIndex] = value;
     
  if(packet[startIndex] == 0xFA && packet[endIndex] == 0xFA)
  {
    //Index in packet: 
    byte Index = packet[startIndex == PacketSize ? 0 : (startIndex+1)];
    if(Index >= 0xA0 && Index <= 0xF9)
    {
      PacketRecived(startIndex, Index);
      isUpdating = true; 
    }
  }
      
  endIndex = startIndex; // increment one
}
    
void Lidar::Start()
{
  if(!isStarted)
  {
    CurentPWMValue = 255; 
    analogWrite(PWMPin, CurentPWMValue);
    isStarted = true;
    Serial.begin(115200);
  }
}
   
void Lidar::Stop()
{
  if(isStarted)
  {
    analogWrite(PWMPin, 0); 
    Serial.end();
    isStarted = false;
  }
}

void Lidar::PacketRecived(byte startIndex,byte packetIndex)
{
    int dataIndex = (packetIndex-0xA0)*4;

    int LSBSPEEDINDEX = startIndex+2 > PacketSize ? startIndex+2-BufferSize : startIndex+2;
    int MSBSPEEDINDEX = startIndex+3 > PacketSize ? startIndex+3-BufferSize : startIndex+3;

    speedData[0] = packet[MSBSPEEDINDEX];
    speedData[1] = packet[LSBSPEEDINDEX];

    int currentspeed = (speedData[0]<<8)+speedData[1];

    if(currentspeed<0x4b00)
      CurentPWMValue = CurentPWMValue < 255 ? CurentPWMValue+1: CurentPWMValue ;
    else if(currentspeed>0x4b50)
      CurentPWMValue = CurentPWMValue == 0 ? CurentPWMValue: CurentPWMValue-1 ;

    analogWrite(PWMPin, CurentPWMValue);
     
    int index1 = startIndex+4 > PacketSize ? startIndex+4-BufferSize : startIndex+4;
    int index2 = startIndex+8 > PacketSize ? startIndex+8-BufferSize : startIndex+8;
    int index3 = startIndex+12 > PacketSize ? startIndex+12-BufferSize : startIndex+12;
    int index4 = startIndex+16 > PacketSize ? startIndex+16-BufferSize : startIndex+16;
    
    data[dataIndex].Update(packet, index1);
    data[dataIndex+1].Update(packet, index2);
    data[dataIndex+2].Update(packet, index3);
    data[dataIndex+3].Update(packet, index4); 
}


void Lidar::GetMessurement(SoftwareSerial&  writer, DataType type)
{
  if(IsUpdating())
  {
    if(type == Speed)
    {
      writer.write(speedData[0]); 
      writer.write(speedData[1]); 
    }
    else
    {
      for(int i = 0; i<360; i++)
      {
        data[i].GetMessurement(writer, type);
      }
    }
  }
  writer.flush();
}


bool Lidar::IsUpdating()
{
  bool isup = isUpdating;
  isUpdating = false; 
  return isup; 
}

LidarData::LidarData()
{
  
}
void inline Cpy(byte* dst, byte* scr, byte count)
{
  for(int i = 0; i<count; i++)
  {
    dst[i] = scr[i]; 
  }
}

void LidarData::Update(byte* packetBuffer, byte Start)
{
  byte rest = 0; 
  byte main = 4; 
  if(Start+4 > BufferSize)
  {
    rest = (Start+4) - BufferSize;
    main = main - rest;

   Cpy(&LidarData::data[main],packetBuffer, rest);
  }
  Cpy(LidarData::data,&packetBuffer[Start], main);  
}


void LidarData::GetMessurement(SoftwareSerial&  writer, DataType type)
{
    if(type == Distance)
    {
      if( (data[1]&0x80) == 0)
      {
        writer.write((data[1]&0x3F));
        writer.write(data[0]);
      }
      else
      {
        byte zero = 0; 
        writer.write(zero);
        writer.write(zero);
      }
    }
    else if(type == SignalStrength)
    {
      writer.write(data[3]);
      writer.write(data[2]);
    }
    else
    {
      writer.write(((data[1]&0xC0)));
    }
}

