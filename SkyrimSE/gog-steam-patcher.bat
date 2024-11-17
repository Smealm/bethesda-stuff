@echo off
echo setting variables
set arch="x86_64"
set name="xdelta3"
set ver="3.1.0"
:mainmenu
cls

:: Title
echo ***************************************
echo   Skyrim GOG to Skyrim Steam patcher
echo ***************************************
echo.

:: Option Menu
echo [1] Patch Skyrim
echo [2] Unpatch Skyrim
echo [3] Exit
echo.

:: Get User Choice
choice /c 123 /n /m "Please select an option (1, 2, or 3):"

:: Handle User Input
set choice=%errorlevel%

:: Handle Patching Option
if %choice%==1 (
    cls
    echo *********************
    echo   Patching Skyrim...
    echo *********************
    echo.
    if exist SkyrimSE.exe.unpatched (
        echo Skyrim is already patched!
		pause
        goto mainmenu
    ) else (
        echo Skyrim is not patched yet. Proceeding with patching...
        echo.
        
        echo Downloading patcher...
        curl -fSLo xdelta.zip https://github.com/jmacd/xdelta-gpl/releases/download/v%ver%/%name%-%ver%-%arch%.exe.zip
        powershell Expand-Archive -Path xdelta.zip -DestinationPath .
        del xdelta.zip
        move xdelta\%name%-%ver%-%arch%.exe .
        echo.

        echo Downloading patch...
        curl -fSLo xdelta.zip https://files.catbox.moe/nt10nn.zip
        powershell Expand-Archive -Path xdelta.zip -DestinationPath .
        del xdelta.zip
        move xdelta\exepatch.xdelta .
        move xdelta\dllpatch.xdelta .
        rmdir /S /Q xdelta
        echo.

        echo Applying patches...
        ren SkyrimSE.exe SkyrimSE.exe.unpatched
        %name%-%ver%-%arch%.exe -d -s SkyrimSE.exe.unpatched exepatch.xdelta SkyrimSE.exe
        %name%-%ver%-%arch%.exe -d -s Galaxy64.dll dllpatch.xdelta steam_api64.dll
        echo.

        echo Cleaning up...
        del exepatch.xdelta
        del dllpatch.xdelta
        del %name%-%ver%-%arch%.exe
        echo.

        echo Skyrim GOG has been patched successfully!
		pause
        goto mainmenu
    )
)

:: Handle Unpatching Option
if %choice%==2 (
    cls
    echo *********************
    echo  Unpatching Skyrim...
    echo *********************
    echo.
    if not exist steam_api64.dll (
        echo Skyrim is already unpatched.
		pause
        goto mainmenu
    ) else (
        del SkyrimSE.exe
        ren SkyrimSE.exe.unpatched SkyrimSE.exe
		del steam_api64.dll
        echo Skyrim has been unpatched successfully.
		pause
        goto mainmenu
    )
)
