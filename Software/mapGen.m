map = zeros(85,384);
map(1:end,1)=1;
map(1:end,end)=1;
map(1,1:end)=1;
map(end,1:end)=1;
map(end-45:end,128*2:128*2+15) = 1;
map(end-45:end-30,128*2-15:128*2) = 1;

costwidth = 25;
se = strel('square', costwidth);
costmap = imdilate(map,se);
% temp = costmap;
% while (length(find(costmap==0))>0)
%     temp = (imdilate(temp,se));
%     costmap = costmap + temp;
% end
costmap = (costmap+map)%*50);
figure(1), imshow(costmap/max(max(costmap))), title('Dilated')