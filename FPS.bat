@echo off
setlocal
title FPS - World of Warcraft monitor

set "PS1=%~dp0FPS.ps1"
set "LOG=%~dp0FPS.log"

if not exist "%PS1%" (
  echo PS1 file not found:
  echo "%PS1%"
  pause
  exit /b 1
)

echo Starting monitor. Log file:
echo "%LOG%"
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%PS1%"

echo.
echo Monitor stopped. Check log file:
echo "%LOG%"
pause
endlocal
