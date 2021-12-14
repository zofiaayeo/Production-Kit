{Object_Title_and_Purpose}


CON
        _clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
        _xinfreq = 5_000_000
        _ConClkFreq = ((_clkmode - xtal1) >> 6) * _xinfreq
        _Ms_001 = _ConClkFreq / 1_000

        xbee
        xbeeBaud = 9600

        commStart =$7A
        commForward = $01
        commReverse = $02
        commLeft = $03
        commRight = $04
        commStopAll = $AA

VAR
  long  symbol

OBJ
  XBee          :"FullDuplexSerial.spin"

PUB Main

  Pause(2000)

  XBee.Start(xbeeRx, xbeeTx, 0, xbeeBaud)

  'Perform a forward movement
  StartCmd    '1st byte
  MoveForward '2nd byte
  Pause(3000)  'Commcontrol waits, motorcontrol (continue move forward)
  StartCmd     '1st byte
  StopCmd      '2nd byte


  repeat


PRI performCrankCourse
{{Sequence for performing the route as specified in EE-6 Assignment}}

  StartCmd
  repeat 10
    MoveFwd


DAT
name    byte  "string_data",0
