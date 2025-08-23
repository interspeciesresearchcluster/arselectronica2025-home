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
speedInterval = 0.5

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
    print("pringing message: ")
    print(message)

    if message == 'X+':
        speedX = 1
        print("X+")
    elif speedX == 'X-':
        speedX = -1
        print("X-")
    elif speedX == 'X':
        speedX = 0
        print("X")
    elif speedX == 'Y+':
        speedY = 1
        print("Y+")
    elif speedX == 'Y-':
        speedY = -1
        print("Y-")
    elif speedX == 'Y':
        speedY = 0
        print("Y")

def move():
    global ardu
    print(f"Moving: {speedX},{speedY}")
    # if speedX > 0:
    #     ardu.write('1'.encode())
    # elif speedX < 0:
    #     ardu.write('q'.encode())
    # elif speedY > 0:
    #     ardu.write('3'.encode())
    # elif speedY < 0:
    #     ardu.write('e'.encode())

def move_loop():
    global speedX, speedY
    move()

    threading.Timer(speedInterval, move_loop).start()

def finish():
    global ardu
    ardu.close()