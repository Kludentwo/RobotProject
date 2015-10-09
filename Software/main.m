% Robot Project
% Rune, René  & Nicolai
%Robot_controller = RobotController();

d = zeros(2, 360); 
d(1, :) = 1:360;

while(1)

d(2,:) = Robot_controller.Distance();



points(2,:) = cos(d(1,:)*pi/180).*d(2,:);
points(1,:) = sin(d(1,:)*pi/180).*d(2,:);

figure(3)
scatter(points(2,:),points(1,:));



[maxdis ang] = max(d(2,:));
ang = (ang - ( idivide(int32(ang),int32(180))*360))*-1;

Robot_controller.Turn(ang);
pause(5); 
Robot_controller.Move(100,100,1000);
pause(1); 
end

pause(2)
for n = 1:3
tic;
d = robot.Distance();
e = robot.SignalIntensity();
toc
end

robot.Turn(30);


delete(robot);