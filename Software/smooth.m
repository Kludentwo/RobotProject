function [ newpath ] = smooth( path, weight_data, weight_smooth, tolerance )
% This function takes input path of size N,2 and smooths it using
% weight_data and weight_smooth in accordance to the tolerance.
%
% Example use:
% newpath = smooth(path,0.5,0.3);

if nargin < 4
    tolerance = 0.000001;
end
if nargin < 3
    weight_smooth = 0.1;
end
if nargin < 2
    weight_data = 0.5;
end

newpath = path;

change = tolerance;
while (change >= tolerance)
    change = 0.0;
    for i = 2: size(path,1)-1
        for j = 1:size(path,2)
            aux = newpath(i,j);
            newpath(i,j) = newpath(i,j) + weight_data * (path(i,j) - newpath(i,j));
            newpath(i,j) = newpath(i,j) + weight_smooth * (newpath(i-1,j) + newpath(i+1,j) - (2.0 * newpath(i,j)));
            change = change + abs(aux - newpath(i,j));
        end
    end
end
end
