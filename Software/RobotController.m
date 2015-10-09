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
        
        function col = Shootbeams(obj, NObeams)
            dis = GetDistance(obj.socket, 'D');
            for n = 1:NObeams
                id = uint32((360/NObeams)*(n-1))+1;
                currentdis = dis(id);
                
                col(n) = currentdis; 
            end
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
        
        % robot.Move(-100,100,2320); % full turnaround at speed 100.
        function [] = Move(obj, motor1, motor2, time)
            Move(obj.socket,motor1, motor2, time);
        end; 
        
        % Precondition: -180 <= phi <= 180;
        % Postcondition: yada ydada
        function [] = Turn(obj, phi)
            if ( phi < 0 )
                phi = abs(phi);
                motor1 = 100;
                motor2 = -100;
                t = -2.127E-7*phi^4 + 2.596E-4*phi^3 - 0.067*phi^2 + 12.163*phi + 60.442;
            else
                motor1 = -100;
                motor2 = 100;
                t = -1.291E-7*phi^4 + 1.166E-4*phi^3 - 0.034*phi^2 + 9.391*phi + 67.849; % Time as a function of angle
            end
            
            Move(obj.socket,motor1,motor2,t)
        end;
        
        function delete(obj)
            fclose(obj.socket);
        end
        
    end
    
end

