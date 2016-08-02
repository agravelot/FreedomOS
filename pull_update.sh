#!/bin/bash

adb shell "mount /data"
adb shell "mount /system"

DATA_PATH="data/app/"

app_list="
com.google.android.apps.photos-1
com.google.android.apps.maps-1
com.google.android.calendar-1
com.google.android.apps.messaging-1
com.google.android.youtube-1
com.google.android.music-1
com.google.android.talk-1
com.android.chrome-1
com.touchtype.swiftkey-1
com.google.android.gm-1
com.google.android.apps.docs-1
com.google.android.googlequicksearchbox-1
com.google.android.music-1
de.robv.android.xposed.installer-1
"

for i in ${app_list}
do
  mkdir -p ${DATA_PATH}${i}
done

for i in ${app_list}
do
  echo " "
  echo "Pulling ${i} :"
  adb pull /data/app/${i} ${DATA_PATH}${i}
done

cd ${DATA_PATH}
chmod 775 *
cd -

echo "Remove .odex files"
cd ${DATA_PATH}
find . -name "*.odex" -type f -delete
cd -

echo "Pull hosts file"
adb pull /system/etc/hosts tools/adaway/hosts
