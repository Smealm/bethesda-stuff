@echo off
if exist nvse_loader.exe ( 
 nvse_loader.exe
 exit
) else (
 goto skip1
)
:skip1

FalloutNVLauncher.exe