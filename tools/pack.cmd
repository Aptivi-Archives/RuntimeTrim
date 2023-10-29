@echo off
for /f "tokens=* USEBACKQ" %%f in (`type version`) do set ksversion=%%f

:packbin
echo Packing binary...
"%ProgramFiles%\7-Zip\7z.exe" a -tzip %temp%/%ksversion%-bin.zip "..\RuntimeTrim\bin\Release\net6.0\*"
if %errorlevel% == 0 goto :complete
echo There was an error trying to pack binary (%errorlevel%).
goto :finished

:complete
move %temp%\%ksversion%-bin.zip
echo Pack successful.
:finished
