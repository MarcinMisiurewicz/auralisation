clear all

[impx,Fs]=audioread('01.kostka_x_5s.wav');
[impy,Fs]=audioread('01.kostka_y_5s.wav');
[impz,Fs]=audioread('01.kostka_z_5s.wav');


invfilter(:,1)=invFIR('complex',impx(:,1),length(impx(:,1)),0,3000,[20 2000], [20 -6], 1);
invfilter(:,2)=invFIR('complex',impx(:,2),length(impx(:,2)),0,3000,[20 2000], [20 -6], 1);
invfilter(:,3)=invFIR('complex',impy(:,3),length(impy(:,3)),0,3000,[20 2000], [20 -6], 1);
invfilter(:,4)=invFIR('complex',impz(:,4),length(impz(:,4)),0,3000,[20 2000], [20 -6], 1);

for i=1:4
impx(:,i)=filter(invfilter(:,i),1,impx(:,i));
end

for i=1:4
impy(:,i)=filter(invfilter(:,i),1,impy(:,i));
end

for i=1:4
impz(:,i)=filter(invfilter(:,i),1,impz(:,i));
end

impx=resample(impx,44100,51200);
impy=resample(impy,44100,51200);
impz=resample(impz,44100,51200);

save('impx','impx')
save('impy','impy')
save('impz','impz')
save('invfilter','invfilter')







