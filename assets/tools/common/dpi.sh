#!/sbin/sh
#
#	Author : Nevax
#
/tmp/tools/busybox echo "Set DPI to $1"
dpi=$1

if grep -qr ro.sf.lcd_density= /system/build.prop ; then
  /tmp/tools/busybox echo "DEBUG: ro.sf.lcd_density is set, add value $dpi"
  /tmp/tools/busybox sed -i "s/ro.sf.lcd_density=.*/ro.sf.lcd_density=$dpi/" /system/build.prop
else
  /tmp/tools/busybox echo "DEBUG: ro.sf.lcd_density is not set, change value $dpi"
  /tmp/tools/busybox echo ro.sf.lcd_density=$dpi >> /system/build.prop
fi
