function [xy] = recRot(zLength, zWidth, x, y, oAngle, rAngle)
% rectangle rotation
% Input:
%   zLength: length
%   zWidth: zebro width
%   x, y : coordinates of zebro(rectangle) center
%   oAngle: angle between the diagonle and the width
%   rAngle: heading of the zebro, which uses [0, 1] as reference)
% Output:
%   xy(): coordinates of vertex of the rectangle after rotation.
% Written by Pengqi Chen (chenpq1993@gmail.com).
    diagonal = sqrt(zLength^2+zWidth^2);
    d = diagonal/2;
    p1=[cos(oAngle + rAngle),sin(oAngle + rAngle)];
    p2=[cos(pi-oAngle + rAngle),sin(pi-oAngle + rAngle)];
    p3=[cos(oAngle + rAngle+pi),sin(oAngle + rAngle+pi)];
    p4=[cos(2*pi-oAngle + rAngle),sin(2*pi-oAngle + rAngle)];
    rect=[p1;p2;p3;p4;p1];
    rectReal=rect * d;
    rectReal(:,1)=rectReal(:,1) + x;
    rectReal(:,2)=rectReal(:,2) + y;
    xy(:,1) = rectReal(:,1);
    xy(:,2) = rectReal(:,2);
end