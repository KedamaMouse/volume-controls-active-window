;following the example here: 
;https://www.autohotkey.com/docs/commands/OnMessage.htm#ExCustom
;using windows messages lets us avoid hotkeys while keeping this script persistent so it only creates one Gui.
;a second script can take command line arguments to send commands to this script.
OnMessage(0x5555, "MsgMonitor",20)
global debugMode:=false
MsgMonitor(wParam, lParam, msg)
{
	If (debugMode) 
	{
		OutputDebug, message received: %wParam% %lParam%
	}
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

ChangeActiveAppVolume(change, startingVolume:="")
{
	WinGet, process_name, ProcessName, A
	
	If(startingVolume="")
	{
		startingVolume:=GetAppPercentVolume(process_name)
	}
	
	If(ProcessInCache(process_name))
	{
		If (debugMode) 
		{
			OutputDebug, ChangeActiveAppVolume cached
		}
		Run svcl.exe /ChangeVolume "%process_name%" %change%,, hide
		cachedVolume["value"]:=Min(Max(startingVolume + change, 0),100)
	}
	Else
	{
		If (debugMode) 
		{ 
			OutputDebug, ChangeActiveAppVolume uncached
		}
		RunWait svcl.exe /ChangeVolume "%process_name%" %change%,, hide
	}
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
	If(ProcessInCache(process_name))
	{
		Run svcl.exe /SetVolume "%process_name%" %newVal%,, hide
	}
	Else
	{
		RunWait svcl.exe /SetVolume "%process_name%" %newVal%,, hide
	}
	ShowAppVolume(process_name, ((newVal > 0) ? true : false))
}
global cachedVolume:= {process: "", value: 0}

ProcessInCache(processName)
{		
	return ((processName = cachedVolume["process"]) && (cachedVolume["value"] > 0))
}

GetAppPercentVolume(processName)
{
	
	If(ProcessInCache(processName))
	{
		return cachedVolume["value"]
	}
	
	RunWait svcl.exe /GetPercent %processName%,, hide
	vol:= errorlevel // 10
	cachedVolume["process"]:=processName 
	cachedVolume["value"]:=vol
	
	return vol
}

global OverlayLabel
global OverlayProgress
global OverlayShowing:=false

ShowAppVolume(processName, notExpectingZero:=false)
{
	msForOverlay:=AddIniSetting("Overlay","msForOverlay",3000,"how long in milliseconds the overlay displays")
	guiBackgroundColor:=AddIniSetting("Overlay","popupBackgroundColor","228C22","hex code for background color")
	textColor:=AddIniSetting("Overlay","textColor","FFFFFF", "hex code for text color")
	progressColor:=AddIniSetting("Overlay","ProgressBarColor","0000AF","hex code for progress bar color")
	guiTransparency:=AddIniSetting("Overlay","popupTransparency",255,"This takes a value between 0 and 255, 150 is a good semi-transparent value.") 
	width:=AddIniSetting("Overlay","progressBarWidth",400,"width of the progress bar in pixels")

	volume:= GetAppPercentVolume(processName)
	msg:=""
	If(notExpectingZero & (volume = 0))
	{
		msg = Volume for %processName% not found.
		cachedVolume:={}
		
	}
	Else
	{
		msg = %processName% %volume%
	}

	
	windowToPositionFrom:=AddIniSetting("Overlay","windowToPositionFrom",false,"specify an exe name to show over a specific window, eg. obs64.exe")
	If(windowToPositionFrom){
		WinGetPos, X, Y, , ,  ahk_exe %windowToPositionFrom%
	}
	
	X:= (X ? X : 0)+AddIniSetting("Overlay","xCoordOffset",20,"x offset for where to show this, from the topleft of the target window.")
	Y:= (Y ? Y : 0)+AddIniSetting("Overlay","yCoordOffset",50,"y offset for where to show this, from the topleft of the target window.")
	
	alwaysOnTop:=AddIniSetting("Overlay","alwaysOnTop",True,"If the overlay shows on top of other windows. For capturing in obs you may want this off")
	hideFromTaskbar:=AddIniSetting("Overlay","hideFromTaskbar", True,"If the overlay is hidden from the taskbar. needs to be off if you want to capture it in obs.")
	alwaysOnTop:= (alwaysOnTop ? "+AlwaysOnTop" : "")
	hideFromTaskbar:= (hideFromTaskbar ? "+ToolWindow" : "")

	If(OverlayShowing)
	{
		GuiControl, VolumeIndicator:Text, OverlayLabel, %msg%
		GuiControl, VolumeIndicator: , OverlayProgress, %volume%
		
	}
	Else
	{
		OverlayShowing:=true
		Gui, VolumeIndicator:New
		Gui, -Caption  %alwaysOnTop% +LastFound %hideFromTaskbar%
		Gui, Color, %guiBackgroundColor%
		WinSet, Transparent, %guiTransparency%
		Gui, Font, s16 c%textColor%
		Gui, Add, Text, vOverlayLabel, %msg%
		Gui, Add, Progress, vOverlayProgress w%width% c%progressColor%, %volume%
		Gui, Show, x%X% y%Y% NoActivate , ShowAppVolumePopup
	}
	SetTimer, RemoveOverlay, %msForOverlay%
}


RemoveOverlay()
{
	OverlayShowing:=false
	SetTimer, RemoveOverlay, Off
	cachedVolume:={}
	OverlayLabel:=false
    Gui VolumeIndicator:Destroy
	
}
AddIniSetting(SectionName,Key,Default, comment:="")
{
	
	IniRead, valueAndComment, config.ini, %SectionName%, %Key%, %default%|
	valueArray:= StrSplit(valueAndComment,"|")
	value:=valueArray[1]
	If(value = "")
	{
		value:= Default
	}
	IniWrite, %value%|%comment%, config.ini, %SectionName%, %Key%
	return %value%
}