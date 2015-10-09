% Robot Project
% Rune, René  & Nicolai
clear all; close all; clc;

% Defines og inits osv.
load('map.mat');
delta = [[-1, 0 ]; [ 0, -1]; [ 1, 0 ]; [ 0, 1 ]];
init = [ 42 23 ];
goal = [ size(map) - [ 38 41 ]];

scalefactor = 5;
nuinit = [ idivide(int32(init-1),scalefactor)+1 ];
numap = ceil(imresize(map,1/scalefactor));
nugoal = [ idivide(int32(goal-1),scalefactor)+1 ];

cost = numap * 80;
cost = imgaussfilt(cost,2)*10;

[ policyvect path ] = AstarSearch( numap, nuinit, nugoal, cost);
nupolicyvect = scaleMap(policyvect, 5);

figure,
plotpath(path,numap)
startdir = 4;
Robot = [ 0 0 mod((startdir/2)*pi,2*pi)]
indexcounter = 1;
Robotcontroller1 = RobotController();
newpos = init;
while( newpos ~= goal )
dist = calcDist(nupolicyvect, indexcounter, 20);

newpos = init + delta(nupolicyvect(indexcounter))*dist;
angle = maneuver(Robotcontroller1,Robot,nupolicyvect(indexcounter),dist);

Robot = [ newpos angle]
indexcounter = indexcounter + dist

end

% Startup
% Measure & get init position
% (while ( ! goal ))
% calculer path ud fra a star
%   if new path then indexcounter = 1; end
%   dist = calcDist(policyvect, indexcounter)
%    maneuver(robot, Robotvect, direction, dist);
% Measure & get position
%  end while.



% robot = RobotController();
% pause(2)
% for n = 1:3
% tic;
% d = robot.Distance();
% e = robot.SignalIntensity();
% toc
% end
%
% delete(robot);