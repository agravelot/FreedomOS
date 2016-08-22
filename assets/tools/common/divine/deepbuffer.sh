#!/sbin/sh

if [ "`grep ro.product.brand=Sony /system/build.prop`" ];
then
else
 busybox cp -f /customize/dseehx/lib/libsonydseehxwrapper.so /system/lib/libsonydseehxwrapper.so
fi

sed -i '/deep_buffer {/,/}/d' /system/etc/audio_policy.conf