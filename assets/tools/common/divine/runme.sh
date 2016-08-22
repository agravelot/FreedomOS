#!/sbin/sh

busybox echo "" >> /system/build.prop
busybox echo "#=====================================" >> /system/build.prop
busybox echo "" >> /system/build.prop
busybox echo "# DivineBeats by TheRoyalSeeker" >> /system/build.prop
busybox echo "" >> /system/build.prop
busybox echo "#=====================================" >> /system/build.prop
busybox echo "audio.offload.buffer.size.kb=128" >> /system/build.prop
busybox echo "audio.offload.pcm.24bit.enable=true" >> /system/build.prop
busybox echo "audio.offload.pcm.32bit.enable=true" >> /system/build.prop
busybox echo "audio.offload.pcm.64bit.enable=true" >> /system/build.prop
busybox echo "htc.audio.swalt.enable=1" >> /system/build.prop
busybox echo "htc.audio.swalt.mingain=14512" >> /system/build.prop
busybox echo "htc.audio.alc.enable=1" >> /system/build.prop
busybox echo "persist.audio.SupportHTCHWAEC=1" >> /system/build.prop
busybox echo "af.resampler.quality=255" >> /system/build.prop
busybox echo "persist.af.resampler.quality=255" >> /system/build.prop
busybox echo "af.resample=52000" >> /system/build.prop
busybox echo "persist.af.resample=52000" >> /system/build.prop
busybox echo "ro.audio.samplerate=6144000" >> /system/build.prop
busybox echo "persist.dev.pm.dyn_samplingrate=1" >> /system/build.prop
busybox echo "ro.audio.pcm.samplerate=6144000" >> /system/build.prop
busybox echo "AUDIODRIVER=alsa" >> /system/build.prop
busybox echo "ro.sound.driver=alsa" >> /system/build.prop
busybox echo "default.pcm.rate_converter=samplerate_best" >> /system/build.prop
busybox echo "ro.sound.alsa=snd_pcm" >> /system/build.prop
busybox echo "alsa.mixer.playback.master=Speaker" >> /system/build.prop
busybox echo "alsa.mixer.capture.master=Mic" >> /system/build.prop
busybox echo "alsa.mixer.playback.earpiece=Earpiece" >> /system/build.prop
busybox echo "alsa.mixer.capture.earpiece=Mic" >> /system/build.prop
busybox echo "alsa.mixer.playback.headset=Headset" >> /system/build.prop
busybox echo "alsa.mixer.capture.headset=Mic" >> /system/build.prop
busybox echo "alsa.mixer.playback.speaker=Speaker" >> /system/build.prop
busybox echo "alsa.mixer.capture.speaker=Mic" >> /system/build.prop
busybox echo "alsa.mixer.playback.bt.sco=BTHeadset" >> /system/build.prop
busybox echo "alsa.mixer.capture.bt.sco=BTHeadset" >> /system/build.prop
busybox echo "htc.audio.lpa.a2dp=0" >> /system/build.prop
busybox echo "htc.audio.global.state=0" >> /system/build.prop
busybox echo "htc.audio.global.profile=0" >> /system/build.prop
busybox echo "htc.audio.q6.topology=0" >> /system/build.prop
busybox echo "htc.audio.enable_dmic=1" >> /system/build.prop
busybox echo "persist.htc.audio.pcm.samplerate=192000" >> /system/build.prop
busybox echo "persist.htc.audio.pcm.channels=2" >> /system/build.prop
busybox echo "persist.audio.fluence.mode=endfire" >> /system/build.prop
busybox echo "persist.audio.vr.enable=false" >> /system/build.prop
busybox echo "#Change under line to 'digital' if you have 2 mic" >> /system/build.prop
busybox echo "persist.audio.handset.mic=analog" >> /system/build.prop
busybox echo "htc.audio.swalt.enable=1" >> /system/build.prop
busybox echo "htc.audio.swalt.mingain=14512" >> /system/build.prop
busybox echo "htc.audio.alc.enable=1" >> /system/build.prop
busybox echo "ro.ril.enable.amr.wideband=1" >> /system/build.prop
busybox echo "ro.config.hw_dolby=true" >> /system/build.prop
busybox echo "ro.config.hw_dts=true" >> /system/build.prop
busybox echo "# Sony Audio & Resampling" >> /system/build.prop
busybox echo "mpq.audio.decode=true" >> /system/build.prop
busybox echo "sony.support.effect=0x1FF" >> /system/build.prop
busybox echo "ro.semc.sound_effects_enabled=true" >> /system/build.prop
busybox echo "ro.semc.xloud.supported=true" >> /system/build.prop
busybox echo "persist.service.xloud.enable=1" >> /system/build.prop
busybox echo "ro.semc.enhance.supported=true" >> /system/build.prop
busybox echo "persist.service.enhance.enable=1" >> /system/build.prop
busybox echo "ro.semc.clearaudio.supported=true" >> /system/build.prop
busybox echo "persist.service.clearaudio.enable=1" >> /system/build.prop
busybox echo "ro.sony.walkman.logger=1" >> /system/build.prop
busybox echo "persist.service.walkman.enable=1" >> /system/build.prop
busybox echo "ro.semc.clearphase.supported=true" >> /system/build.prop
busybox echo "persist.service.clearphase.enable=1" >> /system/build.prop
busybox echo "persist.service.enhance.enable=1" >> /system/build.prop
busybox echo "ro.somc.sforce.supported=true" >> /system/build.prop
busybox echo "persist.service.sforce.enable=1" >> /system/build.prop
busybox echo "persist.service.dseehx.enable=1" >> /system/build.prop
busybox echo "com.sonymobile.dseehx_enabled=true" >> /system/build.prop
busybox echo "com.sonyericsson.xloud_enabled=true" >> /system/build.prop
busybox echo "ro.semc.xloud.default_setting=true" >> /system/build.prop
busybox echo "com.sonymobile.clearphase_enabled=true" >> /system/build.prop
busybox echo "ro.semc.cp.default_setting=true" >> /system/build.prop
busybox echo "com.sonymobile.sforce_enabled=true" >> /system/build.prop
busybox echo "ro.semc.sfs.default_setting=true" >> /system/build.prop
busybox echo "audio.offload.multiple.enabled=true" >> /system/build.prop
busybox echo "audio.offload.gapless.enabled=true" >> /system/build.prop
busybox echo "audio.offload.passthrough=false" >> /system/build.prop
busybox echo "ro.somc.ldac.audio.supported=true" >> /system/build.prop
busybox echo "persist.service.ldac.enable=1" >> /system/build.prop
busybox echo "com.sonymobile.ldac_enabled=true" >> /system/build.prop
busybox echo "sony.ahc.supported=yes" >> /system/build.prop





