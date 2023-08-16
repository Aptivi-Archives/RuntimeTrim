@echo off
REM This script builds documentation and packs the artifacts. Use when you have VS installed.
for /f "tokens=* USEBACKQ" %%f in (`type version`) do set ksversion=%%f

echo Finding DocFX...
if exist %ProgramData%\chocolatey\bin\docfx.exe goto :build
echo You don't have DocFX installed. Download and install Chocolatey and DocFX.
goto :finished

:build
echo Building documentation...
%ProgramData%\chocolatey\bin\docfx.exe "..\DocGen\docfx.json"
if %errorlevel% == 0 goto :success
echo There was an error trying to build documentation (%errorlevel%).
goto :finished

:success
echo Build and pack successful.
:finished
