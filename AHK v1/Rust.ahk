#SingleInstance force
#Persistent
#include Lib\JSON.ahk
#include Lib\AutoHotInterception.ahk
#NoEnv
#SingleInstance force
#InstallKeybdHook
#InstallMouseHook
if FileExist(A_ScriptDir . "\icon.ico")
	Menu, Tray, Icon, %A_ScriptDir%\icon.ico
global game_name := "RustClient.exe"
global AHI := new AutoHotInterception()
global keyboardId := AHI.GetKeyboardId(0x0951, 0x16DD)
global mouseId := AHI.GetMouseId(0x09DA, 0x13C1)
;;TEST
AHI.SubscribeMouseButton(mouseId, 0, false, Func("Assault_Rifle"))
;;TEST
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

		case 73:
            Numpad9()
    }
}
; Numpad0 - Normal_Mode
Numpad0(){
    AHI.UnsubscribeMouseButton(mouseId, 0)
    notice("Normal_Mode")
}
; Numpad1 - Assault_Rifle
Numpad1(){
    AHI.UnsubscribeMouseButton(mouseId, 0)
    AHI.SubscribeMouseButton(mouseId, 0, false, Func("Assault_Rifle"))
    notice("Assault_Rifle")
}
global Assault_Rifle := new Gun(4000,30)
Assault_Rifle(state){
	ifequal state, 0, return
	tick := A_TickCount
	bullet_counter := 1
	While (GetKeyState("LButton", "P") && state && CheckIfWinActive()){
		tock := A_TickCount
		elapse := tock-tick
		if (elapse > Assault_Rifle.bullet_times[bullet_counter-1])
		{
			Switch bullet_counter
			{-----------------------------------------------------------------------------------------------------
				case 1:
					mmove(-5, 5)
				case 2:
					mmove(-5, 5)
				case 3:
					mmove(-5, 5)
				default:
					mmove(-2, 3)
			}
			bullet_counter += 1
		}
	}
}
class Gun {
    ; Define some properties
    all_magazine_time := 0
    magazine_size := 0
    bullet_times := []

    ; Constructor
    __New(all_magazine_time, magazine_size) {
        this.all_magazine_time := all_magazine_time
        this.magazine_size := magazine_size
        this.calculate_bullet_times()
    }

    ; Calculate bullet times and add them to bullet_times[]
    calculate_bullet_times() {
		current_bullet_time := 0
        per_bullet_time := this.all_magazine_time / this.magazine_size
        loop, % this.magazine_size {
			current_bullet_time += per_bullet_time
            this.bullet_times[A_Index] := current_bullet_time
        }
    }

    getMagazine_size() {
        return this.magazine_size
    }

	getBullet_times() {
        return this.bullet_times
    }
}

; Numpad9 - Record
Numpad9(){
	AHI.UnsubscribeMouseButton(mouseId, 0)
    AHI.SubscribeMouseButton(mouseId, 0, false, Func("Record"))
    notice("Record")
}
;; DLL-----------------------------------------

;; DLL-----------------------------------------
Record(state){
	While (GetKeyState("LButton", "P") && state && CheckIfWinActive())
    {
		MouseGetPos, xpos, ypos
		FormatTime, timestamp, %A_Now%, yyyy-MM-dd HH:mm:ss
		FileAppend, %timestamp% - x: %xpos% y: %ypos%`n, mouse_log.txt
		Sleep, 10
	}
}



mmove(x,y){
	AHI.SendMouseMove(mouseId, x, y)
}
notice(message){
    ToolTip, %message% on
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
;====================================================================================
/*
;0: Left Mouse
;1: Right Mouse
;2: Middle Mouse
;3: Side Button 1
;4: Side Button 2
;5: Mouse Wheel (Vertical)
;6: Mouse Wheel (Horizontal)
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
;AHI.SubscribeMouseMoveAbsolute(mouseId, false, Func("MouseEvent"))
;AHI.SubscribeMouseMoveRelative(mouseId, false, Func("MouseEvent"))

;AHI.SendMouseMoveAbsolute(mouseId, 850, 201)
;AHI.MoveCursor(850, 201, coordMode, mouseId)
;ToolTip, down
ak_bullets := [[-35, 50],[5, 46],[-55, 42],[-42, 37],[0, 33],[16, 28],[29, 24],[38, 19],[42, 14],[42, 9],[38, 9],[30, 18],[17, 25],[0, 29],[-15, 32],[-27, 33],[-37, 32],[-43, 29],[-46, 24],[-45, 17],[-42, 8],[-35, 5],[-24, 14],[-11, 21],[12, 25],[36, 28],[49, 28],[49, 26],[38, 21]]
for index, bullet in ak_bullets
{
	x := ak_bullets[index][1]
	y := ak_bullets[index][2]
	AHI.SendMouseMove(mouseId, x, y)
	sleep 133 ; delay between each bullet to achieve 7.5 rounds per second
	if (!GetKeyState("LButton", "P"))
		break
}
*/
^Esc::
	ExitApp
return
^`::
	;ControlSend, , ^s, ahk_exe notepad++.exe
	ControlSend, , ^s, ahk_exe SciTE.exe
	Reload
return







