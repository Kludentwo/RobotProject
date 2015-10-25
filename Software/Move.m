function [ ] = Move( socket, motor1, motor2, time )
%MOVE translates move commands into a string, which the robot can
%understand.
%   socket: The bluetooth socket.
%   motor1: The speed of the right motor (-127:128).
%   motor2: The speed of the left motor (-127:128).
%   time:   The time the robot moves (in centiseconds (Hundreds of a second)).
    motor1msb = (bin2dec(num2str(bitget((int16(motor1)),16:-1:9))));
    motor1lsb = (bin2dec(num2str(bitget((int16(motor1)),8:-1:1))));
    motor2msb = (bin2dec(num2str(bitget((int16(motor2)),16:-1:9))));
    motor2lsb = (bin2dec(num2str(bitget((int16(motor2)),8:-1:1))));
    timemsb = (bin2dec(num2str(bitget((uint16(time)),16:-1:9))));
    timelsb = (bin2dec(num2str(bitget((uint16(time)),8:-1:1))));
    
    fwrite(socket, uint8(['M','O',motor1msb, motor1lsb,motor2msb,motor2lsb,timemsb,timelsb,10]));
end

