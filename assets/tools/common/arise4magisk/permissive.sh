#!/system/bin/sh
# Please don't hardcode /magisk/modname/... ; instead, please use $MODDIR/...
# This will make your scripts compatible even if Magisk change its mount point in the future
MODDIR=${0%/*}

# This script will be executed in post-fs-data mode
# More info in the main Magisk thread

sepolicy-inject --live "permissive *"

if [ -e /system/su.d/arisesound_services ]; then
	./system/su.d/arisesound_services
else
	if [ -e /system/su.d/arisesound_setprop ]; then
		./system/su.d/arisesound_setprop
	fi

	if [ -e /system/su.d/smeejaytee_setprop ]; then
		./system/su.d/smeejaytee_setprop
	fi

	if [ -e /system/su.d/sony_setprop ]; then
		./system/su.d/sony_setprop
	fi
fi
