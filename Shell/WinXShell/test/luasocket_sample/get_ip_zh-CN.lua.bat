rem=nil --[=[
@echo off && cd /d "%~dp0"
call ..\wxsHelper.cmd "%~0"
]=]
--- -- ====================  lua script  ====================
local run_test = MsgBox("Test", "Do you want to continue the test?", "yes-no")
if run_test ~= "yes" then App:Exit(88) end

-- LuaSocket 测试脚本：获取IP地址信息

-- 动态设置搜索路径
App:Require("socket", "mime")

-- 引入所需模块
local http = require("socket.http")
local ltn12 = require("ltn12")

-- 一个无需SSL的、免费的IP地址查询API
local url = "http://ip-api.com/json"

print("正在从 " .. url .. " 获取您的IP地址信息...\n")

-- 用于存储JSON响应
local response_body = {}

-- 直接发起请求
local res, status, headers = http.request{
    url = url,
    sink = ltn12.sink.table(response_body)
}

-- 将响应的 table 连接成一个字符串
local json_string = table.concat(response_body)

-- 检查HTTP状态码
if status == 200 then
    print("请求成功！您的IP地址信息 (JSON格式) 如下：")
    print(json_string)
    print("\n测试圆满成功！我们编译的 LuaSocket 模块可以正常进行 HTTP 通信。")
else
    print("\n请求失败！")
    print("HTTP 状态码: " .. tostring(status))
    print("响应内容: " .. json_string)
end

