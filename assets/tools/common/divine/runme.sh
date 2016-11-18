#!/sbin/sh

if [ "`grep divine.beats.activated=true /system/build.prop`" ]; 
then
   :
else
busybox echo "" >> /system/build.prop
busybox echo "#=====================================" >> /system/build.prop
busybox echo "" >> /system/build.prop
busybox echo "# DivineBeats by TheRoyalSeeker" >> /system/build.prop
busybox echo "" >> /system/build.prop
busybox echo "#=====================================" >> /system/build.prop
busybox echo "divine.beats.activated=true" >> /system/build.prop
busybox echo "audio.offload.buffer.size.kb=64" >> /system/build.prop
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
fi

