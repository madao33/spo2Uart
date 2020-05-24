function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 24-May-2020 10:16:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)
% h = handles.h0bject; %获取句柄
newIcon = javax.swing.ImageIcon('logo.jpg'); %读取图片文件
figFrame = get(gcf,'JavaFrame');
figFrame.setFigureIcon(newIcon);
set(gcf,'name','口罩式睡眠呼吸监测仪器'); %第三个参数为要修改的界面名称

% Choose default command line output for main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%开始按键
% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc
delete(instrfindall);
global s;                   %串口对象
global xlength;             %横坐标
global xlength2;
global byteCallBackCount;   %中断触发字节数
global spo2Bak;
global spo2Plot;
global breathBak;
global breathPlot;
global spo2Index;
global breathIndex;
global dataBak;
global voltvalue;
voltvalue=50;

xlength=5e2;                    %x轴显示范围
xlength2=2e2;
ylength1 = 3e2;                 %y轴显示范围（1、2、3三个图）
ylength2 = 3e2;
spo2Plot = zeros(2,xlength);    %二维血氧数组
spo2Index = 1;
breathPlot = zeros(1,xlength);  %呼吸数据
dataBak = [];
breathIndex = 1;
spo2Bak = [];
breathBak = [];
byteCallBackCount=50;

axis(handles.axes1,[0 xlength 0 ylength1]);%各个图表具体参数设置
set(handles.axes1,'Ycolor','k');            %X、Y颜色
set(handles.axes1,'Xcolor','k');
axis(handles.axes2,[0 xlength 0 ylength1]);
handles.axes2.XAxis.Visible = 'off';
handles.axes2.YAxis.Visible = 'off';
axis(handles.axes3,[0 xlength 200 ylength2]);
handles.axes3.XAxis.Visible = 'off';
handles.axes3.YAxis.Visible = 'off';
com = 'COM1';


%端口选择
if get(handles.comlist,'value')~=0
    switch get(handles.comlist,'Value')
        case 1
            com='COM1';
        case 2
            com='COM2';
        case 3
            com='COM3';
        case 4
            com='COM4';
        case 5
            com='COM5';
        case 6
            com='COM6';
        case 7
            com='COM7';
        case 8
            com='COM8';
        case 9
            com='COM9';
        case 10
            com='COM10'; 
        case 11
            com='COM11';
        case 12
            com='COM12';
    end 
end
 
%串口详细参数设置（奇偶校验、波特率、数据位、停止位、接受缓存区大小）
s=serial(com,'Parity','none','BaudRate',115200,'DataBits',8,'StopBits',1,'inputbuffersize',10240000);

s.BytesAvailableFcnMode='byte';             %字节
s.BytesAvailableFcnCount=byteCallBackCount; %100个字节触发中断
fopen(s);                                   %打开串口
s.BytesAvailableFcn={@ReceiveCallback,handles};%中断触发回调函数
set(handles.start,'Enable','off');          %设置按键不可按下
set(handles.stop,'Enable','on');

%停止按键
% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s;                   %串口对象
fclose(s);                  %关闭串口
delete(s);                  %删除
delete(instrfindall);       %清除所有串口
clear s;
cla(handles.axes1);         %清除所有图表
cla(handles.axes2);
cla(handles.axes3);
set(handles.start,'Enable','on');%改变按键状态
set(handles.stop,'Enable','off');

% --- Executes on selection change in comlist.
function comlist_Callback(hObject, eventdata, handles)
% hObject    handle to comlist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns comlist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from comlist


% --- Executes during object creation, after setting all properties.
function comlist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comlist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on mouse press over axes background.
function axes3_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pulse_btn.


% --- Executes on button press in pulse_btn.
function pulse_btn_Callback(hObject, eventdata, handles)
% hObject    handle to pulse_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s;
% fopen(s);
disp('发送:');
disp('1');
fprintf(s,1);


% --- Executes on button press in breath_btn.
function breath_btn_Callback(hObject, eventdata, handles)
% hObject    handle to breath_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s;
% fopen(s);
disp('发送:');
disp('2');
fprintf(s,hex2dec('2'));
