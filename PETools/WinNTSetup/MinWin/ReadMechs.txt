贡献者
	wimb & alacran : 提供灵感和类似项目的文件列表 : : http://reboot.pro/index.php?showtopic=21977&page=1
	iavn kehayov   : 感谢他在 Windows 10 轻量化 (Windows 10 Enterprise 2019 LTSC x64 v2107 lite) 上的出色工作。



该文件夹包含 minwin 配置文件。

minwin 配置文件有 3 个可选子文件夹
	Add
		该文件夹的内容将添加到应用或捕获图像的根目录中
	Reg
		*.reg 文件将添加到应用或捕获的图像中
	Remove
		文件格式为 *.txt 的文件内容将被排除在应用或捕获操作之外
		*.reg 文件将添加到应用或捕获的图像中

应该有一个 WinSxS.ini
	其中包含一个 WindowsWinSXS 文件夹的白名单
	通配符只能匹配一个组件，该组件的过时版本将被删除
                如果需要保留低版本，应在该行前加上"！"。

默认配置文件应显示可设置和使用的最小安装。
	不能报告程序 xyz.exe 无法运行。
	欢迎提供其他配置文件或建设性报告。



文件格式使用示例

	\Windows\ShellExperiences
		与文件夹匹配，因此将删除该文件夹，包括其子目录
		
	!\Windows\ShellExperiences\TileControl.dll
		与文件相匹配，因此不会被清除
		
	7600-9600 !\Windows\SysWoW64\shsetup.dll
		只有版本号为 Windows 7 - 8.1 的系统才能处理此行
		
	Setup=0 \Windows\System32\SMI
		只有当映像未处于设置模式（SystemSetupInprogress=1）时，才会处理这一行
		
	Arch=amd64 !\Windows\SysWow64 ; 可能的值 (amd64|x86|arm64)
		只有当架构为 AMD64 时，才会保存文件夹
		
	Lang=de-de !\Windows\system32\kbdgr.dll
		只有当语言为 de-de 时，文件才会被保存。

	FBLANG!es-ES	\Windows\Boot\EFI\es-ES
		如果不是备用语言，文件夹才会被移除

不同的条件可以用','组合，相同的条件用'|'组合
	7600-9600,Lang=de-de|en-us|fr-fr,Setup=1,Arch=amd64|x86 !\Windows\System32\kernel32.dll