busybox echo "# MAXXAUDIO" >> /system/build.prop
busybox echo "audiofx.global.enable=1" >> /system/build.prop
busybox echo "audiofx.global.dts.enable=1" >> /system/build.prop
busybox echo "audiofx.eq.preset=10" >> /system/build.prop
busybox echo "audiofx.bass.enable=1" >> /system/build.prop
busybox echo "audiofx.bass.strength=90" >> /system/build.prop
busybox echo "audiofx.treble.enable=1" >> /system/build.prop
busybox echo "audiofx.treble.strength=90" >> /system/build.prop
busybox echo "audiofx.virtualizer.enable=1" >> /system/build.prop
busybox echo "audiofx.virtualizer.strength=60" >> /system/build.prop
busybox echo "audiofx.maxxvolume.enable=1" >> /system/build.prop

busybox echo "# SONY EFFECT" >> /system/build.prop
busybox echo "C_A_PLUS=1" >> /system/build.prop
busybox echo "SPEAKER_BUNDLE=1" >> /system/build.prop
busybox echo "sony.effect.custom.caplus_hs=0x2DE" >> /system/build.prop
busybox echo "sony.effect.custom.caplus_sp=0x2FA" >> /system/build.prop
busybox echo "sony.effect.custom.sp_bundle=0x162" >> /system/build.prop
busybox echo "dsee_hx_state=1" >> /system/build.prop
busybox echo "DSEE_HX=1" >> /system/build.prop

busybox echo "# Harman Kardon" >> /system/build.prop
busybox echo "support_harman=true" >> /system/build.prop
busybox echo "support_boomsound_effect=true" >> /system/build.prop
busybox echo "#=====================================" >> /system/build.prop

