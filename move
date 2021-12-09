
from vilib import Vilib
from ezblock import print
from ezblock import ADC
from picarx import Picarx
px = Picarx()

Traffic = None
Ref = None
value = None
direction = None
Left = None
Mid = None
Right = None
status = None
Key = None

"""Describe this function...
"""
def GetTraffic():
  global Traffic, Ref, value, direction, Left, Mid, Right, status, Key
  Traffic = Vilib.traffic_sign_detect_object('type');
  print("%s"%(Traffic))
  if Traffic == 'stop':
    Key = 0;
  elif Traffic == 'forward':
    Key = 1;

Ref = 700;
Vilib.camera_start(True)
Vilib.traffic_sign_detect_switch(True)
Key = 1;

"""Describe this function...
"""
def getDirection():
  global Traffic, Ref, value, direction, Left, Mid, Right, status, Key
  value = getGrayscaleValue();
  if value == [0, 1, 0] or value == [1, 1, 1]:
    direction = 'FORWARD';
  elif value == [1, 0, 0] or value == [1, 1, 0]:
    direction = 'RIGHT';
  elif value == [0, 0, 1] or value == [0, 1, 1]:
    direction = 'LEFT';
  elif value == [0, 0, 0]:
    direction = 'OUT';
  return direction

adc_A0 = ADC("A0")

adc_A1 = ADC("A1")

adc_A2 = ADC("A2")

"""Describe this function...
"""
def getGrayscaleValue():
  global Traffic, Ref, value, direction, Left, Mid, Right, status, Key
  if (adc_A0.read()) <= Ref:
    Left = 1;
  else:
    Left = 0;
  if (adc_A1.read()) <= Ref:
    Mid = 1;
  else:
    Mid = 0;
  if (adc_A2.read()) <= Ref:
    Right = 1;
  else:
    Right = 0;
  return [Left, Mid, Right]


def forever():
  global Traffic, Ref, value, direction, Left, Mid, Right, status, Key
  GetTraffic()
  if Key == 0:
    px.stop()
  elif Key == 1:
    status = getDirection();
    if status == 'FORWARD':
      px.set_dir_servo_angle(0)
      px.forward(10)
    elif status == 'LEFT':
      px.set_dir_servo_angle(20)
      px.forward(10)
    elif status == 'RIGHT':
      px.set_dir_servo_angle((-20))
      px.forward(10)
    elif status == 'OUT':
      px.stop()
