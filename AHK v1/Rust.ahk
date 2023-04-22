#SingleInstance force
#Persistent
#include Lib\JSON.ahk
#include Lib\AutoHotInterception.ahk
global AHI := new AutoHotInterception()
global keyboardId := AHI.GetKeyboardId(0x0951, 0x16DD)
global mouseId := AHI.GetMouseId(0x09DA, 0x13C1)
global ls_left, ls_right, ls_middle, ls_side1, ls_side2, ls_mw_vertical, ls_mw_horizontal ;ls = loopstate
global mouseData := [], global dataAk47 := []
Loop, Read, ak47.txt
{
    ; Split the line into separate values
    ;line := StrSplit(A_LoopReadLine, ",")
	arr := StrSplit(A_LoopReadLine, ",")
	timestamp := (StrSplit(arr[1], " ")[2] * 1)*1
	x := (StrSplit(arr[2], " ")[3] * 1)*0.58
	y := (StrSplit(arr[3], " ")[3] * 1)*0.58
	; Create a new object with the values
    item := {}
    item.Timestamp := timestamp
    item.X := x
    item.Y := y
    ; Add the object to the array
    dataAk47.Push(item)
}
;dataAk47 := Json.FromString(ak47Contents)

;==========================================Keyboard==================================
;AHI.SubscribeKeyboard(keyboardId, false, Func("KeyEvent"))
;KeyEvent(code, state){
	;ToolTip % "Keyboard Key - Code: " code ", State: " state
;}
;====================================================================================
;==========================================MOUSE=====================================
/*
;0: Left Mouse
;1: Right Mouse
;2: Middle Mouse
;3: Side Button 1
;4: Side Button 2
;5: Mouse Wheel (Vertical)
;6: Mouse Wheel (Horizontal)
*/
AHI.SubscribeMouseButtons(mouseId, false, Func("MouseButtonEvent"), true)
MouseButtonEvent(code, state){
	IfWinNotActive, ahk_exe RustClient.exe
		return
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
	else if code = 2
	{
		if state
		{
			loop, 10
			{
				AHI.SendMouseMove(mouseId, 127, 0)
				Random, randNum, 16, 22
				Sleep, %randNum%
			}
		}

	}
}
;====================================================================================
;==========================================MOUSE RECORD==============================
;AHI.SubscribeMouseButtons(mouseId, false, Func("record_mouse_movements"), true)
record_mouse_movements(code, state){
	if code = 0 ;0: Left Mouse
	{
		if state
		{
			AHI.SubscribeMouseMove(mouseId, false, Func("MouseMoveEvent"))
		}
		else
		{
			AHI.UnsubscribeMouseMove(mouseId, false, Func("MouseMoveEvent"))
			mouseData := mouseData_dezenleme(mouseData)
			mouseDataStr := ""
			for i, item in mouseData
			{
				mouseDataStr .= "Timestamp: " item.timestamp ", X: " item.x ", Y: " item.y "`n"
			}
			Clipboard := mouseDataStr
			mouseData := []
		}
	}

}
MouseMoveEvent(x, y){
	timestamp := A_TickCount
	mouseData.push({ "timestamp": timestamp, "x": x, "y": y })
	;ToolTip, %x% %y%
}
mouseData_dezenleme(mouseData){
	mouseData_ := []
	global x := 0
	global y := 0
	; loop through original mouse data
	;lastIndex := mouseData.Length() - 1
	;lastElement := mouseData[lastIndex]
	for i, line in mouseData
	{
		if i = 1
			continue
		previousLine := mouseData[i-1]
		; check if this line has the same x and y values as the previous line
		if line.Timestamp = previousLine.Timestamp
		{
			; add this line to the current line
			x += line.X
			x += previousLine.X
			y += line.Y
			y += previousLine.Y
			continue
		}
		else
		{
			elepsed := line.Timestamp - previousLine.Timestamp
		}
		mouseData_.push({ "timestamp": elepsed, "x": x, "y": y })
		x := 0
		y := 0
	}
	return mouseData_
}
;====================================================================================
return
;==========================================MAIN======================================
left_down(){
	;ToolTip, daa
	for i, line in dataAk47
	{
		if (!GetKeyState("LButton", "P")) or (GetKeyState("CTRL", "P"))
			break
		time := line.Timestamp
		x := line.x
		y := line.y
		AHI.SendMouseMove(mouseId, x, y)
		sleep, %time%
	}
	;reload ;macro record testing

return 0
}
left_up(){
	;ToolTip, up

}
;====================================================================================
/*
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

















