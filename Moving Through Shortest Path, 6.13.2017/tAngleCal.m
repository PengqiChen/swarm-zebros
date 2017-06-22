function[tAngle] = tAngleCal(a, b)
% To calculate the angle between vector b and vector a.
% Vector_a is the basis.
% Clockwise turning until pi, tAnglePi>0
% Anticlockwise turning until -pi, tAnglePi<0
% Input:
%   a: one vector
%   b: one vector
% Output:
%   tAngle(1): tAnglePi, turning angle represented by pi
%   tAngle(2): tAngle180, turning angle represented by degrees
% Written by Pengqi Chen (chenpq1993@gmail.com).
    a =a'; %basis vector
    b =b'; %vector  
    tAngle180 = mod(atan2d([a(2) -a(1)]*b,sum(a.*b)),360);
    if(tAngle180 > 180)
        tAngle180 = -360 + tAngle180; 
    end
    tAnglePi = tAngle180 * pi / 180;
tAngle=[tAnglePi tAngle180];