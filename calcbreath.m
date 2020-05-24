function br = calcbreath(data)
LL=length(data);
if (mod(LL,2))
    data1=data(1:LL-1);
else
    data1=data;
end
data1=filterXT(data1);
data1=filterXTT(data1,45);
% data2=fft(data1);
% data2(1)=0;
% data1=ifft(data2);
% data1=data1(1:98);
resultCorrect=nlzxf(data1,1,8);
br=resultCorrect(1,1)*60;
end