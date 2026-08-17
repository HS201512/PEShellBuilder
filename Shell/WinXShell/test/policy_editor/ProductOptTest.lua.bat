rem=nil --[=[
@echo off && cd /d "%~dp0"
call ..\wxsHelper.cmd "%~0"
]=]
--- -- ====================  lua script  ====================
local run_test = MsgBox("Test", "Do you want to continue the test?", "yes-no")
if run_test ~= "yes" then App:Exit(88) end

print("======test===========")
local poleditor = Reg:PolicyLoad([[HKLM\Software\WinXShell\ProductOptions]], 'ProductPolicy')
poleditor:Set("UMDF-WINPE-ENABLED", 0)
poleditor:Set("UMDF-WINPE-ENABLED", 1)
poleditor:Save()

-- ========== one line ========= --
Reg:PolicySet([[HKLM\Software\WinXShell\ProductOptions]], 'ProductPolicy', "UMDF-WINPE-ENABLED", 1)
print("======done===========")
Cmd:Pause()
