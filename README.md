# PEShellBuilder
此工具可以让您自定义 Windows PE（例如壁纸、工具）<br>
建议使用 Windows 8、10、11

# PEShellBuilder 自定义说明

- 自定义工具
位于此目录的 PETools 文件夹里，您可以添加工具<br>

- 自定义壁纸
注意：此设置可能对某些Win11无效
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
