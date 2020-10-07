Nx=2048*1024;
x=randn(1,Nx);

x(100)=1;
x(1200)=2;


Nh=1024*128;
h=randn(1,Nh);

h(200:250)=3;
h(600)=4;


plot(1:Nx,x,1:Nh,h)

%tic;yf=filter(h,1,x);toc
tic;yff=fftfilt(h,x);toc
tic;yfff=fffilt(h,x,2048);toc

%plot(1:Nx,x,1:Nh,h,1:length(yf),yf,1:length(yff),yff)


plot(yff(:)-yfff(:));