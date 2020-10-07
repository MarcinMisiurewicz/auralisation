function [ b ] = chunkFiltration(ang, Y, imp, chunk,sig)
%UNTITLED Summary of this function goes here

%Interaktywne narzêdzie do auralizacji akustyki pomieszczenia
%wykorzystuj¹ce nagrania ambisoniczne.

[hly, hry]=rotateBase(ang,Y);

%HY(w)*A(w)
sig=sig(chunk(1):chunk(2),:);

b=zeros(size(imp,1)+size(sig,1)-1,2);

for i=1:4
 a(:,i)=conv(imp(:,i),sig);
 b(:,1)=b(:,1)+fftfilt(hly(:,i),a(:,i));
 b(:,2)=b(:,2)+fftfilt(hry(:,i),a(:,i));
end



end

