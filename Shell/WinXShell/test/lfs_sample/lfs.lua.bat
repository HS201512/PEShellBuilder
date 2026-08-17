rem=nil --[=[
@echo off && cd /d "%~dp0"
call ..\wxsHelper.cmd "%~0"
]=]
--- -- ====================  lua script  ====================
local run_test = MsgBox("Test", "Do you want to continue the test?", "yes-no")
if run_test ~= "yes" then App:Exit(88) end

----------------------------------------------------------------------------------------
local lfs = require("lfs")

-- Get the current working directory
local current_dir = lfs.currentdir()
print("Current Directory: " .. current_dir)

-- Iterate through files in the directory
for file in lfs.dir(current_dir) do
    print("Found file: " .. file)
end
