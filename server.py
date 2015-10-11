#!/usr/bin/python

import time
import argparse

from simpleOSC import *


parser = argparse.ArgumentParser()
parser.add_argument("--ip", default="127.0.0.1", help="The IP to listen for.")
parser.add_argument("--port", type=int, default=57120, help="The port to listen on.")
args = parser.parse_args()

# a function to read sensor data and do something with it
def readSensor(addr, tags, data, source):
    print "%s -> %s - [%s] %s" % (source, addr, tags[0], data[0])


sensors = 'AF3 F7 F3 FC5 T7 P7 O1 O2 P8 T8 FC6 F4 F8 AF4'.split(' ')

initOSCServer("127.0.0.1",57120,1)
for sensor in sensors:
    setOSCHandler("/sensor/" + sensor, readSensor)
setOSCHandler("/gyro/x", readSensor)
setOSCHandler("/gyro/y", readSensor)

print "Starting server."
startOSCServer()

# loop forever
try:
    while 1:
        time.sleep(1)

#cleanly exit the server
except KeyboardInterrupt:
    print "Terminating server."
    closeOSC()
finally:
    print "Terminating server."
    closeOSC()
