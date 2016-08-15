#!/bin/bash
# FreedomOS build script
# Author : Nevax
# Contributor : TimVNL

# test if running as root
if [ "$EUID" -ne 0 ]; then
  die "Please, run this script as root! Aborting." "7"
fi

# error function
function die {
  code=-1
  err="Unknown error!"
  test "$1" && err=$1
  cd ${top_root}
  echo "$err"
  echo "Check the build log: ${build_log}"
  exit -1
}

#set up environment variables, folder structure, and log files
function initialize {
  top_root=$PWD
  build_root=${top_root}/build
  output_root=${top_root}/output
  MENU=0
  DEVICEMENU=0
  build_log=${top_root}/build/build.log
  config_file=${top_root}/.build.conf

  # create folder structure
  cd ${top_root}
  test -d ${build_root} || mkdir -p ${build_root}
  test -d ${output_root} || mkdir -p ${output_root}

  # test log file
  touch ${build_log}
  rm -f ${build_log}

  # show the configuration, then import it
  cat ${config_file}
  source ${config_file}
}

function banner() {
  tput clear
  echo "----------------------------------------"
  echo " FreedomOS build script by Nevax $normal"
  echo "----------------------------------------"
  echo
}

function confirm() {
  read -p "$1 ([y]es or [N]o): "
  case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
      y|yes)  echo "yes" ;;
      *)      echo "no" ;;
  esac
}

function setup {
  # Show device list
  banner
  echo "Available devices:"
  echo
  find . -name "*.fos" -exec basename \{} .fos \;
  echo
  read -p "Enter your device codename: " DEVICE
  echo

  if [ -f device/$DEVICE/$DEVICE.fos ];
  then
    source device/$DEVICE/$DEVICE.fos
  else
    echo "Can not find $DEVICE.fos file!"
    exit
  fi

  # Choose build method option
  banner
  echo "Choose the build method you want:"
  echo "> user-release"
  echo "> debug"
  echo
  read -p "enter build method [debug]: " BUILD

  case $BUILD in
  1)
    BUILD_TYPE=user-release
    echo "user-release selected"
    ;;
  *)
    BUILD=2
    BUILD_TYPE=debug
    echo "debug selected"
    ;;
  esac

  # Enter version number option
  banner
  read -p "Enter the version number [test] : " version

  if [ -z "$version" ];
  then
    version="test"
  fi

  # confirm config
  review
}

function review {
  # Show Build review
  banner
  echo "Build review:"
  echo
  echo "Device target: $DEVICE"
  echo "Build type: $BUILD_TYPE"
  echo "Build version: $version"
  echo "Arch: $ARCH"
  echo "Codename: $CODENAME"
  echo "Assert: $ASSERT"
  echo "ROM name: $ROM_NAME"
  echo "ROM Link: $ROM_LINK"
  echo "ROM MD5: $ROM_MD5"
  echo "SuperSU zip: $SU"
  echo "Xposed apk: $XPOSED_APK"
  echo "Audio mod: $DIVINE"
  echo
  if [[ "yes" == $(confirm "All options correct?") ]]
  then
    build
  else
    setup
  fi
}

initialize
setup
review
exit


# Building Process
banner
echo "$DEVICE build starting now."
echo

echo "Clear tmp/ foler..."
if mount | grep "FreedomOS/tmp/mount" > /dev/null;
then
	echo "umount tmp/mount/"
	umount tmp/mount/
