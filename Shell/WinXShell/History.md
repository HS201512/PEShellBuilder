# 更新历史记录

[中文](#中文) [English](#English)

## 中文
=======================================================================================================================

## WinXShell RC5.1.5.1 (2025.12.12)
这是一个常规更新。主要修复了 RC5.1.5 造成的新问题，添加和改善了以下内容:

* [FileExplorer] 修复以最大化窗口关闭文件管理器后再次打开时，窗口底部高度不正常的问题。 (感谢 @yamingw)
* [Lua] 修复 `Startmenu:Pin()` 不指定完整路径时，无法正常固定开始菜单图标的问题。
* [Daemon] 修复因启动选项导致无法正确识别PE环境的问题。
* [Daemon] 修复因未正确识别PE环境，导致显示桌面修复功能失效的问题。
* [Daemon] 新增 `WxsHandler.MS_Protocols` 变量，可控制是否接管 `ms-xxxxx` 协议响应。
* [wxsUI] 改善 UI_Settings 组件。Windows 10 环境下(非圆角窗口), 显示窗口边框。
* [wxsUI] 改善 UI_Settings 组件。显示用户定义头像(`%ProgramData%\\Microsoft\\User Account Pictures\\<用户名>.png`)。
* [wxsUI] 改善 UI_Settings 组件。修复 ru-RU 资源显示问题。 (感谢 @AcidBurn)
* [wxsUI] 改善 UI_Settings 组件。支持使用系统主题色。
* [wxsUI] 强化 自动加载UI组件模式，当wxsUI目录存在与执行程序名相同的lua文件时, 将自动加载UI组件。
  * 可通过在 `wxsUI\\xxxxx.lua` 中指定 `App.UIName` 变量的值来指定UI组件名。
* [Lua] 新增 自动加载脚本模式，当程序所在目录存在与执行程序名相同的lua文件时，将自动加载此lua脚本(WinXShell.lua除外)。
  * 等同于 `WinXShell.exe -cd -script 脚本文件.lua` 。

---
## WinXShell RC5.1.5 (2025.11.11)
这是一个常规更新。主要强化了Lua组件，添加和改善了以下内容:

* [Lua] 升级内置Lua组件至 **5.4.7** 版本。
* [Lua] 新增 `MsgBox` 方法，可进行对话框交互( `winapi.show_message` 方法的别名)。
* [Lua] 新增 `App:Require()`, `Script:Require()` 方法，可用来引用Libs目录或者脚本所在目录的其他Lua库。
* [Lua] 导入 `Libs\\<平台>\\lua54.dll`, 支持dll形式的Lua库导入使用。
* [Lua] 导入 `LuaSocket (v3.1.0)` 库，可进行简单http/ftp等网络操作。 (感谢 @江南一根葱)
* [Lua] 导入 `LuaFileSystem (v1.8.0)` 库，可在Lua脚本中进行目录文件的相关操作。
* [Lua] 导入 `xml2lua (v1.6-1)` 库，可以解析xml文件。
* [Lua] 导入 `inifile (v1.0)` 库，可进行ini配置文件的相关操作。 
* [Lua] 更新 Lua库使用的脚本示例( `test\\*.lua.bat`)。 
  *  inifile_parser 
  * lfs_sample 
  * luasocket_sample
  * winapi_sample
  * xmlfile_parser
* [Docs] 更新 使用说明文档(WinXShell_Docs) 内容。

---
## WinXShell RC5.1.4 (2025.11.11)
这是一个主要更新。添加和改善了以下内容:

* [App] 使用`-code`, `-script`选项时，将保持工作目录不变(之前版本是强制切换至程序所在位置)。
* [App] 增加`-cd`选项，运行时自动切换工作目录至程序所在位置。
* [App] _WinXShell.lua_ 中可以定义 `App:PreScript()`函数，加载`-script`选项指定的脚本文件前进行预处理。
  * 新版本将保持程序工作目录，不再强制切换到WinXShell.exe程序所在目录，可通过在此函数中调用App:ChDir(App.Path)切换到程序目录，进行兼容处理。
* [App] 增加`-mount <isofile>[ -to <drive>]`选项，支持挂载ISO镜像文件(指定挂载驱动器时，需要管理员权限)。
* [App] 增加`-unmount <drive>`选项，弹出指定驱动器。
* [wxsUI] 添加 zh-TW 繁体中文资源。
* [wxsUI] 在 Windows 11 环境下，窗口支持圆角显示。
* [wxsUI] 增加 App:LoadFont() 方法加载自定义字体文件，修复早期版本上个别图标无法正常显示问题。
* [wxsUI] 修复下来列表组件(Combo)使用按键改变项目时，总是选中最后一个项目的问题。
* [wxsUI] 修复UI_Settings组件在24H2系统PE下分辨率调整时，任务栏错位问题。
* [wxsUI] 改进UI_Settings组件布局和配色使用Windows11风格，并合并显示系统属性信息。 (感谢 @SYSTEM-RAMOS)
* [wxsUI] 改进UI_SystemInfo组件，支持显示OEMLogo图片。
* [wxsUI] 增加UI_Sample组件，作为UI组件开发实例。
* [wxsUI] 新增自动加载UI组件模式，当执行程序名改为`UI_`开头时, 将自动加载同名UI组件。
  * 可通过在 `wxsUI\\UI_xxxxx.lua` 中指定 `App.UIEntryName` 变量的值来改变UI组件的入口配置(默认为`main.jcfg`)。
  * 可通过在 `wxsUI\\UI_xxxxx.lua` 中指定 `App.UICmdLine` 变量的值来设置UI组件的额外参数。
* [Shell] 支持使用自定义ico文件来配置开始菜单图标。
* [FileExplorer] 改善文件资源管理器在高分屏下的显示效果。
* [FileExplorer] 改善驱动器打开动作。当双击BitLocker加密驱动器时，将自动弹出解锁对话框。
* [Lua] 增加`App.PID`属性，可获取启动的进程PID信息。
* [Lua] 增加`Script.File`, `Script.Path`,`Script.Name`属性，可获取当前执行的Lua脚本信息。
* [Lua] 增加`Script:ChDirHere()`方法，可用来切换工作目录到Lua脚本所在位置。
* [Lua] 增加`os.chdir(), App:ChDir()`方法，可用来切换工作目录到指定位置。
* [Lua] 改进`os.info()`方法，可以获取CPU使用率，磁盘信息，显卡信息等。
* [Lua] 增加`App:GetCurrentDir()`方法，可用获取当前工作目录。
* [Lua] 改进`Shell:Run()`方法，指定`Shell.WaitMode`模式可直接对已经启动的外壳进程进行守护。
* [Lua] 增加`Shell:Move()`方法，对文件或文件夹进行基于外壳组件的移动操作(可触发特定外壳响应事件)。
* [Lua] 增加`Shell:Copy()`方法，对文件或文件夹进行基于外壳组件的复制操作(可触发特定外壳响应事件)。
* [Lua] 增加`Shell:Delete()`方法，对文件或文件夹进行基于外壳组件的删除操作(可触发特定外壳响应事件)。
* [Lua] 增加`Cmd.Stdout()`方法，可以获取调用子程序输出结果(等待程序执行完成)。
* [Lua] 增加`File.ReadAll()`方法，可以读取文本文档内容。

---
## WinXShell RC5.1.4 beta1 (2024.08.08)
这是一个主要更新。添加和改善了以下内容:

* [App] 添加 ru-RU 俄语信息资源。
* [App] 增加`-regist_only`选项，仅注册程序路径，执行命令时可省略程序路径(与`-regist -noaction`效果相同)。
* [Daemon] 增加`"JS_DAEMON":{"disable_showdesktop": boolean}`选项来关闭显示桌面处理行为。
* [Daemon] 增加连续按下2次 CAPSLOCK 大写字母锁定键响应函数。
* [wxsUI] 修复UI_Calendar组件内存使用量持续增长的问题。
* [Shell] 改善 新增 _FileExpRefresh_ 扩展，其他文件管理器也支持自动刷新。
* [Shell] 新增任务栏透明效果相关设置(需要DWM组件支持)。
* [FileExplorer] 改善文件资源管理器在高分屏下的显示效果。
* [FileExplorer] 改善驱动器打开动作。当双击BitLocker加密驱动器时，将自动弹出解锁对话框。
* [Lua] 增加`App.Version`, `Lua.Version`属性，可查看当前程序版本信息。
* [Lua] 增加`App:CreateGUID()`方法，可用来生成GUID字符串。
* [Lua] 增加`System:NetJoin()`方法，可用来加入工作组或域。
* [Lua] 增加`System:EnableEUDC()`方法，开启用户自定义外字支持。
* [Lua] 增加`Proc:IsVisable()`方法，可以判断程序窗口是否处于显示或隐藏状态。
* [Lua] 增加`Proc:Activate()`方法，可以激活程序窗口。
* [Lua] 增加`Disk.IsLocked()`方法，可以判断磁盘分区是否被BitLocker加密。
* [Lua] 增加 _WinXShellC.exe_ 控制台程序，执行`-code 代码`或者`-script 脚本文件`时，可通过`Cmd:Echo()`函数输出内容到控制台进行交互。

```bat
for /f %i in ('WinXShellC.exe -code Cmd:Echo^(App.Version^)') do set Ver=%i
echo %Ver%
for /f %i in ('WinXShellC.exe -code Cmd:Echo^(Screen:Get^('X'^)^)') do set ScreenX=%i
echo %ScreenX%
```

---
## WinXShell 5.1.2 (2024.02.02)
这是一个主要更新。添加和改善了以下内容:

* [Daemon] 修复Explorer.exe高版本显示桌面按钮崩溃问题。
* [wxsUI] UI_Logon增加用户按钮热键，可通过Alt+A直接登录Admin账户, Alt+S登录SYSTEM账户。
* [wxsUI] 任务栏在屏幕上方时，UI_WIFI将显示到右上角。
* [wxsUI] 修复当启动后再创建PPPoE时，UI_WIFI界面显示高度不正确的问题。
* [Shell] 改善 其他文件管理器也支持自动刷新。
* [Shell] _WinXShell.lua_ 中可以定义2个热键函数， WinXShell作为外壳时可自定义WIN+S，WIN+F热键动作。

```lua
Shell.onHotKey['WIN+S'] = function()
  App:Debug("WIN+S hotkey is pressed.")
  App:Run('everything.exe')
end

Shell.onHotKey['WIN+F'] = function()
  App:Debug("WIN+F hotkey is pressed.")
  Alert('F')
end
```

* [Lua] 增加`App:Pause()`命令，作为启动管理器时，可用此命令维持启动进程。
* [Lua] 增加`System:CreatePageFile(file, min, max)`方法，可创建页面文件。
* [Lua] 增加`System:ReloadCursors()`方法，可刷新鼠标指针式样。
* [Lua] 增加`Reg:GetSubKeys()`方法，可以获取注册表的子项目集合。
用法参考 LUA_Tests.bat 中的示例。

```lua
print("GetSubKeys for [HKEY_CLASSES_ROOT\\Folder]:")
local subkeys = Reg:GetSubKeys([[HKEY_CLASSES_ROOT\Folder]])
for i, v in ipairs(subkeys ) do
  print(str.fmt("%d:%s", i, v))
end
```

---

## WinXShell 5.0 (2022.11.11)
这是一个主要更新。添加和改善了以下内容:

* 新增 使用说明文档(`WinXShell_Docs`)
* 重构 Lua 代码接口， `WinXShell.lua` 事件响应函数等
* 改进 当作为外壳(Shell)时，以下操作可分别定义打开不同的文件资源管理器。
  * 桌面双击打开文件夹
  * Windows + E 组合键
  * 任务栏快速启动栏中点击文件资源管理器图标
* 改进 UI组件
  * `UI_WIFI` 支持连接 WPA2/WPA3 密码类型
  * `UI_WIFI` 添加显示密码按钮
  * ~~`UI_WIFI` 支持连接同名SSID~~
  * `UI_WIFI` 修复不显示连接界面时，网络状态指示处理未回收内存的问题
  * `UI_WIFI` 添加 Windows 11 风格托盘图标
  * `UI_WIFI` 支持自定义托盘图标
  * `UI_WIFI` 浅色主题文本框显示效果
  * `UI_Calendar`, `UI_TrayPanel` 修正农历显示不正确的问题，更新农历数据(~2025 年)
* 改进 Lua 接口
  * 新增 `Sui:onClick()` 点击事件支持文本中的URL超链接响应
  * 新增 `Sui:onHover()` 响应鼠标悬停事件
  * 新增 `Dialog:Show()` 弹出对话框
  * 新增 `Dialog:OpenFile()`, `Dialog:SaveFile()` 弹出打开文件/保存文件窗口
  * 新增 `Dialog:BrowseFolder()` 浏览文件夹窗口
  * 新增 `File.GetShortPath()` 获取 8.3格式的短路径
  * 新增 `File.GetFullPath()` 获取 完整路径格式
* 新增 日志功能(`-log` 选项)
* 改善 自动识别是否是 Windows PE 环境运行， `-winpe` 选项 已废弃
* 修复 有时打开菜单时，导致程序无法正常工作的问题
* 更新 适配 Windows 11 新版本系统
* 其他细节更新

**本次更新功能增加不多，主要补充了说明文档，对Lua接口进行了重新设计，代码重构。**

---

## WinXShell 4.6 (2021.11.11)
这是一个主要更新。添加和改善了以下内容:

* 修复 亮度调节功能占用256MB内存的问题。
* 改进 任务栏按钮显示风格。(适配Windows主题，解决Windows 11按钮高亮显示不自然的问题)
* 新增 任务栏程序快速关闭按钮(可通过配置文件进行设定)。
* 新增 UI组件
  * UI_LED        屏幕提示信息(可滚动)。
  * UI_TrayPanel  显示系统信息，日历，调度调节控件。
* 改进 UI组件
  * 当显示设置发生变化时，将调用 ondisplaychanged() 函数，可用来调整窗口位置或更新数据。
  * UI_Settings   DPI设置新增225%, 250%, 275%, 300%选项。
  * UI_SystemInfo 适配Windows 11。
  * UI_Calendar   改善界面，新增亮度调节控件(可通过-brightness=true|false参数控制)。
* 改进 lua接口
  * 新增 app:info('FirmwareType') 方法
  * 新增 app:info('IsUEFIMode') 方法
  * 新增 sui:title(str) 方法
  * 新增 sui:info('rect') 方法
  * 新增 sui:info('wh') 方法
  * 新增 FolderOptions:Toggle(opt) 方法
* 其他细节更新

---

## WinXShell 4.5 (2021.04.04)
这是一个主要更新。添加和改善了以下内容:

* 新增 任务栏窗口预览功能(thumbnail)。
* 改进 lua接口
       可使用Desktop对象，可通过此对象更改壁纸，实时改变桌面图标大小，
       布局等表示样式，可直接刷新桌面。
* 改进 UI组件
  * UI_Settings   支持设置屏幕亮度
  * UI_SystemInfo 支持读取OEM信息
  * UI_SystemInfo 修复无法正确显示机器名的问题
  * UI_SystemInfo 调整界面字体，布局等细节
  * UI_WIFI       可直接输入回车键进行连接
  * UI_WIFI      【网络和Internet 设置】可打开【网络连接】页面(更改适配器选项)
  * UI_WIFI       修复启动窗口闪烁问题
  * UI_WIFI       修复在外壳启动前运行时，弹出连接窗口会覆盖任务栏的问题

将支持的Lua函数和对象信息书写LUA_TEST.bat测试脚本(UTF-8编码，中文说明)。

---

## WinXShell 4.4 (2020.10.10)
这是一个常规更新。添加和改善了以下内容:

* 改善 lua_helper扩展
    将winapi和lua扩展库编译到应用程序本身。
    减小程序体积，简化结构，仅应用程序就可支持运行lua代码。

* 强化 UI组件
  * UI_WIFI      支持连接隐藏网络
  * UI_WIFI      支持多无线网卡进行网络连接
  * UI_Calendar  支持显示农历信息
  * UI_Settings  支持修改显示DPI

---

## WinXShell 4.3 (2020.04.04)
这是一个主要更新。添加和改善了以下内容:

* 改进 编译选项设置 “随机基址”和“数据执行保护(DEP)”。
* 新增 开始菜单项目，新增【网络连接】项目。
* 新增 UI_WIFI 新增 PPPoE拨号按钮，有拨号连接时显示。
* 新增 UI_WIFI，UI_Volume支持 -notrayicon 参数，不创建托盘图标。
* 改进 直接接管系统 声音，网络 托盘图标，点击调用 UI_Volume 和 UI_WIFI 组件。
  * 原生状态指示图标
  * 支持图标右键菜单
  * 菜单支持全部语言
* 改善 lua_helper 函数库，WinXShell.lua 仅保留用户自定义函数和接口。
* 新增 wxs-ui:xxx, wxs-open:xxx 短命令协议接口。
  例如: wxs-ui:wifi, wxs-open:system, wxs-open:networkconnections,
        wxs-open:devices, wxs-open:printers
* 改善 控制面板中点击【连接到网络】，将打开 UI_WIFI 连接界面。
* 改善 ADSL拨号连接，将打开 UI_WIFI 连接界面。(正常系统下有效，PE下无效)
* 修复 我的电脑右键【属性】菜单没有菜单热键问题。
* 修复 点击控制面板无限弹出资源管理器问题。
* 改善 我的电脑右键【属性】默认显示系统属性界面。
* 新增 浅色主题支持。
  * 任务栏           添加浅色主题
  * 声音,WIFI,日历   添加浅色主题
* 改善 个性化设定界面，增加更多颜色相关设定选项。
* 改善 声音设定界面滑块移动流畅度提高，提示音不再阻塞。
* 修复 信息通知栏无法显示的问题。


## __________

## English
=======================================================================================================================

## WinXShell 5.0 (2022.11.11) EN
Not translated yet.
Please use the translation tool to view this update instructions.

---

## WinXShell 4.6 (2021.11.11) EN
Not translated yet.
Please use the translation tool to view this update instructions.

---

## WinXShell 4.5 (2021.04.04) EN
This is a major update.The following was added and improved:

* Added task thumbnail feature.
* Improved the lua interface.
    Add the Desktop object, through which you can change the wallpaper, change the size of the desktop icons, the layout and other presentation styles in real time,
    and refresh the desktop directly.
* Improved UI components
  * UI_Settings    supports setting screen brightness
  * UI_SystemInfo  supports reading OEM information
  * UI_SystemInfo  fix the issue that the computer name cannot be displayed correctly
  * UI_SystemInfo  adjust interface font, layout and other details
  * UI_WIFI        add the enter key to connect
  * UI_WIFI        [network and Internet settings] link will open [Network connection] control panel window(change adapter options)
  * UI_WIFI        fix the flickering problem of the startup window
  * UI_WIFI        fix the problem that the connection window will cover the taskbar when the this is running before the shell starts.

Write the supported Lua functions and objects into the LUA_TEST.bat test script (UTF-8 encoding, in Chinese).

---

## WinXShell 4.4 (2020.10.10) EN
This is a regular update. The following were updated or improved:

* Improved the lua_helper extension.
    Compile winapi.dll and lua extension helpers into the application itself.
    Reduce the size of the program, simplify the structure, and only the application program can support running Lua code.
* Improved UI components.
  * UI_WIFI      supports connection to hidden network
  * UI_WIFI      supports multiple wireless network adapters for network connection
  * UI_Calendar  supports display of lunar calendar for Chinese OS
  * UI_Settings  supports modification and display of DPI
