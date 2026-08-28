@echo off
ECHO GhConfig failed to find Windows active drive
for %%a in (C D E F G H I J K L M N O P Q R S T U V W Y Z) do if exist %%a:\Windows\AeXNSAgent.ini (
  set WINDOWSDRIVE=%%a
  echo { ActiveWndDrive = "%%a:", ActiveWndDir = "%%a:\\Windows" } > act_wnd.txt
  echo Windows Drive found at '%%a'
  EXIT /B 0
)
for %%a in (C D E F G H I J K L M N O P Q R S T U V W Y Z) do if exist %%a:\Windows (
  set WINDOWSDRIVE=%%a
  echo { ActiveWndDrive = "%%a:", ActiveWndDir = "%%a:\\Windows" } > act_wnd.txt
  echo Windows Drive found at '%%a'
  EXIT /B 0
)
echo { ActiveWndDrive = "%WINDOWSDRIVE%:", ActiveWndDir = "%WINDOWSDRIVE%:\\Windows" } > act_wnd.txt
echo Windows Drive not found!