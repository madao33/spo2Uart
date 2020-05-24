function [spo2,hr] = calcSpo2(data)
%calcSpo2 计算脉率，血氧饱和度
%   data-输入数据，spo2-血氧饱和度，hr-脉率
[channels,dlength] = size(data);
diff = zeros(channels,dlength);
% 计算红光及红外光差分
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
    %红外光差分极大值
    if diff(2,i)>diff(2,i-1) && diff(2,i)>diff(2,i+1) && diff(2,i)>max(diff(2,:))/5 && i>3
        %判断两个极大值是否够远
        if peakNum ==1 %首次最大值，直接读取
            spo2Peak(peakNum) = i;
            peakNum = peakNum + 1;
        elseif i-spo2Peak(peakNum-1)>thresh
            spo2Peak(peakNum)=i;
            peakNum = peakNum + 1;
        end
    end
    %红外光差分从极大到零
    if diff(2,i)==0 && diff(2,i-1)>0 && diff(2,i+1)==0
        if troughNum ==1 %首次最大值，直接读取
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
% 计算心率
for i = 2:peakNum-1
    hr = hr + spo2Peak(i)-spo2Peak(i-1);
end
hr = hr/(peakNum-1);
% hr = 60/(hr/50);
disp('hr:')
disp(hr);%输出的为两个脉搏波之间的数据间隔，根据采样率转换为心率
%% 调试画图
%差分阈值找波峰波谷
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

