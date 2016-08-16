function build_oneplus {
  # Building Process

  echo ">> Copying ${ROM_NAME} needed files" 2>&1 | tee -a ${build_log}
  rsync -vr ${rom_root}/${device}/${ROM_NAME}/* ${build_root}/ --exclude='system.transfer.list' --exclude='system.new.dat' --exclude='system.patch.dat' --exclude='META-INF/' >> ${build_log} 2>&1
  mkdir -p ${build_root}/mount >> ${build_log} 2>&1
  mkdir -p ${build_root}/system >> ${build_log} 2>&1

  echo ">> Extracting system.new.dat" 2>&1 | tee -a ${build_log}
  ${download_root}/sdat2img.py ${rom_root}/${device}/${ROM_NAME}/system.transfer.list ${rom_root}/${device}/${ROM_NAME}/system.new.dat ${build_root}/system.img >> ${build_log} 2>&1

  echo ">> Mounting system.img" 2>&1 | tee -a ${build_log}
  mount -t ext4 -o loop ${build_root}/system.img ${build_root}/mount/ >> ${build_log} 2>&1

  echo ">>> Extracting system files" 2>&1 | tee -a ${build_log}
  cp -rvf ${build_root}/mount/* ${build_root}/system/ >> ${build_log} 2>&1

  echo ">> Cleaning build root " 2>&1 | tee -a ${build_log}
  if mount | grep "${build_root}/mount" > /dev/null;
  then
      echo ">> Unmounting system.img" 2>&1 | tee -a ${build_log}
      sleep 2
      umount ${build_root}/mount/ >> ${build_log} 2>&1
  fi
  rm -rvf ${build_root}/mount >> ${build_log} 2>&1
  rm -rvf ${build_root}/system.* >> ${build_log} 2>&1

  echo "> Removing unneeded system files" 2>&1 | tee -a ${build_log}
  for i in ${CLEAN_LIST}
  do
    rm -rvf ${build_root}${i} >> ${build_log} 2>&1
  done

  echo
  echo "> Patching system files" 2>&1 | tee -a ${build_log}
  cp -rvf ${top_root}/system/* ${build_root}/system >> ${build_log} 2>&1

  #echo
  #echo "Copying data files:"
  #cp -rvf data ${build_root}/data

  echo ">> Add aroma" 2>&1 | tee -a ${build_log}
  mkdir -p ${build_root}/META-INF/com/google/android/ >> ${build_log} 2>&1
  cp -vR ${top_root}/device/${device}/aroma/* ${build_root}/META-INF/com/google/android/ >> ${build_log} 2>&1

  echo ">> Add tools" 2>&1 | tee -a ${build_log}
  cp -vR "${top_root}/tools" ${build_root} >> ${build_log} 2>&1

  echo ">> Add SuperSU" 2>&1 | tee -a ${build_log}
  mkdir ${build_root}/supersu >> ${build_log} 2>&1
  cp -v ${download_root}/$SU.zip ${build_root}/supersu/supersu.zip >> ${build_log} 2>&1

  echo ">> Add FreedomOS wallpapers by badboy47" 2>&1 | tee -a ${build_log}
  mkdir -p ${build_root}/media/wallpaper >> ${build_log} 2>&1
  cp -v ${top_root}/media/wallpaper/* ${build_root}/media/wallpaper >> ${build_log} 2>&1

  echo ">> Add Divine ..." 2>&1 | tee -a ${build_log}
  mkdir -p ${build_root}/tools/divine >> ${build_log} 2>&1
  unzip -o "${download_root}/$DIVINE.zip" -d "${build_root}/tools/divine/" >> ${build_log} 2>&1


  echo ">> Set Assert in updater-script" 2>&1 | tee -a ${build_log}
  sed -i.bak "s:!assert!:$ASSERT:" ${build_root}/META-INF/com/google/android/updater-script >> ${build_log} 2>&1

  echo ">> Set VERSION in aroma" 2>&1 | tee -a ${build_log}
  sed -i.bak "s:!VERSION!:$VERSION:" ${build_root}/META-INF/com/google/android/aroma-config >> ${build_log} 2>&1

  echo ">> Set device in aroma" 2>&1 | tee -a ${build_log}
  sed -i.bak "s:!device!:${device}:" ${build_root}/META-INF/com/google/android/aroma-config >> ${build_log} 2>&1

  echo ">> Set date in aroma" 2>&1 | tee -a ${build_log}
  sed -i.bak "s:!date!:$(date +"%d%m%y"):" ${build_root}/META-INF/com/google/android/aroma-config >> ${build_log} 2>&1

  echo ">> Set date in en.lang" 2>&1 | tee -a ${build_log}
  sed -i.bak "s:!date!:$(date +"%d%m%y"):" ${build_root}/META-INF/com/google/android/aroma/langs/en.lang >> ${build_log} 2>&1

  echo ">> Set date in fr.lang" 2>&1 | tee -a ${build_log}
  sed -i.bak "s:!date!:$(date +"%d%m%y"):" ${build_root}/META-INF/com/google/android/aroma/langs/fr.lang >> ${build_log} 2>&1

  rm -rvf ${build_root}/META-INF/com/google/android/aroma-config.bak >> ${build_log} 2>&1
  rm -rvf ${build_root}/META-INF/com/google/android/aroma/langs/*.lang.bak >> ${build_log} 2>&1

  ## user release build
  if [ "$BUILD" = 1 ];
  then
    cd ${build_root}/

    echo "> Making zip file" 2>&1 | tee -a ${build_log}
    zip -r9 "FreedomOS-$CODENAME-nevax-$VERSION.zip" * -x "*EMPTY_DIRECTORY*" >> ${build_log} 2>&1
    cd ${top_root}

    echo ">> Copy Unsigned in output folder" 2>&1 | tee -a ${build_log}
    cp -v ${build_root}/FreedomOS-$CODENAME-nevax-$VERSION.zip ${output_root}/FreedomOS-$CODENAME-nevax-$VERSION.zip >> ${build_log} 2>&1

    echo ">> testing zip integrity" 2>&1 | tee -a ${build_log}
    zip -T ${output_root}/FreedomOS-$CODENAME-nevax-$VERSION.zip >> ${build_log} 2>&1

    echo ">> Generating md5 hash" 2>&1 | tee -a ${build_log}
    openssl md5 "${output_root}/FreedomOS-$CODENAME-nevax-$VERSION.zip" |cut -f 2 -d " " > "${output_root}/FreedomOS-$CODENAME-nevax-$VERSION.zip.md5" >> ${build_log} 2>&1

    echo ">> SignApk....." 2>&1 | tee -a ${build_log}
    chmod +x ${top_root}/SignApk/signapk.jar >> ${build_log} 2>&1
    java -jar "SignApk/signapk.jar" "SignApk/certificate.pem" "SignApk/key.pk8" "${build_root}/FreedomOS-$CODENAME-nevax-$VERSION.zip" "${output_root}/FreedomOS-$CODENAME-nevax-$VERSION-signed.zip" >> ${build_log} 2>&1

    echo ">> Generating md5 hash" 2>&1 | tee -a ${build_log}
    openssl md5 "${output_root}/FreedomOS-$CODENAME-nevax-$VERSION-signed.zip" |cut -f 2 -d " " > "${output_root}/FreedomOS-$CODENAME-nevax-$VERSION-signed.zip.md5" >> ${build_log} 2>&1
    #We doesn't test the final, because it doesn't work with the signed zip.
    FINAL_ZIP=FreedomOS-$CODENAME-nevax-$VERSION-signed

  fi

  ## debug build
  if [ "$BUILD" = 2 ];
  then
    cd ${build_root}/

    echo "> Making zip file" 2>&1 | tee -a ${build_log}
    zip -r1 "FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION.zip" * -x "*EMPTY_DIRECTORY*" >> ${build_log} 2>&1

    echo ">> testing zip integrity" 2>&1 | tee -a ${build_log}
    zip -T "FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION.zip" >> ${build_log} 2>&1

    cd ${top_root}
    echo ">> Move unsigned zip file in output folder" 2>&1 | tee -a ${build_log}
    mv -v "${build_root}/FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION.zip" "${output_root}/" >> ${build_log} 2>&1

    echo ">> Generating md5 hash"
    openssl md5 "${output_root}/FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION.zip" |cut -f 2 -d " " > "${output_root}/FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION.zip.md5" >> ${build_log} 2>&1
    FINAL_ZIP=FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION
  fi

  echo
  echo "> Cleaning build root" 2>&1 | tee -a ${build_log}
  rm -rvf ${build_root}/* >> ${build_log} 2>&1

  echo ">" 2>&1 | tee -a ${build_log}
  echo "> Build finished! You can find the build here: ${output_root}/FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION.zip" 2>&1 | tee -a ${build_log}
  echo "> You can find the log file here: ${build_log}" 2>&1 | tee -a ${build_log}
}
