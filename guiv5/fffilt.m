function y = fffilt (h,x,N)
  h=reshape(h,N,[]);
  size(h)
  x=reshape(x,N,[]);
  H=fft(h,2*N);
  X=fft(x,2*N);
  %zakladamy ze x jest dluzsze  h
  Mx=size(x,2)
  Mh=size(h,2)

  y=zeros(size(x));

  %ywork=zeros(2*N,1);
  ywork1=zeros(N,1);    
  for ix=1:Mx
    ywork=zeros(2*N,1);
    for ih=1:Mh
      if ih>ix
	continue
      end
      ywork=ywork+(X(:,ix-ih+1).*(H(:,ih)));
    end
    ywork=ifft(ywork);
    y(:,ix)=ywork(1:N)+ywork1; %podstawienie bloku 2048
    ywork1=ywork(N+1:end);%ogonek
  end
  y=y(:);
  if isreal(x)&&isreal(h)
    y=real(y);
  end
end
