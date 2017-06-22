function [newSZebro] = newSZebros(sZebro, vCeil, aCeil, disDanger)
% To calculate the new position and velocity(vCeil/heading) for zebros.
% Input:
%   sZebro: id of the source zebro
%   vCeil: speed ceiling bound
%   aCeil: acceleration ceiling bound
%   disDanger: dangerous distance
%   
% Global Variables
%   zebros:
%       zebros(i, :): information of zebro No.i
%       zebros(:, 1): x coordinate of zebro
%       zebros(:, 2): y coordinate of zebro
%       zebros(:, 3): speed on x coordinate of zebro
%       zebros(:, 4): speed on x coordinate of zebro
%       zebros(:, 5): heading of zebro. (-pi, Pi].
%                     zebros(:, 5)>0 when vX<0. zebros(:, 5)<0 when vX>0.
%   zLength: length of zebro, as a global variable
%   skyX: bound on x Axis, as global variable
%   skyY: bound on y Axis, as global variable
%   shorPath: set of id of zebros on shortest path
%   range: detection range
%   success: 0, movement through shortest path not finished; 
%            1, movement finished
%
% Output:
%   newSZebro: information update for source zebro.
% Written by Pengqi Chen (chenpq1993@gmail.com).
global zebros;
global zLength; 
global skyX;    
global skyY;
global shorPath;
global range;
global success;
% Boundary collision detection
colX = @(a, va) (a + va > skyX - 2 * zLength) | (a + va < 2 * zLength);
colY = @(b, vb) (b + vb > skyY - 2 * zLength) | (b + vb < 2 * zLength);
zebro = zebros(sZebro, :); % zebro = [x, y, vX, vY, zAnglePi]
x = zebro(1);
y = zebro(2);
      
len = length(shorPath);
distance = 0;  
target = shorPath(len);
for jLen= 1:(len-1)
    other = zebros(shorPath(len + 1 - jLen), :);
    distance = sqrt((zebro(1) - other(1))^2 +  (zebro(2) - other(2))^2);
    if(distance < range)
        target = shorPath(len + 1 - jLen);
        if target == shorPath(1) && distance < 2 * disDanger
            success = 1;
        end
        break;    
    end
end

xTarget = zebros(target,1) - zLength;    %zLength*1.5: to avoid collision
yTarget = zebros(target,2) + zLength*1.5;
k1 = 5/5;
k2 = 3/5;
distX = xTarget - zebro(1);
distY = yTarget - zebro(2);
% To limit abs(a) to be in the range of vCeil/3.
aX = distX / distance * vCeil;
aY = distY / distance * vCeil;
a = sqrt(aX^2 + aY^2);
aX = aX * (aCeil) / max(a, aCeil);
aY = aY * (aCeil) / max(a, aCeil);

% To limit abs(a) to be in the range of vCeil.
vX = k1*aX + k2*zebro(3);
vY = k2*aY + k2*zebro(4);
v = sqrt(vX^2 + vY^2);
vX = vX * (vCeil) / max(v, vCeil);
vY = vY * (vCeil) / max(v, vCeil);
% Boundary collision detection
if colX(x, vX)
    vX = -vX / 3;
end

if colY(y, vY)
    vY = -vY / 3;   
end

vPre = [-sin(zebro(5)) cos(zebro(5))];  % Direction of previous velocity
vCur = [vX vY];                         % Direction of current velocity
tAngle = tAngleCal(vPre, vCur);         % Turning angle
tAnglePi = tAngle(1);
zAnglePi = zebro(5) - tAnglePi;
zAnglePi = limAn2Pi(zAnglePi); %limit zAnglePi in (-pi, pi]
% Output of the function
if success == 1         
    newSZebro = [x, y, 0, 0, zAnglePi];
else
    newSZebro = [vX + x, vY + y, vX, vY, zAnglePi];
end