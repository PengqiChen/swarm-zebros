function[an] = angleBet2Vec(a,b)
% Compute angle between 2 vectors
% input
%   a: basis vector as the reference
%   b: the other vector
% Output:
%   an(1): angle represented by pi
%   an(2): angle represented by degrees
% Written by Pengqi Chen (chenpq1993@gmail.com).
    cosAB=dot(a,b)/(norm(a)*norm(b));
    an(1)= acos(cosAB);
    an(2)= rad2deg(acos(cosAB));
end