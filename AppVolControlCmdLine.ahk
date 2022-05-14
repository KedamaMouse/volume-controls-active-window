command:=0

If(%1% = ChangeActiveAppVolume)
{
	command:=1
}
Else If(%1% = ChangeActiveAppVolumeRelative)
{
	command:=2
}
Else If(%1% = SetActiveAppVolume)
{
	command:=3
}
Else
{
	
}

SetTitleMatchMode 2
DetectHiddenWindows On
if (!WinExist("AppVolumeControls.ahk ahk_class AutoHotkey"))
{
	Run AppVolumeControls.ahk
}


if (WinExist("AppVolumeControls.ahk ahk_class AutoHotkey"))
{
    PostMessage, 0x5555, %command%, %2%  ; The message is sent  to the "last found window" due to WinExist() above.
}
DetectHiddenWindows Off 