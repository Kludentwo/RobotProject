function [ ] = Move( socket, motor1, motor2, time )
%MOVE Summary of this function goes here
%   Detailed explanation goes here
    motor1msb = (bin2dec(num2str(bitget((int16(motor1)),16:-1:9))));
    motor1lsb = (bin2dec(num2str(bitget((int16(motor1)),8:-1:1))));
    motor2msb = (bin2dec(num2str(bitget((int16(motor2)),16:-1:9))));
    motor2lsb = (bin2dec(num2str(bitget((int16(motor2)),8:-1:1))));
    timemsb = (bin2dec(num2str(bitget((uint16(time)),16:-1:9))));
    timelsb = (bin2dec(num2str(bitget((uint16(time)),8:-1:1))));
       
    %Henning = uint8(['M','0',bitsra(motor1,8), (motor1), bitsra(motor2,8), (motor2),bitsra(time,8), (time),10]);
    fwrite(socket, uint8(['M','O',motor1msb, motor1lsb,motor2msb,motor2lsb,timemsb,timelsb,10]));
end

