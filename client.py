#!/usr/bin/python

import random
import time
import gevent
import argparse
import traceback

import pygame, sys, os
from pygame.locals import *

from emokit.emotiv import Emotiv
from simpleOSC import *


def updateQuality(i, q):
    if not guifeature: return
    coords = (
        (236,104), (179,164), (275,158),
        (215,202), (157,254), (215,373),
        (270,431), (370,431), (425,373),
        (483,254), (425,202), (365,158),
        (461,164), (404,104) )
    if q == 0:
        color = (255,255,255)
    elif q <= 4:
        color = (255,0,0)
    elif q <= 8:
        color = (255,255,0)
    else:
        color = (0,255,0)
    pygame.draw.circle(surface, color, coords[i], 15)


guifeature = True
parser = argparse.ArgumentParser(description="Create and OSC bridge between Emotiv Epoc USB Receiver and SuperCollider.")
parser.add_argument("--ip", default="127.0.0.1", help="The server's IP.")
parser.add_argument("--port", type=int, default=57120, help="The server's listening port.")
parser.add_argument("--nogui", type=bool, default=False, help="Disable the client's graphical callibration tool.")
args = parser.parse_args()
if(args.nogui):
    guifeature = False

sensornames = 'AF3 F7 F3 FC5 T7 P7 O1 O2 P8 T8 FC6 F4 F8 AF4'.split(' ')

if guifeature:
    # building the node connection display
    pygame.init()
    surface = pygame.display.set_mode((640, 480), 0, 32)
    pygame.display.set_caption('Emotiv Epoc Callibration Test')
    background = pygame.image.load(os.path.join('images','sensormap.png'))
    surface.blit(background, (0,0))
    pygame.display.flip()

print "Initializing controller..."
emotiv = Emotiv(displayOutput=False)
gevent.spawn(emotiv.setup)
gevent.sleep(1)
print "Controller initialized."

initOSCClient(args.ip, args.port)
print "Starting client."

# run forever
try:
    running = True
    while running:

        if guifeature:
            for event in pygame.event.get():
                if event.type == QUIT:
                    running = False
                    break
            if not running:
                break

        # get sensor values from headset
        packet = emotiv.dequeue()
        displaychanged = False
        for i in range(len(sensornames)):
            try:
                # read the data and send it as OSC message
                value = packet.sensors[sensornames[i]]['value']
                quality = packet.sensors[sensornames[i]]['quality']
                updateQuality(i, quality)
                sendOSCMsg("/sensor/" + sensornames[i], [value, quality])
                #print "CLIENT: /sensor/%s %d %d" % (sensornames[i], value, quality)
            except Exception, e:
                print e
        try:
            sendOSCMsg("/gyro/x", [packet.gyroX])
            #print "CLIENT: /gyro/x %d" % (packet.gyroX)
            sendOSCMsg("/gyro/y", [packet.gyroY])
            #print "CLIENT: /gyro/y %d" % (packet.gyroY)
        except Exception, e:
            print e
        if guifeature:
            pygame.display.flip()
        gevent.sleep(0)
    print "Terminating client."
    if guifeature:
        pygame.quit()
    emotiv.close()
    closeOSC()
    sys.exit()

# cleanly exit the client
except KeyboardInterrupt:
    print "Terminating client."
    if guifeature:
        pygame.quit()
    emotiv.close()
    closeOSC()
    sys.exit()
finally:
    print "Terminating client."
    if guifeature:
        pygame.quit()
    emotiv.close()
    closeOSC()
    sys.exit()
