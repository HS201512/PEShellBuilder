@echo off
if "%1"=="/?" goto help
cls
title PEShellBuilder v1.00 功能包 2
if not exist %windir%\zh-cn\*.mui goto langerror
if /i "%PROCESSOR_ARCHITECTURE%"=="X86" goto oserror
if /i "%PROCESSOR_ARCHITECTURE%"=="ARM64" goto oserror
dism >nul
if errorlevel 740 (
    echo 错误：0x10
    echo 请以管理员身份运行
    echo.
    echo 按任意键退出
    pause >nul
    exit
)
cd /d "%~dp0"

:main
path=%path%;%~dp0bin
echo PEShellBuilder v1.00 功能包 2
echo.
echo 欢迎使用 PEShellBuilder！
echo 此工具可以帮您自定义 Windows PE 并生成 ISO
echo.
echo 只支持 Windows 8、10、11
echo.
set /p drv=请输入Windows安装介质的挂载或物理盘符：
if exist "%~dp0ISO\sources\boot.wim" goto continue   
cls
if not exist %drv%:\sources\boot.wim goto error
if not exist %drv%:\sources\install.wim goto error
if /i "%1"=="/f" goto shell
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

:shell
cls
echo 选择PE框架
echo.
echo 1.WinXShell
echo 2.PEShell
echo.
set /p shell=输入数字：
if "%shell%"=="1" set sn=WinXShell&goto tandiso
if "%shell%"=="2" set sn=PEShell&goto tandiso
cls
echo 你没有选择正确的选项
echo 按任意键返回
pause >nul
cls
goto shell

:tandiso
set wallpaper=%~dp0Theme\8
set peiso=%~dp0Windows 8 PE %sn% x64.iso
set pever=Windows 8.x
dism /get-wiminfo /wimfile:%drv%:\sources\boot.wim /index:1 | find "版本 : 10.0.1" >nul 
if %errorlevel% equ 0 (
    set wallpaper=%~dp0Theme\10
    set peiso=%~dp0Windows 10 PE %sn% x64.iso
    set pever=Windows 10
)
dism /get-wiminfo /wimfile:%drv%:\sources\boot.wim /index:1 | find "版本 : 10.0.2" >nul 
if %errorlevel% equ 0 (
    set wallpaper=%~dp0Theme\11
    set peiso=%~dp0Windows 11 PE %sn% x64.iso
    set pever=Windows 11
)

