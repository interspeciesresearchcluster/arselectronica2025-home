import time
import serial


PORT = '/dev/ttyUSB0'
BAUD = 115200
KEYS = '1q3e4r5t0z'

ardu = None

speedX = 0
speedY = 0

def init():
    global ardu
    print('Initialising Robot')
    ardu= serial.Serial(PORT, BAUD, timeout=.1)
    print('Initialised Robot')

def updateDirection(message):
    global speedX, speedY

    if message == '+X':
        speedX = 1
    elif speedX == '-X':
        speedX = -1
    elif speedX == 'X':
        speedX = 0
    elif speedX == '+Y':
        speedY = 1
    elif speedX == '-Y':
        speedY = -1
    elif speedX == 'Y':
        speedY = 0

def move():
    global ardu
    if speedX > 0:
        ardu.write('1'.encode())
    elif speedX < 0:
        ardu.write('q'.encode())
    elif speedY < 0:
        ardu.write('3'.encode())
    elif speedY < 0:
        ardu.write('e'.encode())

def move_loop():
    while True:
        move()
        time.sleep(1)


def finish():
    global ardu
    ardu.close()