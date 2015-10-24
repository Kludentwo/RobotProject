function [ beamCol ] = Shootbeams(robot, map, beams,  propeDistance, hitchar)
%SHOOT Summary of this function goes here
%   Detailed explanation goes here
NObeams = size(beams,2);

beamCol = zeros(size(robot,1),NObeams);

robot = [robot ones(size(robot,1),1)];

for n = 0: NObeams-1
    distance = 0; 
    direction = wrapTo2Pi(robot(:,3)+ beams(n+1));
    
    robot(:,4) = 1;
    
    while(distance<1500)
         distance = distance + propeDistance;
         
         propX = int32(robot(:,1) + (cos(direction).*distance).*robot(:,4));
         propY = int32(robot(:,2) + (sin(direction).*distance).*robot(:,4));
         
         
         res = diag(map(propX,propY));
         beamCol(:,n+1) = beamCol(:,n+1) +  (res.*distance).*robot(:,4);
         robot(:,4) = robot(:,4).*~res;
         
         if(sum(robot(:,4))==0)
             break;
         end
    end
    
  
end

end

