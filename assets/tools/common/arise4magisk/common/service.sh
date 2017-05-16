#!/system/bin/sh
# Please don't hardcode /magisk/modname/... ; instead, please use $MODDIR/...
# This will make your scripts compatible even if Magisk change its mount point in the future
MODDIR=${0%/*}

# This script will be executed in late_start service mode
# More info in the main Magisk thread

/data/magisk/sepolicy-inject --live "allow mediaserver mediaserver_tmpfs file { read write execute }" \
"allow audioserver audioserver_tmpfs file { read write execute }"

if [ -e /system/su.d/arisesound_services ]; then
	/system/bin/sh /system/su.d/arisesound_services
else
	if [ -e /system/su.d/arisesound_setprop ]; then
		/system/bin/sh /system/su.d/arisesound_setprop
	fi
	if [ -e /system/su.d/smeejaytee_setprop ]; then
		/system/bin/sh /system/su.d/smeejaytee_setprop
	fi
	if [ -e /system/su.d/sony_setprop ]; then
		/system/bin/sh /system/su.d/sony_setprop
	fi
	if [ -e /system/su.d/dts_configurator_wrapper ]; then
		/system/bin/sh /system/su.d/dts_configurator_wrapper
	fi
fi
