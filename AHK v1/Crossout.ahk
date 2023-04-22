#NoEnv
#Include Lib\AutoHotInterception.ahk
;~ Run, chair\chair.ahk```
#SingleInstance force
if FileExist(A_ScriptDir . "\icon.ico")
	Menu, Tray, Icon, %A_ScriptDir%\icon.ico
;~ #SingleInstance force
;~ #Persistent
global AHI := new AutoHotInterception()
global keyboardId := AHI.GetKeyboardId(0x0951, 0x16DD)
global mouseId := AHI.GetMouseId(0x09DA, 0x13C1)
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
        case 14:
            keyDelete()
    }
}
Numpad0(){
    AHI.UnsubscribeMouseButton(mouseId, 0)
    notice_mod_chance("Normal")
}
Numpad1(){
    AHI.UnsubscribeMouseButton(mouseId, 0)
    AHI.SubscribeMouseButton(mouseId, 0, false, Func("All_Guns_Fire_mouse"))
    notice_mod_chance("All Guns Fire")
}
Numpad2(){
    AHI.UnsubscribeMouseButton(mouseId, 0)
    AHI.SubscribeMouseButton(mouseId, 0, false, Func("Machine_mouse"))
    notice_mod_chance("Machine")
}
keyDelete(){
    ifequal state, 1, return
    IfWinNotActive, ahk_exe Crossout.exe
        return
    sleep 100
    AHI.SendKeyEvent(keyboardId, 14, 1)
    sleep 1020
    AHI.SendKeyEvent(keyboardId, 14, 0)
}
notice_mod_chance(mod){
    ToolTip, %mod% on
    Sleep 1000
    ToolTip
}
All_Guns_Fire_mouse(state){
    ;~ ifequal state, 0, return
    ;~ notice_mod_chance("state " . state . " All_Guns_Fire_mouse")
    IfWinNotActive, ahk_exe Crossout.exe
        return
    ;~ start := A_TickCount
    if state
    {
        AHI.SendKeyEvent(keyboardId, GetKeySC("1"), 1)
        Sleep, 25
        AHI.SendKeyEvent(keyboardId, GetKeySC("1"), 0)
        Sleep, 25
        AHI.SendKeyEvent(keyboardId, GetKeySC("2"), 1)
        Sleep, 25
        AHI.SendKeyEvent(keyboardId, GetKeySC("2"), 0)
        Sleep, 25
        AHI.SendKeyEvent(keyboardId, GetKeySC("shift"), 1)
        Sleep, 25
        AHI.SendKeyEvent(keyboardId, GetKeySC("shift"), 0)
    }
    else
    {

    }
    ;~ While GetKeyState("LButton", "P")
    ;~ {
        ;~ ;;~ if ((A_TickCount - start)/1000) > 3
            ;~ ;;~ break
        ;~ IfWinNotActive, ahk_exe Crossout.exe
            ;~ break
        ;~ ;;~ AHI.SendMouseButtonEvent(mouseId, 0, 1)

        ;~ AHI.SendKeyEvent(keyboardId, GetKeySC("3"), 1)
        ;~ Sleep, 100
    ;~ }

}
Machine_mouse(state){
    ifequal state, 0, return
    ;~ notice_mod_chance("state " . state . " Machine_mouse")
    IfWinNotActive, ahk_exe Crossout.exe
        return
    start := A_TickCount
    While GetKeyState("LButton", "P")
    {
        ;;~ if ((A_TickCount - start)/1000) > 3
            ;;~ break
        IfWinNotActive, ahk_exe Crossout.exe
            break
        ; down
        ;;~ AHI.SendMouseButtonEvent(mouseId, 0, 1)
        AHI.SendKeyEvent(keyboardId, GetKeySC("1"), 1)
        ; up
        ;;~ AHI.SendMouseButtonEvent(mouseId, 0, 0)
        AHI.SendKeyEvent(keyboardId, GetKeySC("1"), 0)
    }
}
    /*
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
return
^Esc::
    ExitApp
return

^`::
    ;ControlSend, , ^s, ahk_exe notepad++.exe
    ControlSend, , ^s, ahk_exe SciTE.exe
    Reload
return