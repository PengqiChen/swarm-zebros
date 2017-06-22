function[Angle] = limAn2Pi(angle)
% To limit an angle in the range: (-pi, pi]
% Input:
%   angle: original angle
% Output:
%   Angle: angle after transformation
% Written by Pengqi Chen (chenpq1993@gmail.com).
if(angle > pi)
    angle = angle - 2 * pi;
elseif(angle <= -pi)
    angle = 2 * pi + angle;
end
Angle = angle;