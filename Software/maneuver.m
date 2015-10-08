function [] = maneuver( Controller, Robot, Direction, Distance )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if nargin < 4
    Distance = 10;
end



RobotAngle = Robot(3);
Angle2 = mod(Direction*(pi/2),2*pi);
newangle = RobotAngle - Angle2;
Controller.Turn(newangle*180/pi); %Negativ drejer til venstre
Controller.Move(100,100,Distance);
end
