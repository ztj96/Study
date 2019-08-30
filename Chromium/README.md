# <center>WINDOWS下Chromium编译</center> #


#一.配置depot_tools

获取depot_tools工具，用于后续自动化下载配置编译Chromium

	d:\Work>git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git

执行gclient自动下载所需的git/python工具

	d:\Work\depot_tools>gclient

添加系统path路径,并置顶

	d:\Work\depot_tools\


#二.下载Chromium

Chromium代码路径

[https://chromium.googlesource.com/chromium/src/](https://chromium.googlesource.com/chromium/src/ "Chromium代码")

使用depot_tools中的fetch工具获取<font color=red>最新</font>Chromium代码

	d:\Work>mkdir Chromium
	d:\Work>cd Chromium
	d:\Work\Chromium>fetch chromium	//下载很慢，共15G代码，使用--no-history参数(10G左右)会快一点，否则会下载所有历史记录；完成会显示done

此时是master最新的代码

	d:\Work\Chromium>cd src
	d:\Work\Chromium\src>git branch -a
	* (HEAD detached at origin/master)
	  master
	  remotes/origin/HEAD -> origin/master
	  remotes/origin/master

----------

*若需要下载<font color=red>指定TAG</font>代码(如62.0.3202.99版本)*

	d:\Work\Chromium\src>git fetch origin tag 62.0.3202.99	//获取分支代码
	d:\Work\Chromium\src>git tag	//查看当前本地保存的tag
	62.0.3202.99
	pre_blink_merge
	d:\Work\Chromium\src>git checkout -b my_local 62.0.3202.99	//在本地创建一个my_local分支(因为tag不能修改，后续同步操作需要在一个分支进行)
	d:\Work\Chromium\src>git branch -a	//当前分支已经切换到my_local
	  master
	* my_local
	  remotes/origin/HEAD -> origin/master
	  remotes/origin/master

----------

#三.编译前配置Chromium项目

配置系统变量

	DEPOT_TOOLS_WIN_TOOLCHAIN = 0
	GYP_MSVS_VERSION = 2019	//目前最新Chromium编译只支持vs2017、vs2019，部分旧版本是vs2015、vs2017，不同版本使用不同的VS

执行gclient sync，获取最新代码(偶尔会出错，可能需执行多次)，配置Chromium项目，等待时间30min

master主干直接获取最新代码

	d:\Work\Chromium\src>gclient sync	//配置Chromium项目，同步项目代码

分支/Tag代码，带参数执行命令

	d:\Work\Chromium\src>gclient sync --with_branch_heads --with_tags	//配置Chromium项目，分支需要--with_branch_heads --with_tags参数

期间可能会多次遇到如下的错误，是因为某些代码历史本地没有记录(可能与之前使用fetch --no-history chromium有关)

	Error: Command 'git checkout --quiet ae02d6b8a2af41e87c956c7c7d3f651a8b7b9e79' returned non-zero exit status 128 in d:\Work\Chromium\src\third_party\cld_3\src
	fatal: reference is not a tree: ae02d6b8a2af41e87c956c7c7d3f651a8b7b9e79

执行fetch后，再次gclient sync

方法一：每次遇到此问题则进行一次fetch,checkout

	d:\Work\Chromium\src>cd third_party\cld_3\src
	d:\Work\Chromium\src\third_party\cld_3\src>git fetch origin ae02d6b8a2af41e87c956c7c7d3f651a8b7b9e79
	d:\Work\Chromium\src\third_party\cld_3\src>git checkout ae02d6b8a2af41e87c956c7c7d3f651a8b7b9e79
	d:\Work\Chromium\src\>gclient sync --with_branch_heads --jobs 16

方法二：修改脚本，在checkout前先fetch，具体在gclient_smc.py中添加fetch的逻辑

	  def _Checkout(self, options, ref, force=False, quiet=None):
	    if quiet is None:
	      quiet = (not options.verbose)
	    checkout_args = ['checkout']
	    if force:
	      checkout_args.append('--force')
	    if quiet:
	      checkout_args.append('--quiet')
	    checkout_args.append(ref)

		#fetch before checkout
	    fetch_args=['fetch']
	    fetch_args.append('origin')
	    fetch_args.append(ref)
	    self._Capture(fetch_args)

	    return self._Capture(checkout_args)

期间可能会多次遇到如下警告，需要删除无用目录，若不删除，后续编译可能会出问题。运行gclient sync -D或者手动删除都可以，确保都删除了。

	WARNING: 'src\third_party\angle\third_party\vulkan-tools\src' is no longer part of this client.
	It is recommended that you manually remove it or use 'gclient sync -D' next time.


#四.生成gn工程

可直接执行

	d:\Work\Chromium\src>gn gen out/Default 

若需配置，可带参数执行
	
	//生成完整chromium工程
	d:\Work\Chromium\src>gn gen --ide=vs2019 --winsdk=10.0.14393.0 out\Default --args="symbol_level=2 is_debug=true is_component_build=true target_cpu=\"x86\""

	//生成精简chromium工程 --推荐使用这个
	d:\Work\Chromium\src>gn gen --sln=chrome --filters=//chrome --no-deps --ide=vs2019 --winsdk=10.0.14393.0 out\Default --args="symbol_level=2 is_debug=true is_component_build=true target_cpu=\"x86\""

	//生成content_shell工程	
	d:\Work\Chromium\src>gn gen --sln=content_shell --ide=vs2019 --filters=//content/shell:content_shell --no-deps --winsdk=10.0.14393.0 out\Default --args="symbol_level=2 is_debug=true is_component_build=true target_cpu=\"x86\""

其中

	--sln=chrome 	//工程名字
	--filters=//chrome --no-deps	//vs工程中去除各种组件，提高打开速度
	--filters=//content/shell:content_shell	//只包含基础的单标签网页功能
	--ide=vs	//生成vs工程，sln文件，可vs版本
	--winsdk=10.0.14393.0	//指定win10Sdk路径，不指定可能找不到一些文件
	//--args中
	symbol_level=2	//控制最小编译，一般想调试=2
	is_debug=true	//是否生成debug信息
	target_cpu=\"x86\"	//x86或者x64,x86编译会快一点
	is_component_build = true	//是否生成更多组件，若true会附带很多dll
	



#五.编译代码

	使用ninja编译，或者vs工程编译都行，vs工程编译会比较卡，推荐使用depot_tools中的autoninja
	d:\Work\Chromium\src>autoninja -C out\Default chrome

建议使用未安装chrome的机器进行最终生成的文件，因为安装chrome可能会存在一些插件冲突问题。



#六.调试Chromium

由于chrome是多进程，可使用--single-process --disable-gpu作为参数启动，方便调试

#注：
Chromium编译官方说明

[https://chromium.googlesource.com/chromium/src/+/master/docs/windows_build_instructions.md](https://chromium.googlesource.com/chromium/src/+/master/docs/windows_build_instructions.md)

[https://www.chromium.org/developers/how-tos/get-the-code/working-with-release-branches](https://www.chromium.org/developers/how-tos/get-the-code/working-with-release-branches)