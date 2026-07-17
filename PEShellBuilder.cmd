@echo off
cls
title PEShellBuilder v1.00 by derasd
dism >nul
if errorlevel 740 (
    echo 错误：0x10
    echo 请以管理员身份运行
    echo.
    echo 按任意键退出
    pause >nul
    exit
)
path=%path%;%~dp0bin
echo PEShellBuilder
echo.
echo 欢迎使用 PEShellBuilder！
echo 此工具可以帮您自定义 Windows PE 并生成 ISO
echo.
echo 建议使用 WIndows 8、10、11
echo.
set /p drv=请输入Windows ISO的挂载盘符：
cls
if not exist %drv%:\sources\boot.wim goto error
if not exist %drv%:\sources\install.wim goto error
goto custompe

:error
echo 错误：所需的文件不存在
echo 按任意键退出
pause >nul
exit

:custompe
echo 自定义 PE 工具
echo.
echo 目前存在的工具：
dir /b %~dp0PETools
echo.
echo 不能放的工具：
echo 依赖运行库的（例如WinNTSetup、EasyRC、CoolInstaller）
echo.
echo 如果选择F，那么PE将不带任何第三方工具
set /p choice=是否自定义工具？（Y/N/F）：
if /i "%choice%"=="Y" (
    explorer "%~dp0PETools"
    notepad "%~dp0LaunchBats\PEShell.bat"
    pause
    goto makingpe
)
if /i "%choice%"=="N" goto makingpe
if /i "%choice%"=="F" goto makingpe

:makingpe
cls
echo 构建 PE
echo.
echo 5秒后将开始PE的制作……
timeout /t 5 /nobreak >nul
md "%~dp0temp\mount"
md "%~dp0temp\wim"
dism /export-image /sourceimagefile:"%drv%:\sources\boot.wim" /sourceindex:1 /destinationimagefile:"%~dp0temp\wim\boot.wim"
dism /mount-wim /wimfile:"%~dp0temp\wim\boot.wim" /mountdir:"%~dp0temp\mount"
pause
takeown /f "%~dp0temp\mount\Windows\System32\winre.jpg" /a
icacls "%~dp0temp\mount\Windows\System32\winre.jpg" /grant Administrators:F /c
del "%~dp0temp\mount\Windows\System32\winre.jpg"
copy "%~dp0winre.jpg" "%~dp0temp\mount\Windows\System32"
wimlib-imagex extract "%drv%:\sources\install.wim" 1 "\Windows\System32\oledlg.dll" --dest-dir="%~dp0temp\mount\Windows\System32"
wimlib-imagex extract "%drv%:\sources\install.wim" 1 "\Windows\System32\zh-cn\oledlg.dll.mui" --dest-dir="%~dp0temp\mount\Windows\System32\zh-cn"
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
dism /unmount-wim /mountdir:"%~dp0temp\mount" /commit
dism /export-image /sourceimagefile:"%~dp0temp\wim\boot.wim" /sourceindex:1 /destinationimagefile:"%~dp0ISO\sources\boot.wim" /bootable

:makeiso
cls
echo 生成 ISO
echo.
echo 删除临时文件……
rd /s /q "%~dp0temp"
echo.
set /p efisys=是否让PE启动时提示按任意键启动？（Y/N）：
if /i "%efisys%"=="Y" oscdimg -u1 -udfver102 -h -o -bootdata:2#p0,e,b"%~dp0ISO\boot\etfsboot.com"#pEF,e,b"%~dp0ISO\efi\microsoft\boot\efisys.bin" -l"WinPE" "%~dp0ISO" "%~dp0Windows PE.iso"
if /i "%efisys%"=="N" oscdimg -u1 -udfver102 -h -o -bootdata:2#p0,e,b"%~dp0ISO\boot\etfsboot.com"#pEF,e,b"%~dp0ISO\efi\microsoft\boot\efisys_noprompt.bin" -l"WinPE" "%~dp0ISO" "%~dp0Windows PE.iso"
echo.
echo 完成！
echo 按任意键退出
pause >nul
exit
