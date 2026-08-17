-- https://santoslove.github.io/inifile.html
-- inifile.lua

inifile = {}
local lines
local write

if love then
   lines = love.filesystem.lines
   write = love.filesystem.write
else
   lines = function(name) return assert(io.open(name)):lines() end
   write = function(name, contents) return assert(io.open(name, "w")):write(contents) end
end

function inifile.parse(name)
   local t = {}
   local section
   for line in lines(name) do
      local s = line:match("^%[([^%]]+)%]$")
      if s then
         section = s
         t[section] = t[section] or {}
      end
     -- local key, value = line:match("^(%w+)%s-=%s-(.+)$")
 local key, value = line:match("^([^=]-)=([^=]+)$")
      if key and value then
         if tonumber(value) then value = tonumber(value) end
         if value == "true" then value = true end
         if value == "false" then value = false end
         t[section][key] = value
      end
   end
   return t
end

function inifile.save(name, t)
   local contents = ""
   for section, s in pairs(t) do
      contents = contents .. ("[%s]\n"):format(section)
      for key, value in pairs(s) do
         contents = contents .. ("%s=%s\n"):format(key, tostring(value))
      end
      contents = contents .. "\n"
   end
   write(name, contents)
end
return inifile
