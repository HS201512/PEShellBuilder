@echo off
path=%path%;X:\sources\recovery
title Windows PE

:main
cls
set choice=
echo 欢迎使用 Windows PE
echo.
echo - PE工具
echo 1.命令提示符
echo 2.注册表
echo 3.记事本
echo 4.任务管理器
echo.
echo - Windows RE 选项
echo 5.进入 Windows RE
echo.
echo - 电源选项
echo A.关机
echo B.重启
echo.
set /p choice=输入选项：
if "%choice%"=="1" start cmd.exe
if "%choice%"=="2" start regedit.exe
if "%choice%"=="3" start notepad.exe
if "%choice%"=="4" start taskmgr.exe
if "%choice%"=="5" start recenv.exe
if /i "%choice%"=="A" cls&echo 正在关机&wpeutil shutdown
if /i "%choice%"=="B" cls&echo 正在重启&wpeutil reboot
goto main
