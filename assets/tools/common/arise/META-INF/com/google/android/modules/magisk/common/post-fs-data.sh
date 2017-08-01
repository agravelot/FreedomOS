#!/system/bin/sh
# Please don't hardcode /magisk/modname/... ; instead, please use $MODDIR/...
# This will make your scripts compatible even if Magisk change its mount point in the future
MODDIR=${0%/*}

# This script will be executed in post-fs-data mode
# More info in the main Magisk thread

if [ -d "/system/system" ]; then
  SYS=/system/system
else
  SYS=/system
fi

$SYS/bin/sh $SYS/su.d/arisesound_services
