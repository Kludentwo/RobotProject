function [ heuristic ] = GenHeuristic( grid )
%This function generates the heuristic function for the size of the grid
heuristic = zeros(size(grid));
hsize = (size(grid,1) + size(grid,2) - 2);
for i = 1:size(grid,1)
    for j = 1:size(grid,2)
        heuristic(i,j) = ( hsize - (i-1) - (j-1));
    end
end
end