:custompe
cls
echo 自定义 PE 工具
echo.
echo 目前存在的工具：
dir /b "%~dp0PETools"
echo.
echo 不能放的工具：
echo 依赖运行库的
echo.
if "%sn%"=="WinXShell" (
    echo PE 热键
    echo 刷新：Ctrl+Alt+R
    echo 更改主题：Ctrl+Alt+T
    echo 重启：Ctrl+Shift+R
    echo 关机：Ctrl+Shift+S
    echo.
)
echo 如果有WinNTSetup，则不需要再添加BootICE
echo 如果选择F，那么PE将不带任何第三方工具
set /p choice=是否自定义工具？（Y/N/F）：
if /i "%choice%"=="Y" (
    explorer "%~dp0PETools"
    notepad "%~dp0Shell\PEShell\PEShell.bat"
    notepad "%~dp0Shell\Normal\pecmd.ini"
    pause
    goto ca2023
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
echo %wallpaper%\winpe.jpg
echo.
echo 要添加的程序包
if not exist "%~dp0packages\*.cab" echo 无
if exist "%~dp0packages\*.cab" dir /b "%~dp0packages\*.cab"
echo.
echo bootx64.efi证书
if /i "%ca%"=="Y" echo Windows UEFI CA 2023
if /i "%ca%"=="N" echo Microsoft Windows Production PCA 2011
echo.
echo PE 框架
echo %sn%
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
if "%pever%"=="Windows 11" (
    echo 检测到版本为Win11，将使用Winre.wim……
    set wim=Winre.wim
    wimlib-imagex extract "%drv%:\sources\install.wim" 1 "\Windows\System32\Recovery\Winre.wim" --dest-dir="%~dp0temp\wim"
) else (
    set wim=boot.wim
    dism /export-image /sourceimagefile:"%drv%:\sources\boot.wim" /sourceindex:1 /destinationimagefile:"%~dp0temp\wim\boot.wim"
)
dism /mount-wim /wimfile:"%~dp0temp\wim\%wim%" /mountdir:"%~dp0temp\mount"
echo.
echo 应用壁纸……
takeown /f "%~dp0temp\mount\Windows\System32\winpe.jpg" /a >nul
icacls "%~dp0temp\mount\Windows\System32\winpe.jpg" /grant Administrators:F /c >nul
copy /y "%wallpaper%\winpe.jpg" "%~dp0temp\mount\Windows\System32" >nul
takeown /f "%~dp0temp\mount\Windows\System32\winre.jpg" /a >nul
icacls "%~dp0temp\mount\Windows\System32\winre.jpg" /grant Administrators:F /c >nul
del "%~dp0temp\mount\Windows\System32\winre.jpg"
if "%sn%"=="WinXShell" (
    md "%~dp0temp\mount\Windows\Web"
    copy "%wallpaper%\bg1.jpg" "%~dp0temp\mount\Windows\Web" >nul
    copy "%~dp0Theme\CW.bat" "%~dp0temp\mount\Windows\System32" >nul
    md "%~dp0temp\mount\Program Files\WinXShell\Light"
    md "%~dp0temp\mount\Program Files\WinXShell\Dark"
    copy "%~dp0Theme\Light\WinXShell.jcfg" "%~dp0temp\mount\Program Files\WinXShell\Light" >nul
    copy "%~dp0Theme\Dark\WinXShell.jcfg" "%~dp0temp\mount\Program Files\WinXShell\Dark" >nul
)
echo.
echo 复制文件……
wimlib-imagex extract "%drv%:\sources\install.wim" 1 "\Windows\System32\oledlg.dll" --dest-dir="%~dp0temp\mount\Windows\System32"
wimlib-imagex extract "%drv%:\sources\install.wim" 1 "\Windows\System32\zh-cn\oledlg.dll.mui" --dest-dir="%~dp0temp\mount\Windows\System32\zh-cn"
wimlib-imagex extract "%drv%:\sources\install.wim" 1 "\Windows\System32\comctl32.dll" --dest-dir="%~dp0temp\mount\Windows\System32"
wimlib-imagex extract "%drv%:\sources\install.wim" 1 "\Windows\System32\zh-cn\comctl32.dll.mui" --dest-dir="%~dp0temp\mount\Windows\System32\zh-cn"
wimlib-imagex extract "%drv%:\sources\install.wim" 1 "\Windows\SysWOW64\oledlg.dll" --dest-dir="%~dp0temp\mount\Windows\SysWOW64"
wimlib-imagex extract "%drv%:\sources\install.wim" 1 "\Windows\SysWOW64\comctl32.dll" --dest-dir="%~dp0temp\mount\Windows\SysWOW64"
wimlib-imagex extract "%drv%:\sources\install.wim" 1 "\Windows\SysWOW64\zh-cn\comctl32.dll.mui" --dest-dir="%~dp0temp\mount\Windows\SysWOW64\zh-cn"
if "%sn%"=="WinXShell" (
    wimlib-imagex extract "%drv%:\sources\install.wim" 1 "\Windows\System32\ExplorerFrame.dll" --dest-dir="%~dp0temp\mount\Windows\System32"
    wimlib-imagex extract "%drv%:\sources\install.wim" 1 "\Windows\System32\StructuredQuery.dll" --dest-dir="%~dp0temp\mount\Windows\System32"
    wimlib-imagex extract "%drv%:\sources\install.wim" 1 "\Windows\System32\shellstyle.dll" --dest-dir="%~dp0temp\mount\Windows\System32"
    wimlib-imagex extract "%drv%:\sources\install.wim" 1 "\Windows\System32\zh-cn\ExplorerFrame.dll.mui" --dest-dir="%~dp0temp\mount\Windows\System32\zh-cn"
    wimlib-imagex extract "%drv%:\sources\install.wim" 1 "\Windows\SystemResources\ExplorerFrame.dll.mun" --dest-dir="%~dp0temp\mount\Windows\SystemResources" --nullglob
)
if /i "%choice%"=="Y" xcopy "%~dp0PETools" "%~dp0temp\mount\Program Files" /E /H /I /R /Y >nul
if /i "%choice%"=="N" xcopy "%~dp0PETools" "%~dp0temp\mount\Program Files" /E /H /I /R /Y >nul
takeown /f "%~dp0temp\mount\Windows\System32\msvc*.dll" /a >nul
icacls "%~dp0temp\mount\Windows\System32\msvc*.dll" /grant Administrators:F /c >nul
takeown /f "%~dp0temp\mount\Windows\SysWOW64\msvc*.dll" /a >nul
icacls "%~dp0temp\mount\Windows\SysWOW64\msvc*.dll" /grant Administrators:F /c >nul
if exist "%~dp0temp\mount\Windows\System32\vcruntime*.dll" (
    takeown /f "%~dp0temp\mount\Windows\System32\vcruntime*.dll" /a >nul
    icacls "%~dp0temp\mount\Windows\System32\vcruntime*.dll" /grant Administrators:F /c >nul
)
if exist "%~dp0temp\mount\Windows\SysWOW64\vcruntime*.dll" (
    takeown /f "%~dp0temp\mount\Windows\SysWOW64\vcruntime*.dll" /a >nul
    icacls "%~dp0temp\mount\Windows\SysWOW64\vcruntime*.dll" /grant Administrators:F /c >nul
)
copy /y "%~dp0Runtime\*.dll" "%~dp0temp\mount\Windows\System32" >nul
copy /y "%~dp0Runtime\x86\*.dll" "%~dp0temp\mount\Windows\SysWOW64" >nul
if exist "%~dp0Startup\PEStartup.bat" xcopy "%~dp0Startup" "%~dp0temp\mount\Windows\System32" /E /H /I /R /Y >nul
if "%shell%"=="2" goto peshell
xcopy "%~dp0Shell\WinXShell" "%~dp0temp\mount\Program Files\WinXShell" /E /H /I /R /Y >nul
if /i "%choice%"=="F" (
    xcopy "%~dp0Shell\NotTool" "%~dp0temp\mount\Windows\System32" /E /H /I /R /Y >nul
) else xcopy "%~dp0Shell\Normal" "%~dp0temp\mount\Windows\System32" /E /H /I /R /Y >nul
reg load "HKLM\PE_SYSTEM" "%~dp0temp\mount\Windows\System32\config\SYSTEM" >nul
reg load "HKLM\PE_SOFTWARE" "%~dp0temp\mount\Windows\System32\config\SOFTWARE" >nul
reg load "HKLM\PE_DEFAULT" "%~dp0temp\mount\Windows\System32\config\DEFAULT" >nul
reg add "HKLM\PE_SYSTEM\Setup" /v "CmdLine" /t REG_SZ /d "PECMD.exe MAIN X:\Windows\System32\PECMD.INI" /f >nul
if /i "%1"=="/s" (
    reg add "HKLM\PE_SYSTEM\Setup\LabConfig" >nul
    reg add "HKLM\PE_SYSTEM\Setup\LabConfig" /v "BypassTPMCheck" /t REG_DWORD /d "1" /f >nul
    reg add "HKLM\PE_SYSTEM\Setup\LabConfig" /v "BypassRAMCheck" /t REG_DWORD /d "1" /f >nul
    reg add "HKLM\PE_SYSTEM\Setup\LabConfig" /v "BypassSecureBootCheck" /t REG_DWORD /d "1" /f >nul
)
reg add "HKLM\PE_SYSTEM\ControlSet001\Services\FBWF" /v "WinPECacheThreshold" /t REG_DWORD /d "4094" /f >nul
reg add "HKLM\PE_SYSTEM\ControlSet001\Services\FBWF" /v "Start" /t REG_DWORD /d "0" /f >nul
reg add "HKLM\PE_SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableCursorSuppression" /t REG_DWORD /d "0" /f >nul
reg add "HKLM\PE_SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\S-1-5-18" /v "ProfileImagePath" /t REG_EXPAND_SZ /d "X:\Users\Default" /f >nul
reg add "HKLM\PE_DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f >nul
reg add "HKLM\PE_DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d "1" /f >nul
reg add "HKLM\PE_DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d "0" /f >nul
reg unload "HKLM\PE_SYSTEM" >nul
reg unload "HKLM\PE_SOFTWARE" >nul
reg unload "HKLM\PE_DEFAULT" >nul
if exist "%~dp0Packages\*.cab" (
    dism /image:"%~dp0temp\mount" /add-package /packagepath:"%~dp0Packages"
    if exist "%~dp0Packages\Windows*-KB*.cab" dism /image:"%~dp0temp\mount" /cleanup-image /startcomponentcleanup /resetbase
)
dism /image:"%~dp0temp\mount" /set-targetpath:X:\
dism /unmount-wim /mountdir:"%~dp0temp\mount" /commit
dism /export-image /sourceimagefile:"%~dp0temp\wim\%wim%" /sourceindex:1 /destinationimagefile:"%~dp0ISO\sources\boot.wim" /bootable
goto makeiso

:peshell
if /i "%1"=="/s" (
    reg load "HKLM\PE_SYSTEM" "%~dp0temp\mount\Windows\System32\config\SYSTEM" >nul
    reg add "HKLM\PE_SYSTEM\Setup\LabConfig" >nul
    reg add "HKLM\PE_SYSTEM\Setup\LabConfig" /v "BypassTPMCheck" /t REG_DWORD /d "1" /f >nul
    reg add "HKLM\PE_SYSTEM\Setup\LabConfig" /v "BypassRAMCheck" /t REG_DWORD /d "1" /f >nul
    reg add "HKLM\PE_SYSTEM\Setup\LabConfig" /v "BypassSecureBootCheck" /t REG_DWORD /d "1" /f >nul
    reg unload "HKLM\PE_SYSTEM" >nul
)
if /i "%choice%"=="F" (
    copy "%~dp0Shell\PEShell\PEShell_NotTool.bat" "%~dp0temp\mount\Windows\System32" >nul
    echo [LaunchApps] > "%~dp0temp\mount\Windows\System32\winpeshl.ini"
    echo wpeinit.exe >> "%~dp0temp\mount\Windows\System32\winpeshl.ini"
    echo PEShell_NotTool.bat >> "%~dp0temp\mount\Windows\System32\winpeshl.ini"
) else (
    copy "%~dp0Shell\PEShell\PEShell.bat" "%~dp0temp\mount\Windows\System32" >nul
    echo [LaunchApps] > "%~dp0temp\mount\Windows\System32\winpeshl.ini"
    echo wpeinit.exe >> "%~dp0temp\mount\Windows\System32\winpeshl.ini"
    echo PEShell.bat >> "%~dp0temp\mount\Windows\System32\winpeshl.ini"
)
if exist "%~dp0packages\*.cab" (
    dism /image:"%~dp0temp\mount" /add-package /packagepath:"%~dp0Packages"
    if exist "%~dp0Packages\Windows*-KB*.cab" dism /image:"%~dp0temp\mount" /cleanup-image /startcomponentcleanup /resetbase
)
dism /image:"%~dp0temp\mount" /set-targetpath:X:\
dism /unmount-wim /mountdir:"%~dp0temp\mount" /commit
dism /export-image /sourceimagefile:"%~dp0temp\wim\%wim%" /sourceindex:1 /destinationimagefile:"%~dp0ISO\sources\boot.wim" /bootable
goto makeiso

:makeiso
cls
echo 生成 ISO
echo.
echo 删除临时文件……
if exist "%~dp0temp\wim\%wim%" rd /s /q "%~dp0temp"
echo.
set /p isopath=输入保存ISO的路径和名称（默认%peiso%）：
if "%isopath%"=="" set isopath=%peiso%
set /p efisys=是否让PE启动时提示按任意键启动？（Y/N）：
if /i "%efisys%"=="Y" oscdimg -u1 -udfver102 -h -o -bootdata:2#p0,e,b"%~dp0ISO\boot\etfsboot.com"#pEF,e,b"%~dp0ISO\efi\microsoft\boot\efisys.bin" -l"WinPE" "%~dp0ISO" "%isopath%"
if /i "%efisys%"=="N" oscdimg -u1 -udfver102 -h -o -bootdata:2#p0,e,b"%~dp0ISO\boot\etfsboot.com"#pEF,e,b"%~dp0ISO\efi\microsoft\boot\efisys_noprompt.bin" -l"WinPE" "%~dp0ISO" "%isopath%"
echo.
echo 如果选择Y，下一次运行可直接跳转到此页面并重新制作ISO
echo 如果选择N，下一次运行只能全新制作
set /p isosave=是否保存ISO文件夹？（Y/N）：
echo 为下一次运行做准备……
if /i "%isosave%"=="N" rd /s /q "%~dp0ISO"
powershell -Command "(New-Object -ComObject Shell.Application).Namespace(17).ParseName('%drv%:').InvokeVerb('Eject')"
echo.
echo 完成！
echo 按任意键退出
pause >nul
exit /b

:continue
cls
echo 继续生成ISO
echo.
echo 如果选择Y，将跳转到生成ISO
echo 如果选择N，将删除ISO文件夹并开启全新制作
set /p continue=是否用上次未删除的ISO文件夹制作ISO？（Y/N）：
if /i "%continue%"=="Y" set peiso=Windows PE x64.iso&goto makeiso
rd /s /q "%~dp0ISO"
goto main

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

:langerror
echo 错误：不支持此系统
echo.
echo 导致此问题的原因可能是：
echo - 当前系统的架构不是AMD64
echo.
echo 按任意键退出
pause >nul
exit /b

:langerror
title PEShellBuilder v1.00 Feature Pack 2
echo Error: Not support of this system
echo.
echo The reason for this issue may be:
echo - Current OS Language is not zh-CN
echo.
echo Press any key to exit
pause >nul
exit /b

:help
echo.
echo PEShellBuilder v1.00 功能包 2
echo.
echo ^/f 不推荐：强制跳过映像检测
echo ^/s 让 PE 强制绕过 Windows 11 安装程序硬件检测
echo.