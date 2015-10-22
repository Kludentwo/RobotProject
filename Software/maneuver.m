function [turn] = maneuver( Controller, Robot, Direction, Distance )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if nargin < 4
    Distance = 1;
end

raddir = Direction*(pi/2); 
turn = mod(raddir - Robot(3),2*pi)

turndeg = turn*(180/pi);

Distance = Distance;

Controller.Turn((turndeg - idivide(int32(turndeg),int32(180))*360)*-1); %Negativ drejer til venstre
Controller.Move(102,100,Distance);
end
