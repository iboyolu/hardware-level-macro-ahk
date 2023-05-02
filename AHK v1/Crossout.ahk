#NoEnv
#Include Lib\AutoHotInterception.ahk
#SingleInstance force
#InstallMouseHook
if FileExist(A_ScriptDir . "\icon.ico")
	Menu, Tray, Icon, %A_ScriptDir%\icon.ico
global AHI := new AutoHotInterception()
global keyboardId := AHI.GetKeyboardId(0x0951, 0x16DD)
global mouseId := AHI.GetMouseId(0x09DA, 0x13C1)
global game_name := "Crossout.exe"
AHI.SubscribeKeyboard(keyboardId, false, Func("KeyEvent"))
KeyEvent(code, state){
    ifequal state, 0, return
    ; Numpad0 = 82; Numpad1 = 79; Numpad2 = 80; Numpad3 = 81; Numpad4 = 75; Numpad5 = 76; Numpad6 = 77; Numpad7 = 71; Numpad8 = 72; Numpad9 = 73
	;~ ToolTip % "Keyboard Key - Code: " code ", State: " state
    Switch code
    {
        case 82:
            Numpad0()
        case 79:
            Numpad1()
        case 80:
            Numpad2()
        case 81:
            Numpad3()
        case 69:
            pauseKey()
    }
}
; Numpad0
Numpad0(){
    AHI.UnsubscribeMouseButton(mouseId, 0)
    notice_mod_chance("Normal Mode")
}
; Numpad1
Numpad1(){
    AHI.UnsubscribeMouseButton(mouseId, 0)
    AHI.SubscribeMouseButton(mouseId, 0, false, Func("All_Guns_Fire_mouse"))
    notice_mod_chance("All Guns Fire")
}
All_Guns_Fire_mouse(state){
    if !CheckIfWinActive()
        return
    if state
    {
        AHI.SendKeyEvent(keyboardId, GetKeySC("1"), 1)
        AHI.SendKeyEvent(keyboardId, GetKeySC("2"), 1)
        AHI.SendMouseButtonEvent(mouseId, 2, 1)

    }
    else
    {
        AHI.SendKeyEvent(keyboardId, GetKeySC("1"), 0)
        AHI.SendKeyEvent(keyboardId, GetKeySC("2"), 0)
        AHI.SendMouseButtonEvent(mouseId, 2, 0)
    }

}
; Numpad2
Numpad2(){
    AHI.UnsubscribeMouseButton(mouseId, 0)
    AHI.SubscribeMouseButton(mouseId, 0, false, Func("Machine_mouse"))
    notice_mod_chance("Machine")
}
Machine_mouse(state){
    While (GetKeyState("LButton", "P") && state && CheckIfWinActive())
    {
        AHI.SendKeyEvent(keyboardId, GetKeySC("1"), 1)
        AHI.SendKeyEvent(keyboardId, GetKeySC("1"), 0)
        ;~ AHI.SendMouseButtonEvent(mouseId, 0, 1)
        ;~ AHI.SendMouseButtonEvent(mouseId, 0, 0)
    }
}
; Numpad3
Numpad3(){
    AHI.UnsubscribeMouseButton(mouseId, 0)
    AHI.SubscribeMouseButton(mouseId, 0, false, Func("Artillery_numpad3"))
    notice_mod_chance("Artillery_numpad3")
}
Artillery_numpad3(state){
    if !CheckIfWinActive()
        return
}
; pauseKey
pauseKey(){
    ifequal state, 0, return
    IfWinNotActive, ahk_exe Crossout.exe
        return
    ; delete code 14
    AHI.SendKeyEvent(keyboardId, 14, 1)
    sleep 1020
    AHI.SendKeyEvent(keyboardId, 14, 0)
}
; Right_Mouse_Zoom
;~ AHI.SubscribeMouseButton(mouseId, 1, false, Func("Right_Mouse_Zoom"))
Right_Mouse_Zoom(state){
    if !CheckIfWinActive()
        return
    ifequal state, 0, return
    AHI.SendMouseButtonEvent(mouseId, 5, 1)
    Sleep, 25
    AHI.SendMouseButtonEvent(mouseId, 5, 0)
    Sleep, 25

}
; Others
/*
;~ start := A_TickCount
;~ notice_mod_chance("state " . state . " All_Guns_Fire_mouse")
;~ Run, chair\chair.ahk
;~ #SingleInstance force
;~ #Persistent
;~ #InstallMouseHook
;~ AHI.SendMouseButtonEvent(mouseId, 0, 1)
;~ AHI.SendMouseButtonEvent(mouseId, 0, 0)
;~ start := A_TickCount
;;~ if ((A_TickCount - start)/1000) > 3
    ;;~ break
myList := []
While GetKeyState("LButton", "P")
{
    ; Get the current position of the mouse
    ;~ MouseGetPos, currentX, currentY
    direction := AHI.GetDirection(cp, dp)
    ; Calculate the distance moved from the starting position
    ;~ distance := AHI.GetDirection(startX "|" startY, currentX "|" currentY)

    ; Print the distance moved
    myList.push(direction)
    ToolTip, % " : " direction
}
myString := myList.Join(", ")
Clipboard := myString  ; copy string to clipboard
*/
notice_mod_chance(mod){
    ToolTip, %mod% on
    Sleep 500
    ToolTip
}
CheckIfWinActive(){
    IfWinActive, ahk_exe %game_name%
        return true
    else
        return false
}
return




^Esc::
    ExitApp
return

^`::
    ;ControlSend, , ^s, ahk_exe notepad++.exe
    ControlSend, , ^s, ahk_exe SciTE.exe
    Reload
return