function [newzebros] = newZebros(zebros, speed, nNeighbors, disDanger, disDisp)
% To calculate the new position and velocity(speed/heading) for zebros.
% Input:
%   zebros:
%       zebros(i, :): information of zebro No.i
%       zebros(:, 1): x coordinate of zebro
%       zebros(:, 2): y coordinate of zebro
%       zebros(:, 3): speed on x coordinate of zebro
%       zebros(:, 4): speed on x coordinate of zebro
%       zebros(:, 5): heading of zebro
%   speed: speed limitation on zebro
%   nNeighbors: Maximum number of neighbors to avoid
%   disDanger: Dangerous distance
%   disDisp: Neighbor in disDisp may have repusion on the zebro
% Output:
%   newzebros: update of zebros. The data structure is the same with zebros
% Written by Pengqi Chen (chenpq1993@gmail.com).

% Get the number of zebros
nzebros = size(zebros, 1);            
% Preallocation of newzebros 
newzebros = zeros(nzebros, 5);
for i = 1:nzebros
    flag=0; % 0, initial value
            % 1, need to avoid collision with close zebros
    zebro = zebros(i, :); % zebro = [x, y, vX, vY]
    x = zebro(1);
    y = zebro(2);
    % Calculate the distance from zebro i to all zebros(including itself)    
    distance = zeros(nzebros, 1);
    for jZebro = 1:nzebros
        other = zebros(jZebro, :);
        dis = sqrt((zebro(1) - other(1))^2 + (zebro(2) - other(2))^2);
        distance(jZebro) = dis;
    end
    
    % Sort 'distance' in ascending order
    % The sorted distance is stored in 'distance2' 
    % The number of element 'distance2' is stored in 'order' 
    [distance2, order] = sort(distance);
    count = 0;
    % 'neighbor' will store the information of neighbors to avoid 
    neighbor = zeros(nNeighbors, 8);
    for n = 1:nNeighbors
        % zebros(order(1), :) is the zebro itself.
        % So start from zebros(order(2), :)
        neighbor(n, 1:5) = zebros(order(n+1), :);
        neighbor(n, 6) = zebro(1) - neighbor(n, 1);
        neighbor(n, 7) = zebro(2) - neighbor(n, 2);
        neighbor(n, 8) =  sqrt(neighbor(n, 6)^2 + neighbor(n, 7)^2);
        if(distance2(n+1) < disDisp)
            count = count + 1;       
        end
    end    
    % Only one neighbor is in disDanger, zebro will escape from this one
    if(distance2(2) < disDanger)&&(distance2(3) > disDanger)
        flag = 1;
        count = 1;
    end
 
    % k0: to keep inertia
    % k1: to calculate accelaration from distance 
    acceleration = speed / 3; % the limitation of accelaration
    aX = 0; % Accelaration on x-axis
    aY = 0; % Accelaration on y-axis
    if flag == 0
       k0 = 3.5 / 5;
       k1 = 8;
    elseif flag == 1 % Repulsion is more important than situation above
       k0 = 2/ 5;
       k1 = 8;
    end
    if count == 0 % No neighbor to avoid, zebro just keeps inertia
         vX = k0 * zebro(3);
         vY = k0 * zebro(4);
    else
         for p = 1:count
             distX = neighbor(p, 6);
             distY = neighbor(p, 7);
             dist3 = neighbor(p, 8);
             % Calculate accelaration
             if(dist3 < disDisp)  
                aPX = k1 / dist3 * distX / dist3;
                aPY = k1 / dist3 * distY / dist3;
                aX = aX + aPX;
                aY = aY + aPY;
             end
             % Calculate new velocity
             if(p == count)
                a = sqrt(aX^2 + aY^2);
                % To limit abs(a) to be in the range of speed/3.
                aX = aX * (acceleration) / max(a, acceleration);
                aY = aY * (acceleration) / max(a, acceleration);
                
                vX = zebro(3) * k0 + aX;
                vY = zebro(4) * k0 + aY;
                % To limit abs(v) to be in the range of speed.
                if vX ~= 0
                    vX = vX / abs(vX) * min(abs(vX), speed);
                end
                if vY ~= 0
                    vY = vY / abs(vY) * min(abs(vY), speed);
                end
             end
         end
    end
    
    speedFloor = 0.2;% Bound floor of speed
    v = sqrt(vX^2 + vY^2);
    if(v <= speedFloor)
        vX = 0;
        vY = 0;
    end
    
    % Calculate the heading of zebro
    if(v > speedFloor)
        angle = angleBet2Vec([0, 1], [vX, vY]);
        anglePi = angle(1);
        if(vX >= 0) 
            anglePi = -anglePi;
        end
    else
        anglePi = zebro(5);
    end
    % Output of the function
    newzebros(i, :) = [vX + x, vY + y, vX, vY, anglePi];
end
end