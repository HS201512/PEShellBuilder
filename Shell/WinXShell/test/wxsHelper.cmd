if "x%~1"=="x" goto :EOF
set "WINXSHELL_LOGFILE=%Temp%\WinXShell.log"

set WINXSHELL=WinXShell.exe
set x8664=x64
set DebugArch=x64
if not "x%PROCESSOR_ARCHITECTURE%"=="xAMD64" set "x8664=x86" && set DebugArch=Win32
if "x%USE_WIN32_WINXSHELL%"=="x1" set "x8664=x86" && set DebugArch=Win32
set WINXSHELL=..\..\WinXShell_%x8664%.exe
if not exist "%WINXSHELL%" set WINXSHELL=..\WinXShell_%x8664%.exe
if not exist "%WINXSHELL%" set WINXSHELL=..\WinXShell.exe
if not exist "%WINXSHELL%" set WINXSHELL=..\%DebugArch%\Debug\WinXShell.exe
if not exist "%WINXSHELL%" set WINXSHELL=..\..\WinXShell.exe
if not exist "%WINXSHELL%" set WINXSHELL=..\..\%DebugArch%\Debug\WinXShell.exe

:LOOP
echo. > "%WINXSHELL_LOGFILE%"
%WINXSHELL% -console -script "%~1"
set _ExitCode=%errorlevel%
type "%WINXSHELL_LOGFILE%" & echo. & echo ERRORLEVEL=%_ExitCode% & pause
goto :LOOP

goto :EOF
