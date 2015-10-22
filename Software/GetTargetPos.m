function [ dis, ang ] = GetTargetPos( pos, ser, Robot_controller )
%GETTARGETPOS Summary of this function goes here
%   Detailed explanation goes here

if(ser == 0.80)
    
else
    d = zeros(2, 360); 
    d(1, :) = 1:360;
    d(2,:) = Robot_controller.Distance();

    [dis, id] = max(d(2,:));
    ang = id*180/pi;
    dis = 19
    
    points(2,:) = cos(d(1,:)*pi/180).*d(2,:);
    points(1,:) = sin(d(1,:)*pi/180).*d(2,:);
    figure(3)
    scatter(points(2,:),points(1,:));
end

end

