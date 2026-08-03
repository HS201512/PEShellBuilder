@echo off
if "%1"=="/?" goto help
cls
title PEShellBuilder v1.00 Feature Pack 1
if exist %windir%\zh-cn\*.mui start "%~dp0PEShellBuilder.cmd"&exit
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
echo PEShellBuilder v1.00 Feature Pack 1
echo.
echo Welcome to PEenBuilder!
echo This is the English version of PEShellBuilder.cmd 
echo Launch bat and tools is Chinese version
echo.
echo Only supports Windows 8 10 11
echo.
set /p drv=Enter Windows installation media letter:
cls
if not exist %drv%:\sources\boot.wim goto error
if not exist %drv%:\sources\install.wim goto error
if /i "%1"=="/f" goto wandiso
goto imagecheck

:error
echo Error: Required files not found
echo.
echo The reason for this issue may be:
echo - Drive letter input error
echo - boot.wim And install.wim do not exist or are not in the sources directory
echo.
echo Press any key to exit
pause >nul
exit /b

:imagecheck
dism /get-wiminfo /wimfile:%drv%:\sources\boot.wim /index:1 | find "zh-CN ^(Default^)" >nul || goto imageerror
dism /get-wiminfo /wimfile:%drv%:\sources\boot.wim /index:1 | find "Architecture : x86" >nul && goto imageerror
dism /get-wiminfo /wimfile:%drv%:\sources\boot.wim /index:1 | find "Version : 6.0" >nul && goto imageerror
dism /get-wiminfo /wimfile:%drv%:\sources\boot.wim /index:1 | find "Version : 6.1" >nul && goto imageerror

:wandiso
set wallpaper=%~dp0Wallpaper\8\winre.jpg
set peiso=%~dp0Windows 8 PE x64.iso
set pever=Windows 8.x
dism /get-wiminfo /wimfile:%drv%:\sources\boot.wim /index:1 | find "Version : 10.0.1" >nul 
if %errorlevel% equ 0 (
    set wallpaper=%~dp0Wallpaper\10\winre.jpg
    set peiso=%~dp0Windows 10 PE x64.iso
    set pever=Windows 10
)
dism /get-wiminfo /wimfile:%drv%:\sources\boot.wim /index:1 | find "Version : 10.0.2" >nul 
if %errorlevel% equ 0 (
    set wallpaper=%~dp0Wallpaper\11\winre.jpg
    set peiso=%~dp0Windows 11 PE x64.iso
    set pever=Windows 11
)

:custompe
echo Custom PE tools
echo.
echo Existing tools:
dir /b "%~dp0PETools"
echo.
echo Tools that can't be left:
echo Depends on runtime libraries
echo.
echo If you have WinNTSetup, there's no need to add BootICE
echo If you choose F, PE won't come with any third-party tools
set /p choice=Do you want custom tools? (Y/N) :
if /i "%choice%"=="Y" (
    explorer "%~dp0PETools"
    notepad "%~dp0LaunchBats\PEShell.bat"
    pause
    goto infos
)
if /i "%choice%"=="N" goto ca2023
if /i "%choice%"=="F" goto ca2023
cls
echo You didn't pick the right option
echo Press any key to return
pause >nul
cls
goto custompe

:ca2023
cls
echo Windows UEFI CA 2023
echo.
echo The old PCA 2011 certificate will expire in October 2026
echo To avoid unnecessary trouble, it is recommended to choose Y
echo.
set /p ca=Is it set up? (Y/N) :
if /i "ca"=="Y" goto infos
if /i "ca"=="N" goto infos
cls
echo You didn't pick the right option
echo Press any key to return
pause >nul
cls
goto custompe


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
echo %wallpaper%
echo.
echo Packages to add:
if not exist "%~dp0packages\*.cab" echo None
if exist "%~dp0packages\*.cab" dir /b "%~dp0packages\*.cab"
echo.
echo bootx64.efi Certificate
if /i "ca"=="Y" echo Windows UEFI CA 2023
if /i "ca"=="N" echo Microsoft Windows Production PCA 2011
echo.
echo Windows PE Version
echo %pever%
echo.
echo If correct, press any key to continue. 
echo If wrong, exit and reconfigure.
pause >nul

