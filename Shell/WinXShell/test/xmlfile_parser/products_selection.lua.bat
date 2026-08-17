rem=nil --[=[
@echo off && cd /d "%~dp0"
call ..\wxsHelper.cmd "%~0"
]=]
--- -- ====================  lua script  ====================
local run_test = MsgBox("Test", "Do you want to continue the test?", "yes-no")
if run_test ~= "yes" then App:Exit(88) end

local xml2lua = require("xml2lua")
local handler = require("xmlhandler.tree")

print("xml2lua v" .. xml2lua._VERSION.."\n")

-- os.chdir(App:GetScriptDir())
App:ChScriptDir()

local xml = xml2lua.loadFile("products_Win11_20241005.xml")
local parser = xml2lua.parser(handler)
parser:parse(xml)

--Recursivelly prints the table in an easy-to-ready format
-- xml2lua.printable(handler.root.MCT.Catalogs.Catalog.PublishedMedia.Files.File)

local files = handler.root.MCT.Catalogs.Catalog.PublishedMedia.Files.File

for i, f in pairs(files) do
  if f.Architecture == "ARM64" and f.LanguageCode == "zh-cn" and f.Edition == 'Professional' then
    print("FileName:", f.FileName, "\nArchitecture:", f.Architecture, "\nEdition:", f.Edition)
    print("FilePath:", f.FilePath)
  end
end

Cmd:Pause()
