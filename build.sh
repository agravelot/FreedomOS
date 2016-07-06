#!/bin/bash
# FreedomOS build script
# Author : Nevax

VERSION=0
OOS=OnePlus3Oxygen_16_OTA_010_all_1607012342_741e629725ed457b
SU=UPDATE-SuperSU-v2.76-20160630161323
XPOSED=xposed-v85-sdk23-arm64
XPOSED_APK=XposedInstaller_3.0_alpha4
DIVINE=DiVINE_BEATS_v7.0_EVOLUTION_BY_THE_ROYAL_SEEKER

MENU=0
echo "#################################"
echo "FreedomOS build script by Nevax"
echo "#################################"
echo ""
echo "Choose the build method you want:"
echo "1) Signed (Slower)"
echo "2) Unsigned (Faster)"
echo ""
read -p "enter build method [1-2]: " MENU

if [ "$MENU" = 1 ];
then
        echo "Signed method selected"
elif  [ "$MENU" = 2 ];
then
        echo "Unsigned method selected"
else
        echo "Wrong entry, please select between 1 or 2"
        exit
fi
echo ""
read -p "Enter a version number you want to use: " VERSION

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
   curl -o download/$OOS.zip "https://s3.amazonaws.com/oxygenos.oneplus.net/$OOS.zip"
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

if [ -f "download/$XPOSED.zip" ];
then
   echo "File $XPOSED.zip exist."
else
   echo "File $XPOSED.zip does not exist" >&2
   echo "Downloading.."
   curl -o download/$XPOSED.zip "http://dl-xda.xposed.info/framework/sdk23/arm64/$XPOSED.zip"
   echo ""
   echo "testing zip integrity"
   zip -T download/$XPOSED.zip
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
echo "Copy OOS"
cp -rf system/* tmp/
echo ""
echo "Remove META-INF"
rm -rf "tmp/META-INF"
echo ""
echo "Add aroma"
cp -R "aroma/META-INF" "tmp/"
echo ""
echo "Add tools"
cp -R "tools" "tmp/"
echo ""
echo "Add SuperSU"
cp download/$SU.zip tmp/tools/su/su.zip
echo ""
echo "Add xposed"
cp download/{$XPOSED.zip,$XPOSED_APK.apk} tmp/tools/xposed/
echo ""
echo "Add Divine"
unzip -o "download/$DIVINE.zip" -d "tmp/tools/divine/"
echo ""
echo "Set version in aroma"
sed -i "s:!version!:$VERSION:" tmp/META-INF/com/google/android/aroma-config
echo ""
echo "Set date in aroma"
sed -i "s:!date!:$(date +"%d%m%y"):" tmp/META-INF/com/google/android/aroma-config
echo ""
echo "Set date in en.lang"
sed -i "s:!date!:$(date +"%d%m%y"):" tmp/META-INF/com/google/android/aroma/langs/en.lang
echo ""
echo "Set date in fr.lang"
sed -i "s:!date!:$(date +"%d%m%y"):" tmp/META-INF/com/google/android/aroma/langs/fr.lang

if [ "$MENU" = 1 ];
then
  cd tmp/
  echo ""
  echo "Making zip file"
  zip -r9 "FreedomOS-op3-nevax-$VERSION-unsigned.zip" * -x EMPTY_DIRECTORY
  echo "----"
  cd ..
  echo ""
  echo "SignApk....."
  java -jar "SignApk/signapk.jar" "SignApk/testkey.x509.pem" "SignApk/testkey.pk8" "tmp/FreedomOS-op3-nevax-$VERSION-unsigned.zip" "tmp/FreedomOS-op3-nevax-$VERSION-signed.zip"
  echo ""
  echo "testing zip integrity"
  zip -T "tmp/FreedomOS-op3-nevax-$VERSION-signed.zip"
  echo ""
  echo "Move signed zip file in output folder"
  mv "tmp/FreedomOS-op3-nevax-$VERSION-signed.zip" "output/"
  echo ""
  echo "Generating md5 hash"
  openssl md5 "output/FreedomOS-op3-nevax-$VERSION-signed.zip" |cut -f 2 -d " " > "output/FreedomOS-op3-nevax-$VERSION-signed.zip.md5"
fi

if [ "$MENU" = 2 ];
then
  cd tmp/
  echo ""
  echo "Making zip file"
  zip -r1 "FreedomOS-op3-nevax-$VERSION.zip" * -x EMPTY_DIRECTORY
  echo "----"
  echo ""
  echo "testing zip integrity"
  zip -T "FreedomOS-op3-nevax-$VERSION.zip"
  echo ""
  cd ..
  echo "Move unsigned zip file in output folder"
  mv "tmp/FreedomOS-op3-nevax-$VERSION.zip" "output/"
  echo ""
  echo "Generating md5 hash"
  openssl md5 "output/FreedomOS-op3-nevax-$VERSION.zip" |cut -f 2 -d " " > "output/FreedomOS-op3-nevax-$VERSION.zip.md5"
fi

echo "Clear tmp/ foler..."
rm -rf "tmp/*"
touch "tmp/EMPTY_DIRECTORY"
echo ""
echo "Finish! You can find the build here: output/FreedomOS-op3-nevax-$VERSION.zip"
