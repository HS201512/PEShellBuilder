if "x%~1"=="x" goto :EOF
call :x64main "%~dpn1"
goto :EOF

:x64main
set USE_WIN32_WINXSHELL=1
call "%~dpn1.bat"
set USE_WIN32_WINXSHELL=
goto :EOF
