# Active Window Volume Controls
## Overview
This is a set of scripts for adjusting volume on whatever the active application in windows is.

I created this to simplify making on the fly audio adjustments for my partner's streams (shameless plug, check him out on twitch at [AogumaBear](https://www.twitch.tv/AogumaBear))

By defautl it also shows an overlay giving you the adjusted volume:

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
```markdown
```

### StreamDeck without plugin
For each button you want, make a .bat file containing the appropriate command line command. 

### Using keyboard shortcuts


## Advanced tweaks

