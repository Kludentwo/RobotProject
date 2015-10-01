classdef RobotController
    %ROBOTCONTROLLER Summary of this class goes here
    %   Detailed explanation goes here
       
    properties(SetAccess = private)
        socket;
    end
    
    methods
        function Obj = RobotController()
            Obj.socket = Bluetooth('H-C-2010-06-01',1);
            fopen(Obj.socket);
        end; 
        
        function dis = Distance(obj)
            dis = GetDistance(obj.socket, 'D');
        end; 
        
        function dis = Error(obj)
            dis = GetDistance(obj.socket,'E');
        end;
        
        function dis = SignalIntensity(obj)
            dis = GetDistance(obj.socket,'S');
        end;
        
        function [] = Move(obj, motor1, motor2, time)
            Move(obj.socket,motor1, motor2, time);
        end; 
        
        function delete(obj)
            fclose(obj.socket);
        end
        
    end
    
end

