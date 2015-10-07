function [ prob ] = CalcProb( robot_beamCol, real_robot_beamCol, sense_noise)
%CALCPROB Summary of this function goes here
%   Detailed explanation goes here
beamColTrue = repmat(real_robot_beamCol,size(robot_beamCol,1),1);
dis = abs(beamColTrue - robot_beamCol);
prob = prod((1/sqrt(2*pi*sense_noise^2))*exp(-(dis).^2/(2*sense_noise^2)),2);
end

