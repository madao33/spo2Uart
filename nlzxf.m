function resultCorrect=nlzxf(inputDate,correctNum,fs)
%功能：离散频谱校正能量重心法，适用单频点信号校正，只采用了加汉宁窗的结果
%注意:信号的模型为Acos(2*pi*f*t+pha),注意t从0开始，correctNum为采用校正的正点数，汉宁窗通常采用两点就可以获得很高的精度
%输入：inputDate待分析数据，数据长度为偶数，统一为行向量；fs采样频率
%输出：resultCorrect校正后的频率，幅值，相位结果
resultCorrect=zeros(1,4);   
N=length(inputDate);    %数据长度
w=hann(N,'periodic');   %生成汉宁窗
fftDate=fft(inputDate.*w');  
k=8/3;  %2.667              %汉宁窗恢复系数 
fftDate=fftDate(1:N/2)/N*2;      %单边复数谱  
fftDateMag=abs(fftDate);         %单边幅值谱
fftDatePower=fftDateMag.^2;      %单边功率谱
[~,maxIndex]=max(fftDatePower);     %功率最大值对应位置
maxAngle=angle(fftDate(maxIndex));  %最大值处对应的相位  
dn=-correctNum:correctNum;
f=sum((maxIndex+dn).*fftDatePower(maxIndex+dn))/sum(fftDatePower(maxIndex+dn));   %归一化校正频率      

Ik=real(fftDate(maxIndex));
Rk=imag(fftDate(maxIndex));


resultCorrect(1,1)=(f-1)*fs/N;       %频率校正结果,注意matlab下标是从1开始的
resultCorrect(1,2)=sqrt(k*sum(fftDatePower(maxIndex+dn)));    %校正幅值结果  
resultCorrect(1,4)=maxAngle+pi*(maxIndex-f);                  %校正相位结果
resultCorrect(1,3)=atan(Ik/Rk)+pi*(maxIndex-f);
resultCorrect(1,3)=mod(resultCorrect(1,3),2*pi);
resultCorrect(1,3)=resultCorrect(1,3)-(resultCorrect(1,3)>pi)*2*pi;    %象限定在（-pi,pi]  
end