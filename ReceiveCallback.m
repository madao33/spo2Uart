% function ReceiveCallback(raw,handles)
function ReceiveCallback(obj, event,handles)
global s;                       %���ڶ���
global byteCallBackCount;       %�жϴ����ֽ���
global xlength;                 %X������
global xlength2;
global spo2Bak;                 %��������û��                
global spo2Plot;                %Ѫ����ʾ�ؼ�
global breathBak;               %��������û��
global breathPlot;              %������ʾ�ؼ�
global spo2Index;               %Ѫ�����ݺ�����
global breathIndex;             %�������ݺ�����
global dataBak;                 %һ���ж�δ��ʶ�������

% global breathIndexf;
% global breathPlotf;
global voltvalue;

raw = fread(s,byteCallBackCount);%�Ӵ���������ȡ100���ֽ�
raw = [dataBak;raw];             %�ϲ���һ�����ݺ���һ������
% disp(raw);
[rlength,~] = size(raw);         %����һ�������С
% disp('length:');
% disp(rlength);
i=1;

while i <= rlength-5             %��֤�ж�ʱ�������±��ںϷ���Χ��
    %ʶ��Ѫ������֡ͷ��֡β
    if i <= rlength-7 && raw(i) == 255 && raw(i+1) == 255 && raw(i+6) == 165 && raw(i+7) == 165
        %�ж�Ѫ�������Ƿ�����
        if spo2Index > xlength
            % Ѫ���������������½��и���
            spo2Index = 1;
            [spo2,hr]=calcSpo2(spo2Plot);
            set(handles.spo2Text,'String',int2str(spo2)+"%");
            set(handles.hrText,'String',int2str(hr)+"/min");
        end
        
        % ��ȡʶ��ɹ����м������е����ݣ���⣩
        spo2Plot(1,spo2Index) =raw(i+2)*256+raw(i+3);
        % �����
        spo2Plot(2,spo2Index) = raw(i+4)*256+raw(i+5);
        % hanning�˲�
        if spo2Index>2
            spo2Plot(1,spo2Index)=(spo2Plot(1,spo2Index-2)+2*spo2Plot(1,spo2Index-1)+spo2Plot(1,spo2Index))/4;  
            spo2Plot(2,spo2Index)=(spo2Plot(2,spo2Index-2)+2*spo2Plot(2,spo2Index-1)+spo2Plot(2,spo2Index))/4;  
        end
        spo2Index = spo2Index + 1; % ��������ָ���һ
%         disp(spo2Plot(1,spo2Index-1));
        i = i+8;                   %ʶ��ɹ���������8�����ݼ��������ж�
    %δ��ʶ��ɹ����ж��Ƿ�Ϊ��������
    elseif raw(i) == 255 && raw(i+1) == 254 && raw(i+4) == 165 && raw(i+5)==165
        % �ж������Ƿ��Ѿ����
        if breathIndex > xlength2
            breathIndex = 1;
            breath=calcbreath(breathPlot(3:200));
            set(handles.breathTex,'String',int2str(breath)+"/min");
        end
        
        % ʶ��ɹ�����ȡ��������
        breathPlot(1,breathIndex) = bitand(raw(i+2),15,'int8')*256+raw(i+3);
        % hanning�˲�
        if breathIndex > 2
            breathPlot(1,breathIndex) = (breathPlot(1,breathIndex-2) + 2 * breathPlot(1,breathIndex-1) + breathPlot(1,breathIndex))/4;
%             breathf=[breathPlot(1,breathIndex-2) breathPlot(1,breathIndex-1) breathPlot(1,breathIndex)];
%             breathPlot(1,breathIndex)=order(breathf);
        end
        breathIndex = breathIndex + 1;
        i = i + 6;          %�����������ݣ�������һ������ʶ��
    
    % δ��ʶ��ɹ����ж��Ƿ�Ϊ��ѹ����������
    elseif raw(i) == 255 && raw(i+1) == 253 && raw(i+4) == 165 && raw(i+5)==165
        volt = mod(raw(i+2),15) * 256 + raw(i+3);
        btn1 = bitand(raw(i+2),32,'int8');          %λ�룬��ȡ����1��������
        btn2 = bitand(raw(i+2),16,'int8');          %λ�룬��ȡ����2��Ѫ����
        disp('��ѹ��');
        disp(volt);                                 %��ʾ��ѹ
        volt=(volt/2048)*1.5;%�����ж�
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
        set(handles.voltTex,'String',"������"+int2str(voltvalue+90)+"%");%���õ�ѹ��ʾ�ؼ�
        if btn1 == 32
            set(handles.pulse_btn,'BackgroundColor','g');    %���ð���״̬���ı���ɫ��
        else
%             set(handles.pulse_btn,'BackgroundColor','r');    
        end
        
        if btn2 == 16
            set(handles.breath_btn,'BackgroundColor','g');
        else
%             set(handles.breath_btn,'BackgroundColor','r');
        end
        
        i = i + 6;                      %ʶ��ɹ��󣬽�����һ������ʶ��
    else
        i = i + 1;                      %��δ��ʶ��ɹ�������һ�����ݼ���ʶ��
    end
end % while-end
dataBak = raw(i:rlength);               %������100���ݵ���󼸸����ݣ���ֹ�����ж�

handlePlot(handles.axes1,spo2Plot(1,:),xlength);
handlePlot(handles.axes2,spo2Plot(2,:),xlength);
handlePlot(handles.axes3,breathPlot,xlength2);

end % function-end 


    
            
            






