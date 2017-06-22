function [newzebroi] = newZebroi(izebro)
% To calculate the new position and velocity(vCeil/heading) for zebros.
% Input:
%   izebro: id of the zebro to calculate speed/turning angle for
% Global Variable:
%   zebros(as a global variable):
%   zebros(i, :): information of zebro No.i
%   zebros(:, 1): x coordinate of zebro
%   zebros(:, 2): y coordinate of zebro
%   zebros(:, 3): vCeil on x coordinate of zebro
%   zebros(:, 4): vCeil on x coordinate of zebro
%   zebros(:, 5): heading of zebro. (-pi, Pi].
%                 zebros(:, 5)>0 when vX<0. zebros(:, 5)<0 when vX>0. 
% Output:
%   newzebros: updated information of zebroi. The data structure is the same with zebros
% Written by Pengqi Chen (chenpq1993@gmail.com).
global zebros;
global range; 
% Get number of zebros
nzebros = size(zebros, 1);            
%flag=0; % 0, Initial value
        % 1, Need to avoid collision with close zebros
%zebro = zeros(1,5);
zebro = zebros(izebro, :); % zebro = [x, y, vX, vY, zAnglePi]
x = zebro(1);
y = zebro(2);
% Calculate the distance from zebro i to all zebros(including itself)    
distance = zeros(nzebros, 1);    
for jZebro = 1:nzebros
        other = zebros(jZebro, :);
        dis = sqrt((zebro(1) - other(1))^2 + (zebro(2) - other(2))^2);
        distance(jZebro) = dis;
end    
neiInRan = zeros(nzebros, 3); % Neighbors in range
                              % rel. distance, rel. angle, id
numInRan = 0;                 % number of neighbor zebros in the detection range of zebroi
for jZebro = 1:nzebros
    if (jZebro ~= izebro) && (distance(jZebro) <  range)
        numInRan = numInRan + 1;
        xNeij = zebros(jZebro, 1);
        yNeij = zebros(jZebro, 2);
        vPre = [-sin(zebro(5)) cos(zebro(5))];    % vector of previous velocity
        vCur = [(xNeij - x) (yNeij - y)];         % vector from the zebroi to neighborj
        relAngle = tAngleCal(vPre, vCur);         % angle
        relAnglePi = relAngle(1);
        neiInRan(numInRan, 1) = distance(jZebro);
        neiInRan(numInRan, 2) = relAnglePi;
        neiInRan(numInRan, 3) = jZebro;
    end
end
if numInRan > 0
    speed = sqrt(zebro(3)^2 + zebro(4)^2);
    neiInRan = neiInRan(1:numInRan, :);
    output = dispersion(neiInRan, speed);
    newSpeed = output(1);
    tAngle = output(2);
    zAnglePi = zebro(5) - tAngle; 
    zAnglePi = limAn2Pi(zAnglePi); %limit zAnglePi in (-pi, pi]
    vX = -sin(zAnglePi) * newSpeed;
    vY = cos(zAnglePi) * newSpeed; 
else
    kv = 2/5;
    %kv = 0;
    vX = kv * zebro(3);
    vY = kv * zebro(4);
    v = sqrt(vX^2 + vY^2);
    sFloor = 0.2;   % Speed Floor
    if v < sFloor 
        vX = 0;
        vY = 0;
    end
    zAnglePi = zebro(5);
end
% Output of the function
newzebroi = [vX + x, vY + y, vX, vY, zAnglePi];
end