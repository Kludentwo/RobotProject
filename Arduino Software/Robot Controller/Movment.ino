
unsigned long StopTime = 0;

void InitMovment()
{
  Robot.begin(); // initialize the library
  Robot.setMode(MODE_SIMPLE );
}

void ServiceMovment()
{
  if(StopTime != 0)
  {
      unsigned long now = millis(); 
      if(StopTime<now)
      {
         Robot.motorsStop();
         StopTime = 0; 
      }
  }
  
}

void MoveStop()
{
  Robot.motorsStop();
}

void MoveRobot(int Moter1Speed, int Moter2Speed, int runtime)
{
    StopTime = runtime + millis(); 
    Robot.motorsWrite(Moter1Speed,Moter2Speed);
}


void TurnRobot(int deg)
{
  Robot.turn(deg);
}
