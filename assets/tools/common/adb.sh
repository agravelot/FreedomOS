#!/sbin/sh
#
# Author : Nevax
#
/tmp/tools/busybox echo "persist.service.adb.enable=1" >> /system/build.prop
/tmp/tools/busybox echo "persist.service.debuggable=1" >> /system/build.prop
/tmp/tools/busybox echo "persist.sys.usb.config=mtp,adb" >> /system/build.prop
