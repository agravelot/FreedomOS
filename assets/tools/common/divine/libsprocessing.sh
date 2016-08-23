#!/sbin/sh

VENDOR_CONFIG=/system/vendor/etc/audio_effects.conf
# Add libary
sed -i 's/^libraries {/libraries {\n  znrwrapper {\n    path \/system\/lib\/soundfx\/libznrwrapper.so\n  }/g' $VENDOR_CONFIG
	
# Add effect
sed -i 's/^effects {/effects {\n  ZNR {\n    library znrwrapper\n    uuid b8a031e0-6bbf-11e5-b9ef-0002a5d5c51b\n  }/g' $VENDOR_CONFIG

