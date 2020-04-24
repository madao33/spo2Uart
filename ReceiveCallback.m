function ReceiveCallback(obj, event,handles)
global s;
global x1;
global x2;
global xlength;
str = fread(s,10);

plot(handles.axes1,x1:x1+9,str,'g');
plot(handles.axes2,x2:x2+9,str,'g');
x1=x1+9;
x2=x2+9;


if x1 > xlength
    x1 = 0;
    cla(handles.axes1);
end
if x2 > xlength
    x2 = 0;
    cla(handles.axes2);
end


