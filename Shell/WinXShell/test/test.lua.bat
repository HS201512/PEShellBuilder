rem=nil --[=[
@echo off && cd /d "%~dp0"
call wxsHelper.cmd "%~0"
]=]
--- -- ====================  lua script  ====================
local run_test = MsgBox("Test", "Do you want to continue the test?", "yes-no")
if run_test ~= "yes" then App:Exit(88) end

Alert(App.ScriptFile)
