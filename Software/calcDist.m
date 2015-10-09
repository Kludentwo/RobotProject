function [ distance ] = calcDist( policyvect, index, maxdist )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

if nargin < 3
    maxdist = 10;
end

compare = policyvect(index);
distance = 0;
while ( policyvect(index+distance) == compare || distance == maxdist)
    distance = distance + 1;
end
end

