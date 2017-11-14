#!/bin/bash
# Copyright 2016 Antoine GRAVELOT
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# FreedomOS build script
# Contributors : TimVNL, Mavy

function dat_to_dat {
  # Building Process
  echo "> $device build starting now with $BUILD_METHOD build method." 2>&1 | tee -a ${build_log}

  echo ">> Copying ${ROM_NAME} needed files" 2>&1 | tee -a ${build_log}
  cp -rv ${rom_root}/${device}/${ROM_NAME}/{RADIO/,firmware-update/,boot.img} ${tmp_root}/ >> ${build_log} 2>&1
  mkdir -p ${tmp_root}/mount >> ${build_log} 2>&1
  mkdir -p ${tmp_root}/system >> ${build_log} 2>&1

  mkdir -p ${tmp_root}/boot
  cp ${tmp_root}/boot.img ${tmp_root}/boot/boot.img >> ${build_log} 2>&1
  cd ${tmp_root}/boot >> ${build_log} 2>&1
  echo ">>> Extracting kernel" 2>&1 | tee -a ${build_log}
  ${build_root}/tools/${HOST_ARCH}/unpackbootimg -i boot.img -o . >> ${build_log} 2>&1
  echo ">>>> Extracting ramdisk" 2>&1 | tee -a ${build_log}
  ${build_root}/tools/${HOST_ARCH}/abootimg-unpack-initrd boot.img-ramdisk.gz >> ${build_log} 2>&1

  if [[ -f ${tmp_root}/boot/ramdisk/file_contexts ]]; then
    # For Android Lollipop
    echo ">>>> Getting file_contexts" 2>&1 | tee -a ${build_log}
    cp ${tmp_root}/boot/ramdisk/file_contexts ${tmp_root}/ >> ${build_log} 2>&1
  elif [[ -f ${tmp_root}/boot/ramdisk/file_contexts.bin ]]; then
     # For Android Nougat
    echo ">>>> Getting file_contexts.bin" 2>&1 | tee -a ${build_log}
    cp ${tmp_root}/boot/ramdisk/file_contexts.bin ${tmp_root}/ >> ${build_log} 2>&1
    echo ">>>>> Convert into file_contexts" 2>&1 | tee -a ${build_log}
    contest=$(strings ${tmp_root}/file_contexts.bin | sed -e '/^u:/,/\//!d' | grep -v "abcd") >> ${build_log} 2>&1
		paste -d '\t' <(echo "$contest" | grep -v "^u:") <(echo "$contest" | grep "^u:") | grep -v "S2RP\|ERCP" >> ${tmp_root}/file_contexts
    rm -vf ${tmp_root}/file_contexts.bin >> ${build_log} 2>&1
  elif [[ -f ${tmp_root}/boot/ramdisk/plat_file_contexts ]]; then
      # For Android Oreo
      CONTEXTS_LIST=" 
      nonplat_service_contexts
      plat_property_contexts
      nonplat_property_contexts
      plat_file_contexts
      nonplat_file_contexts
      "
      # plat_service_contexts
      # vndservice_contexts
      # nonplat_hwservice_contexts
     # nonplat_service_contexts
      # plat_service_contexts
      
      # nonplat_service_contexts

      for i in $CONTEXTS_LIST; do
        if [[ -f ${tmp_root}/boot/ramdisk/$i ]]; then
          cat ${tmp_root}/boot/ramdisk/${i} >> ${tmp_root}/file_contexts
        else
          die "Context file '$i' not found!" "55"
        fi
      done

  else
    die "No file_contexts fond" "150"
  fi

  cd ${tmp_root}
  echo ">> Extracting system.new.dat" 2>&1 | tee -a ${build_log}
  ${sdat2img_repo}/sdat2img.py ${rom_root}/${device}/${ROM_NAME}/system.transfer.list ${rom_root}/${device}/${ROM_NAME}/system.new.dat ${tmp_root}/system.img >> ${build_log} 2>&1

  echo ">> Mounting ext4 system.img" 2>&1 | tee -a ${build_log}
  mount -t ext4 -o loop ${tmp_root}/system.img ${tmp_root}/mount/ >> ${build_log} 2>&1

  if [ ! -z "${CLEAN_SYSTEM_LIST}" ]; then
    echo ">>> Removing unneeded system files" 2>&1 | tee -a ${build_log}
    for i in ${CLEAN_SYSTEM_LIST}
    do
      rm -rvf ${tmp_root}/mount/${i} >> ${build_log} 2>&1
    done
  fi

  if [ ! -z "${ADD_SYSTEM_COMMON_LIST}" ]; then
    echo ">>> Patching system files [COMMON]" 2>&1 | tee -a ${build_log}
    for i in ${ADD_SYSTEM_COMMON_LIST}
    do
      cp -vf ${assets_root}/system/common/${i} ${tmp_root}/mount/${i} >> ${build_log} 2>&1
    done
  fi

  if [ ! -z "${ADD_SYSTEM_LIST}" ]; then
    echo ">>> Patching system files [${TARGET_ARCH}]" 2>&1 | tee -a ${build_log}
    for i in ${ADD_SYSTEM_LIST}
    do
      mkdir -p ${tmp_root}/mount/${i}  >> ${build_log} 2>&1
      cp -rvf ${assets_root}/system/${TARGET_ARCH}/${i}/* ${tmp_root}/mount/${i} >> ${build_log} 2>&1
    done
  fi

  if [ ! -z "${ADD_DATA_LIST}" ]; then
    echo ">>> Patching system files [${TARGET_ARCH}]" 2>&1 | tee -a ${build_log}
    for i in ${ADD_DATA_LIST}
    do
      mkdir -p ${tmp_root}/data/${i}  >> ${build_log} 2>&1
      cp -rvf ${assets_root}/system/${TARGET_ARCH}/${i}/* ${tmp_root}/data/${i} >> ${build_log} 2>&1
    done
  fi

  if [ ! -z "${PATCH_SYSYEM}" ]; then
    for i in ${PATCH_SYSYEM}
    do
      echo ">>> Patching system [${i}]" 2>&1 | tee -a ${build_log}
      cp -rvf ${assets_root}/system/${i}/* ${tmp_root}/mount/ >> ${build_log} 2>&1
    done
  fi

  if [ ! -z "${BOOTANIMATION}" ]; then
    echo ">>> Adding bootanimation ${BOOTANIMATION}" 2>&1 | tee -a ${build_log}
    mkdir -p ${tmp_root}/bootanimation >> ${build_log} 2>&1
    cp -rvf ${assets_root}/media/bootanimation/${BOOTANIMATION}/* ${tmp_root}/bootanimation >> ${build_log} 2>&1
    cd ${tmp_root}/bootanimation >> ${build_log} 2>&1
    zip ${tmp_root}/bootanimation/bootanimation.zip * -r0 >> ${build_log} 2>&1
    cd - >> ${build_log} 2>&1
    mv -fv  ${tmp_root}/bootanimation/bootanimation.zip ${tmp_root}/mount/media/ >> ${build_log} 2>&1
    rm -rvf ${tmp_root}/bootanimation >> ${build_log} 2>&1
  fi

  echo ">> Set rom version in build.prop" 2>&1 | tee -a ${build_log}
  sed -i "s/ro.rom.version=.*/ro.rom.version=${ZIP_NAME}-${CODENAME}-${BUILD_TYPE}-${VERSION}/" ${tmp_root}/mount/build.prop
  sed -i "s/ro.oxygen.version=.*/ro.oxygen.version=${ZIP_NAME}-${CODENAME}-${BUILD_TYPE}-${VERSION}/" ${tmp_root}/mount/build.prop

  echo ">> Building new ext4 system" 2>&1 | tee -a ${build_log}
  ${build_root}/tools/${HOST_ARCH}/make_ext4fs_${ANDROID_VERSION} -T 0 -S file_contexts -l ${SYSTEMIMAGE_PARTITION_SIZE} -a system system_new.img mount/ >> ${build_log} 2>&1

  echo ">> Converting ext4 raw image to sparse image" 2>&1 | tee -a ${build_log}
  ${build_root}/tools/${HOST_ARCH}/img2simg system_new.img system_new_sparse.img

  echo ">> Converting sparse image to sparse data" 2>&1 | tee -a ${build_log}
  ${build_root}/scripts/img2sdat.sh ${tmp_root}/system_new_sparse.img . 4 >> ${build_log} 2>&1

  echo "> Clean unneeded tmp files" 2>&1 | tee -a ${build_log}
  if mount | grep "${tmp_root}/mount" > /dev/null;
  then
    echo ">> Unmount rom" 2>&1 | tee -a ${build_log}
    umount ${tmp_root}/mount/ >> ${build_log} 2>&1
  fi
  echo ">> Deleting files" 2>&1 | tee -a ${build_log}
  rm -rvf ${tmp_root}/mount >> ${build_log} 2>&1
  rm -rvf ${tmp_root}/system.img >> ${build_log} 2>&1
  rm -rvf ${tmp_root}/system_new* >> ${build_log} 2>&1
  rm -rvf ${tmp_root}/boot >> ${build_log} 2>&1
  rm -rvf ${tmp_root}/system >> ${build_log} 2>&1
}
