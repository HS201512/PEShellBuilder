rem=nil --[=[
@echo off && cd /d "%~dp0"
call ..\wxsHelper.cmd "%~0"
]=]
--- -- ====================  lua script  ====================
local run_test = MsgBox("Test", "Do you want to continue the test?", "yes-no")
if run_test ~= "yes" then App:Exit(88) end

local inifile = require "inifile"
local config = inifile.parse('iniconfig.ini')
Alert(config['square']['name'])
Alert(config['square']['fill'])
Alert(config['square']['x'])
Alert(config['square']['str'])

config['square']['change']=99
config['square']['new']='new message'

inifile.save('iniconfig_new.ini', config)
