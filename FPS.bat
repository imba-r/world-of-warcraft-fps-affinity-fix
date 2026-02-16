@echo off
setlocal
title FPS - World of Warcraft monitor

set "PS1=%~dp0FPS.ps1"
set "LOG=%~dp0FPS.log"

if not exist "%PS1%" (
  echo PS1 bestand niet gevonden:
  echo "%PS1%"
  pause
  exit /b 1
)

echo Start monitor. Logbestand:
echo "%LOG%"
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%PS1%"

echo.
echo Monitor is gestopt. Check logbestand:
echo "%LOG%"
pause
endlocal
