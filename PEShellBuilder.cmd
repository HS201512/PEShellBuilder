@echo off
if "%1"=="/?" goto help
cls
title PEShellBuilder v1.00 功能包 1
if not exist %windir%\zh-cn\*.mui start "%~dp0PEenBuilder.cmd" %1&exit
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
echo PEShellBuilder v1.00 功能包 1
echo.
echo 欢迎使用 PEShellBuilder！
echo 此工具可以帮您自定义 Windows PE 并生成 ISO
echo.
echo 只支持 Windows 8、10、11
echo.
set /p drv=请输入Windows安装介质的挂载或物理盘符：
cls
if not exist %drv%:\sources\boot.wim goto error
if not exist %drv%:\sources\install.wim goto error
if /i "%1"=="/f" goto wandiso
goto checkimage

:error
echo 错误：所需的文件不存在
echo.
echo 导致此问题的原因可能是：
echo - 盘符输入错误
echo - boot.wim和install.wim不存在或者不在sources目录
echo.
echo 按任意键退出
pause >nul
exit /b

:checkimage
dism /get-wiminfo /wimfile:%drv%:\sources\boot.wim /index:1 | find "zh-CN (默认值)" >nul || goto imageerror
dism /get-wiminfo /wimfile:%drv%:\sources\boot.wim /index:1 | find "体系结构 : x86" >nul && goto imageerror
dism /get-wiminfo /wimfile:%drv%:\sources\boot.wim /index:1 | find "版本 : 6.0" >nul && goto imageerror
dism /get-wiminfo /wimfile:%drv%:\sources\boot.wim /index:1 | find "版本 : 6.1" >nul && goto imageerror

:wandiso
set wallpaper=%~dp0Wallpaper\8\winre.jpg
set peiso=%~dp0Windows 8 PE x64.iso
set pever=Windows 8.x
dism /get-wiminfo /wimfile:%drv%:\sources\boot.wim /index:1 | find "版本 : 10.0.1" >nul 
if %errorlevel% equ 0 (
    set wallpaper=%~dp0Wallpaper\10\winre.jpg
    set peiso=%~dp0Windows 10 PE x64.iso
    set pever=Windows 10
)
dism /get-wiminfo /wimfile:%drv%:\sources\boot.wim /index:1 | find "版本 : 10.0.2" >nul 
if %errorlevel% equ 0 (
    set wallpaper=%~dp0Wallpaper\11\winre.jpg
    set peiso=%~dp0Windows 11 PE x64.iso
    set pever=Windows 11
)

:custompe
echo 自定义 PE 工具
echo.
echo 目前存在的工具：
dir /b "%~dp0PETools"
echo.
echo 不能放的工具：
echo 依赖运行库的
echo.
echo 如果有WinNTSetup，则不需要再添加BootICE
echo 如果选择F，那么PE将不带任何第三方工具
set /p choice=是否自定义工具？（Y/N/F）：
if /i "%choice%"=="Y" (
    explorer "%~dp0PETools"
    notepad "%~dp0LaunchBats\PEShell.bat"
    pause
    goto infos
)
if /i "%choice%"=="N" goto ca2023
if /i "%choice%"=="F" goto ca2023
cls
echo 你没有选择正确的选项
echo 按任意键返回
pause >nul
cls
goto custompe

:ca2023
cls
echo Windows UEFI CA 2023
echo.
echo 旧版的PCA 2011证书将在2026年10月过期
echo 为了避免不必要的麻烦，推荐选择Y
echo.
set /p ca=是否集成？（Y/N）：
if /i "%ca%"=="Y" goto infos
if /i "%ca%"=="N" goto infos
cls
echo 你没有选择正确的选项
echo 按任意键返回
pause >nul
cls
goto ca2023

:infos
cls
echo 确认信息
echo.
echo 确保以下信息正确：
echo PE 工具
if /i "%choice%"=="F" echo 无
if /i "%choice%"=="Y" dir /b "%~dp0PETools"
if /i "%choice%"=="N" dir /b "%~dp0PETools"
echo.
echo PE 壁纸
echo %wallpaper%
echo.
echo 要添加的程序包
if not exist "%~dp0packages\*.cab" echo 无
if exist "%~dp0packages\*.cab" dir /b "%~dp0packages\*.cab"
echo.
echo bootx64.efi证书
if /i "%ca%"=="Y" echo Windows UEFI CA 2023
if /i "%ca%"=="N" echo Microsoft Windows Production PCA 2011
echo.
echo Windows PE 版本
echo %pever%
echo.
echo 如果正确，按任意键继续
echo 如果错误，退出并重新配置
pause >nul

