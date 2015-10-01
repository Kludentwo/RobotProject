function [ ] = Move( socket, motor1, motor2, time )
%MOVE Summary of this function goes here
%   Detailed explanation goes here
    fwrite(socket, uint8(['M','0',bitsra(motor1,8), (motor1), bitsra(motor2,8), (motor2),bitsra(time,8), (time),10]));
end

