#!/sbin/sh
# Copyright VillainROM 2011. All Rights Reserved
# Updated for Android 5 Lollipop by Spannaa @ XDA 2014
# Modded by skin1980 @ XDA 2014 for LG G3

rm -r /data/vrtheme-backup
mkdir /data/tmp
mkdir /data/tmp/vrtheme
mkdir /data/vrtheme-backup
mkdir /data/vrtheme-backup/app
mkdir /data/vrtheme-backup/priv-app
mkdir /data/vrtheme-backup/framework
mkdir /data/vrtheme-backup/framework/lge-res


# start with /system/app

if [ -d "/data/tmp/vrtheme/apply/system/app" ]; then
cd /data/tmp/vrtheme/apply/system/app/
echo "   Processing /system/app"
for f in $(ls)
do
	echo "     $f.apk"
	busybox mkdir -p /data/vrtheme-backup/system/app/$f
# get apk
  cp /system/app/$f/$f.apk /data/tmp/vrtheme/apply/system/app/$f/
# backup apk
	cp /system/app/$f/$f.apk /data/vrtheme-backup/system/app/$f/
# patch apk
	cd /data/tmp/vrtheme/apply/system/app/$f/
  /data/tmp/vrtheme/zip -r /data/tmp/vrtheme/apply/system/app/$f/$f.apk *
# zipalign apk
	cd /data/tmp/vrtheme/apply/system/app/$f/
	busybox mkdir aligned
	/data/tmp/vrtheme/zipalign -f 4 $f.apk aligned/$f.apk
# move apk back
	cp aligned/$f.apk /system/app/$f/
	chmod 644 /system/app/$f/$f.apk
# delete dalvik-cache entry if it exists
	dc_file=/data/dalvik-cache/arm/system@app@$f@$f.apk@classes.dex
	if [ -f $dc_file ]; then
		rm -f $dc_file
	fi
done
else 
echo "can't find /data/tmp/vrtheme/apply/system/app"
fi
# repeat for /system/priv-app

if [ -d "/data/tmp/vrtheme/apply/system/priv-app" ]; then
cd /data/tmp/vrtheme/apply/system/priv-app/
echo "   Processing /system/priv-app"
for f in $(ls)
do
	echo "     $f.apk"
	busybox mkdir -p /data/vrtheme-backup/system/priv-app/$f
# get apk
  cp /system/priv-app/$f/$f.apk /data/tmp/vrtheme/apply/system/priv-app/$f/
# backup apk
	cp /system/priv-app/$f/$f.apk /data/vrtheme-backup/system/priv-app/$f/
# patch apk
	cd /data/tmp/vrtheme/apply/system/priv-app/$f/
  /data/tmp/vrtheme/zip -r /data/tmp/vrtheme/apply/system/priv-app/$f/$f.apk *
# zipalign apk
	cd /data/tmp/vrtheme/apply/system/priv-app/$f/
	busybox mkdir aligned
	/data/tmp/vrtheme/zipalign -f 4 $f.apk aligned/$f.apk
# move apk back
	cp aligned/$f.apk /system/priv-app/$f/
	chmod 644 /system/priv-app/$f/$f.apk
# delete dalvik-cache entry if it exists
	dc_file=/data/dalvik-cache/arm/system@priv-app@$f@$f.apk@classes.dex
	if [ -f $dc_file ]; then
		rm -f $dc_file
	fi
done
else 
echo "can't find /data/tmp/vrtheme/apply/system/priv-app"
fi
# repeat for /system/framework

if [ -d "/data/tmp/vrtheme/apply/system/framework" ]; then
cd /data/tmp/vrtheme/apply/system/framework
echo "   Processing /system/framework"

# get apk
  cp /system/framework/framework-res.apk /data/tmp/vrtheme/apply/system/framework/
# backup apk
  cp /system/framework/framework-res.apk /data/vrtheme-backup/system/framework/
# patch apk
  cd /data/tmp/vrtheme/apply/system/framework/
  /data/tmp/vrtheme/zip -r /data/tmp/vrtheme/apply/system/framework/framework-res.apk *
# zipalign apk
	cd /data/tmp/vrtheme/apply/system/framework/
	busybox mkdir aligned
	/data/tmp/vrtheme/zipalign -f 4 framework-res.apk aligned/framework-res.apk
# move apk back
	cp aligned/framework-res.apk /system/framework/
	chmod 644 /system/framework/framework-res.apk
else
echo "can't find /data/tmp/vrtheme/apply/system/framework"
fi

# repeat for /system/framework/lge-res

if [ -d "/data/tmp/vrtheme/apply/system/lge-res" ]; then
cd /data/tmp/vrtheme/apply/system/lge-res/

echo "   Processing /system/framework/lge-res"

# get apk
  cp /system/framework/lge-res/lge-res.apk /data/tmp/vrtheme/apply/system/lge-res/
# backup apk
  cp /system/framework/lge-res/lge-res.apk /data/vrtheme-backup/system/framework/lge-res/
# patch apk
  cd /data/tmp/vrtheme/apply/system/lge-res/
  /data/tmp/vrtheme/zip -r /data/tmp/vrtheme/apply/system/lge-res/lge-res.apk *
# zipalign apk
	cd /data/tmp/vrtheme/apply/system/lge-res/
	busybox mkdir aligned
	/data/tmp/vrtheme/zipalign -f 4 lge-res.apk aligned/lge-res.apk
# move apk back
	cp aligned/lge-res.apk /system/framework/lge-res/
	chmod 644 /system/framework/lge-res/lge-res.apk
else
echo "can't find /data/tmp/vrtheme/apply/system/lge-res"
fi

# create restore zip from backup apks
echo "   Creating vrtheme-restore.zip"
	cd /data/vrtheme-backup/
  /data/tmp/vrtheme/zip -r /data/tmp/vrtheme/vrtheme_restore.zip *
rm -rf *
	cp /data/tmp/vrtheme/vrtheme_restore.zip /data/vrtheme-backup/
	
	#rm -rf /data/tmp/

