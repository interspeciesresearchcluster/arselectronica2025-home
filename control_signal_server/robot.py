import time
import serial


PORT = "/dev/ttyUSB0"
BAUD = 115200
KEYS = '1q3e4r5t0z'

def init():
    print("Initialising Robot")
    ardu= serial.Serial(PORT, BAUD, timeout=.1)
    print("Initialised Robot")

def move(message):
   for i in range (10):
        ardu.write(message.encode())

def finish():
    ardu.close()