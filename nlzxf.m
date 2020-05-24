function resultCorrect=nlzxf(inputDate,correctNum,fs)
%���ܣ���ɢƵ��У���������ķ������õ�Ƶ���ź�У����ֻ�����˼Ӻ������Ľ��
%ע��:�źŵ�ģ��ΪAcos(2*pi*f*t+pha),ע��t��0��ʼ��correctNumΪ����У������������������ͨ����������Ϳ��Ի�úܸߵľ���
%���룺inputDate���������ݣ����ݳ���Ϊż����ͳһΪ��������fs����Ƶ��
%�����resultCorrectУ�����Ƶ�ʣ���ֵ����λ���
resultCorrect=zeros(1,4);   
N=length(inputDate);    %���ݳ���
w=hann(N,'periodic');   %���ɺ�����
fftDate=fft(inputDate.*w');  
k=8/3;  %2.667              %�������ָ�ϵ�� 
fftDate=fftDate(1:N/2)/N*2;      %���߸�����  
fftDateMag=abs(fftDate);         %���߷�ֵ��
fftDatePower=fftDateMag.^2;      %���߹�����
[~,maxIndex]=max(fftDatePower);     %�������ֵ��Ӧλ��
maxAngle=angle(fftDate(maxIndex));  %���ֵ����Ӧ����λ  
dn=-correctNum:correctNum;
f=sum((maxIndex+dn).*fftDatePower(maxIndex+dn))/sum(fftDatePower(maxIndex+dn));   %��һ��У��Ƶ��      

Ik=real(fftDate(maxIndex));
Rk=imag(fftDate(maxIndex));


resultCorrect(1,1)=(f-1)*fs/N;       %Ƶ��У�����,ע��matlab�±��Ǵ�1��ʼ��
resultCorrect(1,2)=sqrt(k*sum(fftDatePower(maxIndex+dn)));    %У����ֵ���  
resultCorrect(1,4)=maxAngle+pi*(maxIndex-f);                  %У����λ���
resultCorrect(1,3)=atan(Ik/Rk)+pi*(maxIndex-f);
resultCorrect(1,3)=mod(resultCorrect(1,3),2*pi);
resultCorrect(1,3)=resultCorrect(1,3)-(resultCorrect(1,3)>pi)*2*pi;    %���޶��ڣ�-pi,pi]  
end