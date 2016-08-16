function build_op3 {
  # Building Process
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
  echo "Set VERSION in aroma"
  sed -i.bak "s:!VERSION!:$VERSION:" tmp/META-INF/com/google/android/aroma-config
  echo
  echo "Set VERSION in aroma"
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
    zip -r9 "FreedomOS-$CODENAME-nevax-$VERSION.zip" * -x "*EMPTY_DIRECTORY*" >> $BUILD_LOG 2>&1
    echo "----"
    cd ..
    echo
    echo "Copy Unsigned in output folder"
    cp -v tmp/FreedomOS-$CODENAME-nevax-$VERSION.zip output/FreedomOS-$CODENAME-nevax-$VERSION.zip >> $BUILD_LOG 2>&1
    echo
    echo "testing zip integrity"
    zip -T output/FreedomOS-$CODENAME-nevax-$VERSION.zip >> $BUILD_LOG 2>&1
    echo
    echo "Generating md5 hash"
    openssl md5 "output/FreedomOS-$CODENAME-nevax-$VERSION.zip" |cut -f 2 -d " " > "output/FreedomOS-$CODENAME-nevax-$VERSION.zip.md5"
    echo
    echo "SignApk....."
    chmod +x SignApk/signapk.jar
    java -jar "SignApk/signapk.jar" "SignApk/certificate.pem" "SignApk/key.pk8" "tmp/FreedomOS-$CODENAME-nevax-$VERSION.zip" "output/FreedomOS-$CODENAME-nevax-$VERSION-signed.zip"
    echo
    echo "Generating md5 hash"
    openssl md5 "output/FreedomOS-$CODENAME-nevax-$VERSION-signed.zip" |cut -f 2 -d " " > "output/FreedomOS-$CODENAME-nevax-$VERSION-signed.zip.md5"
    #We doesn't test the final, because it doesn't work with the signed zip.
    FINAL_ZIP=FreedomOS-$CODENAME-nevax-$VERSION-signed
  fi

  ## debug build
  if [ "$BUILD" = 2 ];
  then
    cd tmp/
    echo
    echo "Making zip file"
    zip -r1 "FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION.zip" * -x "*EMPTY_DIRECTORY*" >> $BUILD_LOG 2>&1
    echo "----"
    echo
    echo "testing zip integrity"
    zip -T "FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION.zip" >> $BUILD_LOG 2>&1
    echo
    cd ..
    echo "Move unsigned zip file in output folder"
    mv -v "tmp/FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION.zip" "output/"
    echo
    echo "Generating md5 hash"
    openssl md5 "output/FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION.zip" |cut -f 2 -d " " > "output/FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION.zip.md5"
    FINAL_ZIP=FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION
  fi

  echo
  echo "Clear tmp/ foler..."
  rm -rf tmp/*
  touch "tmp/EMPTY_DIRECTORY"
  echo
  echo "$greent$bold Build finished! You can find the build here: output/FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION.zip $normal"
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
}
