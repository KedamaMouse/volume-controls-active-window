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

ChangeActiveAppVolumeRelative(dir)
{

	WinGet, process_name, ProcessName, A
	volume:= GetAppPercentVolume(process_name)
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
	volume:= GetAppPercentVolume(processName)
	Gui, -Caption +AlwaysOnTop +LastFound +ToolWindow
	Gui, Color, 228C22
	WinSet, Transparent, 150
	Gui, Font, s16
	Gui, Add, Text,, %processName% %volume%
	Gui, Add, Progress,  w416, %volume%
	Gui, Show, x10 y20 NoActivate , ShowAppVolumePopup
	SetTimer, RemoveOverlay, 4000
}
RemoveOverlay:
    Gui Destroy
	
	
;TODOS:
;1. update existing GUI object if it exists, so this is more responsive. probably need to store it.
;2. use https://www.autohotkey.com/docs/commands/OnMessage.htm#ExCustom to send messages so this gets run from another script, but still uses this threads variables. used to avoid more hotkeys.
;3. make other script start up this script if it doesn't exist yet. 