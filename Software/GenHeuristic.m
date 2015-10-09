function [ heuristic ] = GenHeuristic( grid, goal )
%This function generates the heuristic function for the size of the grid

if nargin < 2
    goal = size(grid)-1;
end

heuristic = zeros(size(grid));
% hsize = (size(grid,1) + size(grid,2) - 2);
for i = 1:size(grid,1)
    for j = 1:size(grid,2)
        heuristic(i,j) = ( abs(goal(1) - (i)) + abs(goal(2) - (j)));
    end
end
end

