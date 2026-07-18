@echo off
path=%path%;X:\Program Files\Ghost;X:\Program Files\DiskGenius;X:\Program Files\Dism++;X:\Program Files\7-Zip;X:\Program Files\CPU-Z;X:\Program Files\BOOTICE;X:\sources\recovery
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
echo 4.7-Zip
echo 5.CPU-Z
echo 6.BOOTICE
echo 7.命令提示符
echo 8.注册表
echo 9.记事本
echo 10.任务管理器
echo.
echo - Windows RE 选项
echo 11.进入 Windows RE
echo.
echo - 电源选项
echo A.关机
echo B.重启
echo.
set /p choice=输入选项：
if "%choice%"=="1" start ghost64.exe
if "%choice%"=="2" start diskgenius.exe
if "%choice%"=="3" start dism++x64.exe
if "%choice%"=="4" start 7zfm.exe
if "%choice%"=="5" start cpuz_x64.exe
if "%choice%"=="6" start booticex64.exe
if "%choice%"=="7" start cmd.exe
if "%choice%"=="8" start regedit.exe
if "%choice%"=="9" start notepad.exe
if "%choice%"=="10" start taskmgr.exe
if "%choice%"=="11" start recenv.exe
if /i "%choice%"=="A" cls&echo 正在关机&wpeutil shutdown
if /i "%choice%"=="B" cls&echo 正在重启&wpeutil reboot
goto main
