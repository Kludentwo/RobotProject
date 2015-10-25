
grid = zeros(5,6);
grid(1,2) = 1;
grid(2,2) = 1;
grid(3,2) = 1;
grid(4,2) = 1;
grid(5,4) = 1;
grid(4,5) = 1;
grid(5,5) = 1;
init = [1,1];
goal = [size(grid)]

[ policyvect path ] = AstarSearch( grid, init, goal )
plotpath( path, grid )