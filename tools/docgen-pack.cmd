@echo off
REM This script builds documentation and packs the artifacts. Use when you have VS installed.
for /f "tokens=* USEBACKQ" %%f in (`type version`) do set ksversion=%%f

:pack
echo Packing documentation...
"%ProgramFiles%\WinRAR\rar.exe" a -ep1 -r -m5 %temp%/%ksversion%-doc.rar "..\docs\"
if %errorlevel% == 0 goto :finalize
echo There was an error trying to pack documentation (%errorlevel%).
goto :finished

:finalize
rmdir /S /Q "..\DocGen\api\"
rmdir /S /Q "..\DocGen\obj\"
rmdir /S /Q "..\docs\"
move %temp%\%ksversion%-doc.rar
echo Build and pack successful.
goto :finished

:finished
pause
