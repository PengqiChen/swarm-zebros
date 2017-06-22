function [zebroi] = dispersion(neiInRan, speed)
% Dispersion Algorithm 
% Input:
%   neiInRan: information of neighbor zebros in the range of zebroi.
%     neiInRan(:, 1): rel.distance from the neighbor zebro to zebroi 
%     neiInRan(:, 2): rel.angle between the neighbor zebro and zebroi
%     neiInRan(:, 3): Id of the neighbor zebro
%   speed: speed of zebroi
% Important Variable:
%   sCeil: speed limitation on zebro
%   aCeil: acceleration limitation on zebro
%   numNeighbors: maximum number of zebros to avoid
%   disDanger: dangerous distance
%   disDisp: neighbor in disDisp may have repusion on the zebro
% Output: 
%   zebroi: [v, tAngle]
%     v: new speed of zebroi
%     tAngle: turnning angle of zebroi
% Written by Pengqi Chen (chenpq1993@gmail.com).

% First check there is at least one close neighbor and than do the
% following calculation.
% if input_angle > 0, the neighbor is on the clockwise direction. 
% turn_angle > 0, turn right.
% if input_angle < 0, the neighbor is on the anticlockwise direction. 
% turn_angle < 0, turn left.
% the angle of acceleration uses the direction of the velocity as the basis.
%
% neiZebros = [1, pi/3; 1.333, -pi/3; 8, 0;];
numNeighbors = 3;                         % max number of neighbors to avoid.
disDisp = 10;
disDanger = 5;
distance = neiInRan(:, 1);        
[distance2, order] = sort(distance);
nneiZebros = 0;                             % number of neighbor zebros
numNeighbors = min(numNeighbors, length(distance));
neiZebros = zeros(numNeighbors, 3);   % neighbor zebros for calculation
for jzebro = 1:numNeighbors
    if(distance2(jzebro) < disDisp)
        nneiZebros = nneiZebros + 1;       
        neiZebros(nneiZebros,: ) = neiInRan(order(jzebro), :); % to get numNeighbors closest neighbor zebros
    end
end
% To calculate acceleration:
neiZebros = neiZebros(1: nneiZebros, :);
% To get the angle for acceleration:
for iIter = 1:nneiZebros
    neiZebros(iIter, 2) = acceAngle(neiZebros(iIter, 2));
end
aCeil = 1;
sCeil = 3;
ka = 5;
if nneiZebros == 0                        % No neighbor zebro in disDisp
    a = 0;
elseif nneiZebros == 1                    % One zebro in disDisp
    a = ka/neiZebros(1, 1);
    a = a * (aCeil) / max(a, aCeil);
    aAngle = neiZebros(1, 2);
else                                    % Equal to or More than 2 zebros in disDisp
    con1 = distance2(1) < disDanger;
    con2 = distance2(2) > disDanger;
    if con1 && con2
        ka = 8;
    end
    for jIter = 1:nneiZebros-1
        a1 = ka/neiZebros(1, 1);             % value of basis acceleration
        angle1 = neiZebros(1, 2);         % direction of basis acceleration
        a2 = ka/neiZebros(jIter + 1, 1);     
        angle2 = neiZebros(jIter + 1, 2);
        angle = angle1 - angle2;
        % angle is in range of (-pi, pi], a1 is the basis. 
        % angle > 0, a2 is on the anticlockwise direction
        % angle < 0, a2 is on the clockwise direction
        angle = limAn2Pi(angle);
        % value of the new basis acceleration
        a = sqrt(a1^2 + a2^2 + 2 * a1 * a2 * cos(angle)); 
        if a == 0               % if it is the last iteration, it also does not matter
            neiZebros(1, 1) = 0;                      
            neiZebros(1, 2) = 0;
            if(jIter == nneiZebros-1)
                aAngle = 0;
                break;
            end
            continue;
        elseif a1==0
            neiZebros(1, 1) = a2;
            neiZebros(1, 2) = angle2;
        else
            x = (a1^2 + a^2 - a2^2)/(2*a1*a);
            tangle = acos(x);
            if(angle < 0)           
                tangle = -tangle;
            end
            % The sum of acceleration is finished
            % Limit a to be in range of aCeil
            if(jIter == nneiZebros-1)
                a = a * (aCeil) / max(a, aCeil);
                aAngle = neiZebros(1, 2) - tangle;
                aAngle = limAn2Pi(aAngle);
            end
            % Next basis acceleration for calculation
            neiZebros(1, 1) = a;                      
            neiZebros(1, 2) = neiZebros(1, 2) - tangle;
            neiZebros(1, 2) = limAn2Pi(neiZebros(1, 2));
        end
    end 
end    

s = speed;
if a == 0 && s == 0
    s = 0;
    tAngle = 0;
elseif a == 0 && s ~= 0
    kv = 2/5;
    %kv = 0;
    s = kv * s;     %If there is no neighbor to avoid, just stop soon.
    tAngle = 0;
elseif a ~= 0 && s == 0
    s = a;
    tAngle = neiZebros(1, 2);
else
    kv = 3/5;
    %kv = 0;
    s = speed * kv;
    angle1 = aAngle;
    if angle1 == 0
        s = s + a;
        tAngle = 0;
    else
        s1 = sqrt(a^2 + s^2 + 2 * a * s * cos(angle1));
        if s1 == 0               % if it is the last iteration, it also does not matter
            s = 0;
            tAngle = 0;
        else
            x = (s^2 + s1^2 - a^2)/(2*s*s1);
            tAngle = acos(x);
            if angle1 < 0
                tAngle = -tAngle;           
            end
            s = s1;
        end
    end
end

sFloor = 0.2;   % Speed Floor
if s < sFloor
    s = 0;
    tAngle = 0; 
end

s = s * (sCeil) / max(s, sCeil);
tAngle = limAn2Pi(tAngle);
zebroi = [s, tAngle];