

%% Create map of crate

load('map')

crateHeigth = size(map,1); 
crateWidth = size(map,2); 

%Robot_controller = RobotController();

%Create walls 
%map = zeros(crateHeigth,crateWidth);
%map(:,1) = ones(crateHeigth,1)*10;
%map(:,crateWidth) = ones(crateHeigth,1)*10; 
%map(1,:) = ones(1,crateWidth)*10;
%map(crateHeigth,:) = ones(1,crateWidth)*10;


%%
sence_noise = 600; 
RealRobot = [50, 150, 0];


%% 
NumPar = 200; 


%% Shoot beams

NObeams = 20; 
propeDistance = 0.5; 
bestfit =  0; 

for sim_loop = 1:500 

if bestfit < 0.10
    x = (crateHeigth-1).*rand(NumPar,1) + 1;
    y = (crateWidth-1).*rand(NumPar,1) + 1;
    phi = (2*pi).*rand(NumPar,1);
    robot = [x , y, phi];   
end
    
%%    
    
beamCol = Shootbeams(robot, map, NObeams, propeDistance,1).*10;

%% Fitness

realbeam = Robot_controller.Shootbeams(NObeams);%[675 521 354 488 459 690 479 672] ;%Robot_controller.Shootbeams(NObeams);

prob = CalcProb(beamCol,realbeam, sence_noise);
alfa = prob/sum(prob);
%%
bestfit =  0; 
mean = [0, 0, 0];
for i = 1:NumPar
mean = mean + robot(i,:)*alfa(i);
if(prob(i) > bestfit)
    bestfit = prob(i); 
    bestpos = robot(i,:);
end

end

zero_hit_x = cos(bestpos(3))*realbeam(1)/10+bestpos(1);
zero_hit_y = sin(bestpos(3))*realbeam(1)/10+bestpos(2);

pd = pdist([bestpos; mean],'euclidean');

figure(2)
    [X, Y] = find(map);
    plot(X,Y, 'ob', bestpos(1),bestpos(2),'og', robot(:,1),robot(:,2),'.r',mean(:,1),mean(:,2),'xb');
    hold on
    plot([bestpos(1), zero_hit_x], [bestpos(2), zero_hit_y]);
    hold off
    legend(num2str(bestfit));
    axis([0 size(map,1) 0 size(map,2)]);
pause(0.1)

disTurn, targetDis = GetTargetPos( bestpos, bestfit,Robot_controller );


%% Resample

alfa = prob/sum(prob);

ca=cumsum(alfa);
np=[];
for k=1:size(robot,1)
    s=rand;
    m=1;
    while s>ca(m) 
        m=m+1;
    end

    np =[np;robot(m,:)];
end

robot = np;
%% Real Move
ang = disTurn*(180/pi);
ang = ((ang - ( idivide(int32(ang),int32(180))*360))*-1);

Robot_controller.Turn(ang);
Robot_controller.Move(100,100,targetDis); 

%% 
turn_noise = 0.5;
turn = disTurn; 

move = targetDis; 
move_noise = 5;


 
RealRobot(:,3) = wrapTo2Pi(RealRobot(:,3)+turn);
RealRobot(:,1) = mod((RealRobot(:,1)-1 + move*cos(RealRobot(:,3))), crateHeigth-1)+1;
RealRobot(:,2) = mod((RealRobot(:,2)-1 + move*sin(RealRobot(:,3))), crateWidth-1)+1;


robot(:,3) = wrapTo2Pi(robot(:,3)+turn+randn(size(robot,1),1)*turn_noise);
robot(:,1) = mod((robot(:,1)-1 + move*cos(robot(:,3))+randn(size(robot,1),1)*move_noise), crateHeigth-1)+1;
robot(:,2) = mod((robot(:,2)-1 + move*sin(robot(:,3))+randn(size(robot,1),1)*move_noise), crateWidth-1)+1;

end
