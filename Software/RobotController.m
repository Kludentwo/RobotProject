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
        function [] = Move(obj, motor1, motor2, distance)
            if ( distance > 0 )
            distance = distance * 10; % formula is in milimiters, map is in centimeters

            t = 2E-5*distance^3 - 0.0157E-3*distance^2 + 7.6742*distance;
            
            Move(obj.socket,motor1, motor2, t);
            pause(t/1000+0.5)
            end
        end; 
        
        % Precondition: -180 <= phi <= 180;
        % Postcondition: yada ydada
        function [] = Turn(obj, phi)
            if ( phi < 0 ) %Turn Left
                phi = abs(phi);
                motor1 = 100;
                motor2 = -100;
                t = -2E-6*phi^4 + 8E-4*phi^3 - 0.1485*phi^2 + 16.418*phi;
            else %Turn Right
                motor1 = -100;
                motor2 = 100;
                t = -2E-7*phi^4 + 2E-4*phi^3 - 0.0578*phi^2 + 11.871*phi; % Time as a function of angle
            end
            
            Move(obj.socket,motor1,motor2,t)
            pause(t/1000+0.5)
        end;
               
        function delete(obj)
            fclose(obj.socket);
        end
        
    end
    
end

