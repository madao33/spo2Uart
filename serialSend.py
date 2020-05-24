import time
import serial
import binascii
# 串口设置
ser = serial.Serial()

def port_open():
    ser.port = "COM6"           #设置端口号
    ser.baudrate = 115200     #设置波特率
    ser.bytesize = 8        #设置数据位
    ser.stopbits = 1        #设置停止位
    ser.parity = "N"        #设置校验位
    ser.open()
    if(ser.isOpen()):
        print("打开成功")
    else:
        print("打开失败")

def port_close():
    ser.close()
    if (ser.isOpen()):
        print("关闭失败")
    else:
        print("关闭成功")


def send(send_data):
    if (ser.isOpen()):
        # ser.write(send_data.encode('utf-8'))  #utf-8 编码发送
        ser.write(binascii.a2b_hex(send_data))  #Hex发送
        print("发送成功",send_data)
    else:
        print("发送失败")

# 打开文件
fileName = 'text9.txt'
f = open(fileName,'r')
lines = f.readlines()
former = ''
port_open()
while True:
    for line in lines:
        for word in line.split(" "):
            if len(word)==2:
                print('发送数据：' + word)
                send(word)
                time.sleep(0.001)
            elif former == '':
                former = word
            else:
                word = former+word
                print('发送数据：' + word)
                send(word)
                time.sleep(0.001)
            