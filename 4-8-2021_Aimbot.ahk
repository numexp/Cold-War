#Persistent
#KeyHistory, 0
#NoEnv
#HotKeyInterval 1
#MaxHotkeysPerInterval 127
#InstallKeybdHook
#UseHook
#SingleInstance, Force
SetKeyDelay,-1, 8
SetControlDelay, -1
SetMouseDelay, -1
SetWinDelay,-1
SendMode, InputThenPlay
SetBatchLines,-1
ListLines, Off
CoordMode, Pixel, Screen, RGB
CoordMode, Mouse, Screen
PID := DllCall("GetCurrentProcessId")
Process, Priority, %PID%, Normal
 

EMCol := 0xd40f2d
ColVn := 15
ZeroX := 955
ZeroY := 520
CFovX := 100
CFovY := 50
ScanL := ZeroX - CFovX
ScanR := ZeroX + CFovX
ScanT := ZeroY - CFovY
ScanB := ZeroY + CFovY

\:: ;starting hotkey
loop {
Loop, {

keywait, ', D T0.01 ;exit out of loop
if errorlevel = 0
break

GetKeyState, Mouse2, RButton, P
PixelSearch, AimPixelX, AimPixelY, ScanL, ScanT, ScanR, ScanB, EMCol, ColVn, Fast RGB
GoSub GetAimOffset
GoSub GetAimMoves
GoSub MouseMoves
;GoSub DebugTool
GoSub SleepF
}
 
GetAimOffset:
 AimX := AimPixelX - ZeroX
 AimY := AimPixelY - ZeroY
  If ( AimX > 0 ) {
   DirX := .8
  }
  If ( AimX < 0 ) {
   DirX := -.8
  }
  If ( AimY > 0 ) {
   DirY := .8
  }
  If ( AimY < 0 ) {
   DirY := -.8
  }
 AimOffsetX := AimX * DirX
 AimOffsetY := AimY * DirY
Return
 
GetAimMoves:
 RootX := Ceil(( AimOffsetX ** ( 1 / 2 )))
 RootY := Ceil(( AimOffsetY ** ( 1 / 2 )))
 MoveX := RootX * DirX
 MoveY := RootY * DirY
Return
 
MouseMoves:
If ( Mouse2 == "D" ) {
 DllCall("mouse_event", uint, 1, int, MoveX, int, MoveY, uint, 0, int, 0)
 }
Return
 
SleepF:
SleepDuration = 1
TimePeriod = 1
DllCall("Winmm\timeBeginPeriod", uint, TimePeriod)
Iterations = 4
StartTime := A_TickCount
Loop, %Iterations% {
    DllCall("Sleep", UInt, TimePeriod)
}
DllCall("Winmm\timeEndPeriod", UInt, TimePeriod)
Return
 
DebugTool:
;MouseGetPos, MX, MY
;ToolTip, %AimOffsetX% | %AimOffsetY%
;ToolTip, %AimX% | %AimY%
;ToolTip, %IntAimX% | %IntAimY%
;ToolTip, %RootX% | %RootY%
;ToolTip, %MoveX% | %MoveY% || %MX% %MY%
Return
 
!x::
Reload
Return
}
return
