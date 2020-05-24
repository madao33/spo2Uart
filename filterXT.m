function waveform=filterXT(a)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%形态学滤波
fs=496;
k=0:(2*pi/fs):pi;
o=sin(k);
op=1;
H=min(a);
g=H*o;
a2=fushi2(a,g,op);      %开运算
a2=pengzhang2(a2,g,op);

a2=pengzhang2(a2,g,op); %闭运算
a2=fushi2(a2,g,op);


waveform=a2;