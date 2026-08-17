rem=nil --[=[
@echo off && cd /d "%~dp0"
call ..\wxsHelper.cmd "%~0"
]=]
--- -- ====================  lua script  ====================
local run_test = MsgBox("Test", "Do you want to continue the test?", "yes-no")
if run_test ~= "yes" then App:Exit(88) end

----------------------------------------------------------------------------------------
-- https://stevedonovan.github.io/winapi/api.html

require 'winapi'

drives = winapi.get_logical_drives()
for _,drive in ipairs(drives) do
    local free,avail = winapi.get_disk_free_space(drive)
    if not free then -- call failed, avail is error
        free = '('..avail..')'
    else
        free = math.ceil(free/1024) -- get Mb
    end
    local rname = ''
    local dtype = winapi.get_drive_type(drive)
    if dtype == 'remote' then
        rname = winapi.get_disk_network_name(drive:gsub('\\$',''))
    end
    print(drive,dtype,free,rname)
end
