#ifndef Lidar_h
#define Lidar_h
#include "Arduino.h"
#include <SoftwareSerial.h>

#define PacketSize 22
#define BufferSize 23

enum DataType
{
  Distance = 'D',
  SignalStrength = 'S',
  Error = 'E',
  Speed = 'P',
};

class LidarData
{
    friend class Lidar;
    LidarData();
    void Update(byte* packet, byte Start);
    void GetMessurement(SoftwareSerial&  writer, DataType type);
    byte data[4] = {0,0,0,0};  
};


class Lidar
{
  public:
    Lidar();
    void OnSerialEvent();
    void Start();
    void Stop();
    bool IsUpdating(); 
    void GetMessurement(SoftwareSerial&  writer, DataType type);
  private:
    void PacketRecived(byte startIndex,byte packetIndex);
    bool isStarted = false; 
    byte endIndex = 0; 
    byte packet[BufferSize];
    LidarData data[360];
    byte speedData[2] = {0, 0};
    bool isUpdating = false; 
    byte CurentPWMValue = 180;
};



#endif

