function [ b ] = main_function(ang, base_no)
%   tworzenie œcie¿ki binauralnej
%   funkcja tworzy œcie¿kê binauraln¹ b=[lewy g³oœnik, prawy g³oœnik] dla
%   k¹ta ang i bazy HRTF o numerze base_no

[hly, hry]=makeBase_v2(base_no, ang); % stworzneie filtrów dla ka¿dej ze œcie¿ek W X Y Z
load('impx.mat'); %wczytanie nagrania testowego - przefiltrowanego, obciêtego impulsu z kierunku x
imp=impx;

%HY(w)*A(w)
[y,Fs]=audioread('intro.wav'); %wczytanie muzyki, która zostanie spleciona z impulsem, aby finalna œcie¿ka binauralna zawiera³a wiêcej ni¿ impuls
y=y(1:96000,1); %stereo2mono i obciêcie nagrania do niewielkiego rozmiaru
y=resample(y,44100,48000);

b=zeros(size(imp,1)+size(y,1)-1,2); % prealokacja
for i=1:4 %splot impulsu z muzyk¹ i filtracja
 a(:,i)=conv(imp(:,i),y);
 b(:,1)=b(:,1)+fftfilt(hly(:,i),a(:,i));
 b(:,2)=b(:,2)+fftfilt(hry(:,i),a(:,i));
end

end

