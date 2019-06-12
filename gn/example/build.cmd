
".\\gn\\bin\\gn.exe" gen "build_cache" --ide=vs2015 --args="is_debug=false target_cpu=\"x86\" win_vc=\"C:\\Program Files (x86)\\Microsoft Visual Studio 14.0\\VC\" win_vc_ver=\"2015\" win_xp=false"

".\\gn\\bin\\ninja.exe" -C  "build_cache"