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
speedInterval = 0.4

ardu = None

moveSpeedX = 0
moveSpeedY = 0
cameraSpeedX = 0
cameraSpeedY = 0

def init():
    global ardu
    print('Initialising Robot')
    ardu= serial.Serial(PORT, BAUD, timeout=.1)
    print('Initialised Robot')
    move_loop()

def updateDirection(message):
    global moveSpeedX, moveSpeedY
    global cameraSpeedX, cameraSpeedY

    print(message)

    if message == 'Joystick 0: X+':
        moveSpeedX = 1
    elif message == 'Joystick 0: X-':
        moveSpeedX = -1
    elif message == 'Joystick 0: X':
        moveSpeedX = 0
    elif message == 'Joystick 0: Y+':
        moveSpeedY = 1
    elif message == 'Joystick 0: Y-':
        moveSpeedY = -1
    elif message == 'Joystick 0: Y':
        moveSpeedY = 0
    elif message == 'Button down: 1':
        cameraSpeedX = 1
    elif message == 'Button down: 2':
        cameraSpeedX = -1
    elif message == 'Button up: 1' or message == 'Button up: 2':
        cameraSpeedX = 0
    elif message == 'Button down: 0':
        cameraSpeedY = 1
    elif message == 'Button down: 3':
        cameraSpeedY = -1
    elif message == 'Button up: 0' or message == 'Button up: 3':
        cameraSpeedY = 0

def move():
    global ardu
    print(f"Moving: {moveSpeedX},{moveSpeedY}")
    print(f"Camera: {cameraSpeedX},{cameraSpeedY}")

    if moveSpeedX > 0:
        ardu.write('3'.encode())
    elif moveSpeedX < 0:
        ardu.write('e'.encode())
    
    if moveSpeedY > 0:
        ardu.write('q'.encode())
    elif moveSpeedY < 0:
        ardu.write('1'.encode())
    
    if cameraSpeedX > 0:
        ardu.write('r'.encode())
    elif cameraSpeedX < 0:
        ardu.write('4'.encode())
    
    if cameraSpeedY > 0:
        ardu.write('5'.encode())
    elif cameraSpeedY < 0:
        ardu.write('t'.encode())

def move_loop():
    global moveSpeedX, moveSpeedY
    move()

    threading.Timer(speedInterval, move_loop).start()

def finish():
    global ardu
    ardu.close()