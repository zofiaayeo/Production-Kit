{Object_Title_and_Purpose}
{
  Project: EE-8 Assignment
  Platform: Parallax Project USB Board
  Author: Elson Tan Jun Hao 2102036
  Date: 22 Nov 2021
  Log:
        Date:   Desc:
        22 Nov 2021:   Create a CommControl.spin file to poll & capture the data from the ZigBee transmitter.
}

CON
        ''Communication Protocol - ZigBee
        commTxPin = 21          'DIN
        commRxPin = 20          'DOUT
        commBaud = 9600

        commStart =$7A          'Start
        commForward = $01       'Move Forward
        commReverse = $02       'Reverse
        commLeft = $03          'Turn Left
        commRight = $04         'Turn Right
        commStopAll = $AA       'Stop and wait for further commands




VAR  'Global Variable

  long cog3ID
  long cog3Stack[64]
  long _Ms_001

OBJ   ' Objects
  Comm      : "FullDuplexSerial.spin" 'UART communication for debugging


PUB Start(mainMSVal1,rxVal)



  _Ms_001 := mainMSVal1

  Stop

  Pause(1000)

  cog3ID := cognew(Value(rxVal),@cog3Stack)

  return
PUB Value(rxVal) | tmp

  Comm.Start(commRxPin,commTxPin,0,commBaud)
  Pause(1000)

  repeat
    tmp := Comm.Rx  'tmp repeatly check for the command
    if tmp == CommStart  'When tmp is $7A
      tmp := Comm.Rx   'Check tmp next command for movement
      case tmp
        CommForward:
         long[rxVal] := 1
        CommReverse:
         long[rxVal] := 2
        CommLeft:
          long[rxVal] := 3
        CommRight:
          long[rxVal] := 4
        CommStopAll:
          long[rxVal] := 5


PUB Stop
  if cog3ID    ''Avoid reintialization of cog
    cogstop (cog3ID~)

PRI Pause(ms) | t
  t := cnt - 1088
  repeat ( ms#>0 )
    waitcnt(t += _Ms_001)
  return