@echo off
if exist f4se_loader.exe ( 
 f4se_loader.exe
 exit
) else (
 goto ELSE
)

:ELSE
cls
@echo off
Fallout4Launcher.exe