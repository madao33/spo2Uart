function waveformT=filterXTT(a,n)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%形态学滤波
m=n;
g=zeros(1,m);
for i=1:m
    g(i)=1;
end
op=1;
a1=fushi2(a,g,op);
a1=pengzhang2(a1,g,op);%kai
a1=pengzhang2(a1,g,op);%bi
a1=fushi2(a1,g,op);

a3=pengzhang2(a,g,op);%闭运算
a3=fushi2(a3,g,op);
a3=fushi2(a3,g,op);
a3=pengzhang2(a3,g,op);%开运算

a22=a1/2+a3/2;
a32=a-a22;
waveformT=a32;