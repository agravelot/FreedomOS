#!/bin/bash
# Copyright 2017 Antoine GRAVELOT
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

function build_arise4magisk() {
  echo ">> Building ARISE4Magisk module" | tee -a ${build_log}
  mv ${tmp_root}/tools/arise4magisk ${tmp_root}/tools/arise4magisk_tmp
  mkdir -p ${tmp_root}/tools/arise4magisk >> ${build_log} 2>&1
  cd ${tmp_root}/tools/arise4magisk_tmp >> ${build_log} 2>&1
  zip -r9 arise4magisk.zip * >> ${build_log} 2>&1
  cd - >> ${build_log} 2>&1
  mv ${tmp_root}/tools/arise4magisk_tmp/arise4magisk.zip ${tmp_root}/tools/arise4magisk/
  rm -rvf ${tmp_root}/tools/arise4magisk_tmp >> ${build_log} 2>&1
}
