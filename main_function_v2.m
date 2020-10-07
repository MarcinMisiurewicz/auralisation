function [ b ] = main_function_v2(ang, base_no,chunk,sig)
%UNTITLED Summary of this function goes here

%Interaktywne narzêdzie do auralizacji akustyki pomieszczenia
%wykorzystuj¹ce nagrania ambisoniczne.




[hly, hry]=makeBase_v2(base_no, ang);
load('impx.mat');
imp=impx;

%HY(w)*A(w)
sig=sig(chunk(1):chunk(2),:);

% aW=conv(imp(:,1),y);
% aX=conv(imp(:,2),y);
% aY=conv(imp(:,3),y);
% aZ=conv(imp(:,4),y);


b=zeros(size(imp,1)+size(sig,1)-1,2);

for i=1:4
 a(:,i)=conv(imp(:,i),sig);
 b(:,1)=b(:,1)+fftfilt(hly(:,i),a(:,i));
 b(:,2)=b(:,2)+fftfilt(hry(:,i),a(:,i));
end



end

