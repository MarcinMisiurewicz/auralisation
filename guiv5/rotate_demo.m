clear all;

load IRC_1002_C_HRIR.mat

for f=1
theta=l_eq_hrir_S.elev_v*pi/180;
phi=l_eq_hrir_S.azim_v*pi/180;
hl=l_eq_hrir_S.content_m;
hr=r_eq_hrir_S.content_m;
%theta=pi/2-theta; %zmiana 0st wg definicji k¹tów harmonik sferycznych (k¹t bazy HRTF elev=0st dla theta=90

%Wyznaczenie harmonik sferycznych dla k¹tów bazy
for i=1:length(theta) 
    Y00(i)=1/sqrt(4*pi);
    Ym11(i)=sqrt(3/(8*pi))*sin(theta(i))*cos(phi(i));
    Y11(i)=-sqrt(3/(8*pi))*sin(theta(i))*sin(phi(i));
    Y01(i)=sqrt(3/(4*pi))*cos(theta(i));
end

Y=[Y00; Ym11; Y11; Y01];
Y=pinv(Y);
clear Y00 Y01 Y11 Ym11
end
hAng=15;
vAng=15;
v2Ang=0;
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



figure(1)
scatter3(x,y,z)
xlabel('x')
ylabel('y')
zlabel('z')

hold on

scatter3(x1,y1,z1)

for i=1:187
    temp=[x(i),y(i),z(i); x1(i), y1(i), z1(i)];
    plot3(temp(:,1),temp(:,2),temp(:,3),'red')
end

figure(2)
scatter3(x,y,z)
xlabel('x')
ylabel('y')
zlabel('z')

hold on
vAng=vAng*pi/180;

r=ones(length(phi),1);
[x1,y1,z1]=sph2cart(phi+5*pi/180,theta,r);

scatter3(x1,y1,z1)
for i=1:length(k)
    
    temp=[x(i),y(i),z(i); x1(k(i)), y1(k(i)), z1(k(i))];
    plot3(temp(:,1),temp(:,2),temp(:,3),'red')
end


% [theta2,phi2,r]=cart2sph(x,y,z);