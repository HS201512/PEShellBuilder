@echo off
cls
title PEShellBuilder v1.00 by derasd
if exist %windir%\zh-cn\*.mui start PEShellBuilder.cmd&exit
dism >nul
if errorlevel 740 (
    echo Error: 0x10
    echo Please run as Administrator
    echo.
    echo Press any key to exit
    pause >nul
    exit
)
path=%path%;%~dp0bin
echo PEShellBuilder
echo.
echo Welcome to PEenBuilder!
echo This is PEShellBuilder.cmd's english edition 
echo Launch bat and tools is chinese edition 
echo.
echo Recommended to use Windows 8¡¢10¡¢11
echo.
set /p drv=Enter Windows ISO driver letter£º
cls
if not exist %drv%:\sources\boot.wim goto error
if not exist %drv%:\sources\install.wim goto error
goto custompe

:error
echo Error: Required files not found
echo Press any key to exit
pause >nul
exit

:custompe
echo Custom PE tools
echo.
echo Existing tools:
dir /b %~dp0PETools
echo.
echo Tools that can't be left:
echo Depends on runtime libraries£¨e.g. WinNTSetup EasyRC CoolInstaller£©
echo.
echo If you choose F, PE won't come with any third-party tools
set /p choice=Do you want custom tools£¿£¨Y/N/F£©£º
if /i "%choice%"=="Y" (
    explorer "%~dp0PETools"
    notepad "%~dp0LaunchBats\PEShell.bat"
    pause
    goto infos
)
if /i "%choice%"=="N" goto infos
if /i "%choice%"=="F" goto infos

:infos
cls
echo Confirm Info
echo.
echo Make sure the following info is correct:
echo PE Tools
if /i "%choice%"=="F" echo None
if /i "%choice%"=="Y" dir /b "%~dp0PETools"
if /i "%choice%"=="N" dir /b "%~dp0PETools"
echo.
echo PE Wallpaper
echo %~dp0winre.jpg
echo.
echo Packages to add:
if not exist "%~dp0packages\*.cab" echo None
if exist "%~dp0packages\*.cab" dir /b "%~dp0packages\*.cab"
echo.
echo If correct, press any key to continue. 
echo If wrong, exit and reconfigure.
pause >nul

:makingpe
cls
echo Build PE
echo.
echo PE creation will start in 5 seconds¡­¡­
timeout /t 5 /nobreak >nul
md "%~dp0temp\mount"
md "%~dp0temp\wim"
dism /export-image /sourceimagefile:"%drv%:\sources\boot.wim" /sourceindex:1 /destinationimagefile:"%~dp0temp\wim\boot.wim"
dism /mount-wim /wimfile:"%~dp0temp\wim\boot.wim" /mountdir:"%~dp0temp\mount"
takeown /f "%~dp0temp\mount\Windows\System32\winre.jpg" /a
icacls "%~dp0temp\mount\Windows\System32\winre.jpg" /grant Administrators:F /c
del "%~dp0temp\mount\Windows\System32\winre.jpg"
copy "%~dp0winre.jpg" "%~dp0temp\mount\Windows\System32"
if /i "%choice%"=="Y" wimlib-imagex extract "%drv%:\sources\install.wim" 1 "\Windows\System32\oledlg.dll" --dest-dir="%~dp0temp\mount\Windows\System32"
if /i "%choice%"=="N" wimlib-imagex extract "%drv%:\sources\install.wim" 1 "\Windows\System32\oledlg.dll" --dest-dir="%~dp0temp\mount\Windows\System32"
if /i "%choice%"=="Y" wimlib-imagex extract "%drv%:\sources\install.wim" 1 "\Windows\System32\zh-cn\oledlg.dll.mui" --dest-dir="%~dp0temp\mount\Windows\System32\zh-cn"
if /i "%choice%"=="N" wimlib-imagex extract "%drv%:\sources\install.wim" 1 "\Windows\System32\zh-cn\oledlg.dll.mui" --dest-dir="%~dp0temp\mount\Windows\System32\zh-cn"
if /i "%choice%"=="Y" xcopy "%~dp0PETools" "%~dp0temp\mount\Program Files" /E /H /I /R /Y
if /i "%choice%"=="N" xcopy "%~dp0PETools" "%~dp0temp\mount\Program Files" /E /H /I /R /Y
if /i "%choice%"=="Y" copy "%~dp0LaunchBats\PEShell.bat" "%~dp0temp\mount\Windows\System32"
if /i "%choice%"=="N" copy "%~dp0LaunchBats\PEShell.bat" "%~dp0temp\mount\Windows\System32"
if /i "%choice%"=="F" copy "%~dp0LaunchBats\PEShell_NotTools.bat" "%~dp0temp\mount\Windows\System32"
echo [LaunchApps] > %~dp0temp\mount\Windows\System32\winpeshl.ini
echo wpeinit >> %~dp0temp\mount\Windows\System32\winpeshl.ini
if /i "%choice%"=="Y" echo PEShell.bat >> %~dp0temp\mount\Windows\System32\winpeshl.ini
if /i "%choice%"=="N" echo PEShell.bat >> %~dp0temp\mount\Windows\System32\winpeshl.ini
if /i "%choice%"=="F" echo PEShell_NotTools.bat >> %~dp0temp\mount\Windows\System32\winpeshl.ini
if exist "%~dp0packages\*.cab" (
    dism /image:"%~dp0temp\mount" /add-package /packagepath:"%~dp0packages"
    dism /image:"%~dp0temp\mount" /cleanup-image /startcomponentcleanup /resetbase
)
dism /image:"%~dp0temp\mount" /set-targetpath:X:\
dism /unmount-wim /mountdir:"%~dp0temp\mount" /commit
dism /export-image /sourceimagefile:"%~dp0temp\wim\boot.wim" /sourceindex:1 /destinationimagefile:"%~dp0ISO\sources\boot.wim" /bootable

:makeiso
cls
echo Create ISO
echo.
echo Delete temporary files¡­¡­
rd /s /q "%~dp0temp"
echo.
set /p isopath=Enter the path where you want to save the ISO and name ^(default's path %~dp0Windows PE.iso^£©£º
if "%isopath%"=="" set isopath=%~dp0Windows PE.iso
set /p efisys=Display Press any to boot from CD or DVD£¿£¨Y/N£©£º
if /i "%efisys%"=="Y" oscdimg -u1 -udfver102 -h -o -bootdata:2#p0,e,b"%~dp0ISO\boot\etfsboot.com"#pEF,e,b"%~dp0ISO\efi\microsoft\boot\efisys.bin" -l"WinPE" "%~dp0ISO" "%isopath%"
if /i "%efisys%"=="N" oscdimg -u1 -udfver102 -h -o -bootdata:2#p0,e,b"%~dp0ISO\boot\etfsboot.com"#pEF,e,b"%~dp0ISO\efi\microsoft\boot\efisys_noprompt.bin" -l"WinPE" "%~dp0ISO" "%isopath%"
echo.
echo Getting ready for the next run¡­
del "%~dp0ISO\sources\boot.wim"
echo.
echo Finished!
echo Press any key to exit
pause >nul
exit
