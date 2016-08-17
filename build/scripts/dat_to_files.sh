#!/bin/bash
# FreedomOS device build script
# Author : Nevax
# Contributors : TimVNL, Mavy

function dat_to_files {
  
  # Building Process
  echo "> $device build starting now with $BUILD_METHOD build method." 2>&1 | tee -a ${build_log}

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

  #Make zip

  echo "> Cleaning tmp folder" 2>&1 | tee -a ${build_log}
  rm -rvf ${tmp_root} >> ${build_log} 2>&1

  echo ">" 2>&1 | tee -a ${build_log}
  echo "> Build finished! You can find the build here: ${output_root}/FreedomOS-$CODENAME-$BUILD_TYPE-$VERSION.zip" 2>&1 | tee -a ${build_log}
  echo "> You can find the log file here: ${build_log}" 2>&1 | tee -a ${build_log}
}
