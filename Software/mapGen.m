%% Big map
map = zeros(85,384);
map(1:end,1)=1;
map(1:end,end)=1;
map(1,1:end)=1;
map(end,1:end)=1;
map(end-45:end,128*2:128*2+15) = 1;
map(end-45:end-30,128*2-15:128*2) = 1;
save('bigmap','map')
% Cost map
costwidth = 25;
se = strel('square', costwidth);
costmap = imdilate(map,se);
costmap = (costmap+map)*50+1;
figure(1), imshow(costmap/max(max(costmap))), title('Dilated')
save('bigcostmap','costmap')

%% Small map
map = zeros(113,141);
map(1:end,1)=1;
map(1:end,end)=1;
map(1,1:end)=1;
map(end,1:end)=1;
map(1:45,end-66:end-59) = 1;
map(38:45,end-81:end-44) = 1;
save('smallmap','map')

% Cost map
costwidth = 35;
se = strel('square', costwidth);
costmap = imdilate(map,se);
costmap = (costmap+map*25)*2+1;
figure(1), imshow(costmap/max(max(costmap))), title('Dilated')
save('smallcostmap','costmap')