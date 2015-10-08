function [ expand action policy policyvect path ] = AstarSearch( grid, init, goal, cost, heuristic )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%
% Example of use:
% grid = zeros(5,6);
% grid(1,2) = 1;
% grid(2,2) = 1;
% grid(3,2) = 1;
% grid(4,2) = 1;
% grid(5,4) = 1;
% grid(4,5) = 1;
% grid(5,5) = 1;
% 
% heuristic = GenHeuristic(grid);
% init = [1,1];
% goal = [size(grid)]
% cost = 1;
% [expand action policy policyvect path] = AstarSearch(grid, init, goal, cost, heuristic);

if nargin < 5
    heuristic = GenHeuristic(grid);
end
if nargin < 4
    cost = ones(size(grid));
end
if nargin < 3
    goal = size(grid);
end
if nargin < 2
    init = [1,1];
end
% end of Arguments block

closed = zeros(size(grid));
closed(init(1,1),init(1,2)) = 1;

expand = -1*ones(size(grid));
action = -1*ones(size(grid));

delta = [[-1, 0 ]; [ 0, -1]; [ 1, 0 ]; [ 0, 1 ]];
delta_name = ['^'; '<'; 'v'; '>';];
delta_int = [ 1; 2; 3; 4;];

x = init(1,1);
y = init(1,2);
g = 0;
h = heuristic(x,y);
f = g + h;

open = table(f,g,h,x,y);

found = false;
resign = false;
count = 0;

while (~found && ~resign)
    if (isempty(open))
        resign = true;
        expand = 'fail';
        return;
    else
        open = sortrows(open,1);
        x = open{1,4};
        y = open{1,5};
        g = open{1,2};
        open(1,:) = [];
        expand(x,y) = count;
        count = count + 1;
        
        if (x == goal(1,1) && y == goal(1,2))
            found = true;
        else
            for i = 1:length(delta)
                x2 = x + delta(i,1);
                y2 = y + delta(i,2);
                if (x2 > 0 && x2 < size(grid,1) + 1 && y2 > 0 && y2 < size(grid,2)+1)
                    if (closed(x2,y2) == 0 && grid(x2,y2) == 0)
                        g2 = g + cost(x2,y2);
                        h2 = heuristic(x2,y2);
                        f2 = g2 + h2;
                        newtable = table(f2,g2,h2,x2,y2);
                        newtable.Properties.VariableNames = open.Properties.VariableNames;
                        open = [open; newtable];
                        closed(x2,y2) = 1;
                        action(x2,y2) = i;
                    end
                end
            end
        end
    end
end
policy = 35*ones(size(grid));
x = goal(1,1);
y = goal(1,2);
policy(x,y) = '*';
cntr = 0;
policyvect = [];
path = [x y];
while( or(x ~= init(1,1) , y ~= init(1,2)) )
    cntr = cntr + 1;
    x2 = x - delta(action(x,y),1);
    y2 = y - delta(action(x,y),2);
    policy(x2,y2) = delta_name(action(x,y));
    path = [path; x2 y2];
    policyvect(cntr) = delta_int(action(x,y));
    x = x2;
    y = y2;
end

% Calculer path length og return et action array i stedet for det vi gør
% nu.
%expand
%action
%policy = char(policy)
%policyvect = fliplr(policyvect)
path = path(end:-1:1,:);
end

