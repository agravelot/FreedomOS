#!/bin/bash
# FreedomOS build script
# Author : Nevax
# Contributors : TimVNL, Mavy

#aboot -x boot.img
#tools/abootimg-unpack-initrd initrd.img
#get filecontext

#sdat2img.py system.transfer.list system.new.dat system.img
#mount -t ext4 -o loop system.img output/
#make_ext4fs -T 0 -S file_contexts -l ${SYSTEMIMAGE_PARTITION_SIZE} -a system system_new.img output/
#rimg2sdat system_new.img

function dat_to_dat {
  # Building Process
  echo "> $device build starting now with $BUILD_METHOD build method." 2>&1 | tee -a ${build_log}

  echo ">> Copying ${ROM_NAME} needed files" 2>&1 | tee -a ${build_log}
  rsync -vr ${rom_root}/${device}/${ROM_NAME}/* ${tmp_root}/ --exclude='system.transfer.list' --exclude='system.new.dat' --exclude='system.patch.dat' --exclude='META-INF/' >> ${build_log} 2>&1
  mkdir -p ${tmp_root}/mount >> ${build_log} 2>&1
  mkdir -p ${tmp_root}/system >> ${build_log} 2>&1

  mkdir -p ${tmp_root}/boot
  cp ${tmp_root}/boot.img ${tmp_root}/boot/boot.img >> ${build_log} 2>&1
  cd ${tmp_root}/boot >> ${build_log} 2>&1
  echo ">>> Extracting kernel" 2>&1 | tee -a ${build_log}
  ${build_root}/tools/${HOST_ARCH}/unpackbootimg -i boot.img -o . >> ${build_log} 2>&1
  echo ">>>> Extracting ramdisk" 2>&1 | tee -a ${build_log}
  ${build_root}/tools/${HOST_ARCH}/abootimg-unpack-initrd boot.img-ramdisk.gz >> ${build_log} 2>&1
  echo ">>>> Getting file_contexts" 2>&1 | tee -a ${build_log}
  cp ${tmp_root}/boot/ramdisk/file_contexts ${tmp_root}/ >> ${build_log} 2>&1

  cd ${tmp_root}
  echo ">> Extracting system.new.dat" 2>&1 | tee -a ${build_log}
  ${build_root}/tools/sdat2img.py ${rom_root}/${device}/${ROM_NAME}/system.transfer.list ${rom_root}/${device}/${ROM_NAME}/system.new.dat ${tmp_root}/system.img >> ${build_log} 2>&1

  echo ">> Mounting ext4 system.img" 2>&1 | tee -a ${build_log}
  mount -t ext4 -o loop ${tmp_root}/system.img ${tmp_root}/mount/ >> ${build_log} 2>&1

  echo ">>> Removing unneeded system files" 2>&1 | tee -a ${build_log}
  for i in ${CLEAN_SYSTEM_LIST}
  do
    rm -rvf ${tmp_root}/mount/${i} >> ${build_log} 2>&1
  done

  echo ">>> Patching system files" 2>&1 | tee -a ${build_log}
  for i in ${ADD_SYSTEM_LIST}
  do
    mkdir -p ${tmp_root}/mount/${i}  >> ${build_log} 2>&1
    cp -rvf ${assets_root}/system/${TARGET_ARCH}/${i} ${tmp_root}/mount/${i} >> ${build_log} 2>&1
  done

  echo ">> Building new ext4 system" 2>&1 | tee -a ${build_log}
  ${build_root}/tools/${HOST_ARCH}/make_ext4fs -T 0 -S file_contexts -l ${SYSTEMIMAGE_PARTITION_SIZE} -a system system_new.img mount/ >> ${build_log} 2>&1

  echo ">> Converting ext4 to dat file" 2>&1 | tee -a ${build_log}
  ${build_root}/tools/rimg2sdat system_new.img >> ${build_log} 2>&1

  touch ${tmp_root}/system.patch.dat

  echo "> Clean unneeded tmp files" 2>&1 | tee -a ${build_log}
  if mount | grep "${tmp_root}/mount" > /dev/null;
  then
    echo ">> Unmount rom" 2>&1 | tee -a ${build_log}
    umount ${tmp_root}/mount/ >> ${build_log} 2>&1
  fi
  echo ">> Deleting files" 2>&1 | tee -a ${build_log}
  rm -rvf ${tmp_root}/mount >> ${build_log} 2>&1
  rm -rvf ${tmp_root}/system.img >> ${build_log} 2>&1
  rm -rvf ${tmp_root}/system_new.img >> ${build_log} 2>&1
  rm -rvf ${tmp_root}/file_contexts >> ${build_log} 2>&1
  rm -rvf ${tmp_root}/boot >> ${build_log} 2>&1
  rm -rvf ${tmp_root}/system >> ${build_log} 2>&1
}
