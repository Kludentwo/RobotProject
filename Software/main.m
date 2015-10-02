% Robot Project
% Rune, René  & Nicolai
clear all; clc;


robot = RobotController();


%robot.Move(-100,100,2320); % full turnaround at speed 100.
%robot.Move(-100,100,1); % 90 degree turn at speed 100.
% Minstep = 4.5 % ved speed 100;

% for i = 1:(180/4.5)
%     robot.Move(-100,100,1);
%     pause(0.1)
% end

% phi = @(x)1.348E-11*x^4 - 8.15E-8*x^3 + 1.627E-4*x^2 + 0.051*x - 1.789; %
% Angle as a function of time

%robot.Move(100,-100,1400);
%robot.Turn(30);


pause(2)
for n = 1:3
tic; 
d = robot.Distance();
e = robot.SignalIntensity();
toc
end

%delete(robot);