# Add effect
sed -i 's/^effects {/effects {\n  srsgeq5 {\n    library SRS\n     uuid f7a247c2-1a7b-11e0-bb0d-2a30dfd72085\n  }/g' $CONFIG_FILE

# Add effect
sed -i 's/^effects {/effects {\n  wowhd {\n    library SRS\n    uuid f7a247d2-1a7b-11e0-bb0d-2a30dfd72085\n  }/g' $CONFIG_FILE

if [ -f $VENDOR_CONFIG ]; then
    #clean
    sed -i '/SRS {/,/}/d' $CONFIG_FILE
    sed -i '/dynamic_bass_boost {/,/}/d' $CONFIG_FILE
    sed -i '/srsrgeq5 {/,/}/d' $CONFIG_FILE
    sed -i '/wowhd {/,/}/d' $CONFIG_FILE
    # Add libary
    sed -i 's/^libraries {/libraries {\n  SRS {\n    path \/system\/lib\/soundfx\/libsrsfx.so\n  }/g' $CONFIG_FILE
    # Add effect
    sed -i 's/^effects {/effects {\n  dynamic_bass_boost {\n    library SRS\n    uuid f7a247b0-1a7b-11e0-bb0d-2a30dfd72085\n  }/g' $CONFIG_FILE
    # Add effect
    sed -i 's/^effects {/effects {\n  srsgeq5 {\n    library SRS\n     uuid f7a247c2-1a7b-11e0-bb0d-2a30dfd72085\n  }/g' $CONFIG_FILE
    # Add effect
    sed -i 's/^effects {/effects {\n  wowhd {\n    library SRS\n    uuid f7a247d2-1a7b-11e0-bb0d-2a30dfd72085\n  }/g' $CONFIG_FILE	
fi

if [ -e /system/customize/ACC/default.xml ]; then
    busybox echo "<item type="boolean" name="support_beats_audio">true</item>" > /system/customize/ACC/default.xml
else
    busybox cp -r /extras/customize /system
fi

if [ "`grep ro.product.brand=htc /system/build.prop`" ];
then
    :
else
    busybox cp -f /extras/AudioBTID.csv /system/etc
	busybox cp -f /extras/AudioBTIDnew.csv /system/etc
fi


#!/sbin/sh
OUTFD=$2
ZIP=$3

SYSTEMLIB=/system/lib

ui_print() {
  echo -n -e "ui_print $1\n" > /proc/self/fd/$OUTFD
  echo -n -e "ui_print\n" > /proc/self/fd/$OUTFD
}

ch_con() {
  LD_LIBRARY_PATH=$SYSTEMLIB /system/toolbox chcon -h u:object_r:system_file:s0 $1
  LD_LIBRARY_PATH=$SYSTEMLIB /system/bin/toolbox chcon -h u:object_r:system_file:s0 $1
  chcon -h u:object_r:system_file:s0 $1
  LD_LIBRARY_PATH=$SYSTEMLIB /system/toolbox chcon u:object_r:system_file:s0 $1
  LD_LIBRARY_PATH=$SYSTEMLIB /system/bin/toolbox chcon u:object_r:system_file:s0 $1
  chcon u:object_r:system_file:s0 $1
}

ch_con_ext() {
  LD_LIBRARY_PATH=$SYSTEMLIB /system/toolbox chcon $2 $1
  LD_LIBRARY_PATH=$SYSTEMLIB /system/bin/toolbox chcon $2 $1
  chcon $2 $1
}

ln_con() {
  LD_LIBRARY_PATH=$SYSTEMLIB /system/toolbox ln -s $1 $2
  LD_LIBRARY_PATH=$SYSTEMLIB /system/bin/toolbox ln -s $1 $2
  ln -s $1 $2
  ch_con $2
}

set_perm() {
  chown $1.$2 $4
  chown $1:$2 $4
  chmod $3 $4
  ch_con $4
  ch_con_ext $4 $5
}

cp_perm() {
  rm $5
  if [ -f "$4" ]; then
    cat $4 > $5
    set_perm $1 $2 $3 $5 $6
  fi
}

cat /system/bin/toolbox > /system/toolbox
chmod 0755 /system/toolbox
ch_con /system/toolbox

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

#!/sbin/sh

sed -i '/deep_buffer {/,/}/d' /system/etc/audio_policy.conf

