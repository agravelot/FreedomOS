#!/bin/bash
# FreedomOS build script
# Author : Nevax
# Contributor : TimVNL

VERSION=0
DEVICE=0
MENU=0
DEVICEMENU=0

echo "#################################"
echo "FreedomOS build script by Nevax"
echo "#################################"
echo ""
echo "Available devices:"
find . -print | grep -i 'device/.*[.]fos'
echo ""
read -p "Enter your device codename: " DEVICE
echo ""

if [ -f device/$DEVICE/$DEVICE.fos ];
then
        source device/$DEVICE/$DEVICE.fos
else
        echo "Can not find $DEVICE.fos file!"
        exit
fi


echo ""
echo "Choose the build method you want:"
echo "1) user-realease"
echo "2) debug"
echo ""
read -p "enter build method [debug]: " BUILD

if [ "$BUILD" = 1 ];
then
        BUILD_TYPE=stable
        echo "user-realease selected"
elif  [ "$BUILD" = 2 ];
then
        BUILD_TYPE=debug
        echo "debug selected"
else
        BUILD=2
        BUILD_TYPE=debug
        echo "debug selected"
fi
echo ""
read -p "Enter the version number [test] : " VERSION

if [ -z "$VERSION" ];
then
        VERSION="test"
fi

echo ""
echo "Clear tmp/ foler..."
rm -rvf tmp/*
touch tmp/EMPTY_DIRECTORY

echo ""
echo "Clear output/ foler..."
rm -rvf output/*.zip
rm -rvf output/*.md5
rm -rvf output/patch*

echo ""
echo "Checking dependencies..."
echo ""
if [ -f "download/$ROM_NAME.zip" ];
then
   echo "File $ROM_NAME.zip exist."
else
   echo "File $ROM_NAME.zip does not exist" >&2
   echo "Downloading.."
   curl -o download/$ROM_NAME.zip $ROM_LINK
fi
echo ""

if [ -d rom/$DEVICE ];
then
  echo "rom/$DEVICE/ dir exist."
else
  echo ""
  echo "Extracting rom zip"
  echo ""
  echo "Checking MD5 of $ROM_NAME"
  #MD5
  echo ""
  echo "Extracting..."
  mkdir -p rom/$DEVICE
  unzip -o download/$ROM_NAME.zip -d rom/$DEVICE/
  echo Done!
fi

echo "Updating sdat2img tools"
curl -o download/sdat2img.py https://raw.githubusercontent.com/xpirt/sdat2img/master/sdat2img.py
chmod +x download/sdat2img.py

echo ""
echo "Copy $ROM_NAME files:"
cp -rvf rom/$DEVICE/* tmp/
mkdir tmp/mount
mkdir tmp/system
echo ""
echo "Extracting system.new.dat:"
download/sdat2img.py tmp/system.transfer.list tmp/system.new.dat tmp/system.img
echo ""
echo "Mounting system.new.dat:"
mount -t ext4 -o loop tmp/system.img tmp/mount/
echo ""
echo "Extracting system files:"
cp -rvf tmp/mount/* tmp/system/
echo ""
echo "Clean tmp/"
umount tmp/mount/
rm -rvf tmp/mount
rm -rvf tmp/system.*
echo ""
echo "Remove stock recovery"
rm -vf tmp/system/bin/install-recovery.sh
rm -vf tmp/system/recovery-from-boot.p

echo ""
echo "Remove META-INF"
rm -rvf "tmp/META-INF"
echo ""
echo "Add aroma"
mkdir -p tmp/META-INF/com/google/android/
cp -vR device/$DEVICE/aroma/* tmp/META-INF/com/google/android/
echo ""
echo "Add tools"
cp -vR "tools" "tmp/"
echo ""
echo "Add SuperSU"
cp -v download/$SU.zip tmp/tools/su/su.zip
echo ""
echo "Add FreedomOS wallpapers by badboy47"
mkdir -p tmp/media/wallpaper
cp -v media/wallpaper/* tmp/media/wallpaper
echo ""
echo "Add Divine"
unzip -o "download/$DIVINE.zip" -d "tmp/tools/divine/"

echo ""
echo "Set Assert in updater-script"
sed -i.bak "s:!assert!:$ASSERT:" tmp/META-INF/com/google/android/updater-script
echo ""
echo "Set version in aroma"
sed -i.bak "s:!version!:$VERSION:" tmp/META-INF/com/google/android/aroma-config
echo ""
echo "Set version in aroma"
sed -i.bak "s:!device!:$DEVICE:" tmp/META-INF/com/google/android/aroma-config
echo ""
echo "Set date in aroma"
sed -i.bak "s:!date!:$(date +"%d%m%y"):" tmp/META-INF/com/google/android/aroma-config
echo ""
echo "Set date in en.lang"
sed -i.bak "s:!date!:$(date +"%d%m%y"):" tmp/META-INF/com/google/android/aroma/langs/en.lang
echo ""
echo "Set date in fr.lang"
sed -i.bak "s:!date!:$(date +"%d%m%y"):" tmp/META-INF/com/google/android/aroma/langs/fr.lang
rm -rvf tmp/META-INF/com/google/android/aroma-config.bak
rm -rvf tmp/META-INF/com/google/android/aroma/langs/*.lang.bak

if [ "$BUILD" = 1 ];
then
  cd tmp/
  echo ""
  echo "Making zip file"
  zip -r9 "FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION.zip" * -x "*EMPTY_DIRECTORY*"
  echo "----"
  cd ..
  echo ""
  echo "Copy Unsigned in output folder"
  cp -v tmp/FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION.zip output/FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION.zip
  echo ""
  echo "testing zip integrity"
  zip -T output/FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION.zip
  echo ""
  echo "Generating md5 hash"
  openssl md5 "output/FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION.zip" |cut -f 2 -d " " > "output/FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION.zip.md5"
  echo ""
  echo "SignApk....."
  java -jar "SignApk/signapk.jar" "SignApk/testkey.x509.pem" "SignApk/testkey.pk8" "tmp/FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION.zip" "tmp/FreedomOS-$DEVICE-$BUILD_TYPE-$VERSION-signed.zip"
  echo ""
  echo "Move signed zip file in output folder"
  mv -v "tmp/FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION-signed.zip" "output/"
  echo ""
  echo "Generating md5 hash"
  openssl md5 "output/FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION-signed.zip" |cut -f 2 -d " " > "output/FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION-signed.zip.md5"
  #We doesn't test the final, because it doesn't work with the signed zip.
fi

if [ "$BUILD" = 2 ];
then
  cd tmp/
  echo ""
  echo "Making zip file"
  zip -r1 "FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION.zip" * -x "*EMPTY_DIRECTORY*"
  echo "----"
  echo ""
  echo "testing zip integrity"
  zip -T "FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION.zip"
  echo ""
  cd ..
  echo "Move unsigned zip file in output folder"
  mv -v "tmp/FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION.zip" "output/"
  echo ""
  echo "Generating md5 hash"
  openssl md5 "output/FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION.zip" |cut -f 2 -d " " > "output/FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION.zip.md5"
fi

echo ""
echo "Clear tmp/ foler..."
rm -rvf tmp/*
touch "tmp/EMPTY_DIRECTORY"
echo ""
echo "Finish! You can find the build here: output/FreedomOS-$DEVICE-$BUILD_TYPE-$VERSION.zip"


if [ -d "device/$DEVICE/patch" ];
then
  echo ""
  echo "Building patch file"
  mkdir -p tmp/patch/
  cp -rvf device/$DEVICE/patch/META-INF tmp/patch/
  cd tmp/patch/
  zip -r9 "patch-FreedomOS-$VERSION.zip" * -x "*EMPTY_DIRECTORY*"
  cd ../..
  echo ""
  echo "Move patch file:"
  mv -vf tmp/patch/patch-FreedomOS-$VERSION.zip output/patch-FreedomOS-$VERSION.zip
  echo ""
  echo "Clear tmp/ foler..."
  rm -rvf tmp/*
  touch "tmp/EMPTY_DIRECTORY"
  echo ""
  echo "Finish! You can find the build here: output/FreedomOS-$DEVICE-$BUILD_TYPE-$VERSION.zip"
fi
