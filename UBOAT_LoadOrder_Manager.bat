@echo off
setlocal
cd /d "%~dp0"
title UBOAT Load Order Manager
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0UBOAT_LoadOrder_Manager.ps1" -Mode Menu
set "RC=%ERRORLEVEL%"
if not "%RC%"=="0" echo The tool ended with error code %RC%.
pause
exit /b %RC%
