function handlePlot(axs,data,index,type)
global xlength;
%handlePlot 在GUI界面绘制图像
%   axes为欲绘制波形的坐标句柄
%   data-要绘制的波形数据，index-当前更新坐标
%   type-为1表示为SPO2波形绘制，为2表示为呼吸波形绘制

% 判断绘制波形的类型
axes(axs);
plot((1:xlength),data(1,1:xlength),'g');
set(axs,'Color',[0 0 0])
end

