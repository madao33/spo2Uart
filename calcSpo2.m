function [spo2,hr] = calcSpo2(data)
%calcSpo2 �������ʣ�Ѫ�����Ͷ�
%   data-�������ݣ�spo2-Ѫ�����Ͷȣ�hr-����
[channels,dlength] = size(data);
diff = zeros(channels,dlength);
% �����⼰�������
for i=1:channels
    for j=1:dlength-4
        diff(i,j) = data(i,j)-data(i,j+4);
        if diff(i,j)<0
            diff(i,j)=0;
        end
    end
end
spo2Peak = ones(1,10);
peakNum = 1;
spo2Trough = ones(1,10);
troughNum = 1;
thresh = 30;
for i=2:dlength-1
    %������ּ���ֵ
    if diff(2,i)>diff(2,i-1) && diff(2,i)>diff(2,i+1) && diff(2,i)>max(diff(2,:))/5 && i>3
        %�ж���������ֵ�Ƿ�Զ
        if peakNum ==1 %�״����ֵ��ֱ�Ӷ�ȡ
            spo2Peak(peakNum) = i;
            peakNum = peakNum + 1;
        elseif i-spo2Peak(peakNum-1)>thresh
            spo2Peak(peakNum)=i;
            peakNum = peakNum + 1;
        end
    end
    %������ִӼ�����
    if diff(2,i)==0 && diff(2,i-1)>0 && diff(2,i+1)==0
        if troughNum ==1 %�״����ֵ��ֱ�Ӷ�ȡ
            spo2Trough(troughNum) = i;
            troughNum = troughNum + 1;
        elseif i-spo2Trough(troughNum-1)>thresh
            spo2Trough(troughNum)=i;
            troughNum = troughNum + 1;
        end
    end
end 
disp('peak:');
disp(spo2Peak(1:peakNum-1));
disp('trough:');
disp(spo2Trough(1:troughNum-1));
hr = 0;
% ��������
for i = 2:peakNum-1
    hr = hr + spo2Peak(i)-spo2Peak(i-1);
end
hr = hr/(peakNum-1);
% hr = 60/(hr/50);
disp('hr:')
disp(hr);%�����Ϊ����������֮������ݼ�������ݲ�����ת��Ϊ����
%% ���Ի�ͼ
%�����ֵ�Ҳ��岨��
%{
figure(1)
subplot(211),plot(data(2,:)),hold on,plot(spo2Trough(1:troughNum-1),data(2,spo2Trough(1:troughNum-1)),'o','MarkerSize',10),plot(spo2Peak(1:peakNum-1)-3,data(2,spo2Peak(1:peakNum-1)-3),'o','MarkerSize',10),hold off;
subplot(212),plot(diff(2,:)),hold on,plot(spo2Trough(1:troughNum-1),diff(2,spo2Trough(1:troughNum-1)),'o','MarkerSize',10),plot(spo2Peak(1:peakNum-1),diff(2,spo2Peak(1:peakNum-1)),'o','MarkerSize',10),hold off;
%}
dcRed = sum(data(1,spo2Trough(1:troughNum-1)))/(troughNum-1);
acRed = sum(data(1,spo2Peak(1:peakNum-1)-3))/(peakNum-1);
dcIred= sum(data(2,spo2Trough(1:troughNum-1)))/(troughNum-1);
acIred= sum(data(2,spo2Peak(1:peakNum-1)-3))/(peakNum-1);
acRed = acRed - dcRed;
acIred = acIred - dcIred;
disp('R:');
R = (acRed/dcRed)/(acIred/dcIred);
disp(R);
spo2 = 104-17*(R);
end

