function [] = maneuver( Controller, Robot, Direction, Distance )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if nargin < 4
    Distance = 1;
end

Distance = Distance * 10; % formula is in milimiters, map is in centimeters

t = 9.131E-6*Distance^3 - 7.859E-3*Distance^2 + 6.154*Distance + 71.996;

RobotAngle = Robot(3);
Angle2 = mod(Direction*(pi/2),2*pi);
newangle = RobotAngle - Angle2;
Controller.Turn(newangle*180/pi); %Negativ drejer til venstre
Controller.Move(100,100,t);
end