fi
rm -rvf tmp/*
touch tmp/EMPTY_DIRECTORY

echo
echo "Clear output/ foler..."
#TODO: Delete only the file with the same name
rm -rvf output/*.zip
rm -rvf output/*.md5

echo
echo "Checking dependencies..."
echo
echo "Checking MD5 of $ROM_NAME"
echo
if [[ $ROM_MD5 == $(md5sum download/$ROM_NAME.zip | cut -d ' ' -f 1) ]];
then
  echo "MD5 $ROM_NAME.zip checksums OK."
else
  echo "File $ROM_NAME.zip does not exist or the file is corrupt" >&2
	echo
  if curl -Is $ROM_LINK | grep "200 OK" &> /dev/null
  then
    echo "Downloading $ROM_NAME..."
		#TODO Ask user for delete or change name of the old corrupted zip
		rm -vf download/$ROM_NAME.zip
    curl -o download/$ROM_NAME.zip $ROM_LINK
  else
    die "$ROM_NAME mirror OFFLINE! Check your connection" "10"
  fi
fi
echo

if [ -f rom/$DEVICE/$ROM_NAME/system.new.dat ];
then
  echo "rom/$DEVICE/$ROM_NAME dir exist."
else
  echo
  echo "Extracting rom zip"
  mkdir -p rom/$DEVICE/$ROM_NAME
  unzip -o download/$ROM_NAME.zip -d rom/$DEVICE/$ROM_NAME >> $BUILD_LOG 2>&1
  echo Done!
fi

echo "Updating sdat2img tools"
if curl -Is $SDAT2IMG_LINK | grep "200 OK" &> /dev/null
then
  curl -o download/sdat2img.py $SDAT2IMG_LINK
else
  echo "$yellowt sdat2img tools mirror is OFFLINE! sdat2img tools not updated $normal"
fi
chmod +x download/sdat2img.py

echo
echo "Copy $ROM_NAME needed files:"
rsync -rv rom/$DEVICE/$ROM_NAME/* tmp/ --exclude='system.transfer.list' --exclude='system.new.dat' --exclude='system.patch.dat' --exclude='META-INF/'
mkdir -p tmp/mount
mkdir -p tmp/system
echo
echo "Extracting system.new.dat:"
download/sdat2img.py rom/$DEVICE/$ROM_NAME/system.transfer.list rom/$DEVICE/$ROM_NAME/system.new.dat tmp/system.img
echo
echo "Mounting system.img:"
mount -t ext4 -o loop tmp/system.img tmp/mount/
echo
echo "Extracting system files:"
cp -rvf tmp/mount/* tmp/system/
echo
echo "Clean tmp/"
if mount | grep "FreedomOS/tmp/mount" > /dev/null;
then
		echo "umount tmp/mount/"
		sleep 2
		umount tmp/mount/
fi
rm -rvf tmp/mount
rm -rvf tmp/system.*

echo
echo "Remove unneeded system files"
for i in ${CLEAN_LIST}
do
	rm -rvf tmp${i}
done

echo
echo "Patching system files:"
cp -rvf system/* tmp/system

#echo
#echo "Copying data files:"
#cp -rvf data tmp/data

echo
echo "Add aroma"
mkdir -p tmp/META-INF/com/google/android/
cp -vR device/$DEVICE/aroma/* tmp/META-INF/com/google/android/
echo
echo "Add tools"
cp -vR "tools" "tmp/"
echo
echo "Add SuperSU"
mkdir tmp/supersu
cp -v download/$SU.zip tmp/supersu/supersu.zip

echo
echo "Add FreedomOS wallpapers by badboy47"
mkdir -p tmp/media/wallpaper
cp -v media/wallpaper/* tmp/media/wallpaper
echo
echo "Add Divine"
unzip -o "download/$DIVINE.zip" -d "tmp/tools/divine/" >> $BUILD_LOG 2>&1

echo
echo "Set Assert in updater-script"
sed -i.bak "s:!assert!:$ASSERT:" tmp/META-INF/com/google/android/updater-script
echo
echo "Set version in aroma"
sed -i.bak "s:!version!:$version:" tmp/META-INF/com/google/android/aroma-config
echo
echo "Set version in aroma"
sed -i.bak "s:!device!:$DEVICE:" tmp/META-INF/com/google/android/aroma-config
echo
echo "Set date in aroma"
sed -i.bak "s:!date!:$(date +"%d%m%y"):" tmp/META-INF/com/google/android/aroma-config
echo
echo "Set date in en.lang"
sed -i.bak "s:!date!:$(date +"%d%m%y"):" tmp/META-INF/com/google/android/aroma/langs/en.lang
echo
echo "Set date in fr.lang"
sed -i.bak "s:!date!:$(date +"%d%m%y"):" tmp/META-INF/com/google/android/aroma/langs/fr.lang
rm -rvf tmp/META-INF/com/google/android/aroma-config.bak
rm -rvf tmp/META-INF/com/google/android/aroma/langs/*.lang.bak

## user release build
if [ "$BUILD" = 1 ];
then
  cd tmp/
  echo
  echo "Making zip file"
  zip -r9 "FreedomOS-$CODENAME-nevax-$version.zip" * -x "*EMPTY_DIRECTORY*" >> $BUILD_LOG 2>&1
  echo "----"
  cd ..
  echo
  echo "Copy Unsigned in output folder"
  cp -v tmp/FreedomOS-$CODENAME-nevax-$version.zip output/FreedomOS-$CODENAME-nevax-$version.zip >> $BUILD_LOG 2>&1
  echo
  echo "testing zip integrity"
  zip -T output/FreedomOS-$CODENAME-nevax-$version.zip >> $BUILD_LOG 2>&1
  echo
  echo "Generating md5 hash"
  openssl md5 "output/FreedomOS-$CODENAME-nevax-$version.zip" |cut -f 2 -d " " > "output/FreedomOS-$CODENAME-nevax-$version.zip.md5"
  echo
  echo "SignApk....."
	chmod +x SignApk/signapk.jar
  java -jar "SignApk/signapk.jar" "SignApk/certificate.pem" "SignApk/key.pk8" "tmp/FreedomOS-$CODENAME-nevax-$version.zip" "output/FreedomOS-$CODENAME-nevax-$version-signed.zip"
  echo
  echo "Generating md5 hash"
  openssl md5 "output/FreedomOS-$CODENAME-nevax-$version-signed.zip" |cut -f 2 -d " " > "output/FreedomOS-$CODENAME-nevax-$version-signed.zip.md5"
  #We doesn't test the final, because it doesn't work with the signed zip.
  FINAL_ZIP=FreedomOS-$CODENAME-nevax-$version-signed
fi

## debug build
if [ "$BUILD" = 2 ];
then
  cd tmp/
  echo
  echo "Making zip file"
  zip -r1 "FreedomOS-$CODENAME-$BUILD_TYPE-$version.zip" * -x "*EMPTY_DIRECTORY*" >> $BUILD_LOG 2>&1
  echo "----"
  echo
  echo "testing zip integrity"
  zip -T "FreedomOS-$CODENAME-$BUILD_TYPE-$version.zip" >> $BUILD_LOG 2>&1
  echo
  cd ..
  echo "Move unsigned zip file in output folder"
  mv -v "tmp/FreedomOS-$CODENAME-$BUILD_TYPE-$version.zip" "output/"
  echo
  echo "Generating md5 hash"
  openssl md5 "output/FreedomOS-$CODENAME-$BUILD_TYPE-$version.zip" |cut -f 2 -d " " > "output/FreedomOS-$CODENAME-$BUILD_TYPE-$version.zip.md5"
  FINAL_ZIP=FreedomOS-$CODENAME-$BUILD_TYPE-$version
fi

echo
echo "Clear tmp/ foler..."
rm -rf tmp/*
touch "tmp/EMPTY_DIRECTORY"
echo
echo "$greent$bold Build finished! You can find the build here: output/FreedomOS-$CODENAME-$BUILD_TYPE-$version.zip $normal"
echo
if [[ "yes" == $(confirm "Want to flash it now?") ]]
then
  ## ADB Push zip on device
  echo
  echo "Pushing $FINAL_ZIP.zip to your $DEVICE..."
  adb shell "rm /sdcard/$FINAL_ZIP.zip"
  adb push -p output/$FINAL_ZIP.zip /sdcard/
  echo "Pushing $FINAL_ZIP.zip.md5 to your $DEVICE..."
  adb shell "rm /sdcard/$FINAL_ZIP.zip.md5"
  adb push -p output/$FINAL_ZIP.zip.md5 /sdcard/
  adb shell "chown -R media_rw:media_rw /sdcard/FreedomOS*"
  ## Flashing zip on device
  echo
  echo "Flashing $FINAL_ZIP.zip into TWRP"
  adb shell "echo 'boot-recovery ' > /cache/recovery/command"
  adb shell "echo '--update_package=/sdcard/$FINAL_ZIP.zip' >> /cache/recovery/command"
  adb shell reboot recovery
  echo
  echo "$greent$bold Flash Successful! Follow the steps on you device $normal"
fi
