function handlePlot(axs,data,index)
global xlength;
%handlePlot 在GUI界面绘制图像
%   axes为欲绘制波形的坐标句�?
%   data-要绘制的波形数据，index-当前更新坐标
%   type-�?1表示为SPO2波形绘制，为2表示为呼吸波形绘�?

% 判断绘制波形的类�?

plot(axs,(1:xlength),data(1,1:xlength),'g');
set(axs,'Color',[0 0 0])
end

