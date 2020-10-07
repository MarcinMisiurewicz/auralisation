clear all
close all
clc

[s Fs] = audioread('t3.wav');
s=-s(:,1);

figure(1)
hold on
plot(s)

k = invFIR('complex',s(350:1100),1024,0,512,[40 22000],[20 -20],1);
%k = kirkeby(s(320:1109),[20 16000],[1 0.001],51200);

figure
plot(k)

h3 = conv(s,k);
figure(1)
plot(h3)

