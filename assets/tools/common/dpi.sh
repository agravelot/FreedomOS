#!/sbin/sh
#
#	Author : Nevax
#
echo Set DPI to $1
echo ro.sf.lcd_density=$1 >> /system/build.prop
