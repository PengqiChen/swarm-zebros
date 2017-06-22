function [zebros] = initZebros(nZebros)
% Initialize zebros
% Input:
%   nZebros: number of zebros
% Global Variable
%   zLength: zebro length
%   skyX: bound on x Axis
%   skyY: bound on y Axix
% Output:
%   zebros:
%       zebros(i, :): information of zebro No.i
%       zebros(:, 1): x coordinate of zebro
%       zebros(:, 2): y coordinate of zebro
%       zebros(:, 3): speed on x coordinate of zebro
%       zebros(:, 4): speed on x coordinate of zebro
%       zebros(:, 5): heading of zebro
% Written by Pengqi Chen (chenpq1993@gmail.com).
global zLength skyX skyY;
zebros = zeros(nZebros, 5);
flag = 2;   %1: Initial shape of swarm: circle
            %2: Initial shape of swarm: rectangle
switch(flag)
    case 1
        R1 = zLength * max(floor(nZebros / 10), 2);       
        r1 = unifrnd(0, 1, nZebros, 1);
        theta1 = 2 * pi * rand(nZebros, 1);
        R2 = skyX * 1 / 4;       
        r2 = unifrnd(0, 1, (nZebros - nZebros), 1);
        theta2 = 2 * pi * rand((nZebros - nZebros), 1);

        zebros(1:nZebros, 1) = R1 * sqrt(r1).* cos(theta1) + skyX * 1 / 2;
        zebros(1:nZebros, 2) = R1 * sqrt(r1).* sin(theta1) + skyY * 1 / 2;

        zebros((nZebros+1):nZebros, 1) = R2 * sqrt(r2).* cos(theta2) + skyX * 1 / 2;
        zebros((nZebros+1):nZebros, 2) = R2 * sqrt(r2).* sin(theta2)+skyY * 1/ 2;
    case 2
        num_x = floor(sqrt(nZebros));
        for iZebro = 1:nZebros
            zebros(iZebro,1) = rem(iZebro-1, num_x) * 2 * zLength + skyX * 1/2-...
                               floor(num_x/2) * 2 * zLength;
            zebros(iZebro,2) = floor((iZebro-1)/num_x) * 2 * zLength + skyY * 1/2 -...
                               floor(num_x/2) * 2 * zLength;
        end
            zebros(:, 1) = zebros(:, 1)+(rand(nZebros, 1) - 1) * 1;
            zebros(:, 2) = zebros(:, 2)+(rand(nZebros, 1) - 1) * 1;
    otherwise
        disp('No valid flag');
end

    zebros(:, 3) = 0;
    zebros(:, 4) = 0;
    anglePi = 2 * pi * rand(nZebros, 1) - pi;
    zebros(:, 5) = anglePi;
end

