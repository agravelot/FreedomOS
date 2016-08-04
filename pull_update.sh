#!/bin/bash

adb shell "mount /data"
adb shell "mount /system"

DATA_PATH="data/app/"

app_list="
com.google.android.apps.photos-
com.google.android.apps.maps-
com.google.android.calendar-
com.google.android.apps.messaging-
com.google.android.youtube-
com.google.android.music-
com.google.android.talk-
com.android.chrome-
com.touchtype.swiftkey-
com.google.android.gm-
com.google.android.apps.docs-
com.google.android.googlequicksearchbox-
com.google.android.music-
de.robv.android.xposed.installer-
"

for i in ${app_list}
do
  mkdir -p ${DATA_PATH}${i}1
done

for f in ${app_list}
do
  echo " "
  #cd "${f}1"
  echo "Pulling ${f} :"
  x=$(adb shell 'ls /data/app/' | grep "${f}" | tr '\r' ' ')
  adb pull /data/app/${x} data/app/${f}1
  #cd ..
done

chmod 775 ${DATA_PATH}*

echo " "
echo "Pull hosts file"
adb pull /system/etc/hosts tools/adaway/hosts
