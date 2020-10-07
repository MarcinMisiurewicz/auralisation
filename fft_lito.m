function [ f, P1 ] = fft_lito( y, Fs,a,b )
%FFT2 Summary of this function goes here
%   Detailed explanation goes here

[v,ind]=max(y);
y=y(ind+a:ind+b);
L=length(y);
Y=fft(y.*hamming(L));
P2 = abs(Y/L);
P1 = P2(1:floor(L/2)+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
end

