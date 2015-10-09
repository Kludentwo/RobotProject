function [ nupolicyvect ] = scaleMap( policyvect , factor)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
nupolicyvect = [];
for l = 1:length(policyvect)
    for i = 1:factor
        nupolicyvect( (l*factor - factor) + i) = policyvect(l);
    end
end
end

