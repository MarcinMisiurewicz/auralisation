function [ hly, hry ] = rotateBase( ang,Y )
%   tworzenie filtrów H*Y
%   makeBase tworzy filtry dla ka¿dej ze œcie¿ek (W, X, Y, Z) nagrania ambisonicznego - operacja H*Y, gdzie H to HRTF a Y to harmoniki sferyczne

ang=-ang; %aby k¹t by³ intuicyjny - roœnie zgodnie z ruchem wskazówek zegara prawo 90st, lewo -90st
ang
hl=getappdata(0,'hl');
hr=getappdata(0,'hr');

%obrót o k¹t ang
k1=round(ang/15); %poniewa¿ baza HRTF jest dyskrenta z delta = 15st, przesuniêcie bazy nast¹pi o k1 miejsc
for i=1:7 %przesuniêcie bazy o k1 miejsc dla k¹tów elev od -45 do 45
    Y(i*24-23:i*24,:)=circshift(Y(i*24-23:i*24,:),k1);
end
k2=round(ang/30); %baza HRTF dla elev=60st jest dyskrenta z delta = 30 st
Y(169:180,:)=circshift(Y(169:180,:),k2);
k3=round(ang/60); %baza HRTF dla elev=75st jest dyskrenta z delta = 60 st
Y(182:186,:)=circshift(Y(182:186,:),k3);
%baza HRTF dla elev=90st ma tylko jeden filtr

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

end

