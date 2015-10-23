classdef Mover  < handle
    %MOVER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        TargetPoint;
        DriveToTarget;
        PointIndex;
        map;
        costmap;
        goal;
    end
    
    methods
        
        function obj = Mover(map, costmap, goal)
            obj.map = map;
            obj.costmap = costmap;
            obj.goal = goal;
            obj.DriveToTarget = false;
            obj.TargetPoint;
            obj.PointIndex = 2;
        end;
        
        
        
        function [turn_rad, move ] = MoveTarget(obj, bestpos, bestfit, Robot_controller)
            
            turn_rad = 0;
            move = 0;
            
            if bestfit > 0.7 && ~obj.DriveToTarget
                obj.DriveToTarget = true;
                [ policyvect path ] = AstarSearch( obj.map, round(bestpos(1:2)), obj.goal, obj.costmap);
                obj.TargetPoint = calcCoordinates( policyvect, round(bestpos(1:2)), obj.goal );
            elseif bestfit < 0.2 && obj.DriveToTarget
                obj.DriveToTarget = false;
                obj.PointIndex = 2;
            end
            
            if obj.DriveToTarget == false
                
                alldis = Robot_controller.Distance();
                pause(0.01)
                
                filtersize = 1;
                Nf = ones(filtersize,1)/filtersize;
                
                alldis = filter(Nf, [1], alldis);
                [move, ang] = max(alldis/10);
                
                allang = 0:2*pi/360:2*pi-2*pi/360;
                [maxdis maxdisang]= max(alldis/10);
                figure(1)
                scatter([bestpos(1)+alldis.*cos(allang+bestpos(3))/10],[bestpos(2)+alldis.*sin(allang+bestpos(3))/10])
                hold on
                scatter([bestpos(1)+maxdis.*cos(maxdisang+bestpos(3))],[bestpos(2)+maxdis.*sin(maxdisang+bestpos(3))])
                hold off
                
                Nang = ((ang - ( idivide(int32(ang),int32(180))*360))*-1);
                
                if move > 25
                    move = 25;
                end
                Robot_controller.SmartTurn(Nang);
                Robot_controller.Move(101,100,move*0.80);
                
                
                turn_rad = ang*(pi/180);
            else
                figure(2)
                hold on
                plot(obj.TargetPoint(:,1),obj.TargetPoint(:,2))
                hold off
                pointAng = mod(atan2(obj.TargetPoint(obj.PointIndex,2)-bestpos(2),obj.TargetPoint(obj.PointIndex,1)-bestpos(1)),2*pi);
                turn_rad = -(bestpos(3) - pointAng);
                
                Nang = turn_rad*(180/pi)
                Nang = ((Nang - ( idivide(int32(Nang),int32(180))*360))*-1);
                
                move = pdist([bestpos(1:2); obj.TargetPoint(obj.PointIndex,:)],'euclidean')
                if move > 30
                    move = 30;
                end
                
                if(move < 10)
                    Robot_controller.Stop();
                    if obj.PointIndex == size(obj.TargetPoint,1)
                        beep
                        pause(10000);
                    end
                    obj.PointIndex = obj.PointIndex +1;
                end
                
                Robot_controller.SmartTurn(Nang);
                Robot_controller.Move(101,100,move*0.80);
                
            end
        end
        
    end
    
end

