{Object_Title_and_Purpose}


CON
        _clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
        _xinfreq = 5_000_000
        _ConClkFreq = ((_clkmode - xtal1) >> 6) * _xinfreq
        _Ms_001 = _ConClkFreq / 1_000

VAR
  long  mainToF1Val, mainToF2Val, mainUltra1Val, mainUltra2Val, trigger

OBJ
  Term      : "FullDuplexSerial.spin" 'UART communication for debugging
  Sensor    : "SensorControlTest.spin"   'Blackbox/Object
  MotorCtrl : "MotorControl.spin"


PUB Main | x


  'Declaration & Initialisation
  Term.Start(31, 30, 0, 115200)
  Pause(3000) 'Wait 2 sec

  ''Forward and check for obstacles
  Sensor.Start(_Ms_001, @mainToF1Val, @mainToF2Val, @mainUltra1Val, @mainUltra2Val)
  MotorCtrl.Start(_Ms_001,1)
  repeat
      OnSensors
      if (mainToF1Val>175) OR (mainUltra1Val>0 and mainUltra1Val<250)
        MotorCtrl.StopAllMotors
        Sensor.Stop
        QUIT

  Pause(3000)
  ''Calibrating sensors back to 0 to avoid the next repeat if loop condition to activate
  mainToF1Val := 0
  mainToF2Val := 0
  mainUltra1Val :=0
  mainUltra2Val :=0

  ''Reverse and check for obstacles
  Sensor.Start(_Ms_001, @mainToF1Val, @mainToF2Val, @mainUltra1Val, @mainUltra2Val)
  MotorCtrl.Start(_Ms_001,2)
  repeat
      OnSensors
      if (mainToF2Val>175) OR (mainUltra2Val>0 and mainUltra2Val<250)
        MotorCtrl.StopAllMotors
        Sensor.Stop
        QUIT


PUB OnSensors

  Term.Str(String(13, "Ultrasonic 1 Readings: "))
  Term.Dec(mainUltra1Val)
  Term.Str(String(13, "Ultrasonic 2 Readings: "))
  Term.Dec(mainUltra2Val)
  Term.Str(String(13, "Tof 1 Reading: "))
  Term.Dec(mainToF1Val)
  Term.Str(String(13, "Tof 2 Reading: "))
  Term.Dec(mainToF2Val)
  Pause(200)
  Term.Tx(0)








PRI Pause(ms) | t
  t := cnt - 1088
  repeat ( ms#>0 )
    waitcnt(t += _Ms_001)
  return