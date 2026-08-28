# 🚀快速下载
[v1.02 Portable](https://github.com/HS201512/PEShellBuilder/releases/download/v1.02/PEShellBuilder_v1.02_Portable.zip)<br>
[v1.02 Setup](https://github.com/HS201512/PEShellBuilder/releases/download/v1.02/PEShellBuilder_v1.02_Setup.exe)<br>
[v1.02 SingleFile](https://github.com/HS201512/PEShellBuilder/releases/download/v1.02/PEShellBuilder_v1.02_SingleFile.exe)<br>

# PEShellBuilder
此工具可以让您自定义 Windows PE（例如壁纸、工具）<br>
建议使用 Windows 8、10、11

# PEShellBuilder 目录说明

<<<<<<< HEAD
版本：v1.02

- 前言
这是 PEShellBuilder 的目录说明（给人看的，删除此文件不影响 PEShellBuilder 运行）

- 工具
位于此目录的 PETools 文件夹里

- 主题
注意：某些设置可能对Win8无效
设置壁纸
如果是Windows 11，位于此目录的 Theme\11\winpe.jpg
如果是Windows 10，位于此目录的 Theme\11\winpe.jpg
如果是Windows 8.x，位于此目录的 Theme\8\winpe.jpg
bg1.jpg则是第二壁纸，您也可以替换
CW.bat是切换壁纸的脚本，不要去动它
Light和Dark文件夹是浅色和暗色的主题
可以把现有的winre.jpg替换为您想要的壁纸，分辨率不要超过1024*768

- 开机自启
新建一个名为Startup的文件夹，在里面创建PEStartup.bat，里面可以写开机自启的命令
PEStartup.bat要和程序放到同一个目录（如果没有程序则忽略）

- 程序包
注意：现在Win11的LCU都是wim或msu格式了，仅支持cab格式的程序包
如果需要此功能，新建名为Packages的文件夹，可以把要添加的cab（包括更新）放到Packages文件夹里

- 框架
位于此目录的 Shell 文件夹
Normal 带工具的PECMD配置
NotTool 不带工具的PECMD配置
PEShell PEShell所在的目录
WinXShell WinXShell所在的目录（您可以自定义WinXShell.jcfg）

- 运行库
位于此目录的 Runtime 文件夹，只放了一点点orz

- PEShellBuilder 要用到的工具
位于此目录的 bin 文件夹，不要去动它
=======
- 自定义工具
位于此目录的 PETools 文件夹里，您可以添加工具<br>

- 自定义壁纸
注意：此设置可能对某些Win11无效<br>
如果是Windows 11，位于此目录的 Wallpaper\11\winre.jpg<br>
如果是Windows 10，位于此目录的 Wallpaper\11\winre.jpg<br>
如果是其他的Windows，位于此目录的 Wallpaper\normal\winre.jpg<br>
可以把现有的winre.jpg替换为您想要的壁纸，分辨率不要超过1024*768

- 自定义欢迎标语<br>
位于此目录的 LaunchBats 文件夹里，您可以把PEShell.bat或PEShell_NotTools.bat中的欢迎标语改为您想要的<br>

- 开机自启
新建一个名为Startup的文件夹，在里面创建PEStartup.bat，里面可以写开机自启的命令和程序<br>
代码千万不要有exit！！！<br>
PEStartup.bat要和程序放到同一个目录（如果没有程序则忽略）<br>

- 自定义程序包
注意：现在Win11的LCU都是wim或msu格式了，仅支持cab格式的程序包<br>
新建名为Packages的文件夹，可以把要添加的cab（包括更新）放到Packages文件夹里<br>

- 预置资源
在此目录下新建Preset目录，里面的数据将会映射到X盘根目录<br>
>>>>>>> e6011d03d06bf9b42baae697f03d4bfa7eadde0b<br>
