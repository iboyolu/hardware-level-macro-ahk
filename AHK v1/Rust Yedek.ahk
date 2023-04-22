#SingleInstance force
#Persistent
#include Lib\JSON.ahk
#include Lib\AutoHotInterception.ahk
global AHI := new AutoHotInterception()
global keyboardId := AHI.GetKeyboardId(0x0951, 0x16DD)
AHI.SubscribeKeyboard(keyboardId, false, Func("KeyEvent"))
KeyEvent(code, state){
	;ToolTip % "Keyboard Key - Code: " code ", State: " state
}
global mouseId := AHI.GetMouseId(0x09DA, 0x13C1)
AHI.SubscribeMouseButtons(mouseId, false, Func("MouseButtonEvent"), true)
;ls = loopstate
global ls_left, ls_right, ls_middle, ls_side1, ls_side2, ls_mw_vertical, ls_mw_horizontal
MouseButtonEvent(code, state){
	;0: Left Mouse
	if code = 0
	{
		ls_left := (state = 1) ? 1 : 0
		;ToolTip % "Mouse Button - Code: " code ", State: " state
		while (ls_left = 1)
			returnedValue := left_down()
		if returnedValue = 0
			left_up()
	}
}
;0: Left Mouse
;1: Right Mouse
;2: Middle Mouse
;3: Side Button 1
;4: Side Button 2
;5: Mouse Wheel (Vertical)
;6: Mouse Wheel (Horizontal)
global mouseData := []
global prevX := -1
global prevY := -1
return
;/////////////////////////////////////////////////////////
;AHI.SendMouseMoveAbsolute(mouseId, 850, 201)
;AHI.MoveCursor(850, 201, coordMode, mouseId)
;ToolTip, down
/*
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
;IfWinActive, ahk_exe RustClient.exe
left_down(){
	record_mouse_movements(1)
return 0
}
left_up(){
	;ToolTip, up
	record_mouse_movements(0)
}
record_mouse_movements(recordOnOff)
{
	if recordOnOff
	{
		timestamp := A_TickCount
		MouseGetPos, mouseX, mouseY

		if (mouseX != prevX or mouseY != prevY)
		{
			mouseData.push({ "timestamp": timestamp, "x": mouseX, "y": mouseY })
			prevX := mouseX
			prevY := mouseY
			;sleep 50
		}
	}
	else{
		sleep, 10
		mouseDataStr := ""
		for i, item in mouseData
		{
			mouseDataStr .= "Timestamp: " item.timestamp ", X: " item.x ", Y: " item.y "`n"
		}
		Clipboard := mouseDataStr
		Sleep, 10
		mouseData := []
	}
}

;/////////////////////////////////////////////////////////
^Esc::
	ExitApp
return
^`::
	ControlSend, , ^s, ahk_exe SciTE.exe
	Reload
return

















