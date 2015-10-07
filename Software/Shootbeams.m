function [ beamCol ] = Shootbeams(robot, map, NObeams,  propeDistance)
%SHOOT Summary of this function goes here
%   Detailed explanation goes here

gap = 2*pi/NObeams; 
beamCol = zeros(size(robot,1),NObeams);

robot = [robot ones(size(robot,1),1)];

for n = 0: NObeams-1
    distance = 0; 
    direction = wrapTo2Pi(robot(:,3)+n*gap);
    
    robot(:,4) = 1;
    
    while(distance<1500)
         distance = distance + propeDistance;
         
         propX = int32(robot(:,1) + (cos(direction(:,1)).*distance).*robot(:,4));
         propY = int32(robot(:,2) + (sin(direction(:,1)).*distance).*robot(:,4));
         
         
         res = diag(map(propX,propY));
         robot(:,4) = robot(:,4).*~res;
         beamCol(:,n+1) = beamCol(:,n+1) +  res.*distance;
         
         if(sum(robot(:,4))==0)
             break;
         end
    end
    
  
end

end

