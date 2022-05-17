# Active Window Volume Controls
## Overview
This is a set of scripts for adjusting volume on whatever the active application in windows is.

I created this to simplify making on the fly audio adjustments for my partner's streams (shameless plug, check him out on twitch at [AogumaBear](https://www.twitch.tv/AogumaBear))

It also shows an overlay giving you the adjusted volume:

![image](https://user-images.githubusercontent.com/2153956/168446531-d917b132-2933-40ba-a532-15a3b7ff8b3d.png)

**Why not just adjust overall desktop volume in windows, or in OBS?**
- In most cases, this is adjusting the volume of things you don't really want to change, like the relative volume of alerts to your voice. You'll also have to adjust volume less overall, one loud APP won't mean having to adjust everything again later.
- The volume OBS captures is actually independent of windonw's master volume, so adjusting that doesn't affect stream at all.

**Why activate this through command line instead of using Autohotkey's built in hotkey functionality?**
- Hotkeys can interfere/overlap with other applications, so it can be difficult to pick unique hotkeys for everything. You never know when a game's going to be using some obscure hotkey combination.

## Dependencies
First you need to download a couple of dependencies:

- [Autohotkey](https://www.autohotkey.com/)
  - This is written using AutoHotkey, which describes itself as "The ultimate automation scripting language for Windows." This simplifies things like getting the active application, getting window positions and showing a basic GUI. It also provides a script that (hopefully) less tech savy folks will feel comfortable adjusting to suit their needs.
- NirSoft's [SoundVolumeCommandLine tool](https://www.nirsoft.net/utils/sound_volume_command_line.html)
  - This is what lets us actually adjust volume for a specific application, and retreive the volume.
  - This needs to be either in the same folder as the autohotkey scripts, or in one of the places windows looks for command line tools, such as C:\Windows. These locations are defined by the PATH variable.
- **Optional** If you're using a Streamdeck, Mike Powell's [Streamdeck command line plugin](https://github.com/mikepowell/streamdeck-commandline/releases/tag/v1.0) makes this simpler to set up. The Streamdeck doesn't support passing in command line arguments natively, so without this you'd need to make a script for each button.

## Setup/Usage

1. download/install the dependencies above
2. Download the two core scripts, AppVolumeControls.ahk and AppVolControlCmdLine.ahk

### General Usage
#### ChangeActiveAppVolume
Adjusts the active window's volume by a fixed Percent
```markdown
//Increase volume by 5%
"[path to AppVolControlCmdLine.ahk]" ChangeActiveAppVolume 5 
//Decrease volume by 5%
"[path to AppVolControlCmdLine.ahk]" ChangeActiveAppVolume -5
```
#### ChangeActiveAppVolumeRelative
Adjusts the active window's volume by a % depending on it's curreent value.
This will use increments of 1 from 0-10, increments of 5 up to 50, and increments of 10 up to 100.
```markdown
//Increase volume
"[path to AppVolControlCmdLine.ahk]" ChangeActiveAppVolumeRelative 1
//Decrease volume
"[path to AppVolControlCmdLine.ahk]" ChangeActiveAppVolumeRelative -1
```
#### SetActiveAppVolume
Sets the active window's volume to the given volume
```markdown
//set volume to 10%
"[path to AppVolControlCmdLine.ahk]" SetActiveAppVolume 10
//set volume to 100%
"[path to AppVolControlCmdLine.ahk]" SetActiveAppVolume 100
```

### StreamDeck using Streamdeck command line plugin
The plugin will give you a new option under "custom" for command line.
Just specify the command you want from the above section and you're good to go!

### StreamDeck without plugin
For each button you want, you need to make a .bat file containing the appropriate command line command, and do this for each button you want.
then you'd use a System: Open button in Streamdeck and launch the .bat file

### Using keyboard shortcuts
If you want to use keyboard shortcuts for this instead, you can use Autohotkey's built in [hotkey syntax](https://www.autohotkey.com/docs/Hotkeys.htm) to specify shortcuts. hotkeyExample.ahk shows an example with the Function keys. If using a hotkey script, it needs to be started for the hotkeys to work. 

## Customizing
The first time it runs, AppVolumeControls.ahk will create a config.ini file in the same folder. This has some simple options you can change, and should look something like this: 
```markdown
[Overlay]
msForOverlay=3000
popupBackgroundColor=228C22
textColor=FFFFFF
ProgressBarColor=0000AF
popupTransparency=255
progressBarWidth=400
windowToPositionFrom=0
xCoordOffset=20
yCoordOffset=50
```
Most of these should be self-explanatory. The one weird one is windowToPositionFrom. You can specify a window to show this on instead of just an offset from the top left of the screen by giving the process exe name. For example to possition the popup on top of obs you would change it to:
```markdown
windowToPositionFrom=obs64.exe
```

## Advanced tweaks
For more advanced tweaks of behavior you have to edit AppVolumeControls.ahk

**After any edits, you need to Exit the script if it's running. do this by right clicking on the AutoHotkey icon in the system tray and choosing Exit**

For example if you like the idea of the relative volume change option, but want it to work slightly differently, you can tweak this if block in ChangeActiveAppVolumeRelative
```markdown
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
```
