#!/sbin/sh
#
# Author : Nevax
#
/tmp/tools/busybox echo "DEBUG: Set sdcard perm"
#chown -R sdcard_rw:sdcard_rw /sdcard/
/tmp/tools/busybox chown -R media_rw:media_rw /data/media

echo "DEBUG: Remove Password"
/tmp/tools/busybox rm /data/system/gatekeeper*
/tmp/tools/busybox rm /data/system/locksettings*

echo "Delete local.prop"
/tmp/tools/busybox rm /data/local.prop
