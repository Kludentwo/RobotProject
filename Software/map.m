map = zeros(85,384);
map(1:end,1)=1;
map(1:end,end)=1;
map(1,1:end)=1;
map(end,1:end)=1;
map(end-45:end,128*2:128*2+15) = 1;
map(end-45:end-30,128*2-15:128*2) = 1;

costwidth = 15;
se = strel('disk', costwidth);
costmap = imdilate(map,se);
figure(1), imshow((costmap+map)*0.5), title('Dilated')