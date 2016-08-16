function build_op2 {
  # Building Process

  echo
  echo "Copy ${ROM_NAME} needed files:"
  rsync -rv ${rom_root}/${device}/${ROM_NAME}/* ${build_root}/ --exclude='system.transfer.list' --exclude='system.new.dat' --exclude='system.patch.dat' --exclude='META-INF/'
  mkdir -p ${build_root}/mount
  mkdir -p ${build_root}/system
  echo
  echo "Extracting system.new.dat:"
  ${download_root}/sdat2img.py ${rom_root}/${device}/${ROM_NAME}/system.transfer.list ${rom_root}/${device}/${ROM_NAME}/system.new.dat ${build_root}/system.img
  echo
  echo "Mounting system.img:"
  mount -t ext4 -o loop ${build_root}/system.img ${build_root}/mount/
  echo
  echo "Extracting system files:"
  cp -rvf ${build_root}/mount/* ${build_root}/system/
  echo
  echo "Clean tmp/"
  if mount | grep "FreedomOS/tmp/mount" > /dev/null;
  then
      echo "umount tmp/mount/"
      sleep 2
      umount ${build_root}/mount/
  fi
  rm -rvf ${build_root}/mount
  rm -rvf ${build_root}/system.*

  echo
  echo "Remove unneeded system files"
  for i in ${CLEAN_LIST}
  do
    rm -rvf ${build_root}${i}
  done

  echo
  echo "Patching system files:"
  cp -rvf ${top_root}/system/* ${build_root}/system

  #echo
  #echo "Copying data files:"
  #cp -rvf data ${build_root}/data

  echo
  echo "Add aroma"
  mkdir -p ${build_root}/META-INF/com/google/android/
  cp -vR ${top_root}/device/${device}/aroma/* ${build_root}/META-INF/com/google/android/
  echo
  echo "Add tools"
  cp -vR "tools" "tmp/"
  echo
  echo "Add SuperSU"
  mkdir ${build_root}/supersu
  cp -v ${download_root}/$SU.zip ${build_root}/supersu/supersu.zip

  echo
  echo "Add FreedomOS wallpapers by badboy47"
  mkdir -p ${build_root}/media/wallpaper
  cp -v ${top_root}/media/wallpaper/* ${build_root}/media/wallpaper
  echo
  echo "Add Divine"
  unzip -o "${download_root}/$DIVINE.zip" -d "${build_root}/tools/divine/" >> ${build_log} 2>&1

  echo
  echo "Set Assert in updater-script"
  sed -i.bak "s:!assert!:$ASSERT:" ${build_root}/META-INF/com/google/android/updater-script
  echo
  echo "Set VERSION in aroma"
  sed -i.bak "s:!VERSION!:$VERSION:" ${build_root}/META-INF/com/google/android/aroma-config
  echo
  echo "Set VERSION in aroma"
  sed -i.bak "s:!device!:${device}:" ${build_root}/META-INF/com/google/android/aroma-config
  echo
  echo "Set date in aroma"
  sed -i.bak "s:!date!:$(date +"%d%m%y"):" ${build_root}/META-INF/com/google/android/aroma-config
  echo
  echo "Set date in en.lang"
  sed -i.bak "s:!date!:$(date +"%d%m%y"):" ${build_root}/META-INF/com/google/android/aroma/langs/en.lang
  echo
  echo "Set date in fr.lang"
  sed -i.bak "s:!date!:$(date +"%d%m%y"):" ${build_root}/META-INF/com/google/android/aroma/langs/fr.lang
  rm -rvf ${build_root}/META-INF/com/google/android/aroma-config.bak
  rm -rvf ${build_root}/META-INF/com/google/android/aroma/langs/*.lang.bak

  ## user release build
  if [ "$BUILD" = 1 ];
  then
    cd ${build_root}/
    echo
    echo "Making zip file"
    zip -r9 "FreedomOS-$CODENAME-nevax-$VERSION.zip" * -x "*EMPTY_DIRECTORY*" >> ${build_log} 2>&1
    echo "----"
    cd ${top_root}
    echo
    echo "Copy Unsigned in output folder"
    cp -v ${build_root}/FreedomOS-$CODENAME-nevax-$VERSION.zip ${output_root}/FreedomOS-$CODENAME-nevax-$VERSION.zip >> ${build_log} 2>&1
    echo
    echo "testing zip integrity"
    zip -T ${output_root}/FreedomOS-$CODENAME-nevax-$VERSION.zip >> ${build_log} 2>&1
    echo
    echo "Generating md5 hash"
    openssl md5 "${output_root}/FreedomOS-$CODENAME-nevax-$VERSION.zip" |cut -f 2 -d " " > "${output_root}/FreedomOS-$CODENAME-nevax-$VERSION.zip.md5"
    echo
    echo "SignApk....."
    chmod +x ${top_root}/SignApk/signapk.jar
    java -jar "SignApk/signapk.jar" "SignApk/certificate.pem" "SignApk/key.pk8" "${build_root}/FreedomOS-$CODENAME-nevax-$VERSION.zip" "${output_root}/FreedomOS-$CODENAME-nevax-$VERSION-signed.zip"
    echo
    echo "Generating md5 hash"
    openssl md5 "${output_root}/FreedomOS-$CODENAME-nevax-$VERSION-signed.zip" |cut -f 2 -d " " > "${output_root}/FreedomOS-$CODENAME-nevax-$VERSION-signed.zip.md5"
    #We doesn't test the final, because it doesn't work with the signed zip.
    FINAL_ZIP=FreedomOS-$CODENAME-nevax-$VERSION-signed
  fi

  ## debug build
  if [ "$BUILD" = 2 ];
  then
    cd ${build_root}/
    echo
    echo "Making zip file"
    zip -r1 "FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION.zip" * -x "*EMPTY_DIRECTORY*" >> ${build_log} 2>&1
    echo "----"
    echo
    echo "testing zip integrity"
    zip -T "FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION.zip" >> ${build_log} 2>&1
    echo
    cd ${top_root}
    echo "Move unsigned zip file in output folder"
    mv -v "${build_root}/FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION.zip" "${output_root}/"
    echo
    echo "Generating md5 hash"
    openssl md5 "${output_root}/FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION.zip" |cut -f 2 -d " " > "${output_root}/FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION.zip.md5"
    FINAL_ZIP=FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION
  fi

  echo
  echo "Clean ${build_root} ..."
  rm -rf ${build_root}/*
  echo
  echo "Build finished! You can find the build here: ${output_root}/FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION.zip"
  echo
}
