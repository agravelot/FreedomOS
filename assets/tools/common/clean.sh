#!/sbin/sh
#
# Author : Nevax
#
echo "DEBUG: Set sdcard perm"
#chown -R sdcard_rw:sdcard_rw /sdcard/
chown -R media_rw:media_rw /data/media

echo "DEBUG: Remove Password"
rm /data/system/gatekeeper*
rm /data/system/locksettings*
