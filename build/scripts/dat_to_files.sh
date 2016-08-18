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
  for i in ${CLEAN_SYSTEM_LIST}
  do
    rm -rvf ${tmp_root}/system/${i} >> ${build_log} 2>&1
  done

  echo "> Patching system files" 2>&1 | tee -a ${build_log}
  for i in ${ADD_SYSTEM_LIST}
  do
    mkdir -p ${tmp_root}/system/${i}
    cp -rvf ${assets_root}/system/${ARCH}/${i} ${tmp_root}/system/${i} >> ${build_log} 2>&1
  done

}
