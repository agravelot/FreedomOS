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

# FreedomOS device build script
# Contributors : TimVNL, Mavy

function add_files {

  echo ">> Add META-INF files" 2>&1 | tee -a ${build_log}
  mkdir -p ${tmp_root}/META-INF/com/google/android/ >> ${build_log} 2>&1
  cp -vrf ${device_root}/${device}/aroma/* ${tmp_root}/META-INF/com/google/android/ >> ${build_log} 2>&1

  echo ">>> Add aroma bin" 2>&1 | tee -a ${build_log}
  cp -vf ${assets_root}/META-INF/update-binary/${AROMA_VERSION}/update-binary ${tmp_root}/META-INF/com/google/android/ >> ${build_log} 2>&1

  echo ">>> Add update-binary bin" 2>&1 | tee -a ${build_log}
  cp -vf ${assets_root}/META-INF/update-binary-installer/${BUILD_METHOD}/update-binary-installer ${tmp_root}/META-INF/com/google/android/ >> ${build_log} 2>&1

  echo ">>> Add aroma config files" 2>&1 | tee -a ${build_log}
  for i in ${aroma_list}
  do
    mkdir -p ${tmp_root}/META-INF/com/google/android/aroma/
    cp -rvf ${assets_root}/META-INF/aroma/${i} ${tmp_root}/META-INF/com/google/android/aroma/ >> ${build_log} 2>&1
  done

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
  sed -i "s:!assert!:$ASSERT:" ${tmp_root}/META-INF/com/google/android/updater-script >> ${build_log} 2>&1

  if [ ! -z $ASSERT_2 ];
  then
    echo ">> Set Assert in updater-script" 2>&1 | tee -a ${build_log}
    sed -i "s:!assert2!:$ASSERT_2:" ${tmp_root}/META-INF/com/google/android/updater-script >> ${build_log} 2>&1
  fi

  echo ">> Set VERSION in aroma" 2>&1 | tee -a ${build_log}
  sed -i "s:!version!:$VERSION:" ${tmp_root}/META-INF/com/google/android/aroma-config >> ${build_log} 2>&1

  echo ">> Set device in aroma" 2>&1 | tee -a ${build_log}
  sed -i "s:!device!:${device}:" ${tmp_root}/META-INF/com/google/android/aroma-config >> ${build_log} 2>&1

  echo ">> Set date in aroma" 2>&1 | tee -a ${build_log}
  sed -i "s:!date!:$(date +"%d%m%y"):" ${tmp_root}/META-INF/com/google/android/aroma-config >> ${build_log} 2>&1

  echo ">> Set date in en.lang" 2>&1 | tee -a ${build_log}
  sed -i "s:!date!:$(date +"%d%m%y"):" ${tmp_root}/META-INF/com/google/android/aroma/langs/en.lang >> ${build_log} 2>&1

  echo ">> Set date in fr.lang" 2>&1 | tee -a ${build_log}
  sed -i "s:!date!:$(date +"%d%m%y"):" ${tmp_root}/META-INF/com/google/android/aroma/langs/fr.lang >> ${build_log} 2>&1

  echo ">> Set VERSION in kernel" 2>&1 | tee -a ${build_log}
  sed -i "s:!version!:${ZIP_NAME}-$VERSION:" ${tmp_root}/tools/kernel/boot/editramdisk.sh >> ${build_log} 2>&1
}
