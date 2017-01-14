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

function build_busybox() {
    echo ">> Building busybox" | tee -a ${build_log}
    mkdir -p ${tmp_root}/tools/busybox_installer/ >> ${build_log} 2>&1
    mkdir -p ${tmp_root}/tools/busybox_installer_tmp/ >> ${build_log} 2>&1
    cp -rvf ${busybox_repo}/* ${tmp_root}/tools/busybox_installer_tmp/ >> ${build_log} 2>&1
    # remove some "=" so fit with the aroma screen
    sed -i 's/================================================/============================================/g' ${tmp_root}/tools/busybox_installer_tmp/META-INF/com/google/android/update-binary >> ${build_log} 2>&1
    # Remove ui_print "Unmounting /system --"
    sed -i '/Unmounting \/system/d' ${tmp_root}/tools/busybox_installer_tmp/META-INF/com/google/android/update-binary >> ${build_log} 2>&1
    # Remove unmount system partition
    sed -i '/umount \/system/d' ${tmp_root}/tools/busybox_installer_tmp/META-INF/com/google/android/update-binary >> ${build_log} 2>&1
    cd ${tmp_root}/tools/busybox_installer_tmp/ >> ${build_log} 2>&1
    # Making nes zip
    zip -r9 busybox.zip * >> ${build_log} 2>&1
    cd - >> ${build_log} 2>&1
    mv ${tmp_root}/tools/busybox_installer_tmp/busybox.zip ${tmp_root}/tools/busybox_installer/ >> ${build_log} 2>&1
    rm -rvf ${tmp_root}/tools/busybox_installer_tmp/ >> ${build_log} 2>&1
}
