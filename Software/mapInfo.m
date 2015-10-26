

%% Create map of crate


crateHeigth = size(map,1); 
crateWidth = size(map,2); 

Robot_controller = RobotController();

%Create walls 
%map = zeros(crateHeigth,crateWidth);
%map(:,1) = ones(crateHeigth,1)*10;
%map(:,crateWidth) = ones(crateHeigth,1)*10; 
%map(1,:) = ones(1,crateWidth)*10;
%map(crateHeigth,:) = ones(1,crateWidth)*10;


%%
sence_noise = 350; 
RealRobot = [50, 150, 0];
mover = Mover(map, costmap , [20, 120]);

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
realbeam = Robot_controller.Shootbeams(NObeams);

beamCol = Shootbeams(robot, map, realbeam(1,:), propeDistance,1).*10;

%% Fitness

prob = CalcProb(beamCol,realbeam(2,:), sence_noise);
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


figure(2)
    [X, Y] = find(map);
    plot(X,Y, 'ob', bestpos(1),bestpos(2),'og', robot(:,1),robot(:,2),'.r',mean(:,1),mean(:,2),'xb');
    hold on
    if realbeam(1,1) == 0 
        zero_hit_x = cos(bestpos(3))*realbeam(2,1)/10+bestpos(1);
        zero_hit_y = sin(bestpos(3))*realbeam(2,1)/10+bestpos(2);
        plot([bestpos(1), zero_hit_x], [bestpos(2), zero_hit_y]);
    end
    hold off
    legend(num2str(bestfit));
    axis([0 size(map,1) 0 size(map,2)]);
pause(0.1)

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
[turn, move] = mover.MoveTarget(bestpos, bestfit,Robot_controller);

%% 
turn_noise = 0.3;
move_noise = 3;

robot(:,3) = wrapTo2Pi(robot(:,3)+turn+randn(size(robot,1),1)*turn_noise);
robot(:,1) = mod((robot(:,1)-1 + move*cos(robot(:,3))+randn(size(robot,1),1)*move_noise), crateHeigth-1)+1;
robot(:,2) = mod((robot(:,2)-1 + move*sin(robot(:,3))+randn(size(robot,1),1)*move_noise), crateWidth-1)+1;

end
