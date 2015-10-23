function [ coordinates ] = calcCoordinates( nupolicyvect, init, goal )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

delta = [[-1, 0 ]; [ 0, -1]; [ 1, 0 ]; [ 0, 1 ]];
len = length(nupolicyvect);
curpos = init;
i = 2;
countmoves = 1;
coordinates = []
coordinatescounter = 2;
coordinates(1,:) = curpos;

while ( i ~= len)
    if ( nupolicyvect(i) ~= nupolicyvect(i-1) )
        coordinates(coordinatescounter,:) = curpos + delta((nupolicyvect(i-1)),:)*countmoves;
        curpos = coordinates(coordinatescounter,:);
        coordinatescounter = coordinatescounter + 1;
        countmoves = 1;
    else
        countmoves = countmoves + 1;
    end
    i = i + 1;
end
coordinates(coordinatescounter,:) = goal;
end

