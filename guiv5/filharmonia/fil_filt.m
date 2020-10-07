clear all

load('invfilter.mat')

for i=1:10
   [ytemp, fs]=audioread(['imp_no_' num2str(i) '.wav']);
   for k=1:4
        y(:,k)=resample(ytemp(:,k),44100,fs);
   end
   y2=y(1160:end,:);
   impulseMap(:,:,i)=y2;
end

figure(1)
plot(impulseMap(:,:,1))

invfilter=resample(invfilter,44100,51200);

for i=1:10
    for k=1:4
        impulseMap(:,k,i)=filter(invfilter(:,k),1,impulseMap(:,k,i));
    end
end


figure(2)
plot(impulseMap(:,:,1))

