import time
import serial
import threading


#KEYS:
# Axis A, back and forth: 1 and q
# Axis B, back and forth: 3 and e
# Camera rotation: 4 and r
# Tool: 5 and t
# Zeroing position: z
# Stop all motors: 0

PORT = '/dev/ttyUSB0'
BAUD = 115200
speedInterval = 0.1

ardu = None

speedX = 0
speedY = 0

def init():
    global ardu
    print('Initialising Robot')
    ardu= serial.Serial(PORT, BAUD, timeout=.1)
    print('Initialised Robot')
    move_loop()

def updateDirection(message):
    global speedX, speedY

    if message[:2] == 'X+':
        speedX = 1
    elif message[:2] == 'X-':
        speedX = -1
    elif message[:2] == 'X':
        speedX = 0
    elif message[:2] == 'Y+':
        speedY = 1
    elif message[:2] == 'Y-':
        speedY = -1
    elif message[:2] == 'Y':
        speedY = 0

def move():
    global ardu
    print(f"Moving: {speedX},{speedY}")
    if speedX > 0:
        ardu.write('1'.encode())
    elif speedX < 0:
        ardu.write('q'.encode())
    elif speedY > 0:
        ardu.write('3'.encode())
    elif speedY < 0:
        ardu.write('e'.encode())

def move_loop():
    global speedX, speedY
    move()

    threading.Timer(speedInterval, move_loop).start()

def finish():
    global ardu
    ardu.close()