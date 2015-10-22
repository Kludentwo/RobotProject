


% Robotcontroller1 = RobotController();

N = 1
Noise_mm = 5; 

d = zeros(2+N, 360);
d(1, :) = 1:360;
for n=0:N
    d(n+2,:) = Robotcontroller1.Distance();

    points(2,:) = cos(d(1,:)*pi/180).*d(2,:);
    points(1,:) = sin(d(1,:)*pi/180).*d(2,:);
    figure(3)
    scatter(points(2,:),points(1,:));
    pause(0.5)
end

deg = 180;

%flyt antal grader 
sd = circshift(d, deg ,2);
sd(1, :) = 1:360; % set deg lable on

% remove zero mesuerments 
out = sd(:,all(sd,1));

%Remove bad mesurements 
data = out(2:end,:); 
outmean = repmat(mean(data), size(data,1) ,1);
out = out(:,all((data+Noise_mm)> outmean & (data-Noise_mm)< outmean, 1));

maxprop = 0; 
pause(0.3)

Robotcontroller1.Turn(deg);
for n=0:10000
    Robotcontroller1.Turn(1); 
    rawreading = zeros(2, 360);
    rawreading(1, :) = 1:360;
    rawreading(2,:) = Robotcontroller1.Distance();
   
    %remove zero 
    reading = rawreading(:,all(rawreading(1:2,:),1));
 
    same = intersect(out(1,:),reading(1,:));
    
    reading = rawreading(1:2,same(1,:));
    target = sd(1:2,same(1,:));
   
    prop = CalcProb(target(2,:),reading(2,:),5000)
    if(prop>0.50)
       
       if(maxprop<prop)
            maxprop = prop; 
       elseif (prop<maxprop)
            'stopping'
            Robotcontroller1.Turn(-1); 
            Robotcontroller1.Stop();
            break; 
       end
       
    end
    
    figure(4)
    plot(target(1,:),reading(2,:)); 
    hold on
    plot(target(1,:),target(2,:)); 
    hold off
    
end





