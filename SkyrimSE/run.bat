@echo off
if exist skse64_loader.exe ( 
 skse64_loader.exe
 exit
) else (
 goto ELSE
)

:ELSE
cls
@echo off
SkyrimSELauncher.exe