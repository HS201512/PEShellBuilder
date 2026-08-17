@echo off
title Windows 11 Network Requirement Override Patch

:main
cls
echo W11NROP v0.02
echo.
echo 此工具可以帮助您绕过 Windows 11 OOBE 的网络要求覆盖
echo.
set /p sysdrv=输入已经安装 Windows 11 的盘符：
if not exist "%sysdrv%:\Windows\System32\config\SYSTEM" (
    cls
    echo 错误：找不到指定的路径
    echo 按任意键返回
    pause >nul
    goto main
)

:startpatch
cls
echo 正在运行 W11NROP v0.02……
echo.
reg load "HKLM\W11" "%sysdrv%:\Windows\System32\config\SOFTWARE"
reg add "HKLM\W11\Microsoft\Windows\CurrentVersion\OOBE" /v BypassNRO /t REG_DWORD /d 1 /f
reg unload "HKLM\W11"
echo.
echo 操作完成！
echo 按任意键返回
pause >nul
exit /b