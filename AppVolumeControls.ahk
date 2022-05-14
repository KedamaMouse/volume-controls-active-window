;adjust this to change how long in milliseconds the overlay displays.
global msForOverlay:=3000

; example
F1::
ChangeActiveAppVolumeRelative(-1)
Exit
F2::
ChangeActiveAppVolumeRelative(1)
Exit
F3::
SetActiveAppVolume(25)
Exit
F4::
SetActiveAppVolume(75)
Exit

ChangeActiveAppVolume(change)
{
	WinGet, process_name, ProcessName, A
	RunWait svcl.exe /ChangeVolume "%process_name%" %change%,, hide
	ShowAppVolume(process_name)
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
	ChangeActiveAppVolume(change)
}


SetActiveAppVolume(newVal)
{
	WinGet, process_name, ProcessName, A
	RunWait svcl.exe /SetVolume "%process_name%" %newVal%,, hide
	ShowAppVolume(process_name)
}

GetAppPercentVolume(processName)
{
	RunWait svcl.exe /GetPercent %processName%,, hide
	vol:= errorlevel // 10

	return vol
}

ShowAppVolume(processName)
{

	;global guiObject
	volume:= GetAppPercentVolume(processName)

	uncomment to position based on obs. 
	;WinGetPos, X, Y, , ,  ahk_exe obs64.exe
	
	X:= (X ? X : 0)+20
	Y:= (Y ? Y : 0)+50
	
	Gui, VolumeIndicator:New
	Gui, -Caption +AlwaysOnTop +LastFound +ToolWindow
	Gui, Color, 228C22
	;uncommment the line below to make the window semi-transparent. this takes a value between 0 and 255
	;WinSet, Transparent, 150
	Gui, Font, s16 cWhite
	Gui, Add, Text,, %processName% %volume%
	Gui, Add, Progress, w416, %volume%
	Gui, Show, x%X% y%Y% NoActivate , ShowAppVolumePopup
	SetTimer, RemoveOverlay, %msForOverlay%
}


RemoveOverlay:
    Gui VolumeIndicator:Destroy