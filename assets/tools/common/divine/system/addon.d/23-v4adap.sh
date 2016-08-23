#!/sbin/sh
# 
# /system/addon.d/23-v4adap.sh
#
. /tmp/backuptool.functions

list_files() {
cat <<EOF
addon.d/23-v4adap.sh
priv-app/As/As.apk
priv-app/AsUI/AsUI.apk
priv-app/ViPER4AndroidFX-2.4.0.1/ViPER4AndroidFX-2.4.0.1.apk
lib/libdlbdapstorage.so
lib/soundfx/libswdap-mod.so
lib/soundfx/libv4a_fx_ics.so
etc/dolby/ds-default.xml
etc/audio_policy.conf
bin/aplay
bin/asound
etc/soundimage/srs_bypass.cfg
etc/soundimage/srs_geq10.cfg
etc/soundimage/srs_global.cfg
etc/soundimage/srsfx_trumedia_51.cfg
etc/soundimage/srsfx_trumedia_movie.cfg
etc/soundimage/srsfx_trumedia_music.cfg
etc/soundimage/srsfx_trumedia_voice.cfg
etc/tfa/playbackbeats.config
etc/tfa/playbackbeats.eq
etc/tfa/playbackbeats.preset
etc/tfa/playbackbeats_I.config
etc/tfa/playbackbeats_I.eq
etc/tfa/playbackbeats_I.preset
etc/image_beatbox_bt.bin
etc/image_beats_speaker.bin
etc/image_beats_wireless_bt.bin
etc/image_gec.bin
etc/image_gec_2vol.bin
etc/image_gec_bt.bin
etc/image_htc_earbud.bin
etc/image_htc_earbud_2vol.bin
etc/image_htc_midtier.bin
etc/image_htc_midtier_2vol.bin
etc/image_ibeats.bin
etc/image_ibeats_2vol.bin
etc/image_ibeats_solo.bin
etc/image_ibeats_solo_2vol.bin
etc/image_ibeats_solo_v2.bin
etc/image_ibeats_solo_v2_2vol.bin
etc/image_ibeats_v2.bin
etc/image_ibeats_v2_2vol.bin
lib/soundfx/libsonypostprocbundle.so
lib/soundfx/libsonysweffect.so
lib/soundfx/libvpt51wrapper.so
lib/soundfx/libeffectproxy.so
lib/soundfx/libsrsfx.so
lib/soundfx/libbeatsbass.so
lib/soundfx/libbeatscorehtc.so
lib/soundfx/libsrscore.so
lib/soundfx/libsrscorehtc.so
lib/soundfx/libsrsprocessing.so
lib/soundfx/libsrstb.so
lib/libbeatscorehtc.so
etc/sony_effect/clearphase_sp_param.bin
etc/sony_effect/effect_params.data
etc/sony_effect/sforce_param_arm.bin
etc/sony_effect/sforce_param_qdsp.bin
etc/sony_effect/xloud_param_arm.bin
etc/sony_effect/xloud_param_qdsp.bin
su.d/50viper.sh
ViPER Version Info.txt
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
 # Remove library & effect
 sed -i '/sonyeffect {/,/}/d' $VENDOR_CONFIG

 # Remove library & effect
 sed -i '/VPT51 {/,/}/d' $VENDOR_CONFIG

 # Remove library & effect
 sed -i '/sonyeffect_sw {/,/}/d' $VENDOR_CONFIG

 # Remove library & effect
 sed -i '/proxy {/,/}/d' $VENDOR_CONFIG

 # Remove library & effect
 sed -i '/vpt51 {/,/}/d' $VENDOR_CONFIG

 # Remove library & effect
 sed -i '/sonyeffect_hw {/,/}/d' $VENDOR_CONFIG

 # Remove library & effect
 sed -i '/srstb {/,/}/d' $VENDOR_CONFIG

 # Remove library & effect
 sed -i '/bass_enhancement {/,/}/d' $VENDOR_CONFIG

 # Remove library & effect
 sed -i '/beatscore {/,/}/d' $VENDOR_CONFIG

 # Remove library & effect
 sed -i '/srscore {/,/}/d' $VENDOR_CONFIG

	# Remove library & effect
 sed -i '/v4a_fx {/,/}/d' $VENDOR_CONFIG

 # Remove library & effect
 sed -i '/v4a_standard_fx {/,/}/d' $VENDOR_CONFIG

 # Remove library & effect
 sed -i '/dap {/,/}/d' $VENDOR_CONFIG

 # Remove library & effect
 sed -i '/SRS {/,/}/d' $VENDOR_CONFIG

 # Remove library & effect
 sed -i '/dynamic_bass_boost {/,/}/d' $VENDOR_CONFIG

 # Remove library & effect
 sed -i '/srsgeq5 {/,/}/d' $VENDOR_CONFIG

 # Remove library & effect
 sed -i '/bassenhance {/,/}/d' $VENDOR_CONFIG

 # Remove library & effect
 sed -i '/wowhd {/,/}/d' $VENDOR_CONFIG
  fi

 # Remove library & effect
 sed -i '/sonyeffect {/,/}/d' $CONFIG_FILE

 # Remove library & effect
 sed -i '/VPT51 {/,/}/d' $CONFIG_FILE

 # Remove library & effect
 sed -i '/sonyeffect_sw {/,/}/d' $CONFIG_FILE

 # Remove library & effect
 sed -i '/proxy {/,/}/d' $CONFIG_FILE

 # Remove library & effect
 sed -i '/vpt51 {/,/}/d' $CONFIG_FILE

 # Remove library & effect
 sed -i '/sonyeffect_hw {/,/}/d' $CONFIG_FILE
 
 # Remove library & effect
 sed -i '/srstb {/,/}/d' $CONFIG_FILE

 # Remove library & effect
 sed -i '/bass_enhancement {/,/}/d' $CONFIG_FILE

 # Remove library & effect
 sed -i '/beatscore {/,/}/d' $CONFIG_FILE

 # Remove library & effect
 sed -i '/srscore {/,/}/d' $CONFIG_FILE

 # Remove library & effect
 sed -i '/v4a_fx {/,/}/d' $CONFIG_FILE

 # Remove library & effect
 sed -i '/v4a_standard_fx {/,/}/d' $CONFIG_FILE

 # Remove library & effect
 sed -i '/dap {/,/}/d' $CONFIG_FILE

 # Remove library & effect
 sed -i '/SRS {/,/}/d' $CONFIG_FILE

 # Remove library & effect
 sed -i '/dynamic_bass_boost {/,/}/d' $CONFIG_FILE

 # Remove library & effect
 sed -i '/srsgeq5 {/,/}/d' $CONFIG_FILE

 # Remove library & effect
 sed -i '/bassenhance {/,/}/d' $CONFIG_FILE

 # Remove library & effect
 sed -i '/wowhd {/,/}/d' $CONFIG_FILE

# Normal/vendor config locations
CONFIG_FILE=/system/etc/audio_effects.conf
VENDOR_CONFIG=/system/vendor/etc/audio_effects.conf
# If vendor exists, patch it
if [ -f $VENDOR_CONFIG ];
then
 # Add library
 sed -i 's/^libraries {/libraries {\n  proxy {\n    path \/system\/lib\/soundfx\/libeffectproxy.so\n  }/g' $VENDOR_CONFIG

 # Add library
 sed -i 's/^libraries {/libraries {\n  sonyeffect_hw {\n    path \/system\/lib\/soundfx\/libsonypostprocbundle.so\n  }/g' $VENDOR_CONFIG

 # Add library
 sed -i 's/^libraries {/libraries {\n  vpt51 {\n    path \/system\/lib\/soundfx\/libvpt51wrapper.so\n  }/g' $VENDOR_CONFIG

 # Add library
 sed -i 's/^libraries {/libraries {\n  sonyeffect_sw {\n    path \/system\/lib\/soundfx\/libsonysweffect.so\n  }/g' $VENDOR_CONFIG

 # Add library
 sed -i 's/^libraries {/libraries {\n  srstb {\n    path \/system\/lib\/soundfx\/libsrstb.so\n  }/g' $VENDOR_CONFIG

 # Add library
 sed -i 's/^libraries {/libraries {\n  bass_enhancement {\n    path \/system\/lib\/soundfx\/libbeats.so\n  }/g' $VENDOR_CONFIG

 # Add library
 sed -i 's/^libraries {/libraries {\n  beatscore {\n    path \/system\/lib\/soundfx\/libbeatscorehtc.so\n  }/g' $VENDOR_CONFIG

 # Add library
 sed -i 's/^libraries {/libraries {\n  srscore {\n    path \/system\/lib\/soundfx\/libsrscorehtc.so\n  }/g' $VENDOR_CONFIG

 # Add library
 sed -i 's/^libraries {/libraries {\n  SRS {\n    path \/system\/lib\/soundfx\/libsrsfx.so\n  }/g' $VENDOR_CONFIG

 # Add library
 sed -i 's/^libraries {/libraries {\n  dap {\n    path \/system\/lib\/soundfx\/libswdap-mod.so\n  }/g' $VENDOR_CONFIG
 
 # Add effect
	sed -i 's/^effects {/effects {\n  VPT51 {\n    library vpt51\n    uuid 447bdc20-198c-11e2-892e-0800200c9a66\n  }/g' $VENDOR_CONFIG

 # Add effect
	sed -i 's/^effects {/effects {\n    libhw {\n      library sonyeffect_hw\n      uuid f9ed8ae0-1b9c-11e4-8900-0002a5d5c51b\n    }\n  }/g' $VENDOR_CONFIG

 # Add effect
	sed -i 's/^effects {/effects {\n    libsw {\n      library sonyeffect_sw\n      uuid 50786e95-da76-4557-976b-7981bdf6feb9\n    }/g' $VENDOR_CONFIG

 # Add effect
	sed -i 's/^effects {/effects {\n  sonyeffect {\n    library proxy\n    uuid 00905020-4e52-11e4-83aa-0002a5d5c51b\n/g' $VENDOR_CONFIG
	
	# Add effect
	sed -i 's/^effects {/effects {\n  dap {\n    library dap\n    uuid 9d4921da-8225-4f29-aefa-39537a041337\n  }/g' $VENDOR_CONFIG

	# Add effect
	sed -i 's/^effects {/effects {\n  dynamic_bass_boost {\n    library SRS\n    uuid f7a247b0-1a7b-11e0-bb0d-2a30dfd72085\n  }/g' $VENDOR_CONFIG

 # Add effect
 sed -i 's/^effects {/effects {\n  srsgeq5 {\n    library SRS\n    uuid f7a247b0-1a7b-11e0-bb0d-2a30dfd72085\n  }/g' $VENDOR_CONFIG

 # Add effect
 sed -i 's/^effects {/effects {\n  wowhd {\n    library SRS\n    uuid f7a247b0-1a7b-11e0-bb0d-2a30dfd72085\n  }/g' $VENDOR_CONFIG

 # Add effect
	sed -i 's/^effects {/effects {\n  bassenhance {\n    library bass_enhancement\n    uuid b3b43f60-a2f0-11e0-8b5a-0002a5d5c51b\n  }/g' $VENDOR_CONFIG

 # Add libary
	sed -i 's/^libraries {/libraries {\n  v4a_fx {\n    path \/system\/lib\/soundfx\/libv4a_fx_ics.so\n  }/g' $VENDOR_CONFIG
	
	# Add effect
	sed -i 's/^effects {/effects {\n  v4a_standard_fx {\n    library v4a_fx\n    uuid 41d3c987-e6cf-11e3-a88a-11aba5d5c51b\n  }/g' $VENDOR_CONFIG
 fi

 # Add library
 sed -i 's/^libraries {/libraries {\n  proxy {\n    path \/system\/lib\/soundfx\/libeffectproxy.so\n  }/g' $CONFIG_FILE

 # Add library
 sed -i 's/^libraries {/libraries {\n  sonyeffect_hw {\n    path \/system\/lib\/soundfx\/libsonypostprocbundle.so\n  }/g' $CONFIG_FILE

 # Add library
 sed -i 's/^libraries {/libraries {\n  vpt51 {\n    path \/system\/lib\/soundfx\/libvpt51wrapper.so\n  }/g' $CONFIG_FILE

 # Add library
 sed -i 's/^libraries {/libraries {\n  sonyeffect_sw {\n    path \/system\/lib\/soundfx\/libsonysweffect.so\n  }/g' $CONFIG_FILE

 # Add library
 sed -i 's/^libraries {/libraries {\n  srstb {\n    path \/system\/lib\/soundfx\/libsrstb.so\n  }/g' $CONFIG_FILE

 # Add library
 sed -i 's/^libraries {/libraries {\n  bass_enhancement {\n    path \/system\/lib\/soundfx\/libbeats.so\n  }/g' $CONFIG_FILE

 # Add library
 sed -i 's/^libraries {/libraries {\n  beatscore {\n    path \/system\/lib\/soundfx\/libbeatscorehtc.so\n  }/g' $CONFIG_FILE

 # Add library
 sed -i 's/^libraries {/libraries {\n  srscore {\n    path \/system\/lib\/soundfx\/libsrscorehtc.so\n  }/g' $CONFIG_FILE

 #Add library
 sed -i 's/^libraries {/libraries {\n  SRS {\n    path \/system\/lib\/soundfx\/libsrsfx.so\n  }/g' $CONFIG_FILE
 
 # Add effect
	sed -i 's/^effects {/effects {\n  VPT51 {\n    library vpt51\n    uuid 447bdc20-198c-11e2-892e-0800200c9a66\n  }/g' $CONFIG_FILE

 # Add effect
	sed -i 's/^effects {/effects {\n    libhw {\n      library sonyeffect_hw\n      uuid f9ed8ae0-1b9c-11e4-8900-0002a5d5c51b\n    }\n  }/g' $CONFIG_FILE

 # Add effect
	sed -i 's/^effects {/effects {\n    libsw {\n      library sonyeffect_sw\n      uuid 50786e95-da76-4557-976b-7981bdf6feb9\n    }/g' $CONFIG_FILE

 # Add effect
	sed -i 's/^effects {/effects {\n  sonyeffect {\n    library proxy\n    uuid 00905020-4e52-11e4-83aa-0002a5d5c51b\n/g' $CONFIG_FILE

 # Add effect
	sed -i 's/^effects {/effects {\n  bassenhance {\n    library bass_enhancement\n    uuid b3b43f60-a2f0-11e0-8b5a-0002a5d5c51b\n  }/g' $CONFIG_FILE

 # Add effect
 sed -i 's/^effects {/effects {\n  dynamic_bass_boost {\n    library SRS\n    uuid f7a247b0-1a7b-11e0-bb0d-2a30dfd72085\n  }/g' $CONFIG_FILE

 # Add effect
 sed -i 's/^effects {/effects {\n  srsgeq5 {\n    library SRS\n    uuid f7a247b0-1a7b-11e0-bb0d-2a30dfd72085\n  }/g' $CONFIG_FILE

 # Add effect
 sed -i 's/^effects {/effects {\n  wowhd {\n    library SRS\n    uuid f7a247b0-1a7b-11e0-bb0d-2a30dfd72085\n  }/g' $CONFIG_FILE

 # Add libary
 sed -i 's/^libraries {/libraries {\n  dap {\n    path \/system\/lib\/soundfx\/libswdap-mod.so\n  }/g' $CONFIG_FILE

 # Add effect
 sed -i 's/^effects {/effects {\n  dap {\n    library dap\n    uuid 9d4921da-8225-4f29-aefa-39537a041337\n  }/g' $CONFIG_FILE

 # Add libary
 sed -i 's/^libraries {/libraries {\n  v4a_fx {\n    path \/system\/lib\/soundfx\/libv4a_fx_ics.so\n  }/g' $CONFIG_FILE

 # Add effect
 sed -i 's/^effects {/effects {\n  v4a_standard_fx {\n    library v4a_fx\n    uuid 41d3c987-e6cf-11e3-a88a-11aba5d5c51b\n  }/g' $CONFIG_FILE

# Normal/vendor config locations
CONFIG_FILE=/system/etc/htc_audio_effects.conf
VENDOR_CONFIG=/vendor/etc/audio_effects.conf
# If vendor exists, patch it
if [ -f $VENDOR_CONFIG ];
then
 # Remove library & effect
 sed -i '/sonyeffect {/,/}/d' $VENDOR_CONFIG

 # Remove library & effect
 sed -i '/VPT51 {/,/}/d' $VENDOR_CONFIG

 # Remove library & effect
 sed -i '/sonyeffect_sw {/,/}/d' $VENDOR_CONFIG

 # Remove library & effect
 sed -i '/proxy {/,/}/d' $VENDOR_CONFIG

 # Remove library & effect
 sed -i '/vpt51 {/,/}/d' $VENDOR_CONFIG

 # Remove library & effect
 sed -i '/sonyeffect_hw {/,/}/d' $VENDOR_CONFIG

 # Remove library & effect
 sed -i '/srstb {/,/}/d' $VENDOR_CONFIG

 # Remove library & effect
 sed -i '/bass_enhancement {/,/}/d' $VENDOR_CONFIG

 # Remove library & effect
 sed -i '/beatscore {/,/}/d' $VENDOR_CONFIG

 # Remove library & effect
 sed -i '/srscore {/,/}/d' $VENDOR_CONFIG

 # Remove library & effect
 sed -i '/v4a_fx {/,/}/d' $VENDOR_CONFIG

 # Remove library & effect
 sed -i '/v4a_standard_fx {/,/}/d' $VENDOR_CONFIG

 # Remove library & effect
 sed -i '/dap {/,/}/d' $VENDOR_CONFIG

 # Remove library & effect
 sed -i '/SRS {/,/}/d' $VENDOR_CONFIG

 # Remove library & effect
 sed -i '/dynamic_bass_boost {/,/}/d' $VENDOR_CONFIG

 # Remove library & effect
 sed -i '/srsgeq5 {/,/}/d' $VENDOR_CONFIG

 # Remove library & effect
 sed -i '/bassenhance {/,/}/d' $VENDOR_CONFIG

 # Remove library & effect
 sed -i '/wowhd {/,/}/d' $VENDOR_CONFIG
  fi

 # Remove library & effect
 sed -i '/sonyeffect {/,/}/d' $CONFIG_FILE

 # Remove library & effect
 sed -i '/VPT51 {/,/}/d' $CONFIG_FILE

 # Remove library & effect
 sed -i '/sonyeffect_sw {/,/}/d' $CONFIG_FILE

 # Remove library & effect
 sed -i '/proxy {/,/}/d' $CONFIG_FILE

 # Remove library & effect
 sed -i '/vpt51 {/,/}/d' $CONFIG_FILE

 # Remove library & effect
 sed -i '/sonyeffect_hw {/,/}/d' $CONFIG_FILE

 # Remove library & effect
 sed -i '/srstb {/,/}/d' $CONFIG_FILE

 # Remove library & effect
 sed -i '/bass_enhancement {/,/}/d' $CONFIG_FILE

 # Remove library & effect
 sed -i '/beatscore {/,/}/d' $CONFIG_FILE

 # Remove library & effect
 sed -i '/srscore {/,/}/d' $CONFIG_FILE

 # Remove library & effect
 sed -i '/v4a_fx {/,/}/d' $CONFIG_FILE

 # Remove library & effect
 sed -i '/v4a_standard_fx {/,/}/d' $CONFIG_FILE

 # Remove library & effect
 sed -i '/dap {/,/}/d' $CONFIG_FILE

 # Remove library & effect
 sed -i '/SRS {/,/}/d' $CONFIG_FILE

 # Remove library & effect
 sed -i '/dynamic_bass_boost {/,/}/d' $CONFIG_FILE

 # Remove library & effect
 sed -i '/srsgeq5 {/,/}/d' $CONFIG_FILE

 # Remove library & effect
 sed -i '/wowhd {/,/}/d' $CONFIG_FILE

 # Remove library & effect
 sed -i '/bassenhance {/,/}/d' $CONFIG_FILE

# Normal/vendor config locations
CONFIG_FILE=/system/etc/htc_audio_effects.conf
VENDOR_CONFIG=/vendor/etc/audio_effects.conf
# If vendor exists, patch it
if [ -f $VENDOR_CONFIG ];
then
 # Add library
 sed -i 's/^libraries {/libraries {\n  proxy {\n    path \/system\/lib\/soundfx\/libeffectproxy.so\n  }/g' $VENDOR_CONFIG

 # Add library
 sed -i 's/^libraries {/libraries {\n  sonyeffect_hw {\n    path \/system\/lib\/soundfx\/libsonypostprocbundle.so\n  }/g' $VENDOR_CONFIG

 # Add library
 sed -i 's/^libraries {/libraries {\n  vpt51 {\n    path \/system\/lib\/soundfx\/libvpt51wrapper.so\n  }/g' $VENDOR_CONFIG

 # Add library
 sed -i 's/^libraries {/libraries {\n  sonyeffect_sw {\n    path \/system\/lib\/soundfx\/libsonysweffect.so\n  }/g' $VENDOR_CONFIG

 # Add library
 sed -i 's/^libraries {/libraries {\n  srstb {\n    path \/system\/lib\/soundfx\/libsrstb.so\n  }/g' $VENDOR_CONFIG

 # Add library
 sed -i 's/^libraries {/libraries {\n  bass_enhancement {\n    path \/system\/lib\/soundfx\/libbeats.so\n  }/g' $VENDOR_CONFIG

 # Add library
 sed -i 's/^libraries {/libraries {\n  beatscore {\n    path \/system\/lib\/soundfx\/libbeatscorehtc.so\n  }/g' $VENDOR_CONFIG

 # Add library
 sed -i 's/^libraries {/libraries {\n  srscore {\n    path \/system\/lib\/soundfx\/libsrscorehtc.so\n  }/g' $VENDOR_CONFIG

 # Add library
 sed -i 's/^libraries {/libraries {\n  SRS {\n    path \/system\/lib\/soundfx\/libsrsfx.so\n  }/g' $VENDOR_CONFIG

 # Add library
 sed -i 's/^libraries {/libraries {\n  dap {\n    path \/system\/lib\/soundfx\/libswdap-mod.so\n  }/g' $VENDOR_CONFIG

 # Add effect
	sed -i 's/^effects {/effects {\n  VPT51 {\n    library vpt51\n    uuid 447bdc20-198c-11e2-892e-0800200c9a66\n  }/g' $VENDOR_CONFIG

 # Add effect
	sed -i 's/^effects {/effects {\n    libhw {\n      library sonyeffect_hw\n      uuid f9ed8ae0-1b9c-11e4-8900-0002a5d5c51b\n    }\n  }/g' $VENDOR_CONFIG

 # Add effect
	sed -i 's/^effects {/effects {\n    libsw {\n      library sonyeffect_sw\n      uuid 50786e95-da76-4557-976b-7981bdf6feb9\n    }/g' $VENDOR_CONFIG

 # Add effect
	sed -i 's/^effects {/effects {\n  sonyeffect {\n    library proxy\n    uuid 00905020-4e52-11e4-83aa-0002a5d5c51b\n/g' $VENDOR_CONFIG
	
	# Add effect
	sed -i 's/^effects {/effects {\n  dap {\n    library dap\n    uuid 9d4921da-8225-4f29-aefa-39537a041337\n  }/g' $VENDOR_CONFIG

	# Add effect
	sed -i 's/^effects {/effects {\n  dynamic_bass_boost {\n    library SRS\n    uuid f7a247b0-1a7b-11e0-bb0d-2a30dfd72085\n  }/g' $VENDOR_CONFIG

 # Add effect
 sed -i 's/^effects {/effects {\n  srsgeq5 {\n    library SRS\n    uuid f7a247b0-1a7b-11e0-bb0d-2a30dfd72085\n  }/g' $VENDOR_CONFIG

 # Add effect
 sed -i 's/^effects {/effects {\n  wowhd {\n    library SRS\n    uuid f7a247b0-1a7b-11e0-bb0d-2a30dfd72085\n  }/g' $VENDOR_CONFIG

 # Add effect
	sed -i 's/^effects {/effects {\n  bassenhance {\n    library bass_enhancement\n    uuid b3b43f60-a2f0-11e0-8b5a-0002a5d5c51b\n  }/g' $VENDOR_CONFIG

 # Add libary
	sed -i 's/^libraries {/libraries {\n  v4a_fx {\n    path \/system\/lib\/soundfx\/libv4a_fx_ics.so\n  }/g' $VENDOR_CONFIG
	
	# Add effect
	sed -i 's/^effects {/effects {\n  v4a_standard_fx {\n    library v4a_fx\n    uuid 41d3c987-e6cf-11e3-a88a-11aba5d5c51b\n  }/g' $VENDOR_CONFIG
 fi

 # Add library
 sed -i 's/^libraries {/libraries {\n  proxy {\n    path \/system\/lib\/soundfx\/libeffectproxy.so\n  }/g' $CONFIG_FILE

 # Add library
 sed -i 's/^libraries {/libraries {\n  sonyeffect_hw {\n    path \/system\/lib\/soundfx\/libsonypostprocbundle.so\n  }/g' $CONFIG_FILE

# Add library
 sed -i 's/^libraries {/libraries {\n  vpt51 {\n    path \/system\/lib\/soundfx\/libvpt51wrapper.so\n  }/g' $CONFIG_FILE

 # Add library
 sed -i 's/^libraries {/libraries {\n  sonyeffect_sw {\n    path \/system\/lib\/soundfx\/libsonysweffect.so\n  }/g' $CONFIG_FILE

 # Add library
 sed -i 's/^libraries {/libraries {\n  srstb {\n    path \/system\/lib\/soundfx\/libsrstb.so\n  }/g' $CONFIG_FILE

 # Add library
 sed -i 's/^libraries {/libraries {\n  bass_enhancement {\n    path \/system\/lib\/soundfx\/libbeats.so\n  }/g' $CONFIG_FILE

 # Add library
 sed -i 's/^libraries {/libraries {\n  beatscore {\n    path \/system\/lib\/soundfx\/libbeatscorehtc.so\n  }/g' $CONFIG_FILE

 # Add effect
	sed -i 's/^effects {/effects {\n  VPT51 {\n    library vpt51\n    uuid 447bdc20-198c-11e2-892e-0800200c9a66\n  }/g' $CONFIG_FILE

 # Add effect
	sed -i 's/^effects {/effects {\n    libhw {\n      library sonyeffect_hw\n      uuid f9ed8ae0-1b9c-11e4-8900-0002a5d5c51b\n    }\n  }/g' $CONFIG_FILE

 # Add effect
	sed -i 's/^effects {/effects {\n    libsw {\n      library sonyeffect_sw\n      uuid 50786e95-da76-4557-976b-7981bdf6feb9\n    }/g' $CONFIG_FILE

 # Add effect
	sed -i 's/^effects {/effects {\n  sonyeffect {\n    library proxy\n    uuid 00905020-4e52-11e4-83aa-0002a5d5c51b\n/g' $CONFIG_FILE

 # Add effect
	sed -i 's/^effects {/effects {\n  bassenhance {\n    library bass_enhancement\n    uuid b3b43f60-a2f0-11e0-8b5a-0002a5d5c51b\n  }/g' $CONFIG_FILE

 # Add library
 sed -i 's/^libraries {/libraries {\n  srscore {\n    path \/system\/lib\/soundfx\/libsrscorehtc.so\n  }/g' $CONFIG_FILE

 # Add library
 sed -i 's/^libraries {/libraries {\n  SRS {\n    path \/system\/lib\/soundfx\/libsrsfx.so\n  }/g' $CONFIG_FILE

 # Add library
 sed -i 's/^libraries {/libraries {\n  dap {\n    path \/system\/lib\/soundfx\/libswdap-mod.so\n  }/g' $CONFIG_FILE
	
	# Add effect
	sed -i 's/^effects {/effects {\n  dap {\n    library dap\n    uuid 9d4921da-8225-4f29-aefa-39537a041337\n  }/g' $CONFIG_FILE

	# Add effect
	sed -i 's/^effects {/effects {\n  dynamic_bass_boost {\n    library SRS\n    uuid f7a247b0-1a7b-11e0-bb0d-2a30dfd72085\n  }/g' $CONFIG_FILE

 # Add effect
 sed -i 's/^effects {/effects {\n  srsgeq5 {\n    library SRS\n    uuid f7a247b0-1a7b-11e0-bb0d-2a30dfd72085\n  }/g' $CONFIG_FILE

 # Add effect
 sed -i 's/^effects {/effects {\n  wowhd {\n    library SRS\n    uuid f7a247b0-1a7b-11e0-bb0d-2a30dfd72085\n  }/g' $CONFIG_FILE

 # Add libary
	sed -i 's/^libraries {/libraries {\n  v4a_fx {\n    path \/system\/lib\/soundfx\/libv4a_fx_ics.so\n  }/g' $CONFIG_FILE
	
	# Add effect
	sed -i 's/^effects {/effects {\n  v4a_standard_fx {\n    library v4a_fx\n    uuid 41d3c987-e6cf-11e3-a88a-11aba5d5c51b\n  }/g' $CONFIG_FILE
 fi
  ;;
esac
