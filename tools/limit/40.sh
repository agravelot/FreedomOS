#!/sbin/sh
sed -i 's:ro.sys.fw.bg_apps_limit=.*:ro.sys.fw.bg_apps_limit=40:' /system/build.prop
