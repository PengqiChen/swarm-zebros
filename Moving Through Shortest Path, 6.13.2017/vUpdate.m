function [v] = vUpdate(vX, vY, angle)
% Update the velocity
% The value of speed will not change. The heading will be angle
% Therefore the speed on x-axis and y axis will change
% Input:
%   vX: speed on x-axis
%   vY: speed on y-axis
%   angle: new heading 
% Output:
%   v:
%       v(1, 1): updated speed on x-axis
%       v(1, 2): updated speed on y-axis
% Written by Pengqi Chen (chenpq1993@gmail.com).
    v = sqrt(vX^2 + vY^2);
    vX = -1 * v * sin(angle);
    vY = v * cos(angle);
    v(1, 1) = vX;
    v(1, 2) = vY;
end