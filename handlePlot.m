function handlePlot(axs,data,index)
global xlength;
%handlePlot 波形显示
%   axes-控件句柄
%   data-波形数据
%   type

plot(axs,(1:index),data(1,1:index),'g');%画出波形
set(axs,'Color',[0 0 0])                    %设置显示控件
end

