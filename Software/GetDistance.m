function [ point_cloud ] = GetDistance( socket, type )
%GETDISTANCE Summary of this function goes here
%   Detailed explanation goes here
    fwrite(socket, uint8(['L','D',type,10]));
    point_cloud = zeros(1,360);
    if(type == 'E')
        for i = 1:360
            point_cloud(i) = fread(socket,1,'uint8');
        end
    else
        for i = 1:360
            point_cloud(i) = (fread(socket,1,'uint8')*2^8)+ fread(socket,1,'uint8');
        end
    end
end

