function [ W, X, Y, Z ] = a2b( y )
%A2 Summary of this function goes here
%   Detailed explanation goes here

FLU=y(:,1);
FRD=y(:,2);
BLD=y(:,3);
BRU=y(:,4);

clear y;

% W = FLU+FRD+BLD+BRU;
% X = FLU+FRD-BLD-BRU;
% Y = FLU-FRD+BLD-BRU;
% Z = FLU-FRD-BLD+BRU;

Wp = FLU+FRD+BLD+BRU;
Xp = FLU+FRD-BLD-BRU;
Yp = FLU-FRD+BLD-BRU;
Zp = FLU-FRD-BLD+BRU;

[fw, fxyz]=filterdesig(48000,0.015);

W=filter(fw,1,Wp);
X=filter(fxyz,1,Xp);
Y=filter(fxyz,1,Yp);
Z=filter(fxyz,1,Zp);

end

