@echo off
for /f "tokens=* USEBACKQ" %%f in (`type version`) do set ksversion=%%f

:packbin
echo Packing binary...
"%ProgramFiles%\WinRAR\rar.exe" a -ep1 -r -m5 %temp%/%ksversion%-bin.rar "..\RuntimeTrim\bin\Release\net6.0\"
if %errorlevel% == 0 goto :complete
echo There was an error trying to pack binary (%errorlevel%).
goto :finished

:complete
move %temp%\%ksversion%-bin.rar
echo Pack successful.
:finished
