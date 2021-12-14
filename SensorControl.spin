{Object_Title_and_Purpose}
{

    Project: EE-7 Assignment
    Platform: Parallax Project USB Board
    Author: Elson Tan Jun Hao 2102036
    Date: 15 Nov 2021
    Log:
        Date:   Desc:
        15 Nov 2021: Implementing Time-Of-Flight sensors and ultrasonic sensors
        22 Nov 2021: Integrate the Sensors and motor control together to stop motors when obstacles detected
}

CON
        'Declaration for Pins Sensor
        ' Ultrasonic 1(Front)-I2C Bus1   Need to be different address , the front and back
        ultra1SCL = 6
        ultra1SDA = 7

        ' Ultrasonic 2(Back)-I2C Bus2
        ultra2SCL = 8
        ultra2SDA = 9

        ' ToF 1(Front)-I2C Bus1
        tof1SCL = 0    'trigger scl
        tof1SDA = 1    'echo sda
        tof1Reset = 14
        tofAdd = $29

        ' ToF 2(Back)-I2C Bus2
        tof2SCL = 2    'trigger scl
        tof2SDA = 3    'echo sda
        tof2Reset = 15


VAR
  long cogStack[64], cogIDNum
  long _Ms_001

OBJ
  'Term      : "FullDuplexSerial.spin"    'UART Communication for debugging
  ToF[2]       : "EE-7_ToF.spin"
  Ultra     : "EE-7_Ultra.spin"          '<-- Embedded a 2 element obj within EE-7_Ultra

PUB Start(mainMSVal, mainToF1Add, mainToF2Add, mainUltra1Add, mainUltra2Add)

  _Ms_001 := mainMSVal

  'Stop

  cogIDnum:=cognew(sensorCore(mainToF1Add, mainToF2Add, mainUltra1Add, mainUltra2Add),@cogStack)

  return

PUB Stop
  if cogIDNum             'To avoid calling the cog twice
    cogstop (cogIDNum~)

PUB sensorCore (mainToF1Add,mainToF2Add,mainUltra1Add,mainUltra2Add)

   'Declaration & Initialisation
  Ultra.Init(ultra1SCL,ultra1SDA,0)    'Assigning & initialize the first element obj in EE-7_Ultra
  Ultra.Init(ultra2SCL,ultra2SDA,1)    'Assigning & initialize the second element obj in EE-7_Ultra

  tofInit     'Perform initialisation for both tof

  'Get reading
  repeat
    long[mainUltra1Add]:= Ultra.readSensor(0)    'Reading first element obj
    long[mainUltra2Add]:= Ultra.readSensor(1)
    long[mainToF1Add]:= ToF[0].GetSingleRange(tofAdd)
    long[mainToF2Add]:= ToF[1].GetSingleRange(tofAdd)
    Pause(50)

PRI tofInit

  'Declaration & Initialisation
  'Term.Start(31, 30, 0, 115200)


  ''ToF 1 initialization
  ToF[0].Init(tof1SCL, tof1SDA, tof1Reset)
  ToF[0].ChipReset(1)
  Pause(1000)
  ToF[0].FreshReset(tofAdd)
  ToF[0].MandatoryLoad(tofAdd)
  ToF[0].RecommendedLoad(tofAdd)
  ToF[0].FreshReset(tofAdd)

  ''ToF 2 initialization
  ToF[1].Init(tof2SCL, tof2SDA, tof2Reset)
  ToF[1].ChipReset(1)             'Last state is ON position
  Pause(1000)
  ToF[1].FreshReset(tofAdd)
  ToF[1].MandatoryLoad(tofAdd)
  ToF[1].RecommendedLoad(tofAdd)
  ToF[1].FreshReset(tofAdd)

  return

PRI Pause(ms) | t
  t := cnt - 1088
  repeat ( ms#>0 )
    waitcnt(t += _Ms_001)
  return