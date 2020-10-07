%Interaktywne narzêdzie do auralizacji akustyki pomieszczenia
%wykorzystuj¹ce nagrania ambisoniczne.

clear all;

%wczytanie wektorów k¹tów bazy HRIR
load('IRC_1043_R_HRIR.mat');
theta=l_hrir_S.elev_v*pi/180;
phi=l_hrir_S.azim_v*pi/180;
hl=l_hrir_S.content_m;
hr=r_hrir_S.content_m;

theta=pi/2-theta;

%Wyznaczenie harmonik sferycznych dla k¹tów bazy
for i=1:length(theta)
    Y00(i)=1/sqrt(4*pi);
    %Ym11(i)=real(sqrt(3/(8*pi))*sin(theta(i))*exp(-1i*phi(i)));
    Ym11(i)=sqrt(3/(8*pi))*sin(theta(i))*cos(phi(i));
    %Y11(i)=real(-sqrt(3/(8*pi))*sin(theta(i))*exp(1i*phi(i)));
    Y11(i)=-sqrt(3/(8*pi))*sin(theta(i))*sin(phi(i));
    Y01(i)=sqrt(3/(4*pi))*cos(theta(i));
end

Yh=[Y00; Ym11; Y11; Y01];
Y=pinv(Yh); %pseudoinwersja

for i=1:187
Hl(i,:)=fft(hl(i,:));
Hr(i,:)=fft(hr(i,:));
end

%H*Y
HlY=Hl.'*Y;
HrY=Hr.'*Y;

hly=zeros(size(HlY));
hry=zeros(size(HrY));
for i=1:4
    hly(:,i)=ifft(HlY(:,i));
    hry(:,i)=ifft(HrY(:,i));
end

%HY(w)*A(w)
[y,Fs]=audioread('intro.wav');
y=y(1:96000,1);
y=resample(y,44100,48000);

[imp,Fs]=audioread('01.bruel_y_5s.wav');
imp=resample(imp,44100,51200);

for i=1:4
invfilter(:,i)=invFIR('complex',imp(:,i),length(imp(:,i)),0,8000,[20 2000], [20 -6], 1);
imp(:,i)=filter(invfilter(:,i),1,imp(:,i));
end

aW=conv(imp(:,1),y);
aX=conv(imp(:,2),y);
aY=conv(imp(:,3),y);
aZ=conv(imp(:,4),y);

% aW=imp(:,1);
% aX=imp(:,2);
% aY=imp(:,3);
% aZ=imp(:,4);

aW=zeros(44100,1);
aW(1)=1/sqrt(4*pi);
aX=zeros(44100,1);
aY=zeros(44100,1);
aZ=zeros(44100,1);
aY(1)=-sqrt(3/(8*pi));

aWXYZ=[aW(1) aX(1) aY(1) aZ(1)];

sfield=Y*aWXYZ';
sfield2=sfield(1:168);
sfield2(169:174)=[0 0 0 0 0 0];
sfield2(175:186)=sfield(169:
imagesc((reshape(sfield(1:168),24,7))');colorbar;

A=[fft(aW), fft(aX), fft(aY), fft(aZ)]';

bl=fftfilt(hly(:,1),aW)+fftfilt(hly(:,2),aX)+fftfilt(hly(:,3),aY)+fftfilt(hly(:,4),aZ);%filtracja a nie mno¿enie macierzy, bo musi tu byæ mno¿enie funkcji w dziedzinie omega z funkcj¹ w dziedzinei omega
br=fftfilt(hry(:,1),aW)+fftfilt(hry(:,2),aX)+fftfilt(hry(:,3),aY)+fftfilt(hry(:,4),aZ);
b=[bl,br]; %cz. probkowania b to 44100
