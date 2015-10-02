% Robot Project
% Rune, René  & Nicolai
clear all; close all; clc;

robot = RobotController();

robot.Turn(30);

pause(2)
for n = 1:3
tic;
d = robot.Distance();
e = robot.SignalIntensity();
toc
end

delete(robot);