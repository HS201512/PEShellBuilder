@echo off

echo.
echo. WinpeÖÆ×÷ÖÐ£¬ÇëÉÔºò¡£¡£¡£
if exist tmp\excel.txt Del tmp\excel.txt /f /q

add2wim\winxshell_x64.exe -script add2wim\Ban.lua

pause
