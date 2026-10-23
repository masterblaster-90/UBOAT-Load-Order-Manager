@echo off
setlocal
cd /d "%~dp0"
title UBOAT - Switch to SP
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0UBOAT_LoadOrder_Manager.ps1" -Mode SP
set "RC=%ERRORLEVEL%"
pause
exit /b %RC%
