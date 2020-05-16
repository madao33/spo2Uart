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

% Last Modified by GUIDE v2.5 23-Apr-2020 22:16:29

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


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc
delete(instrfindall);
global s;
global xlength;
global byteCallBackCount;
global spo2Bak;
global spo2Plot;
global breathBak;
global breathPlot;
global spo2Index;
global breathIndex;
global dataBak;
xlength=2e2;
ylength1 = 3e2;
ylength2 = 3e2;
spo2Plot = zeros(2,xlength);
spo2Index = 1;
breathPlot = zeros(1,xlength);
dataBak = [];
breathIndex = 1;
spo2Bak = [];
breathBak = [];
byteCallBackCount=100;

axis(handles.axes1,[0 xlength 0 ylength1]);
axis(handles.axes2,[0 xlength 0 ylength2]);
com = 'COM1';

% 选择串口，在windows下可用，根据自己�?要�?�择去掉注释

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
 

s=serial(com,'Parity','none','BaudRate',115200,'DataBits',8,'StopBits',1,'inputbuffersize',10240000);

s.BytesAvailableFcnMode='byte';  
s.BytesAvailableFcnCount=byteCallBackCount;
fopen(s);
s.BytesAvailableFcn={@ReceiveCallback,handles};
set(handles.start,'Enable','off'); 
set(handles.stop,'Enable','on');


%{
bcnt = 1;
raw = [];
x1 = 0:0.1:2*pi;
x2 = 0:0.1:2*pi;
[~,xl]=size(x1);
xin1 = 1;
xin2 = 1;
% 测试�?
while true
   
   type = rand*3;
   if type < 1
       raw(bcnt) = 255;
       raw(bcnt+1) = 255;
       raw(bcnt+2) = uint8(0);
       raw(bcnt+3) = uint8(sin(x1(xin1))*256);
       raw(bcnt+4) = uint8(random('norm',0,127));
       raw(bcnt+5) = uint8(random('norm',0,127));
       raw(bcnt+6) = 165;
       raw(bcnt+7) = 165;
       bcnt = bcnt + 8;
       xin1 = xin1 + 1;
       if xin1 > xl
           xin1 = 1;
       end
   
   elseif type < 2
       raw(bcnt) = 255;
       raw(bcnt+1) = 254;
       raw(bcnt+2) = int8(0);
       raw(bcnt+3) = uint8(sin(x2(xin2))*256);
       raw(bcnt+4) = 165;
       raw(bcnt+5) = 165;
       bcnt = bcnt + 6;
       xin2 = xin2 + 1;
       if xin2 > xl
           xin2 = 1;
       end
       
   else
       raw(bcnt) = 255;
       raw(bcnt+1) = 253;
       raw(bcnt+2) = int8(random('norm',0,63));
       raw(bcnt+3) = uint8(random('norm',0,255));
       raw(bcnt+4) = 165;
       raw(bcnt+5) = 165;
       bcnt = bcnt + 6; 
   end
   
   if bcnt > 200
       ReceiveCallback(raw,handles);
       bcnt=1;
       raw=[];
   end
   
end
%}

% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s;
fclose(s);
delete(s);
delete(instrfindall);
clear s;
cla(handles.axes1);
cla(handles.axes2);
set(handles.start,'Enable','on');
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
function axes2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
