#!/system/bin/sh
# Please don't hardcode /magisk/modname/... ; instead, please use $MODDIR/...
# This will make your scripts compatible even if Magisk change its mount point in the future
MODDIR=${0%/*}

# This script will be executed in late_start service mode
# More info in the main Magisk thread

sepolicy-inject --live "allow mediaserver mediaserver_tmpfs file { read write execute }" \
"allow audioserver audioserver_tmpfs file { read write execute }"

if [ -e /system/su.d/arisesound_services ]; then
	./system/su.d/arisesound_services
fi
