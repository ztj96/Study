#最基础版Gn测试项目，在Windows下编译

在build_cache目录下生成gn配置
```
".\\gn\\bin\\gn.exe" gen "build_cache" --args="is_debug=false target_cpu=\"x86\" win_vc=\"C:\\Program Files (x86)\\Microsoft Visual Studio 14.0\\VC\" win_vc_ver=\"2015\" win_xp=false"
```

使用build_cache目录下gn配置，编译最终文件
```
>".\\gn\\bin\\ninja.exe" -C  "build_cache"
```