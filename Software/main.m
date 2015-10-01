% Robot Project
% Rune, René  & Nicolai
clear all; clc;

robot = RobotController();

for n = 1:10
tic; 
d = robot.Distance();
e = robot.SignalIntensity();
toc
end


delete(robot);