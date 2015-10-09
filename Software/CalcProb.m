function [ prob ] = CalcProb( dis, real_robot_beamCol, sense_noise)
%CALCPROB Summary of this function goes here
%   Detailed explanation goes here
% 
truedist = repmat(real_robot_beamCol,size(dis,1),1);
prob = prod(exp(-(dis-truedist).^2/(2*sense_noise^2)),2);



end

