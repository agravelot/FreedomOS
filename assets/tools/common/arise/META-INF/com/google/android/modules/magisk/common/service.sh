#!/system/bin/sh
# Please don't hardcode /magisk/modname/... ; instead, please use $MODDIR/...
# This will make your scripts compatible even if Magisk change its mount point in the future
MODDIR=${0%/*}

# This script will be executed in late_start service mode
# More info in the main Magisk thread

/data/magisk/magisk sepolicy-inject --live "allow mediaserver mediaserver_tmpfs file { read write execute }" \
"allow audioserver audioserver_tmpfs file { read write execute }"

if [ -d "/system/system" ]; then
  SYS=/system/system
else
  SYS=/system
fi

SH=$SYS/bin/sh
ARISE=$SYS/etc/init.d/arisesound_setprop
SONY=$SYS/etc/init.d/sony_setprop
BOOT=$SYS/etc/init.d/post-boot

if [ -e "$ARISE" ]; then

    $SH $ARISE

fi

if [ -e "$SONY" ]; then

    $SH $SONY

fi

(
    sleep 60
    $SH $BOOT
)&
