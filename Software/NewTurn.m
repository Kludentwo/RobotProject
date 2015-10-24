function [] = NewTurn(deg, Robotcontroller1)
Noise_mm = 5; 

d = zeros(2, 360);
d(1,:) = 1:360;
d(2,:) = Robotcontroller1.Distance();
pause(0.1); 

%flyt antal grader 
sd = circshift(d, deg ,2);
sd(1, :) = 1:360; % set deg lable on

% remove zero mesuerments 
out = sd(:,all(sd,1));


maxprop = 0; 
Robotcontroller1.Turn(deg);
if deg>0
    degSign=10;
else
    degSign=-10;
end
for n=0:10000
    Robotcontroller1.Turn(degSign); 
    rawreading = zeros(2, 360);
    rawreading(1, :) = 1:360;
    rawreading(2,:) = Robotcontroller1.Distance();
   
    %remove zero 
    reading = rawreading(:,all(rawreading(1:2,:),1));
 
    same = intersect(out(1,:),reading(1,:));
    if(isempty(same))
       return; 
    end
    
    reading = rawreading(1:2,same(1,:));
    target = sd(1:2,same(1,:));
   
    prop = CalcProb(target(2,:),reading(2,:),5000)
    if(prop>0.5)
       
       if(maxprop<prop)
            maxprop = prop; 
       elseif (prop<maxprop)
            Robotcontroller1.Turn(-degSign); 
            Robotcontroller1.Stop();
            break; 
       end
       
    end
    
%     figure(4)
%     plot(target(1,:),reading(2,:)); 
%     hold on
%     plot(target(1,:),target(2,:)); 
%     hold off
end

end





