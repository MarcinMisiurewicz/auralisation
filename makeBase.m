clear all

ang=90;
ang=ang*pi/180;

%wczytanie wektorów k¹tów bazy HRIR
load('IRC_1043_C_HRIR.mat');
filename='1043_C_hly_hry';

theta=l_eq_hrir_S.elev_v*pi/180;
phi=l_eq_hrir_S.azim_v*pi/180;
hl=l_eq_hrir_S.content_m;
hr=r_eq_hrir_S.content_m;

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

hly_hry=struct('hly',hly,'hry',hry);
save(filename,'hly_hry');
