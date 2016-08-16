!/bin/bash
# FreedomOS device build script
# Author : Nevax
# Contributors : TimVNL, Mavy

function build_oneplus {
  # Building Process

  echo ">> Copying ${ROM_NAME} needed files" 2>&1 | tee -a ${build_log}
  rsync -vr ${rom_root}/${device}/${ROM_NAME}/* ${tmp_root}/ --exclude='system.transfer.list' --exclude='system.new.dat' --exclude='system.patch.dat' --exclude='META-INF/' >> ${build_log} 2>&1
  mkdir -p ${tmp_root}/mount >> ${build_log} 2>&1
  mkdir -p ${tmp_root}/system >> ${build_log} 2>&1

  echo ">> Extracting system.new.dat" 2>&1 | tee -a ${build_log}
  ${build_root}/tools/sdat2img.py ${rom_root}/${device}/${ROM_NAME}/system.transfer.list ${rom_root}/${device}/${ROM_NAME}/system.new.dat ${tmp_root}/system.img >> ${build_log} 2>&1

  echo ">> Mounting system.img" 2>&1 | tee -a ${build_log}
  mount -t ext4 -o loop ${tmp_root}/system.img ${tmp_root}/mount/ >> ${build_log} 2>&1

  echo ">>> Extracting system files" 2>&1 | tee -a ${build_log}
  cp -rvf ${tmp_root}/mount/* ${tmp_root}/system/ >> ${build_log} 2>&1

  echo ">> Cleaning build root " 2>&1 | tee -a ${build_log}
  if mount | grep "${tmp_root}/mount" > /dev/null;
  then
      echo ">> Unmounting system.img" 2>&1 | tee -a ${build_log}
      sleep 2
      umount ${tmp_root}/mount/ >> ${build_log} 2>&1
  fi
  rm -rvf ${tmp_root}/mount >> ${build_log} 2>&1
  rm -rvf ${tmp_root}/system.* >> ${build_log} 2>&1

  echo "> Removing unneeded system files" 2>&1 | tee -a ${build_log}
  for i in ${CLEAN_LIST}
  do
    rm -rvf ${tmp_root}${i} >> ${build_log} 2>&1
  done

  echo
  echo "> Patching system files" 2>&1 | tee -a ${build_log}
  cp -rvf ${assets_root}/system/${ARCH}/* ${tmp_root}/system >> ${build_log} 2>&1

  #echo
  #echo "Copying data files:"
  #cp -rvf data ${tmp_root}/data

  echo ">> Add aroma" 2>&1 | tee -a ${build_log}
  mkdir -p ${tmp_root}/META-INF/com/google/android/ >> ${build_log} 2>&1
  cp -vR ${device_root}/${device}/aroma/* ${tmp_root}/META-INF/com/google/android/ >> ${build_log} 2>&1

  echo ">> Add tools" 2>&1 | tee -a ${build_log}
  mkdir -p ${tmp_root}/tools >> ${build_log} 2>&1
  for i in ${TOOLS_LIST}
  do
    cp -rvf ${assets_root}/tools/${i} ${tmp_root}/tools/ >> ${build_log} 2>&1
  done

  echo ">> Add FreedomOS wallpapers by badboy47" 2>&1 | tee -a ${build_log}
  mkdir -p ${tmp_root}/media/wallpaper >> ${build_log} 2>&1
  cp -v ${assets_root}/media/wallpaper/* ${tmp_root}/media/wallpaper >> ${build_log} 2>&1

  echo ">> Set Assert in updater-script" 2>&1 | tee -a ${build_log}
  sed -i.bak "s:!assert!:$ASSERT:" ${tmp_root}/META-INF/com/google/android/updater-script >> ${build_log} 2>&1

  echo ">> Set VERSION in aroma" 2>&1 | tee -a ${build_log}
  sed -i.bak "s:!VERSION!:$VERSION:" ${tmp_root}/META-INF/com/google/android/aroma-config >> ${build_log} 2>&1

  echo ">> Set device in aroma" 2>&1 | tee -a ${build_log}
  sed -i.bak "s:!device!:${device}:" ${tmp_root}/META-INF/com/google/android/aroma-config >> ${build_log} 2>&1

  echo ">> Set date in aroma" 2>&1 | tee -a ${build_log}
  sed -i.bak "s:!date!:$(date +"%d%m%y"):" ${tmp_root}/META-INF/com/google/android/aroma-config >> ${build_log} 2>&1

  echo ">> Set date in en.lang" 2>&1 | tee -a ${build_log}
  sed -i.bak "s:!date!:$(date +"%d%m%y"):" ${tmp_root}/META-INF/com/google/android/aroma/langs/en.lang >> ${build_log} 2>&1

  echo ">> Set date in fr.lang" 2>&1 | tee -a ${build_log}
  sed -i.bak "s:!date!:$(date +"%d%m%y"):" ${tmp_root}/META-INF/com/google/android/aroma/langs/fr.lang >> ${build_log} 2>&1

  rm -rvf ${tmp_root}/META-INF/com/google/android/aroma-config.bak >> ${build_log} 2>&1
  rm -rvf ${tmp_root}/META-INF/com/google/android/aroma/langs/*.lang.bak >> ${build_log} 2>&1

  ## user release build
  if [ "$BUILD" = 1 ];
  then
    cd ${tmp_root}/

    echo "> Making zip file" 2>&1 | tee -a ${build_log}
    zip -r9 "FreedomOS-$CODENAME-nevax-$VERSION.zip" * -x "*EMPTY_DIRECTORY*" >> ${build_log} 2>&1
    cd ${top_root}

    echo ">> Copy Unsigned in output folder" 2>&1 | tee -a ${build_log}
    cp -v ${tmp_root}/FreedomOS-$CODENAME-nevax-$VERSION.zip ${output_root}/FreedomOS-$CODENAME-nevax-$VERSION.zip >> ${build_log} 2>&1

    echo ">> testing zip integrity" 2>&1 | tee -a ${build_log}
    zip -T ${output_root}/FreedomOS-$CODENAME-nevax-$VERSION.zip >> ${build_log} 2>&1

    echo ">> Generating md5 hash" 2>&1 | tee -a ${build_log}
    openssl md5 "${output_root}/FreedomOS-$CODENAME-nevax-$VERSION.zip" |cut -f 2 -d " " > "${output_root}/FreedomOS-$CODENAME-nevax-$VERSION.zip.md5" >> ${build_log} 2>&1

    echo ">> SignApk....." 2>&1 | tee -a ${build_log}
    chmod +x ${build_root}/bin/signapk.jar >> ${build_log} 2>&1
    java -jar "${build_root}/bin/signapk.jar" "${build_root}/keys/certificate.pem" "${build_root}/keys/key.pk8" "${tmp_root}/FreedomOS-$CODENAME-nevax-$VERSION.zip" "${output_root}/FreedomOS-$CODENAME-nevax-$VERSION-signed.zip" >> ${build_log} 2>&1

    echo ">> Generating md5 hash" 2>&1 | tee -a ${build_log}
    openssl md5 "${output_root}/FreedomOS-$CODENAME-nevax-$VERSION-signed.zip" |cut -f 2 -d " " > "${output_root}/FreedomOS-$CODENAME-nevax-$VERSION-signed.zip.md5" >> ${build_log} 2>&1
    #We doesn't test the final, because it doesn't work with the signed zip.
    FINAL_ZIP=FreedomOS-$CODENAME-nevax-$VERSION-signed

  fi

  ## debug build
  if [ "$BUILD" = 2 ];
  then
    cd ${tmp_root}/

    echo "> Making zip file" 2>&1 | tee -a ${build_log}
    zip -r1 "FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION.zip" * -x "*EMPTY_DIRECTORY*" >> ${build_log} 2>&1

    echo ">> testing zip integrity" 2>&1 | tee -a ${build_log}
    zip -T "FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION.zip" >> ${build_log} 2>&1

    cd ${top_root}
    echo ">> Move unsigned zip file in output folder" 2>&1 | tee -a ${build_log}
    mv -v "${tmp_root}/FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION.zip" "${output_root}/" >> ${build_log} 2>&1

    echo ">> Generating md5 hash"
    openssl md5 "${output_root}/FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION.zip" |cut -f 2 -d " " > "${output_root}/FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION.zip.md5" >> ${build_log} 2>&1
    FINAL_ZIP=FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION
  fi

  echo
  echo "> Cleaning tmp folder" 2>&1 | tee -a ${build_log}
  rm -rvf ${tmp_root} >> ${build_log} 2>&1

  echo ">" 2>&1 | tee -a ${build_log}
  echo "> Build finished! You can find the build here: ${output_root}/FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION.zip" 2>&1 | tee -a ${build_log}
  echo "> You can find the log file here: ${build_log}" 2>&1 | tee -a ${build_log}
}
