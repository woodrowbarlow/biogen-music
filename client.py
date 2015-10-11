#!/usr/bin/python

import random
import time
import gevent
import argparse

from emokit.emotiv import Emotiv
from simpleOSC import *


parser = argparse.ArgumentParser()
parser.add_argument("--ip", default="127.0.0.1", help="The server's IP.")
parser.add_argument("--port", type=int, default=57120, help="The server's listening port.")
args = parser.parse_args()

sensors = 'AF3 F7 F3 FC5 T7 P7 O1 O2 P8 T8 FC6 F4 F8 AF4'.split(' ')

emotiv = Emotiv(displayOutput=False)
gevent.spawn(emotiv.setup)
gevent.sleep(1)

initOSCClient(args.ip, args.port)
print "Starting client."

# run forever
try:
    while True:

        # get sensor values from headset
        packet = emotiv.dequeue()
        for sensor in sensors:
            # read the data and send it as OSC message
            value = packet.sensors[sensor]['value']
            quality = packet.sensors[sensor]['quality']
            sendOSCMsg("/sensor/" + sensor, [value, quality])
            print "CLIENT: /sensor/%s %d %d" % (sensor, value, quality)
        sendOSCMsg("/gyro/x", [packet.gyroX])
        print "CLIENT: /gyro/x %d" % (packet.gyroX)
        sendOSCMsg("/gyro/y", [packet.gyroY])
        print "CLIENT: /gyro/y %d" % (packet.gyroY)
        gevent.sleep(0)

# cleanly exit the client
except KeyboardInterrupt:
    print "Terminating client."
    emotiv.close()
    closeOSC()
finally:
    emotiv.close()
    closeOSC()
