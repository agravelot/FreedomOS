#!/sbin/sh
# 
# /system/addon.d/ZireneAudioFx.sh
#
. /tmp/backuptool.functions

list_files() {
cat <<EOF
addon.d/ZireneAudioFx.sh
app/AudioEffects.apk
app/AudioEffects/AudioEffects.apk
lib/soundfx/libam3daudioenhancement.so
etc/presets/presets.xml
etc/presets/TransducerEQ_XML/Foxconn/TransducerEQ.xml
EOF
}

case "$1" in
  backup)
    list_files | while read FILE DUMMY; do
      backup_file $S/$FILE
    done
  ;;
  restore)
    list_files | while read FILE REPLACEMENT; do
      R=""
      [ -n "$REPLACEMENT" ] && R="$S/$REPLACEMENT"
      [ -f "$C/$S/$FILE" ] && restore_file $S/$FILE $R
    done
  ;;
  pre-backup)
    # Stub
  ;;
  post-backup)
    # Stub
  ;;
  pre-restore)
	# Stub
  ;;
  post-restore)
    # Normal/vendor config locations
	CONFIG_FILE=/system/etc/audio_effects.conf
	VENDOR_CONFIG=/system/vendor/etc/audio_effects.conf

	# If vendor exists, patch it
	if [ -f $VENDOR_CONFIG ];
	then
		sed -i '/am3daudioenhancement {/,/}/d' $VENDOR_CONFIG
		# Add libary
		sed -i 's/^libraries {/libraries {\n  am3daudioenhancement {\n    path \/system\/lib\/soundfx\/libam3daudioenhancement.so\n  }/g' $VENDOR_CONFIG
		# Add effect
		sed -i 's/^effects {/effects {\n  am3daudioenhancement {\n    library am3daudioenhancement\n    uuid 6723dd80-f0b7-11e0-98a2-0002a5d5c51b\n  }/g' $VENDOR_CONFIG
	fi
	
	# Remove library & effect
	sed -i '/am3daudioenhancement {/,/}/d' $CONFIG_FILE
	
	# Add libary
	sed -i 's/^libraries {/libraries {\n  am3daudioenhancement {\n    path \/system\/lib\/soundfx\/libam3daudioenhancement.so\n  }/g' $CONFIG_FILE

	# Add effect
	sed -i 's/^effects {/effects {\n  am3daudioenhancement {\n    library am3daudioenhancement\n    uuid 6723dd80-f0b7-11e0-98a2-0002a5d5c51b\n  }/g' $CONFIG_FILE
  ;;
esac