:makingpe
cls
echo Build PE
echo.
echo PE creation will start in 5 seconds...
timeout /t 5 /nobreak >nul
echo.
echo Copying boot files...
md "%~dp0ISO\efi"
md "%~dp0ISO\boot"
md "%~dp0ISO\sources"
xcopy "%drv%:\efi" "%~dp0ISO\efi" /E /H /I /R /Y >nul
xcopy "%drv%:\boot" "%~dp0ISO\boot" /E /H /I /R /Y >nul
copy "%drv%:\bootmgr.efi" "%~dp0ISO" >nul
copy "%drv%:\bootmgr" "%~dp0ISO" >nul
if /i "ca"=="Y" copy /y "%~dp0CA2023\bootx64.efi" "%~dp0ISO\efi\boot" >nul
md "%~dp0temp\mount"
md "%~dp0temp\wim"
echo.
echo Servicing boot.wim...
dism /export-image /sourceimagefile:"%drv%:\sources\boot.wim" /sourceindex:1 /destinationimagefile:"%~dp0temp\wim\boot.wim"
dism /mount-wim /wimfile:"%~dp0temp\wim\boot.wim" /index:1 /mountdir:"%~dp0temp\mount"
echo.
echo Applying wallpaper...
takeown /f "%~dp0temp\mount\Windows\System32\winre.jpg" /a >nul
icacls "%~dp0temp\mount\Windows\System32\winre.jpg" /grant Administrators:F /c >nul
del "%~dp0temp\mount\Windows\System32\winre.jpg"
copy "%wallpaper%" "%~dp0temp\mount\Windows\System32" >nul
echo.
echo Copying files...
if /i "%choice%"=="Y" wimlib-imagex extract "%drv%:\sources\install.wim" 1 "\Windows\System32\oledlg.dll" --dest-dir="%~dp0temp\mount\Windows\System32"
if /i "%choice%"=="N" wimlib-imagex extract "%drv%:\sources\install.wim" 1 "\Windows\System32\oledlg.dll" --dest-dir="%~dp0temp\mount\Windows\System32"
if /i "%choice%"=="Y" xcopy "%~dp0PETools" "%~dp0temp\mount\Program Files" /E /H /I /R /Y >nul
if /i "%choice%"=="N" xcopy "%~dp0PETools" "%~dp0temp\mount\Program Files" /E /H /I /R /Y >nul
if exist "%~dp0Startup\PEStartup.bat" xcopy "%~dp0Startup" "%~dp0temp\mount\Windows\System32" /E /H /I /R /Y >nul
if /i "%choice%"=="Y" copy "%~dp0LaunchBats\PEShell.bat" "%~dp0temp\mount\Windows\System32" >nul
if /i "%choice%"=="N" copy "%~dp0LaunchBats\PEShell.bat" "%~dp0temp\mount\Windows\System32" >nul
if /i "%choice%"=="F" copy "%~dp0LaunchBats\PEShell_NotTools.bat" "%~dp0temp\mount\Windows\System32" >nul
echo [LaunchApps] > "%~dp0temp\mount\Windows\System32\winpeshl.ini"
echo wpeinit >> "%~dp0temp\mount\Windows\System32\winpeshl.ini"
if /i "%choice%"=="Y" echo PEShell.bat >> "%~dp0temp\mount\Windows\System32\winpeshl.ini"
if /i "%choice%"=="N" echo PEShell.bat >> "%~dp0temp\mount\Windows\System32\winpeshl.ini"
if /i "%choice%"=="F" echo PEShell_NotTools.bat >> "%~dp0temp\mount\Windows\System32\winpeshl.ini"
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
echo Delete temporary files...
rd /s /q "%~dp0temp"
echo.
set /p isopath=Enter the path where you want to save the ISO and name ^(default's path %~dp0Windows PE.iso^) :
if "%isopath%"=="" set isopath=%peiso%
set /p efisys=Display Press any to boot from CD or DVD? (Y/N) :
if /i "%efisys%"=="Y" oscdimg -u1 -udfver102 -h -o -bootdata:2#p0,e,b"%~dp0ISO\boot\etfsboot.com"#pEF,e,b"%~dp0ISO\efi\microsoft\boot\efisys.bin" -l"WinPE" "%~dp0ISO" "%isopath%"
if /i "%efisys%"=="N" oscdimg -u1 -udfver102 -h -o -bootdata:2#p0,e,b"%~dp0ISO\boot\etfsboot.com"#pEF,e,b"%~dp0ISO\efi\microsoft\boot\efisys_noprompt.bin" -l"WinPE" "%~dp0ISO" "%isopath%"
echo.
echo Getting ready for the next run...
rd /s /q "%~dp0ISO"
powershell -Command "(New-Object -ComObject Shell.Application).Namespace(17).ParseName('%drv%:').InvokeVerb('Eject')"
echo.
echo Finished!
echo Press any key to exit
pause >nul
exit /b

:imageerror
echo Error: This image is not supported
echo.
echo The reason for this issue may be:
echo - boot.wim Architecture is x86
echo - boot.wim Default language is not zh-CN
echo - Windows PE version is too low
echo.
echo Press any key to exit
pause >nul
exit /b

:help
echo.
echo PEShellBuilder v1.00 Feature Pack 1
echo.
echo ^/f Not recommend: Forced skip image check
echo.
