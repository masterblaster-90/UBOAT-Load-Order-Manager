@echo off
setlocal
cd /d "%~dp0"
title UBOAT - Switch to MP
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0UBOAT_LoadOrder_Manager.ps1" -Mode MP
set "RC=%ERRORLEVEL%"
pause
exit /b %RC%
