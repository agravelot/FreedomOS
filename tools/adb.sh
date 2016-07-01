#!/sbin/sh
#
# Author : Nevax
#
cd /
busybox echo "persist.service.adb.enable=1" >> /default.prop
busybox echo "persist.service.debuggable=1" >> /default.prop
busybox echo "persist.sys.usb.config=mtp,adb" >> /default.prop
busybox echo "persist.service.adb.enable=1" >> /system/build.prop
busybox echo "persist.service.debuggable=1" >> /system/build.prop
busybox echo "persist.sys.usb.config=mtp,adb" >> /system/build.prop
