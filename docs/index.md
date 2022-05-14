# Active Window Volume Controls
## Overview
This is a set of scripts for adjusting volume on whatever the active application in windows is.

I created this to simplify making on the fly audio adjustments for my partner's streams (shameless plug, check him out on twitch at [AogumaBear](https://www.twitch.tv/AogumaBear))

**Why not just adjust overall desktop volume in windows, or in OBS?**
- In most cases, this is adjusting the volume of things you don't really want to change, like the relative volume of alerts to your voice. You'll also have to adjust volume less overall, one loud APP won't mean having to adjust everything again later.
- The volume OBS captures is actually independent of windonw's master volume, so adjusting that doesn't affect stream at all.

## Dependencies
First you need to download a couple of dependencies:

- [Autohotkey](https://www.autohotkey.com/)
  - This is written using AutoHotkey, which describes itself as "The ultimate automation scripting language for Windows." This simplifies things like getting the active application, getting window positions and showing a basic GUI. It also provides a script that (hopefully) less tech savy folks will feel comfortable adjusting to suit their needs.
- NirSoft's [SoundVolumeCommandLine tool](https://www.nirsoft.net/utils/sound_volume_command_line.html)
  - This is what lets us actually adjust volume for a specific application, and retreive the volume.
  - This needs to be either in the same folder as the autohotkey scripts, or in one of the places windows looks for command line tools, such as C:\Windows. These locations are defined by the PATH variable.
- If you're using a streamdeck, Mike Powell's [stream deck command line plugin](https://github.com/mikepowell/streamdeck-commandline/releases/tag/v1.0) makes this simpler to set up. The streamdeck doesn't support passing in command line arguments natively, so without this you'd need to make a script for each button.

## Setup/Usage

```markdown

```
