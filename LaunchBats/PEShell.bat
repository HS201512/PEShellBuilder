@echo off
path=%path%;X:\Program Files\Ghost;X:\Program Files\DiskGenius;X:\Program Files\Dism++;X:\Program Files\WinNTSetup;X:\Program Files\7-Zip;X:\Program Files\CPU-Z;X:\Program Files\BOOTICE;X:\sources\recovery
title Windows PE

:main
cls
set choice=
echo 欢迎使用 Windows PE
echo.
echo - PE工具
echo 1.Ghost
echo 2.DiskGenius
echo 3.Dism++
echo 4.WinNTSetup
echo 5.7-Zip
echo 6.CPU-Z
echo 7.BOOTICE
echo 8.命令提示符
echo 9.注册表
echo 10.记事本
echo 11.任务管理器
echo.
echo - Windows RE 选项
echo 12.进入 Windows RE
echo.
echo - 电源选项
echo A.关机
echo B.重启
echo.
set /p choice=输入选项：
if "%choice%"=="1" start ghost64.exe
if "%choice%"=="2" start diskgenius.exe
if "%choice%"=="3" start dism++x64.exe
if "%choice%"=="4" start winntsetup.exe
if "%choice%"=="5" start 7zfm.exe
if "%choice%"=="6" start cpuz_x64.exe
if "%choice%"=="7" start booticex64.exe
if "%choice%"=="8" start cmd.exe
if "%choice%"=="9" start regedit.exe
if "%choice%"=="10" start notepad.exe
if "%choice%"=="11" start taskmgr.exe
if "%choice%"=="12" start recenv.exe
if /i "%choice%"=="A" cls&echo 正在关机&wpeutil shutdown
if /i "%choice%"=="B" cls&echo 正在重启&wpeutil reboot
goto main