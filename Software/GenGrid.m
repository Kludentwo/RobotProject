function [ grid ] = GenGrid( size1,size2 )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
    grid = zeros(size1,size2);
    
    for i = 1:size(grid,1)
        for j = 1:size(grid,2)
            grid(i,j) = round(rand);
        end
    end
    grid(1,1) = 0;
    grid(size1,size2) = 0;
end

