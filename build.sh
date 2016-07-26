#!/bin/bash
# FreedomOS build script
# Author : Nevax
# Contributor : TimVNL

VERSION="0"
URLOOS=https://s3.amazonaws.com/oxygenos.oneplus.net
OOS=OnePlus3Oxygen_16_OTA_012_all_1607251520_5926eed75c18470f
SU=UPDATE-SuperSU-v2.76-20160630161323
XPOSED_APK=XposedInstaller_3.0_alpha4
DIVINE=DiVINE_BEATS_v7.0_EVOLUTION_BY_THE_ROYAL_SEEKER
DEVICE=op3
MENU=0

echo "#################################"
echo "FreedomOS build script by Nevax"
echo "#################################"
echo ""
echo "Choose the build method you want:"
echo "1) Signed (Slower)"
echo "2) Unsigned (Faster)"
echo ""
read -p "enter build method [2]: " MENU

if [ "$MENU" = 1 ];
then
        echo "Signed method selected"
elif  [ "$MENU" = 2 ];
then
        echo "Unsigned method selected"
else
        MENU=2
        echo "Unsigned method selected"
fi
echo ""
read -p "Enter a version number you want to use [test] : " VERSION

if [ -z "$VERSION" ];
then
        VERSION="test"
fi

echo ""
echo "Clear tmp/ foler..."
rm -rf tmp/*
touch tmp/EMPTY_DIRECTORY

echo ""
echo "Clear output/ foler..."
rm -rf output/*.zip
rm -rf output/*.md5

echo ""
echo "Checking dependencies..."
echo ""
if [ -f "download/$OOS.zip" ];
then
   echo "File $OOS.zip exist."
else
   echo "File $OOS.zip does not exist" >&2
   echo "Downloading.."
   curl -o download/$OOS.zip "$URLOOS/$OOS.zip"
   echo ""
   echo "testing zip integrity"
   zip -T download/$OOS.zip
   echo ""
   echo "Clean system/"
   rm -rf system/*
   touch "system/EMPTY_DIRECTORY"
   echo ""
   echo "Extracting system"
   unzip -o download/$OOS.zip -d system/
   echo "Done!"
fi
echo ""

if [ -f "download/$SU.zip" ];
then
   echo "File $SU.zip exist."
else
   echo "File $SU.zip does not exist" >&2
   echo "Downloading.."
   curl -o download/$SU.zip "http://fr1.androidfilehost.com/dl/1JCF2741XshSLSFUOQPtaQ/1467951889/24591000424944637/$SU.zip"
   echo ""
   echo "testing zip integrity"
   zip -T download/$SU.zip
   echo "Done!"
fi
echo ""

if [ -f "download/$XPOSED_APK.apk" ];
then
   echo "File $XPOSED_APK.apk exist."
else
   echo "File $XPOSED_APK.apk does not exist" >&2
   echo "Downloading.."
   curl -o download/$XPOSED_APK.apk "http://forum.xda-developers.com/attachment.php?attachmentid=3383776&d=1435601440"
   echo "Done!"
fi
echo""

if [ -f "download/$DIVINE.zip" ];
then
   echo "File $DIVINE.zip exist."
else
   echo "File $DIVINE.zip does not exist" >&2
   echo "Downloading.."
   curl -o download/$DIVINE.zip "http://fr1.androidfilehost.com/dl/b-p7sG3YlA4BZN8XoW7tbQ/1467379312/24533103863141857/$DIVINE.zip"
   echo ""
   echo "testing zip integrity"
   zip -T download/$DIVINE.zip
   echo "Done!"
fi

echo ""
#echo "testing downloaded zip integrity"
#zip -T download/*.zip

echo ""
echo "Copy OOS"
cp -rvf system/* tmp/
echo ""
echo "Remove META-INF"
rm -rf "tmp/META-INF"
echo ""
echo "Add aroma"
cp -vR "aroma/META-INF" "tmp/"
echo ""
echo "Add tools"
cp -vR "tools" "tmp/"
echo ""
echo "Add SuperSU"
cp -v download/$SU.zip tmp/tools/su/su.zip
echo ""
echo "Add xposed apk"
cp -v download/$XPOSED_APK.apk tmp/tools/xposed/
echo ""
echo "Add wallpaper by badboy47"
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
rm -rf tmp/META-INF/com/google/android/aroma-config.bak
rm -rf tmp/META-INF/com/google/android/aroma/langs/*.lang.bak


if [ "$MENU" = 1 ];
then
  cd tmp/
  echo ""
  echo "Making zip file"
  zip -r9 "FreedomOS-$DEVICE-nevax-$VERSION.zip" * -x "*EMPTY_DIRECTORY*"
  echo "----"
  cd ..
  echo ""
  echo "Copy Unsigned in output folder"
  cp -v tmp/FreedomOS-$DEVICE-nevax-$VERSION.zip output/FreedomOS-$DEVICE-nevax-$VERSION.zip
  echo ""
  echo "testing zip integrity"
  zip -T output/FreedomOS-$DEVICE-nevax-$VERSION.zip
  echo ""
  echo "Generating md5 hash"
  openssl md5 "output/FreedomOS-$DEVICE-nevax-$VERSION.zip" |cut -f 2 -d " " > "output/FreedomOS-$DEVICE-nevax-$VERSION.zip.md5"
  echo ""
  echo "SignApk....."
  java -jar "SignApk/signapk.jar" "SignApk/testkey.x509.pem" "SignApk/testkey.pk8" "tmp/FreedomOS-$DEVICE-nevax-$VERSION.zip" "tmp/FreedomOS-$DEVICE-nevax-$VERSION-signed.zip"
  echo ""
  echo "Move signed zip file in output folder"
  mv "tmp/FreedomOS-$DEVICE-nevax-$VERSION-signed.zip" "output/"
  echo ""
  echo "testing zip integrity"
  zip -T "output/FreedomOS-$DEVICE-nevax-$VERSION-signed.zip"
  echo ""
  echo "Generating md5 hash"
  openssl md5 "output/FreedomOS-$DEVICE-nevax-$VERSION-signed.zip" |cut -f 2 -d " " > "output/FreedomOS-$DEVICE-nevax-$VERSION-signed.zip.md5"
  #We doesn't test the final, because it doesn't work with the signed zip.
fi

if [ "$MENU" = 2 ];
then
  cd tmp/
  echo ""
  echo "Making zip file"
  zip -r1 "FreedomOS-$DEVICE-nevax-$VERSION.zip" * -x "*EMPTY_DIRECTORY*"
  echo "----"
  echo ""
  echo "testing zip integrity"
  zip -T "FreedomOS-$DEVICE-nevax-$VERSION.zip"
  echo ""
  cd ..
  echo "Move unsigned zip file in output folder"
  mv "tmp/FreedomOS-$DEVICE-nevax-$VERSION.zip" "output/"
  echo ""
  echo "Generating md5 hash"
  openssl md5 "output/FreedomOS-$DEVICE-nevax-$VERSION.zip" |cut -f 2 -d " " > "output/FreedomOS-$DEVICE-nevax-$VERSION.zip.md5"
  echo ""
  echo "testing final zip integrity"
  zip -T output/FreedomOS-$DEVICE-nevax-$VERSION*.zip
fi

echo ""
echo "Clear tmp/ foler..."
rm -rf "tmp/*"
touch "tmp/EMPTY_DIRECTORY"
echo ""
echo "Finish! You can find the build here: output/FreedomOS-$DEVICE-nevax-$VERSION.zip"
