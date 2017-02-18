#!/bin/bash
# Copyright 2016-2017 Antoine GRAVELOT
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
# Contributors :

function build_arise() {

  remove_list="
  custom/Esira.apk
  modules/dolby
  smeejaytee
  am3d
  v4a_xhifi
  "

  echo ">> Building ARISE" | tee -a ${build_log}
  cd ${tmp_root}/tools/arise/ >> ${build_log} 2>&1
  sed -i '/\/tmp\/\*/d' ${tmp_root}/tools/arise/META-INF/com/google/android/update-binary >> ${build_log} 2>&1
  sed -i '/exit 0/d' ${tmp_root}/tools/arise/META-INF/com/google/android/update-binary >> ${build_log} 2>&1

  for i in $remove_list; do
    rm -rf ${tmp_root}/tools/arise/$i
  done

  echo "rm -rf /data/data/dk.icesound.icepower" >> ${tmp_root}/tools/arise/META-INF/com/google/android/update-binary
  echo "rm -rf /data/data/com.arkamys.audio" >> ${tmp_root}/tools/arise/META-INF/com/google/android/update-binary
  echo "rm -rf /data/data/com.audlabs.viperfx" >> ${tmp_root}/tools/arise/META-INF/com/google/android/update-binary
  echo "rm -rf /data/data/com.fihtdc.am3dfx" >> ${tmp_root}/tools/arise/META-INF/com/google/android/update-binary
  echo "exit 0" >> ${tmp_root}/tools/arise/META-INF/com/google/android/update-binary
  zip -r9 arise.zip * -x install.sh >> ${build_log} 2>&1
  cd - >> ${build_log} 2>&1
  rm -rvf ${tmp_root}/tools/arise/*/ >> ${build_log} 2>&1
}
