#!/sbin/sh
#
# Author : Nevax
#
echo "persist.service.adb.enable=1" >> /system/build.prop
echo "persist.service.debuggable=1" >> /system/build.prop
echo "persist.sys.usb.config=mtp,adb" >> /system/build.prop
