#!/usr/bin/python

import time
import picamera

def takePic(name):
    
    with picamera.PiCamera() as picam:
        picam.start_preview()
        picam.capture(name)
        picam.close()
