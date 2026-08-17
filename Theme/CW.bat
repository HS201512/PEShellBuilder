@echo off
if not exist "X:\Windows\Web\BG" (
    md "X:\Windows\Web\BG"
    pecmd wall X:\Windows\Web\bg1.jpg
    copy /y "X:\Program Files\WinXShell\Light\WinXShell.jcfg" "X:\Program Files\WinXShell" >nul
    pecmd kill WinXShell_x64.exe
) else (
    rd /s /q "X:\Windows\Web\BG"
    pecmd wall X:\Windows\System32\winpe.jpg
    copy /y "X:\Program Files\WinXShell\Dark\WinXShell.jcfg" "X:\Program Files\WinXShell" >nul
    pecmd kill WinXShell_x64.exe
)