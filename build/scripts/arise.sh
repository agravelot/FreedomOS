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
# Contributors :

function build_arise() {
  cd ${tmp_root}/tools/arise/ >> ${build_log} 2>&1
  sed -i '/ui_print "/d' ${tmp_root}/tools/arise/META-INF/com/google/android/update-binary >> ${build_log} 2>&1
  sed -i '/sleep/d' ${tmp_root}/tools/arise/META-INF/com/google/android/update-binary >> ${build_log} 2>&1
  zip -r9 arise.zip * -x install.sh >> ${build_log} 2>&1
  cd - >> ${build_log} 2>&1
  rm -rvf ${tmp_root}/tools/arise/*/ >> ${build_log} 2>&1
}
