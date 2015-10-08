

%% Create map of crate

crateHeigth = 80; 
crateWidth = 47; 

%Create walls 
map = zeros(crateHeigth,crateWidth);
map(:,1) = ones(crateHeigth,1);
map(:,crateWidth) = ones(crateHeigth,1); 
map(1,:) = ones(1,crateWidth);
map(crateHeigth,:) = ones(1,crateWidth);


%%
sense_noise = 500; 
RealRobot = [crateHeigth-10, crateWidth-5, 0];


%% 
NumPar = 200; 

x = (crateHeigth-1).*rand(NumPar,1) + 1;
y = (crateWidth-1).*rand(NumPar,1) + 1;
phi = (2*pi).*rand(NumPar,1);
robot = [x , y, phi];



%% Shoot beams

NObeams = 8; 
propeDistance = 0.5; 

for sim_loop = 1:500 
beamCol = Shootbeams(robot, map, NObeams, propeDistance).*10;

%% Fitness

realbeam = Shootbeams(RealRobot,map,NObeams, propeDistance);
zero_hit_x = cos(RealRobot(3))*realbeam(1)+RealRobot(1);
zero_hit_y = sin(RealRobot(3))*realbeam(1)+RealRobot(2);


prob = CalcProb(beamCol,realbeam*10, sense_noise);
%%
bestfit =  0; 
for i = 1:NumPar

if(prob(i) > bestfit)
    bestfit = prob(i); 
    bestpos = robot(i,:);
end

end


figure(2)
    [X, Y] = find(map);
    plot(X,Y, 'ob', RealRobot(1),RealRobot(2),'og', robot(:,1),robot(:,2),'.r',bestpos(1),bestpos(2),'Xc');
    hold on
    plot([RealRobot(1), zero_hit_x], [RealRobot(2), zero_hit_y]);
    hold off
    axis([-10 90 -10 57]);
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
%%

turn_noise = 0.1;
turn = (rand)*1; 

move = (rand)*5; 
move_noise = 0.5;


 
RealRobot(:,3) = wrapTo2Pi(RealRobot(:,3)+turn);
RealRobot(:,1) = mod((RealRobot(:,1)-1 + move*cos(RealRobot(:,3))), crateHeigth-1)+1;
RealRobot(:,2) = mod((RealRobot(:,2)-1 + move*sin(RealRobot(:,3))), crateWidth-1)+1;


robot(:,3) = wrapTo2Pi(robot(:,3)+turn+randn(size(robot,1),1)*turn_noise);
robot(:,1) = mod((robot(:,1)-1 + move*cos(robot(:,3))+randn(size(robot,1),1)*move_noise), crateHeigth-1)+1;
robot(:,2) = mod((robot(:,2)-1 + move*sin(robot(:,3))+randn(size(robot,1),1)*move_noise), crateWidth-1)+1;

end
