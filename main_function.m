function [ b ] = main_function(ang, base_no)
%   tworzenie �cie�ki binauralnej
%   funkcja tworzy �cie�k� binauraln� b=[lewy g�o�nik, prawy g�o�nik] dla
%   k�ta ang i bazy HRTF o numerze base_no

[hly, hry]=makeBase_v2(base_no, ang); % stworzneie filtr�w dla ka�dej ze �cie�ek W X Y Z
load('impx.mat'); %wczytanie nagrania testowego - przefiltrowanego, obci�tego impulsu z kierunku x
imp=impx;

%HY(w)*A(w)
[y,Fs]=audioread('intro.wav'); %wczytanie muzyki, kt�ra zostanie spleciona z impulsem, aby finalna �cie�ka binauralna zawiera�a wi�cej ni� impuls
y=y(1:96000,1); %stereo2mono i obci�cie nagrania do niewielkiego rozmiaru
y=resample(y,44100,48000);

b=zeros(size(imp,1)+size(y,1)-1,2); % prealokacja
for i=1:4 %splot impulsu z muzyk� i filtracja
 a(:,i)=conv(imp(:,i),y);
 b(:,1)=b(:,1)+fftfilt(hly(:,i),a(:,i));
 b(:,2)=b(:,2)+fftfilt(hry(:,i),a(:,i));
end

end

