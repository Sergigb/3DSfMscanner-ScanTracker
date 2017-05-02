#imports
import sys
from time import sleep
import RPi.GPIO as GPIO

#using BCM references instead of physical
GPIO.setmode(GPIO.BCM)
print("using GPIO BCM mode")

#GPIO signals:
#ENA->GPIO-04
#ENB->GPIO-22
#IN1->GPIO-17
#IN2->GPIO-27
#IN3->GPIO-18
#IN4->GPIO-23

ENA = 4
ENB = 22
IN1 = 17
IN2 = 27
IN3 = 18
IN4 = 23


GPIO.setup(ENA, GPIO.OUT)
GPIO.setup(ENB, GPIO.OUT)
GPIO.setup(IN1, GPIO.OUT)
GPIO.setup(IN2, GPIO.OUT)
GPIO.setup(IN3, GPIO.OUT)
GPIO.setup(IN4, GPIO.OUT)

print("enabling motors")
GPIO.output(ENA, GPIO.HIGH)
GPIO.output(ENB, GPIO.HIGH)

print("forward");
GPIO.output(IN1, GPIO.HIGH)
GPIO.output(IN3, GPIO.HIGH)
sleep(3)
GPIO.output(IN1, GPIO.LOW)
GPIO.output(IN3, GPIO.LOW)

print("backwards")
GPIO.output(IN2, GPIO.HIGH)
GPIO.output(IN4, GPIO.HIGH)
sleep(3)
GPIO.output(IN2, GPIO.LOW)
GPIO.output(IN4, GPIO.LOW)

print("----software PMW test----")

print("PWM at 50% (100Hz)")
m1PWM = GPIO.PWM(IN1, 100)
m2PWM = GPIO.PWM(IN3, 100)

m1PWM.start(50)
m2PWM.start(50)
sleep(3)
m1PWM.stop()
m2PWM.stop()

print("PWM at 40-70-100%(100Hz)")
m1PWM.start(40)
m2PWM.start(40)
sleep(1)
m1PWM.ChangeDutyCycle(70)
m2PWM.ChangeDutyCycle(70)
sleep(1)
m1PWM.ChangeDutyCycle(100)
m2PWM.ChangeDutyCycle(100)
sleep(1)

m1PWM.stop()
m2PWM.stop()


print("Diabling motors")
GPIO.output(ENB, GPIO.LOW)
GPIO.output(ENA, GPIO.LOW)

GPIO.cleanup()

print("exiting")

