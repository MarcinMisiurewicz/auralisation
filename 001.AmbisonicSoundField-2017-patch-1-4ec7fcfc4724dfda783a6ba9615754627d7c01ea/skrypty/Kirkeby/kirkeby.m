function filter=kirkeby(s,freq,gain,fs)

n=length(s);
f=0:(fs/n):fs-(fs/n);

e(1:n/2)=gain(1);
e(f<freq(2))=gain(2);
e(f<freq(1))=gain(1);
e=[e fliplr(e)];
S=fft(s);

C=conj(S)./((conj(S).*S)+e');

filter=ifft(C,'symmetric');
%plot(filter);