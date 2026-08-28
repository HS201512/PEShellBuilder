@echo off
path=%path%;X:\Program Files\Ghost;X:\Program Files\DiskGenius;X:\Program Files\PAWinPEx64;X:\Program Files\Dism++;X:\Program Files\WinNTSetup;X:\Program Files\WimTool;X:\Program Files\7-Zip;X:\Program Files\CPU-Z;X:\Program Files\BootICE;X:\Program Files\W11NROP;X:\Program Files\NTPWEdit;X:\Program Files\WindowsLoginUnlocker;X:\Program Files\Everything;X:\Program Files\WinOSInfo;X:\Program Files\AIDA64;X:\Program Files\fastfetch;X:\Program Files\Calc;X:\sources\recovery
title Windows PE
if exist "%~dp0PEStartup.bat" "%~dp0PEStartup.bat"

:main
cls
set choice=
echo 欢迎使用 Windows PE
echo.
echo - PE工具
echo 1.Ghost
echo 2.DiskGenius
echo 3.傲梅分区助手
echo 4.Dism++
echo 5.WinNTSetup
echo 6.WimTool
echo 7.7-Zip
echo 8.CPU-Z
echo 9.BOOTICE
echo 10.NTPWEdit
echo 11.Windows Login Unlocker
echo 12.Everything
echo 13.WinOSInfo
echo 14.AIDA64
echo 15.fastfetch
echo 16.命令提示符
echo 17.注册表
echo 18.记事本
echo 19.任务管理器
echo 20.计算器
echo 21.W11NROP
echo.
echo - Windows RE 选项
echo 22.进入 Windows RE
echo.
echo - 电源选项
echo A.关机
echo B.重启
echo.
set /p choice=输入选项：
if "%choice%"=="1" start ghost64.exe
if "%choice%"=="2" start diskgenius.exe
if "%choice%"=="3" start startpartassist.exe
if "%choice%"=="4" start dism++x64.exe
if "%choice%"=="5" start winntsetup_x64.exe
if "%choice%"=="6" start wimtool.exe
if "%choice%"=="7" start 7zfm.exe
if "%choice%"=="8" start cpuz_x64.exe
if "%choice%"=="9" start booticex64.exe
if "%choice%"=="10" start NTPWEdit64.exe
if "%choice%"=="11" start WLU64.exe
if "%choice%"=="12" start everything.exe
if "%choice%"=="13" start winosinfo.exe
if "%choice%"=="14" start aida64.exe
if "%choice%"=="15" start startfastfetch.bat
if "%choice%"=="16" start cmd.exe
if "%choice%"=="17" start regedit.exe
if "%choice%"=="18" start notepad.exe
if "%choice%"=="19" start taskmgr.exe
if "%choice%"=="20" start calc-x64.exe
if "%choice%"=="21" start W11NROP.cmd
if "%choice%"=="22" start recenv.exe
if /i "%choice%"=="A" cls&echo 正在关机&wpeutil shutdown
if /i "%choice%"=="B" cls&echo 正在重启&wpeutil reboot
goto main