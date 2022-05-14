SetWorkingDir %A_ScriptDir%
command:=0

If(A_Args[1] == "ChangeActiveAppVolume")
{
	command:=1
}
Else If(A_Args[1] == "ChangeActiveAppVolumeRelative")
{
	command:=2
}
Else If(A_Args[1] == "SetActiveAppVolume")
{
	command:=3
}
Else
{
	;scuff because writing to standard out doesn't work. 
	;supposedly ways around it but they weren't working and i don't want to look into it more now.
	MsgBox , 
	(
	Options:
	ChangeActiveAppVolume [changePercent] : adjust the active window's volume by changePercent
	
	ChangeActiveAppVolumeRelative [Direction] : adjust the active window's volume by a variable percent. Direction should be 1 to increase and -1 to decrease
	
	SetActiveAppVolume [newVolume]: set the active window's volume to newVolume
	
	)
	
}
SetTitleMatchMode 2
DetectHiddenWindows On
if (!WinExist("AppVolumeControls.ahk ahk_class AutoHotkey"))
{
	Run AppVolumeControls.ahk
}


if (WinExist("AppVolumeControls.ahk ahk_class AutoHotkey"))
{
    PostMessage, 0x5555, %command%, A_Args[2]  ; The message is sent  to the "last found window" due to WinExist() above.
}
DetectHiddenWindows Off 