:makingpe
cls
echo 构建 PE
echo.
echo 5秒后将开始PE的制作……
timeout /t 5 /nobreak >nul
echo.
echo 复制启动文件……
md "%~dp0ISO\efi"
md "%~dp0ISO\boot"
md "%~dp0ISO\sources"
xcopy "%drv%:\efi" "%~dp0ISO\efi" /E /H /I /R /Y >nul
xcopy "%drv%:\boot" "%~dp0ISO\boot" /E /H /I /R /Y >nul
copy "%drv%:\bootmgr.efi" "%~dp0ISO" >nul
copy "%drv%:\bootmgr" "%~dp0ISO" >nul
if /i "%ca%"=="Y" copy /y "%~dp0CA2023\bootx64.efi" "%~dp0ISO\efi\boot" >nul
md "%~dp0temp\mount"
md "%~dp0temp\wim"
echo.
echo 服务boot.wim……
dism /export-image /sourceimagefile:"%drv%:\sources\boot.wim" /sourceindex:1 /destinationimagefile:"%~dp0temp\wim\boot.wim"
dism /mount-wim /wimfile:"%~dp0temp\wim\boot.wim" /mountdir:"%~dp0temp\mount"
echo.
echo 应用壁纸……
takeown /f "%~dp0temp\mount\Windows\System32\winre.jpg" /a >nul
icacls "%~dp0temp\mount\Windows\System32\winre.jpg" /grant Administrators:F /c >nul
del "%~dp0temp\mount\Windows\System32\winre.jpg"
copy "%wallpaper%" "%~dp0temp\mount\Windows\System32" >nul
echo.
echo 复制文件……
if /i "%choice%"=="Y" wimlib-imagex extract "%drv%:\sources\install.wim" 1 "\Windows\System32\oledlg.dll" --dest-dir="%~dp0temp\mount\Windows\System32"
if /i "%choice%"=="N" wimlib-imagex extract "%drv%:\sources\install.wim" 1 "\Windows\System32\oledlg.dll" --dest-dir="%~dp0temp\mount\Windows\System32"
if /i "%choice%"=="Y" wimlib-imagex extract "%drv%:\sources\install.wim" 1 "\Windows\System32\zh-cn\oledlg.dll.mui" --dest-dir="%~dp0temp\mount\Windows\System32\zh-cn"
if /i "%choice%"=="N" wimlib-imagex extract "%drv%:\sources\install.wim" 1 "\Windows\System32\zh-cn\oledlg.dll.mui" --dest-dir="%~dp0temp\mount\Windows\System32\zh-cn"
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
echo 生成 ISO
echo.
echo 删除临时文件……
rd /s /q "%~dp0temp"
echo.
set /p isopath=输入保存ISO的路径和名称（默认%peiso%）：
if "%isopath%"=="" set isopath=%peiso%
set /p efisys=是否让PE启动时提示按任意键启动？（Y/N）：
if /i "%efisys%"=="Y" oscdimg -u1 -udfver102 -h -o -bootdata:2#p0,e,b"%~dp0ISO\boot\etfsboot.com"#pEF,e,b"%~dp0ISO\efi\microsoft\boot\efisys.bin" -l"WinPE" "%~dp0ISO" "%isopath%"
if /i "%efisys%"=="N" oscdimg -u1 -udfver102 -h -o -bootdata:2#p0,e,b"%~dp0ISO\boot\etfsboot.com"#pEF,e,b"%~dp0ISO\efi\microsoft\boot\efisys_noprompt.bin" -l"WinPE" "%~dp0ISO" "%isopath%"
echo.
echo 为下一次运行做准备……
rd /s /q "%~dp0ISO"
powershell -Command "(New-Object -ComObject Shell.Application).Namespace(17).ParseName('%drv%:').InvokeVerb('Eject')"
echo.
echo 完成！
echo 按任意键退出
pause >nul
exit /b

:imageerror
echo 错误：不支持此版本的映像
echo.
echo 导致此问题的原因可能是：
echo - boot.wim是32位的
echo - boot.wim的语言（或默认值）不是zh-CN
echo - WinPE版本过低
echo.
echo 按任意键退出
pause >nul
exit /b

:help
echo.
echo PEShellBuilder v1.00 功能包 1
echo.
echo ^/f 不推荐：强制跳过映像检测
echo.