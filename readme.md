this section is for automating Collection installs using Vortex Mod Manager

get [AHK](https://www.autohotkey.com/)
get [ViolentMonkey](https://violentmonkey.github.io/), after installing the extension get [this](https://greasyfork.org/en/scripts/452309-auto-slow-download-nexus-mods) and [this](https://greasyfork.org/en/scripts/483337-nexus-download-collection)
then download AutoVortex from this Github repo


---------------

bethesda scripts or whatever i end up putting here

in the SkyrimSE Folder, download run.bat and put it into `\steamapps\common\Skyrim Special Edition\`
open up steam and right click on skyrim, go to properties, launch options and put `run.bat %command%` into it.
the same setup with Fallout 4 but use the run.bat from the Fallout 4 Folder

---------------

run.bat is for Script Extenders. if the script extender is present, launching the game from steam launches the game through the Script Extender, if the Script Extender is not present it launches the game through its official launcher.

This is useful for people who use mod managers like Vortex and want to launch Skyrim or Fallout 4 through steam without having their mods break due to script extender not running, but also want to switch between modded and vanilla play without having to constantly rename Script Extender and configure its INI to point to the games exe. which is what [these guides do](https://steamcommunity.com/sharedfiles/filedetails/?id=1291557988)

i figured out my own way of achieving the same result with the only downside being that it bypasses the launcher if script extender is present. i uploaded it here with instructions in case it may help someone
