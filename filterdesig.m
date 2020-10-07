function [fw, fxyz] = filterdesig( Fs, r )

c=343;
f=1:10:Fs/2;
om=2*pi*f;
FW=zeros(1,length(f));

for i=1:1:length(f);
    FW(i)=(1+(1i*om(i)*r/c)-((om(i)*r/c)^2)/3)/(1+((1i*om(i)*r)/(3*c)));
    FXYZ(i)=sqrt(6)*(1+(1i*om(i)*r/(3*c))-((om(i)*r/c).^2)/3)/(1+((1i*om(i)*r)/(3*c)));
end

FW=[FW conj(FW(end:-1:1))];
FW=FW.*hamming(length(FW))';
FXYZ=[FXYZ conj(FXYZ(end:-1:1))];
FXYZ=FXYZ.*hamming(length(FXYZ))';

fw=fftshift(real(ifft(FW)));
fxyz=fftshift(real(ifft(FXYZ)));



% [H, W]=freqz(fw);
% figure(1)
% semilogx(W/pi*24000, 20*log10(abs(H)));
% figure(2)
% semilogx(W/pi*24000, 180/pi*unwrap(angle(H)), '-*');
% 
% figure(3)
% plot(fw)
% 
% figure(4)
% freqz(fw)