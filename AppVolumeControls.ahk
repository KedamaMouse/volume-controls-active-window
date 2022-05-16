global msForOverlay:=3000 ;ahow long in milliseconds the overlay displays.
global guiBackgroundColor:="228C22" ;hex code for popup background
global textColor:="FFFFFF"  ;hex code for text color
global progressColor:="0000AF"
global guiTransparency:=255 ;adjust to make the window semi-transparent. this takes a value between 0 and 255, 150 is a good semi-transparent value.

;following the example here: 
;https://www.autohotkey.com/docs/commands/OnMessage.htm#ExCustom
;using windows messages lets us avoid hotkeys while keeping this script persistent so it only creates one Gui.
;a second script can take command line arguments to send commands to this script.
OnMessage(0x5555, "MsgMonitor")

MsgMonitor(wParam, lParam, msg)
{
	If(wParam = 1)
	{
		ChangeActiveAppVolume(lParam)		
	}
	Else If(wParam = 2)
	{
		ChangeActiveAppVolumeRelative(lParam)
	} 
	Else If(wParam = 3)
	{
		SetActiveAppVolume(lParam)
	}
}

;

ChangeActiveAppVolume(change, startingVolume:="")
{
	WinGet, process_name, ProcessName, A
	
	If(startingVolume="")
	{
		startingVolume:=GetAppPercentVolume(process_name)
	}
	
	RunWait svcl.exe /ChangeVolume "%process_name%" %change%,, hide
	ShowAppVolume(process_name,(startingVolume + change > 0))
}

;Adjust volume relative to its current value
;At 0-10% - 1% increments
;At 10-50% - 5% increments
;At 50-100% - 10% increments
;dir - postive to raise volume, negative to lower volume
ChangeActiveAppVolumeRelative(dir)
{

	WinGet, process_name, ProcessName, A
	volume:= GetAppPercentVolume(process_name)
	
	;doing this .1 adjustment based on the direction lets us use the same conditions for +- volume
	adjustedVol:= volume + ((dir > 0) ? 0.1 : -0.1)
	change:=0
	If (adjustedVol > 50)
	{
		change:=10
	}
	Else If(adjustedVol > 10)
	{
		change:=5
	}
	Else
	{
		change:=1
	}
	
	If(dir < 0)
	{
		change:=-change
	}
	ChangeActiveAppVolume(change, volume)
}


SetActiveAppVolume(newVal)
{
	WinGet, process_name, ProcessName, A
	RunWait svcl.exe /SetVolume "%process_name%" %newVal%,, hide
	ShowAppVolume(process_name, ((newVal > 0) ? true : false) )
}

GetAppPercentVolume(processName)
{
	RunWait svcl.exe /GetPercent %processName%,, hide
	vol:= errorlevel // 10

	return vol
}

ShowAppVolume(processName, notExpectingZero:=false)
{

	;global guiObject
	volume:= GetAppPercentVolume(processName)
	
	msg:=""
	If(notExpectingZero & (volume = 0))
	{
		msg = Volume for %processName% not found.
	}
	Else
	{
		msg = %processName% %volume%
	}

	;uncomment to position based on obs. 
	;WinGetPos, X, Y, , ,  ahk_exe obs64.exe
	
	X:= (X ? X : 0)+20
	Y:= (Y ? Y : 0)+50
	
	Gui, VolumeIndicator:New
	Gui, -Caption +AlwaysOnTop +LastFound +ToolWindow
	Gui, Color, %guiBackgroundColor%
	WinSet, Transparent, %guiTransparency%
	Gui, Font, s16 c%textColor%
	Gui, Add, Text,, %msg%
	Gui, Add, Progress, w416 c%progressColor%, %volume%
	Gui, Show, x%X% y%Y% NoActivate , ShowAppVolumePopup
	SetTimer, RemoveOverlay, %msForOverlay%
}


RemoveOverlay:
    Gui VolumeIndicator:Destroy