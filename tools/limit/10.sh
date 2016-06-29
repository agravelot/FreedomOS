#!/sbin/sh
sed -i 's:ro.sys.fw.bg_apps_limit=.*:ro.sys.fw.bg_apps_limit=10:' /system/build.prop
