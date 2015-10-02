clear;
close all;

%Define then World
world_size = 60.0;
step_size = 0.5;
N_angle = 16;
%landmarks  = [[20.0; 20.0], [0.0; 80.0], [80.0; 80.0], [80.0; 20.0]];
MAP = zeros(world_size);
MAP(1:end,1)=1;
MAP(1:end,end)=1;
MAP(1,1:end)=1;
MAP(end,1:end)=1;
MAP(1:world_size/2-5,world_size/2-8)=1;

landmarks  = zeros(2,N_angle);
%Define robot
Z=[40;15; 0];%[world_size*rand;world_size*rand;2*pi*rand];

Zdist=[];
for j=1: size(landmarks,2)
    for i = 1:step_size:world_size
        x_pos = Z(1) + i*cos(N_angle*j/360*2*pi+Z(3));
        y_pos = Z(2) + i*sin(N_angle*j/360*2*pi+Z(3));
        if ceil(y_pos) >= world_size
            y_pos = world_size;
        else
            if ceil(y_pos) <= 1
                y_pos = 1;
            end
        end
        if ceil(x_pos) >= world_size
            x_pos = world_size;
        else
            if ceil(x_pos) <= 1
                x_pos = 1;
            end
        end
        if y_pos >= world_size || x_pos >= world_size || MAP(ceil(y_pos),ceil(x_pos))
            dist = sqrt(x_pos*x_pos+y_pos*y_pos);
            break
        else
            dist = 0; % no distance is measured
        end
    end
    landmarks(1,j) = x_pos;
    landmarks(2,j) = y_pos;
    Zdist =[Zdist dist];
end

%Particles
N=500;
p=[world_size*rand(1,N);world_size*rand(1,N);2*pi*rand(1,N)];

%%Draw the objective function
% [X,Y] = meshgrid(1:world_size,1:world_size);
% sense_noise=10;
% for r=1:size(Y)
%     for s=1:size(X)
%         f(r,s) = 1.0;
%         for j=1:size(landmarks,2)
%             dx = (X(r,s) - landmarks(1,j));
%             dy = (Y(r,r) - landmarks(2,j));
%             dist = sqrt(dx*dx+dy*dy);
%             f(r,s) = f(r,s)*(1/sqrt(2*pi*sense_noise^2))*exp(-(dist-Zdist(j))^2/(2*sense_noise^2));
%         end
%     end  
% end
% figure(1)
% surf(X,Y,f)

erer=[]
for l=1:1000
    %Move particles
    turn=.01;
    forward=.1;
    forward_noise_std=.5;
    turn_noise_std=.1;
    %turn
    Z(3) = Z(3) + turn;
    mod(Z(3),2*pi);
    %move
    dist = forward;
    Z(1)= Z(1) + (cos(Z(3)) * dist);
    Z(1)= mod(Z(1),world_size);
    
    Z(2) = Z(2) + (sin(Z(3)) * dist);
    Z(2)= mod(Z(2),world_size); 
    Zdist=[];
    % Update Zdist and landmarsk
    Zdist=[];
    for j=1: size(landmarks,2)
        for i = 1:step_size:world_size
            x_pos = Z(1) + i*cos(N_angle*j/360*2*pi+Z(3));
            y_pos = Z(2) + i*sin(N_angle*j/360*2*pi+Z(3));
            if ceil(y_pos) >= world_size
                y_pos = world_size;
            else
                if ceil(y_pos) <= 1
                    y_pos = 1;
                end
            end
            if ceil(x_pos) >= world_size
                x_pos = world_size;
            else
                if ceil(x_pos) <= 1
                    x_pos = 1;
                end
            end
            if y_pos >= world_size || x_pos >= world_size || MAP(ceil(y_pos),ceil(x_pos))
                dist = sqrt(x_pos*x_pos+y_pos*y_pos);
                break
            else
                dist = 0; % no distance is measured
            end
        end
%         landmarks(1,j) = x_pos;
%         landmarks(2,j) = y_pos;
        Zdist =[Zdist dist];
    end
    for k=1:size(p,2)
        %turn, and add randomness to the turning command
        p(3,k) = p(3,k) + turn_noise_std*randn;
        p(3,k)= mod(p(3,k),2*pi);

        %move, and add randomness to the motion command
        dist = forward + forward_noise_std*randn;
        p(1,k)= p(1,k) + (cos(p(3,k)) * dist);
        p(1,k)= mod(p(1,k),world_size);

        p(2,k) = p(2,k) + (sin(p(3,k)) * dist);
        p(2,k)= mod(p(2,k),world_size);    
    end
    
    %Draw the world
    figure(2)
    [X, Y] = find(MAP);
    plot(Y,X, 'ob', Z(1,:),Z(2,:),'og', p(1,:),p(2,:),'.r');
    axis([0 world_size 0 world_size]);
    
    %Calculate error and plot
    er = 0;
    for k=1:N
        dx = mod((p(1, k) - Z(1) + (world_size/2.0)), world_size) - (world_size/2.0);
        dy = mod((p(2, k) - Z(2) + (world_size/2.0)), world_size) - (world_size/2.0);
        de = sqrt(dx * dx + dy * dy);
        er = er+de;
    end
    erer=[erer er/N];
    figure(3)
    plot(erer)

    %%%Resample
    %Calculates how likely a measurement should be
    sense_noise=20;
    w=[];
    for k=1:size(p,2)
        prob = 1.0;
        for j=1: size(landmarks,2)
            for i = 1:step_size:world_size
                x_pos = p(1,k) + i*cos(j/360*2*pi+p(3,k));
                y_pos = p(2,k) + i*sin(j/360*2*pi+p(3,k));
                if ceil(y_pos) >= world_size
                    y_pos = world_size;
                else
                    if ceil(y_pos) <= 1
                        y_pos = 1;
                    end
                end
                if ceil(x_pos) >= world_size
                    x_pos = world_size;
                else
                    if ceil(x_pos) <= 1
                        x_pos = 1;
                    end
                end
                if y_pos >= world_size || x_pos >= world_size || MAP(ceil(y_pos),ceil(x_pos))
                    dist = sqrt(x_pos*x_pos+y_pos*y_pos);
                    break
                else
                    dist = 0; % no distance is measured
                end
            end
%             landmarks(1,j) = x_pos;
%             landmarks(2,j) = y_pos;
%             Zdist =[Zdist dist];
%             dist = sqrt(dx*dx+dy*dy);
            prob = prob*(1/sqrt(2*pi*sense_noise^2))*exp(-(dist-Zdist(j))^2/(2*sense_noise^2));
        end
        w = [w,prob];
    end
    alfa=w/sum(w);

    ca=cumsum(alfa);
    np=[];
    for k=1:N
        s=rand;
        m=1;
        while s>ca(m) 
            m=m+1;
        end
  
        np=[np,p(:,m)];
    end

    p=np;
    pause(0.001)
end