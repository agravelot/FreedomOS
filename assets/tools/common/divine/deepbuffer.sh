#!/sbin/sh


sed -i '/deep_buffer {/,/}/d' /system/etc/audio_policy.conf

