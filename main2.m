%Interaktywne narzêdzie do auralizacji akustyki pomieszczenia
%wykorzystuj¹ce nagrania ambisoniczne.

clear all;

%zobaczyc inna baze hrtf - czy przesuniecie b/r jest tam 30 probek czy tak
%jak tu 23-25?

%no i chyba juz splot kolowy - nowa komenda bo soundsc wkurwia

base_no=1030;
ang=180;

[hly, hry]=makeBase_v2(base_no, ang);

load('impy.mat');
imp=impy;

%HY(w)*A(w)
[y,Fs]=audioread('intro.wav');
y=y(1:96000,1);
y=resample(y,44100,48000);

% aW=conv(imp(:,1),y);
% aX=conv(imp(:,2),y);
% aY=conv(imp(:,3),y);
% aZ=conv(imp(:,4),y);


b=zeros(size(imp,1)+size(y,1)-1,2);

for i=1:4
 a(:,i)=conv(imp(:,i),y);
 b(:,1)=b(:,1)+fftfilt(hly(:,i),a(:,i));
 b(:,2)=b(:,2)+fftfilt(hry(:,i),a(:,i));
end

for i=1
% aW=imp(:,1);
% aX=imp(:,2);
% aY=imp(:,3);
% aZ=imp(:,4);

% aW=zeros(44100,1);
% aW(1)=1/sqrt(4*pi);
% aX=zeros(44100,1);
% aY=zeros(44100,1);
% aZ=zeros(44100,1);
% aY(1)=-sqrt(3/(8*pi));
% aWXYZ=[aW(1) aX(1) aY(1) aZ(1)];
% sfield=Y*aWXYZ';
% imagesc(reshape(sfield(1:168),24,7));colorbar;
end %mozliwe sprawdzenie skad idzie dzwiek




