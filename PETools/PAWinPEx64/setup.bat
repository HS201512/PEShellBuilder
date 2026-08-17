@echo off
pushd %~dp0
if not exist %windir%\system32\xcopy.exe (
    pecmd.exe FILE %~dp0WinSxS=>%Windir%\WinSxS
	pecmd.exe FILE %~dp0mfc*.dll=>%Windir%\WinSxS\amd64_microsoft.vc80.mfc_1fc8b3b9a1e18e3b_8.0.50727.762_none_c46a533c8a667ee7
	pecmd.exe FILE %~dp0msvc*.dll=>%Windir%\WinSxS\amd64_microsoft.vc80.crt_1fc8b3b9a1e18e3b_8.0.50727.762_none_c905be8887838ff2
) else (
	xcopy "%~dp0\WinSxS\*.*" %Windir%\WinSxS\ /e/q/y
	xcopy "%~dp0mfc*.dll" %Windir%\WinSxS\amd64_microsoft.vc80.mfc_1fc8b3b9a1e18e3b_8.0.50727.762_none_c46a533c8a667ee7 /e/q/y
	xcopy "%~dp0msvc*.dll" %Windir%\WinSxS\amd64_microsoft.vc80.crt_1fc8b3b9a1e18e3b_8.0.50727.762_none_c905be8887838ff2 /e/q/y
)
regedit /s "import.reg"


if "%PROCESSOR_ARCHITECTURE%"=="x86"
(
	SetupGreen32.exe
)
else
(
	SetupGreen64.exe
)