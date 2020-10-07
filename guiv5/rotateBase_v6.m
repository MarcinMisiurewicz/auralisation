function [ hly, hry ] = rotateBase( hAng,vAng,v2Ang, Y )
%   tworzenie filtrów H*Y
%   tworzy filtry dla ka¿dej ze œcie¿ek (W, X, Y, Z) nagrania ambisonicznego - operacja H*Y, gdzie H to HRTF a Y to harmoniki sferyczne

Hl=getappdata(0,'Hl');
Hr=getappdata(0,'Hr');

%obrót o k¹t ang
k1=round(hAng/15); %poniewa¿ baza HRTF jest dyskrenta z delta = 15st, przesuniêcie bazy nast¹pi o k1 miejsc
for i=1:7 %przesuniêcie bazy o k1 miejsc dla k¹tów elev od -45 do 45
    Y(i*24-23:i*24,:)=circshift(Y(i*24-23:i*24,:),k1);
end
k2=round(hAng/30); %baza HRTF dla elev=60st jest dyskrenta z delta = 30 st
Y(169:180,:)=circshift(Y(169:180,:),k2);
k3=round(hAng/60); %baza HRTF dla elev=75st jest dyskrenta z delta = 60 st
Y(182:186,:)=circshift(Y(182:186,:),k3);
%baza HRTF dla elev=90st ma tylko jeden filtr

%obrót o k¹t vAng
phi=getappdata(0,'phiapp');
theta=getappdata(0,'thetaapp');

vAng=vAng*pi/180;

r=ones(length(phi),1);
[x1,y1,z1]=sph2cart(phi,theta,r);

y2=z1;
z2=y1;
[th,rh,z]=cart2pol(x1, y2, z2);
th=th+vAng;
[x, y2, z2]=pol2cart(th,rh,z);
y=z2;
z=y2;

X1=[x y z];
X2=[x1 y1 z1];
k=dsearchn(X2,X1);

Y2=Y;
for i=1:length(k)
    Y(i,:)=Y2(k(i),:);
end


%obrot o kat v2Ang
v2Ang=v2Ang*pi/180;

r=ones(length(phi),1);
[x1,y1,z1]=sph2cart(phi,theta,r);

x2=z1;
z2=x1;
[th,rh,z]=cart2pol(x2, y1, z2);
th=th+v2Ang;
[x2, y, z2]=pol2cart(th,rh,z);
x=z2;
z=x2;

X1=[x y z];
X2=[x1 y1 z1];
k=dsearchn(X2,X1);

Y2=Y;
for i=1:length(k)
    Y(i,:)=Y2(k(i),:);
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
hly=real(hly);
hry=real(hry);



end

