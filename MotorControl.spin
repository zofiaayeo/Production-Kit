{Object_Title_and_Purpose}
{

    Project: EE-6 Assignment
    Platform: Parallax Project USB Board
    Author: Elson Tan Jun Hao 2102036
    Date: 08 Nov 2021
    Log:
        Date:   Desc:
        08 Nov 2021: Implementing basic navigation-> Forward, Reverse, TurnLeft, TurnRight, StopAllMotors
        22 Nov 2021: Creating cog and split up forward and reverse function to 2 different functions, speed up and slow down
}


CON
        ''[Declare Pins for Motors]

        motor1Zero= 1480
        motor2Zero= 1480
        motor3Zero= 1480
        motor4Zero= 1480
        motor1 = 10
        motor2 = 11
        motor3 = 12
        motor4 = 13

VAR 'global variable

  long cog2Stack[64],cog2ID
  long _Ms_001

OBJ
  Motors      : "Servo8Fast_vZ2.spin"
  'Term        : "FullDuplexSerial.spin"

PUB Start (mainMSVal,motor1add,motor2add,motor3add,motor4add)

  _Ms_001 := mainMSVal

  'StopCore

  cog2ID := cognew(RunMotor(motor1add,motor2add,motor3add,motor4add), @cog2Stack)    ''Run spin method in the cog1ID

  return

PUB RunMotor(motor1add,motor2add,motor3add,motor4add)

  MotorInit     'Initializing motors

  repeat
     Motors.Set(motor1, (motor1Zero + long[motor1add]))
     Motors.Set(motor2, (motor2Zero + long[motor2add]))
     Motors.Set(motor3, (motor3Zero + long[motor3add]))
     Motors.Set(motor4, (motor4Zero + long[motor4add]))


''For calibration purposes
'  StopAllMotors

PUB MotorInit
''Set servo pins according to our connection P10, P11, P12, P13 and start motor

  Motors.Init
  Motors.AddSlowPin(motor1)
  Motors.AddSlowPin(motor2)
  Motors.AddSlowPin(motor3)
  Motors.AddSlowPin(motor4)
  Motors.Start
  Pause(100)

  return


PUB StopCore

''Stop cog and place into dormant state.
   if cog2ID
     ''Set Speed to 0%
     StopAllMotors
     cogstop (cog2ID~)

PUB StopAllMotors
'' Input speed% to 0
  Motors.Set(motor1, 1500)
  Motors.Set(motor2, 1500)
  Motors.Set(motor3, 1500)
  Motors.Set(motor4, 1500)

{
PUB Set(motor, speed)  | SpdValue
  '' Speed range 1120(Reverse)<= 1520(Stop) <= 1920(Forward)
  if speed > 100   ''Limit speed up to 100%
    speed := 100

  if speed < -100  ''Limit speed up to -100%
    speed := -100
  SpdValue := 2000 ''Calibration SpdValue first before running code

  Motors.Set(motor,speed*4+SpdValue) ''Set speed for all 4 motors.
                                     ''Multiply 4 because of difference from speed zero to Forward/Reverse is 400microsec

PUB Fwd_Spdup|i

    repeat i from 0 to 30 step (30*5/100) ''5% of input spdpercent Acceleration
        Set(motor1, i)
        Set(motor2, i)
        Set(motor3, i)
        Set(motor4, i)
        Pause(100)



PUB Fwd_Slowdown|i

    repeat i from 50 to 0 step (50*5/100) ''5% of input spdpercent Decceleration
       Set(motor1, i)
       Set(motor2, i)
       Set(motor3, i)
       Set(motor4, i)
       Pause(100)


PUB Rvs_Spdup |i
'' Only input 0% to 100% speed

''_________________Accelerate and decelerate____________________

    repeat i from 0 to -50 step (50*5/100) ''5% of input spdpercent Acceleration
      Set(motor1, i)
      Set(motor2, i)
      Set(motor3, i)
      Set(motor4, i)
      Pause(100)

PUB Rvs_Slowdown|i

  repeat i from -50 to 0 step (50*5/100) ''5% of input spdpercent Decceleration
      Set(motor1, i)
      Set(motor2, i)
      Set(motor3, i)
      Set(motor4, i)
      Pause(100)

PUB TurnRight|i
''Motor2and4 forward , motor1and3 reverse(Make sure same speed input so that it turn at original position)

  repeat
    repeat i from 0 to 27 step (27*5/100) ''5% of input spdpercent Acceleration
      Set(motor1, -i)
      Set(motor2, i)
      Set(motor3, -i)
      Set(motor4, i)
      Pause(100)
    repeat i from 27 to 0 step (27*5/100) ''5% of input spdpercent Decceleration
      Set(motor1, -i)
      Set(motor2, i)
      Set(motor3, -i)
      Set(motor4, i)
      Pause(100)
    StopAllMotors
    QUIT

PUB TurnLeft|i
''Motor1and3 forward , motor2and4 reverse(Make sure same speed input so that it turn at original position)

  repeat
    repeat i from 0 to 27 step (27*5/100) ''5% of input spdpercent Acceleration
      Set(motor1, i)
      Set(motor2, -i)
      Set(motor3, i)
      Set(motor4, -i)
      Pause(100)
    repeat i from 27 to 0 step (27*5/100) ''5% of input spdpercent Decceleration
      Set(motor1, i)
      Set(motor2, -i)
      Set(motor3, i)
      Set(motor4, -i)
      Pause(100)
    StopAllMotors
    QUIT
}

PRI Pause(ms) | t
  t := cnt - 1088
  repeat (ms #> 0)
    waitcnt(t += _Ms_001)
  return