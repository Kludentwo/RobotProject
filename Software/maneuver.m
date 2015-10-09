function [newangle] = maneuver( Controller, Robot, Direction, Distance )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if nargin < 4
    Distance = 1;
end

Distance = Distance - 5;
RobotAngle = Robot(3);
Angle2 = mod(Direction*(pi/2),2*pi);
newangle = (RobotAngle - Angle2);
if(newangle<0)
    newangle = mod(abs(newangle)+pi,2*pi);
end
res = newangle*180/pi;
Controller.Turn((res - idivide(int32(res),int32(180))*360)); %Negativ drejer til venstre
Controller.Move(100,100,Distance);
end
