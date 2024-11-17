@echo off
echo setting variables
set arch="x86_64"
set name="xdelta3"
set ver="3.1.0"
echo.

echo downloading patcher
curl -fSLo xdelta.zip https://github.com/jmacd/xdelta-gpl/releases/download/v%ver%/%name%-%ver%-%arch%.exe.zip
powershell expand-archive xdelta.zip
del xdelta.zip
move xdelta\%name%-%ver%-%arch%.exe
echo.

echo downloading patch
curl -fSLo xdelta.zip https://files.catbox.moe/2myxqs.zip
powershell expand-archive xdelta.zip
del xdelta.zip
move xdelta\patch.xdelta
rmdir xdelta
echo.

echo patching skyrim
ren SkyrimSE.exe SkyrimSE.exe.unpatched
%name%-%ver%-%arch%.exe -d -s SkyrimSE.exe.unpatched patch.xdelta SkyrimSE.exe
echo.

echo cleaning up leftovers
del patch.xdelta
del %name%-%ver%-%arch%.exe
echo.

echo Skyrim GOG has been patched!
pause