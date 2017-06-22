function [newzebros] = newZebros(vCeil, nNeighbors, disDanger, disDisp)
% To calculate the new position and velocity(vCeil/heading) for zebros.
% Input:
%   vCeil: vCeil limitation on zebro
%   nNeighbors: maximum number of neighbors to avoid
%   disDanger: dangerous distance
%   disDisp: neighbor in disDisp may have repusion on the zebro
% Global Variable:
%   zebros(as a global variable):
%   zebros(i, :): information of zebro No.i
%   zebros(:, 1): x coordinate of zebro
%   zebros(:, 2): y coordinate of zebro
%   zebros(:, 3): vCeil on x coordinate of zebro
%   zebros(:, 4): vCeil on x coordinate of zebro
%   zebros(:, 5): heading of zebro. (-pi, Pi].
%                 zebros(:, 5)>0 when vX<0. zebros(:, 5)<0 when vX>0. 
%   zLength: length of zebro, as a global variable
%   skyX: bound on x Axis, as global variable
%   skyY: bound on y Axis, as global variable
% Output:
%   newzebros: update of zebros. The data structure is the same with zebros
% Written by Pengqi Chen (chenpq1993@gmail.com).
global zebros;
global zLength; 
global skyX;    
global skyY;
% Get number of zebros
nzebros = size(zebros, 1);            
% Preallocation of newzebros 
newzebros = zeros(nzebros, 5);

% Boundary collision detection
colX = @(a, va) (a + va > skyX- 2* zLength) | (a + va < 2*zLength);
colY = @(b, vb) (b + vb> skyY - 2 * zLength) | (b + vb < 2*zLength);
for i = 1:nzebros
    flag=0; % 0, Initial value
            % 1, Need to avoid collision with close zebros
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
    aCeil = vCeil / 2; % the limitation of accelaration
    aX = 0; % Accelaration on x-axis
    aY = 0; % Accelaration on y-axis
    if flag == 0
       k0 = 3/5;
       k1 = 8;
    elseif flag == 1 % Repulsion is more important than situation above
       k0 =1.5/5;
       k1 = 8;
    end
    if count == 0 %No enough neighbors nearby, zebro just keeps inertia
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
                % To limit abs(a) to be in the range of vCeil/3.
                aX = aX * (aCeil) / max(a, aCeil);
                aY = aY * (aCeil) / max(a, aCeil);
                
                vX = zebro(3) * k0 + aX;
                vY = zebro(4) * k0 + aY;
                % To limit abs(v) to be in the range of vCeil.
                v = sqrt(vX^2 + vY^2);
                vX = vX * (vCeil) / max(v, vCeil);
                vY = vY * (vCeil) / max(v, vCeil);
             end
         end
    end
   
    % Boundary collision detection
    if colX(x, vX)
        vX = -vX/3;
    end
      
    if colY(y, vY)
        vY = -vY/3;   
    end
    
    % Speed floor bound
    vFloor = 0.4;
    v = sqrt(vX^2 + vY^2);
    if(v <= vFloor)
        vX = 0;
        vY = 0;
        zAnglePi = zebro(5);
    else
        vPre = [-sin(zebro(5)) cos(zebro(5))];  % previous velocity
        vCur = [vX vY];                         % current velocity
        tAngle = tAngleCal(vPre, vCur);         % turning angle
        tAnglePi = tAngle(1);
        zAnglePi = zebro(5) - tAnglePi;
        %Ceiling bound of tAnglePi: pi/3 
        if(abs(tAnglePi) > pi/3) 
            zAnglePi = zebro(5) - pi / 3 * abs(tAnglePi) / tAnglePi;
            vX = 0;
            vY = 0;
        end
        zAnglePi = limAn2Pi(zAnglePi); %limit zAnglePi in (-pi, pi]
    end     
    
    % Output of the function
    newzebros(i, :) = [vX + x, vY + y, vX, vY, zAnglePi];
end
end