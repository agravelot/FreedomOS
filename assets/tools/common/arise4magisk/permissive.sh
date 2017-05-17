#!/system/bin/sh
# Please don't hardcode /magisk/modname/... ; instead, please use $MODDIR/...
# This will make your scripts compatible even if Magisk change its mount point in the future
MODDIR=${0%/*}

# This script will be executed in late_start service mode
# More info in the main Magisk thread

magiskpolicy --live "permissive *"

if [ -e /system/su.d/arisesound_services ]; then
	/system/bin/sh /system/su.d/arisesound_services
else
	for PROP in arisesound_setprop smeejaytee_setprop sony_setprop dts_configurator_wrapper; do
		if [ -e /system/su.d/$PROP ]; then
			/system/bin/sh /system/su.d/$PROP
		fi
	done
fi
