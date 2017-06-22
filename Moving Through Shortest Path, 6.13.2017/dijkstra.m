function [list]=dijkstra(sZebro,dZebro)
% Input:
%   sZebro: source zebro
%   dZebro: destination zebro
% Global Variable:
%   zebroXY: coordinates of zebros
%   range: detection range of zebros
% Output:
%   list: list of ids of zebros on shortest path
% Written by Pengqi Chen (chenpq1993@gmail.com).
% Reference: https://github.com/iagocaldeira/dijkstra-matlab/blob/master/dijkstra.m
global zebroXY;             
global range;  
N = length(zebroXY);        % Number of zebros
A = false(N);               % Adjacency Matrix
previous = zeros();         % previous(i), previous zebro of zebro i on shortest path.     
later =  zeros();           % later(i) = 0, shortest path from the zebro 
                            % to source zebro has not been calculated
                            % later(i) = 0, the value has been calculated
C = sZebro;                 % Current zebro for calculation
odo = zeros();              % Odometer
dist = zeros(N);            % Distance matrix
for i = 1:N
    for j = 1:i
        if i == j
            continue;
        end
        dist(j, i) = sqrt((zebroXY(i).pos(1) - zebroXY(j).pos(1))^2 + ... 
                     (zebroXY(i).pos(2) - zebroXY(j).pos(2))^2);
        dist(i, j) = sqrt((zebroXY(i).pos(1) - zebroXY(j).pos(1))^2 + ...
                     (zebroXY(i).pos(2) - zebroXY(j).pos(2))^2);
        if dist(j, i) < range
            A(i, j) = true;
            A(j, i) = true;
        end
    end
end

for i = 1:N
    later(i) = 0;
    odo(i) = 10000;
end

odo(C) = 0;
%Iteration
while (C ~= dZebro) && (C ~= 0)
    for i = 1:N
        if(i ~= C) && (dist(C, i) < range) && (later(i) == 0)
            thisdist = odo(C) + dist(C, i);
            if thisdist < odo(i)  
                odo(i) = thisdist;
                previous(i) = C;  
            end
        end
    end
    %determination of the next C
    later(C) = 1;       
    min = 10000;
    C = 0;
    for i = 1:N
        if(later(i) == 0) && (odo(i) < min)
            min = odo(i);
            C = i;
        end
    end
end
if C == dZebro
    list = C;
    num = 0;
    while C ~= sZebro
        num = num + 1;
        list(num + 1) = previous(C); 
        C = previous(C);
    end
    list = fliplr(list); % from source to destination 
else
    disp('There is no available path between the two zebros \n');
end
end