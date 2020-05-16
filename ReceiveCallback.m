% function ReceiveCallback(raw,handles)
function ReceiveCallback(obj, event,handles)
global s;
global byteCallBackCount;
global xlength;
global spo2Bak;
global spo2Plot;
global breathBak;
global breathPlot;
global spo2Index;
global breathIndex;
global dataBak;
% 读取串口中接受到的文本，注意当前读取到的格式为十进制
raw = fread(s,byteCallBackCount);
raw = [dataBak;raw];
disp(raw);
[rlength,~] = size(raw);
% disp('length:');
% disp(rlength);
i=1;

while i <= rlength-7 
    
    %首先�?氧数�?
    if i <= rlength-7 && raw(i) == 255 && raw(i+1) == 255 && raw(i+6) == 165 && raw(i+7) == 165
        
        % �?氧波形绘制到画布末尾
        if spo2Index > xlength
            % 计数指针归一
            spo2Index = 1;
        end
        % 提取红光数据
        spo2Plot(2,spo2Index) = raw(i+2)*256+raw(i+3);
        % 提取红外光数�?
        spo2Plot(1,spo2Index) = raw(i+4)*256+raw(i+5);
        spo2Index = spo2Index + 1; % 指针加一
        disp(spo2Plot(1,spo2Index-1));
        i = i+8;
    % 判断为呼吸数�?
    elseif raw(i) == 255 && raw(i+1) == 254 && raw(i+4) == 165 && raw(i+5)==165
        % 呼吸波形绘制到画布末�?
        if breathIndex > xlength
            breathIndex = 1;
        end
        % 提取呼吸数据
        breathPlot(1,breathIndex) = raw(i+2)*256+raw(i+3);
        breathIndex = breathIndex + 1;
        i = i + 6;
    
    % 判断为电压按键信�?
    elseif raw(i) == 255 && raw(i+1) == 253 && raw(i+4) == 165 && raw(i+5)==165
        volt = mod(raw(i+2),16) * 256 + raw(i+3);
        btn1 = bitand(raw(i+2),32,'int8');
        btn2 = bitand(raw(i+2),16,'int8');
        
        set(handles.voltTex,'String',int2str(volt));
        i = i + 6;
    else
        i = i + 1;
    end
end % while-end
dataBak = raw(i+1:rlength);
% 绘制波形�?
handlePlot(handles.axes1,spo2Plot,spo2Index);
handlePlot(handles.axes2,breathPlot,breathIndex);

end % function-end 


    
            
            






