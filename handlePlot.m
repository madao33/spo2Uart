function handlePlot(axs,data,index)
global xlength;
%handlePlot ������ʾ
%   axes-�ؼ����
%   data-��������
%   type

plot(axs,(1:index),data(1,1:index),'g');%��������
set(axs,'Color',[0 0 0])                    %������ʾ�ؼ�
end

