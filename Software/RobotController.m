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
            dis = zeros(2, 360); 
            dis(1,:) = 0:pi/180:2*pi-pi/180;
            dis(2,:) = GetDistance(obj.socket, 'D'); 
            
            out = dis(:,all(dis(2,:),1));
            indexs = floor(1:size(out,2)/NObeams:size(out,2));
            
            
            col = out(:,indexs);
        end;
        
        function dis = Distance(obj)
            dis = GetDistance(obj.socket, 'D');
        end; 
        
        function [] = Stop(obj)
            fwrite(obj.socket, uint8(['S','T','a','b',10]));
        end; 
        
        
        function dis = Error(obj)
            dis = GetDistance(obj.socket,'E');
        end;
        
        function dis = SignalIntensity(obj)
            dis = GetDistance(obj.socket,'S');
        end;
        
        % robot.Move(-100,100,2320); % full turnaround at speed 100.
        function [moved] = Move(obj, motor1, motor2, distance)
            h = 250;
            w = 200;
            
            
            moved = distance;
            
            if ( distance > 0 )
            distance = distance * 10; % formula is in milimiters, map is in centimeters

            t = 2E-5*distance^3 - 0.0157E-3*distance^2 + 7.6742*distance;
            
            pause(0.1)
            startdis = zeros(2, 360); 
            startdis(1,:) = 0:pi/180:2*pi-pi/180;
            startdis(2,:) = obj.Distance();
            
            optSearch = [ startdis(:,1:end/2);startdis(:,end:-1:end/2+1)];
            optSearch = [optSearch(1:2:end); optSearch(2:2:end)];
            optSearch = optSearch(:,all(optSearch(2,:),1));
            
            valueStartDis = cos(optSearch(1,1))*optSearch(2,1);
            
            if( valueStartDis < h)
                obj.Stop(); 
                moved = 0; 
                return;
            end
            
            
            pause(0.1)
            Move(obj.socket,motor1, motor2, t);
            startTime = now*24*3600; 
            targetTime = startTime+ (t/1000);
            while(now*24*3600 < targetTime)
                dis = zeros(2, 360); 
                dis(1,:) = 0:pi/180:2*pi-pi/180;
                dis(2,:) = obj.Distance(); 
                checkDis = [dis(:,1:46) dis(:,end-45:end) ];
                checkDis = checkDis(:,all(checkDis(2,:),1));
                
                maxDis =  w./cos(checkDis(1,:));
                
                maxDis(find(maxDis>sqrt(w^2+h^2))) = sqrt(w^2+h^2);
                
                
                pause(0.1)
                if ~(sum(checkDis(2,:)<maxDis) == 0)
                    obj.Stop(); 
                    break;
                end
                
            end
            pause(0.1)
            startdis = zeros(2, 360); 
            startdis(1,:) = 0:pi/180:2*pi-pi/180;
            startdis(2,:) = obj.Distance();
            
            optSearch = [ startdis(:,1:end/2);startdis(:,end:-1:end/2+1)];
            optSearch = [optSearch(1:2:end); optSearch(2:2:end)];
            optSearch = optSearch(:,all(optSearch(2,:),1));
            
            valueEndDis = cos(optSearch(1,1))*optSearch(2,1);
            
            moved = (valueStartDis-valueEndDis)/10;
            
            pause(0.3)
            end
        end; 
        
        % Precondition: -180 <= phi <= 180;
        % Postcondition: yada ydada
        function [] = Turn(obj, phi)
            if (phi == 0)
                return;
            elseif ( phi < 0 ) %Turn Left
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
            pause(t/1000+0.2)
        end;
        
        function [] = SmartTurn(obj, phi)
            NewTurn(phi, obj);
        end;
               
        function delete(obj)
            fclose(obj.socket);
        end
        
    end
    
end

