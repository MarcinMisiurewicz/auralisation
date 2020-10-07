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

vAng=0;
vAng=vAng*pi/180;

r=ones(length(phi),1);
[x1,y1,z1]=sph2cart(phi,theta,r);

x2=z1;
z2=x1;
[th,rh,z]=cart2pol(x2, y1, z2);
th=th+vAng;
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
for i=1:7
    plot3(x((i-1)*24+1:i*24),y((i-1)*24+1:i*24),z((i-1)*24+1:i*24),'blue')
end
plot3(x(169:180),y(169:180),z(169:180),'blue')
plot3(x(181:186),y(181:186),z(181:186),'blue')

hold on

scatter3(x1,y1,z1)
for i=1:length(k)
    
    temp=[x(i),y(i),z(i); x1(k(i)), y1(k(i)), z1(k(i))];
    plot3(temp(:,1),temp(:,2),temp(:,3),'red')
end


% [theta2,phi2,r]=cart2sph(x,y,z);