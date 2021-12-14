{Object_Title_and_Purpose}
{
  Project: EE-7 Assignment
  Platform: Parallax Project USB Board
  Author: Elson Tan Jun Hao 2102036
  Date: 15 Nov 2021
  Log:
        Date:   Desc:
        15 Nov 2021: Integrate the Sensors and motor control together to stop motors when obstacles detected
        22 Nov 2021: Integrating a CommControl.spin file to poll & capture the data
        29 Nov 2021: Adjusting and debugging for to allow receiver and transmitter to work with Xbee
}
CON
        _clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
        _xinfreq = 5_000_000
        _ConClkFreq = ((_clkmode - xtal1) >> 6) * _xinfreq
        _Ms_001 = _ConClkFreq / 1_000


VAR
  long  mainToF1Val, mainToF2Val, mainUltra1Val, mainUltra2Val, rxValue, rxVal
  long motor1val,motor2val,motor3val,motor4val

OBJ
  Term      : "FullDuplexSerial.spin" 'UART communication for debugging
  Sensor    : "SensorControl.spin"   'Blackbox/Object
  MotorCtrl : "MotorControl.spin"
  Comm      : "CommControl.spin"


PUB Main

  Term.Start(31, 30, 0 ,115200)
  Pause(200)

  ''Declaration & Initialisation
  Comm.Start(_Ms_001,@rxVal)  'Initialise communication from comm control
  MotorCtrl.Start(_Ms_001,@motor1val,@motor2val,@motor3val,@motor4val)
  Sensor.Start(_Ms_001, @mainToF1Val, @mainToF2Val, @mainUltra1Val, @mainUltra2Val)


  repeat
    'Term.Dec(rxVal)
    OnSensors
    case rxVal
      1:                    'commForward
        'Motors move forward
        FwdandCheck
        if (mainToF1Val>175) OR (mainUltra1Val>0 and mainUltra1Val<250)  'Sensor range Condition for motors to stop
          Stop
      2:                      'commReverse
        'Motors move backward
        RvsandCheck
        if (mainToF2Val>175) OR (mainUltra2Val>0 and mainUltra2Val<250)  'Sensor range Condition for motors to stop
          Stop

      3:                      'commLeft
        TurnLeft

      4:                      'commRight
        TurnRight

      5:                      'commStopAll
        'Stop all motors
        Stop
    Pause(20)

PUB FwdandCheck

  ''Forward and check for obstacles
    motor1val := -120
    motor2val := -120
    motor3val := 120
    motor4val := 120

PUB RvsandCheck


  ''Reverse and check for obstacles

    motor1val := 120
    motor2val := 120
    motor3val := -120
    motor4val := -120

PUB TurnLeft

    motor1val := 120
    motor2val := -120
    motor3val := 120
    motor4val := -120

PUB TurnRight

    motor1val := -120
    motor2val := 120
    motor3val := -120
    motor4val := 120

PUB Stop

    motor1val := 0
    motor2val := 0
    motor3val := 0
    motor4val := 0


PUB OnSensors
  ''Run and print readings for sensors
  Term.Str(String(13, "Ultrasonic 1 Readings: "))
  Term.Dec(mainUltra1Val)
  Term.Str(String(13, "Ultrasonic 2 Readings: "))
  Term.Dec(mainUltra2Val)
  Term.Str(String(13, "Tof 1 Reading: "))
  Term.Dec(mainToF1Val)
  Term.Str(String(13, "Tof 2 Reading: "))
  Term.Dec(mainToF2Val)
  Pause(200)
  Term.Tx(0) 'Clear terminal


PRI Pause(ms) | t
  t := cnt - 1088
  repeat ( ms#>0 )
    waitcnt(t += _Ms_001)
  return