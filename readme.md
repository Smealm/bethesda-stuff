this section is for bethesda scripts or whatever

in the SkyrimSE Folder, download run.bat and put it into `\steamapps\common\Skyrim Special Edition\`
open up steam and right click on skyrim, go to properties, launch options and put `run.bat %command%` into it.
the same setup with Fallout 4 but use the run.bat from the Fallout 4 Folder

---------------

run.bat is for Script Extenders. if the script extender is present, launching the game from steam launches the game through the Script Extender, if the Script Extender is not present it launches the game through its official launcher.

This is useful for people who use mod managers like Vortex and want to launch Skyrim or Fallout 4 through steam without having their mods break due to script extender not running, but also want to switch between modded and vanilla play without having to constantly rename Script Extender and configure its INI to point to the games exe. which is what [these guides do](https://steamcommunity.com/sharedfiles/filedetails/?id=1291557988)

i figured out my own way of achieving the same result with the only downside being that it bypasses the launcher if script extender is present. i uploaded it here with instructions in case it may help someone


---------------

VortexFixer.ps1 is a script enables you to fix your Skyrim installation, reverting it to a clean state without having to completely reinstall it

To use; open Vortex and use its 'purge mods' feature. Vortex will try to remove all mods from your mods folder, however this isn't enough. Vortex is known to leave leftovers behind, it will miss mods. that's where this script comes in. put this script in the root of your skyrims folder and run it (VortexFixer.ps1 should be in the same folder as SkyrimSE.exe). 

it will delete any file that isn't a vortex backup file, vortex management indicator file, vortex deployment index file or any vanilla skyrim file. it will effectively delete all files within the data folder that aren't in a vanilla, clean install, but it also skips any files vortex uses to manage skyrim so you can get right back to modding with it.

---------------
'Duplicate Remover.ps1' searches two set directories, checks for conflicts between both and fixes them by removing the conflicting files from the target folder (the second folder specified) i made this to clean up my skyrim collection packages and put it here in case i might need it again later in case i end up accidentally deleting it.
