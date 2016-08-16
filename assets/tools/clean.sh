#!/sbin/sh
#
# Author : Nevax
#
echo "DEBUG: Remove conflits data app"
rm -R /data/app/com.android.chrome-*
rm -R /data/app/com.google.android.apps.docs-*
rm -R /data/app/com.google.android.apps.maps-*
rm -R /data/app/com.google.android.apps.messaging-*
rm -R /data/app/com.google.android.apps.photos-*
rm -R /data/app/com.google.android.calendar-*
rm -R /data/app/com.google.android.gm-*
rm -R /data/app/com.google.android.googlequicksearchbox-*
rm -R /data/app/com.google.android.music-*
rm -R /data/app/com.google.android.talk-*
rm -R /data/app/com.google.android.youtube-*
rm -R /data/app/com.touchtype.swiftkey-*
rm -R /data/app/de.robv.android.xposed.installer-*

echo "DEBUG: Set sdcard perm"
#chown -R sdcard_rw:sdcard_rw /sdcard/
chown -R media_rw:media_rw /data/media

echo "DEBUG: Remove Password"
rm /data/system/gatekeeper*
rm /data/system/locksettings*
