import sys
from time import sleep
import RPi.GPIO as GPIO
from qtr2rc import MrBit_QTR_8RC
import wiringpi as wp
from cam import *

#https://www.pololu.com/docs/0J21/7.b

#motor pins
ENA = 7
IN1 = 12
IN2 = 11
IN3 = 13
IN4 = 16
ENB = 15

#var camera
numPic = 0
path = './pics/'

def init_motor_pins():
        GPIO.setmode(GPIO.BOARD)

	#GPIO signals:
	#ENA->GPIO-04->7
	#IN1->GPIO-18->12
	#IN2->GPIO-17->11
	#IN3->GPIO-27->13
	#IN4->GPIO-23->16
	#ENB->GPIO-22->15

	GPIO.setup(ENA, GPIO.OUT)
	GPIO.setup(ENB, GPIO.OUT)
	GPIO.setup(IN1, GPIO.OUT)
	GPIO.setup(IN2, GPIO.OUT)
	GPIO.setup(IN3, GPIO.OUT)
	GPIO.setup(IN4, GPIO.OUT)

	print("enabling motors")
	GPIO.output(ENA, GPIO.HIGH)
	GPIO.output(ENB, GPIO.HIGH)


if __name__ == "__main__":
    try:
        qtr = MrBit_QTR_8RC()
        approveCal = False
        while not approveCal:
            print("calibrating")
            qtr.initialise_calibration()
            qtr.emitters_on()
            for i in range(0, 250):
                qtr.calibrate_sensors()
                wp.delay(20)
            qtr.emitters_off()
 
            print "calibration complete"
            print "max vals"
            qtr.print_sensor_values(qtr.calibratedMax)
            print "calibration complete"
            print "min vals"
            qtr.print_sensor_values(qtr.calibratedMin)
            approved = raw_input("happy with calibrtion (y/n)? ")
            if approved == "y": approveCal = True
    except Exception as e:
        qtr.emitters_off()
        print str(e)
 
    try:
    	init_motor_pins()
    	m1PWM = GPIO.PWM(IN1, 100)
        m2PWM = GPIO.PWM(IN3, 100)
        while 1:
                qtr.emitters_on()
                position = qtr.read_line()
                print position
                qtr.emitters_off()
                wp.delay(20)
                if(position < 1500):
                        #We are far to the right of the line: turn left.
                        print("Left")
                        m1PWM.ChangeDutyCycle(10)
                        m2PWM.ChangeDutyCycle(70)
	        
                elif(position < 3500):
	        
	            # We are somewhat close to being centered on the line:
	            # drive straight.
	            print("forward")
	            m1PWM.ChangeDutyCycle(50)
	            m2PWM.ChangeDutyCycle(50)
	            name = "foto" + str(numPic) + ".jpg"
	            #m1PWM.stop()
	            #m2PWM.stop()
	            takePic(path+name)
	            #m1PWM.ChangeDutyCycle(50)
	            #m2PWM.ChangeDutyCycle(50)
	            numPic += 1
	            
	        
	        else:
	        
	            # We are far to the left of the line: turn right.
	            print("Right")
	            m1PWM.ChangeDutyCycle(70)
	            m2PWM.ChangeDutyCycle(30)

 
    except KeyboardInterrupt:
        qtr.emitters_off()
        
        print("Disabling motors")
        m1PWM.stop()
        m2PWM.stop()
	GPIO.cleanup()
	print("exiting")
 
    except Exception as e:
        print str(e)
        qtr.emitters_off()
        
        print("Diabling motors")
        m1PWM.stop()
        m2PWM.stop()
	GPIO.cleanup()
	print("exiting")
