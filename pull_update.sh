#!/bin/bash
APP=com.google.android.apps.photos-1
adb pull -p /data/app/$APP data/app/$APP

APP=com.google.android.apps.maps-1
adb pull -p /data/app/$APP data/app/$APP

APP=com.google.android.calendar-1
adb pull -p /data/app/$APP data/app/$APP

APP=com.google.android.apps.messaging-1
adb pull -p /data/app/$APP data/app/$APP

APP=com.google.android.youtube-1
adb pull -p /data/app/$APP data/app/$APP

APP=com.google.android.music-1
adb pull -p /data/app/$APP data/app/$APP

APP=com.google.android.talk-1
adb pull -p /data/app/$APP data/app/$APP

APP=com.android.chrome-1
adb pull -p /data/app/$APP data/app/$APP

APP=com.touchtype.swiftkey-1
adb pull -p /data/app/$APP data/app/$APP

APP=com.google.android.gm-1
adb pull -p /data/app/$APP data/app/$APP

APP=com.google.android.apps.docs-1
adb pull -p /data/app/$APP data/app/$APP

APP=com.google.android.googlequicksearchbox-1
adb pull -p /data/app/$APP data/app/$APP

APP=com.google.android.music-1
adb pull -p /data/app/$APP data/app/$APP

APP=de.robv.android.xposed.installer-1
adb pull -p /data/app/$APP data/app/$APP

cd data/
find . -name "*.odex" -type f -delete
cd ..

adb pull -p /system/etc/hosts tools/adaway/hosts
