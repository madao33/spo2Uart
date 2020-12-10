% function ReceiveCallback(raw,handles)
function ReceiveCallback(obj, event,handles)
global s;                       %串口对象
global byteCallBackCount;       %中断触发字节数
global xlength;                 %X轴坐标
global xlength2;
global spo2Bak;                 %？？？？没用                
global spo2Plot;                %血氧显示控件
global breathBak;               %？？？？没用
global breathPlot;              %呼吸显示控件
global spo2Index;               %血氧数据横坐标
global breathIndex;             %呼吸数据横坐标
global dataBak;                 %一次判断未能识别的数据

% global breathIndexf;
% global breathPlotf;
global voltvalue;

raw = fread(s,byteCallBackCount);%从串口连续读取100个字节
raw = [dataBak;raw];             %合并上一段数据和下一段数据
% disp(raw);
[rlength,~] = size(raw);         %计算一段数组大小
% disp('length:');
% disp(rlength);
i=1;

while i <= rlength-5             %保证判断时，数组下标在合法范围内
    %识别血氧数据帧头、帧尾
    if i <= rlength-7 && raw(i) == 255 && raw(i+1) == 255 && raw(i+6) == 165 && raw(i+7) == 165
        %判断血氧数组是否已满
        if spo2Index > xlength
            % 血氧数组已满，从新进行覆盖
            spo2Index = 1;
            [spo2,hr]=calcSpo2(spo2Plot);
            set(handles.spo2Text,'String',int2str(spo2)+"%");
            set(handles.hrText,'String',int2str(hr)+"/min");
        end
        
        % 读取识别成功后，中间所含有的数据（红光）
        spo2Plot(1,spo2Index) =raw(i+2)*256+raw(i+3);
        % 红外光
        spo2Plot(2,spo2Index) = raw(i+4)*256+raw(i+5);
        % hanning滤波
        if spo2Index>2
            spo2Plot(1,spo2Index)=(spo2Plot(1,spo2Index-2)+2*spo2Plot(1,spo2Index-1)+spo2Plot(1,spo2Index))/4;  
            spo2Plot(2,spo2Index)=(spo2Plot(2,spo2Index-2)+2*spo2Plot(2,spo2Index-1)+spo2Plot(2,spo2Index))/4;  
        end
        spo2Index = spo2Index + 1; % 数组坐标指针加一
%         disp(spo2Plot(1,spo2Index-1));
        i = i+8;                   %识别成功后，跳过这8个数据继续进行判断
    %未能识别成功，判断是否为呼吸数据
    elseif raw(i) == 255 && raw(i+1) == 254 && raw(i+4) == 165 && raw(i+5)==165
        % 判断数组是否已经溢出
        if breathIndex > xlength2
            breathIndex = 1;
            breath=calcbreath(breathPlot(3:200));
            set(handles.breathTex,'String',int2str(breath)+"/min");
        end
        
        % 识别成功，提取呼吸数据
        breathPlot(1,breathIndex) = bitand(raw(i+2),15,'int8')*256+raw(i+3);
        % hanning滤波
        if breathIndex > 2
            breathPlot(1,breathIndex) = (breathPlot(1,breathIndex-2) + 2 * breathPlot(1,breathIndex-1) + breathPlot(1,breathIndex))/4;
%             breathf=[breathPlot(1,breathIndex-2) breathPlot(1,breathIndex-1) breathPlot(1,breathIndex)];
%             breathPlot(1,breathIndex)=order(breathf);
        end
        breathIndex = breathIndex + 1;
        i = i + 6;          %跳过呼吸数据，进行下一段数据识别
    
    % 未能识别成功，判断是否为电压，按键数据
    elseif raw(i) == 255 && raw(i+1) == 253 && raw(i+4) == 165 && raw(i+5)==165
        volt = mod(raw(i+2),15) * 256 + raw(i+3);
        btn1 = bitand(raw(i+2),32,'int8');          %位与，提取按键1（呼吸）
        btn2 = bitand(raw(i+2),16,'int8');          %位与，提取按键2（血氧）
        disp('电压：');
        disp(volt);                                 %显示电压
        volt=(volt/2048)*1.5;%电量判断
        if volt>=4.2
            voltvalue=100;
        else if volt>3.95
                voltvalue=75;
            else if volt>3.85
                    voltvalue=50;
                else if volt>3.73
                        voltvalue=25;
                    else if volt>3.5
                            voltvalue=5;
                        else
                            voltvalue=1;
                        end
                    end
                end
            end
        end
        set(handles.voltTex,'String',"电量："+int2str(voltvalue+90)+"%");%设置电压显示控件
        if btn1 == 32
            set(handles.pulse_btn,'BackgroundColor','g');    %设置按键状态（改变颜色）
        else
%             set(handles.pulse_btn,'BackgroundColor','r');    
        end
        
        if btn2 == 16
            set(handles.breath_btn,'BackgroundColor','g');
        else
%             set(handles.breath_btn,'BackgroundColor','r');
        end
        
        i = i + 6;                      %识别成功后，进行下一段数据识别
    else
        i = i + 1;                      %均未能识别成功，从下一个数据继续识别
    end
end % while-end
dataBak = raw(i:rlength);               %回收这100数据的最后几个数据，防止数据中断

handlePlot(handles.axes1,spo2Plot(1,:),xlength);
handlePlot(handles.axes2,spo2Plot(2,:),xlength);
handlePlot(handles.axes3,breathPlot,xlength2);

end % function-end 


    
            
            






