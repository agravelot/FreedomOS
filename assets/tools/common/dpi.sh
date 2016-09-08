#!/sbin/sh
#
#	Author : Nevax
#
/tmp/tools/busybox echo "Set DPI to $1"
/tmp/tools/busybox echo ro.sf.lcd_density=$1 >> /system/build.prop
