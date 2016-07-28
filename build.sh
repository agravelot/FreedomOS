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
read -p "enter build method [2]: " BUILD

if [ "$BUILD" = 1 ];
then
        echo "user-realease selected"
elif  [ "$BUILD" = 2 ];
then
        echo "debug selected"
else
        BUILD=2
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

if [ -d "rom/$DEVICE/" ];
then
  echo "rom/$DEVICE/ dir exist."
else
  echo ""
  echo "testing zip integrity"
  #MD5 instead !!
  zip -T download/$ROM_NAME.zip
  echo ""
  echo "Clean system/"
  rm -rvf rom/$DEVICE/*
  touch "system/EMPTY_DIRECTORY"
  echo ""
  echo "Extracting system"
  unzip -o download/$ROM_NAME.zip -d rom/$DEVICE/
  echo Done!
fi

echo "Updating sdat2img tools"
curl -o download/sdat2img.py https://raw.githubusercontent.com/xpirt/sdat2img/master/sdat2img.py

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


echo "Set version in aroma"
sed -i.bak "s:!version!:$VERSION:" tmp/META-INF/com/google/android/aroma-config
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
  zip -r9 "FreedomOS-$CODENAME-nevax-$VERSION.zip" * -x "*EMPTY_DIRECTORY*"
  echo "----"
  cd ..
  echo ""
  echo "Copy Unsigned in output folder"
  cp -v tmp/FreedomOS-$CODENAME-nevax-$VERSION.zip output/FreedomOS-$CODENAME-nevax-$VERSION.zip
  echo ""
  echo "testing zip integrity"
  zip -T output/FreedomOS-$CODENAME-nevax-$VERSION.zip
  echo ""
  echo "Generating md5 hash"
  openssl md5 "output/FreedomOS-$CODENAME-nevax-$VERSION.zip" |cut -f 2 -d " " > "output/FreedomOS-$CODENAME-nevax-$VERSION.zip.md5"
  echo ""
  echo "SignApk....."
  java -jar "SignApk/signapk.jar" "SignApk/testkey.x509.pem" "SignApk/testkey.pk8" "tmp/FreedomOS-$CODENAME-nevax-$VERSION.zip" "tmp/FreedomOS-$DEVICE-nevax-$VERSION-signed.zip"
  echo ""
  echo "Move signed zip file in output folder"
  mv -v "tmp/FreedomOS-$CODENAME-nevax-$VERSION-signed.zip" "output/"
  echo ""
  echo "Generating md5 hash"
  openssl md5 "output/FreedomOS-$CODENAME-nevax-$VERSION-signed.zip" |cut -f 2 -d " " > "output/FreedomOS-$CODENAME-nevax-$VERSION-signed.zip.md5"
  #We doesn't test the final, because it doesn't work with the signed zip.
fi

if [ "$BUILD" = 2 ];
then
  cd tmp/
  echo ""
  echo "Making zip file"
  zip -r1 "FreedomOS-$CODENAME-nevax-$VERSION.zip" * -x "*EMPTY_DIRECTORY*"
  echo "----"
  echo ""
  echo "testing zip integrity"
  zip -T "FreedomOS-$CODENAME-nevax-$VERSION.zip"
  echo ""
  cd ..
  echo "Move unsigned zip file in output folder"
  mv -v "tmp/FreedomOS-$CODENAME-nevax-$VERSION.zip" "output/"
  echo ""
  echo "Generating md5 hash"
  openssl md5 "output/FreedomOS-$CODENAME-nevax-$VERSION.zip" |cut -f 2 -d " " > "output/FreedomOS-$CODENAME-nevax-$VERSION.zip.md5"
fi

echo ""
echo "Clear tmp/ foler..."
rm -rvf tmp/*
touch "tmp/EMPTY_DIRECTORY"
echo ""
echo "Finish! You can find the build here: output/FreedomOS-$DEVICE-nevax-$VERSION.zip"


if [ -d "device/$DEVICE/patch" ];
then
  echo ""
  echo "Building patch file"
  mkdir -p tmp/patch/
  cp -rvf device/$DEVICE/patch/ tmp/patch/
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
  echo "Finish! You can find the build here: output/FreedomOS-$DEVICE-nevax-$VERSION.zip"
fi
