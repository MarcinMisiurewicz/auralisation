%Interaktywne narzêdzie do auralizacji akustyki pomieszczenia
%wykorzystuj¹ce nagrania ambisoniczne.

clear all;

load('1043_C_hly_hry.mat');
hly=hly_hry.hly;
hry=hly_hry.hry;

load('impy.mat');
imp=impy;

%HY(w)*A(w)
[y,Fs]=audioread('intro.wav');
y=y(1:96000,1);
y=resample(y,44100,48000);

aW=conv(imp(:,1),y);
aX=conv(imp(:,2),y);
aY=conv(imp(:,3),y);
aZ=conv(imp(:,4),y);

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
% 
% aWXYZ=[aW(1) aX(1) aY(1) aZ(1)];
% 
% sfield=Y*aWXYZ';
% imagesc(reshape(sfield(1:168),24,7));colorbar;

A=[fft(aW), fft(aX), fft(aY), fft(aZ)]';

bl=fftfilt(hly(:,1),aW)+fftfilt(hly(:,2),aX)+fftfilt(hly(:,3),aY)+fftfilt(hly(:,4),aZ);%filtracja a nie mno¿enie macierzy, bo musi tu byæ mno¿enie funkcji w dziedzinie omega z funkcj¹ w dziedzinei omega
br=fftfilt(hry(:,1),aW)+fftfilt(hry(:,2),aX)+fftfilt(hry(:,3),aY)+fftfilt(hry(:,4),aZ);
b=[bl,br]; %cz. probkowania b to 44100
