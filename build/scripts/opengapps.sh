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

function build_opengapps() {

  # Set unneeded Open Gapps files
  RM_OPENGAPPS="
  Core/setupwizardtablet-all.tar.xz
  GApps/books-all.tar.xz
  GApps/earth-arm64.tar.xz
  GApps/googleplus-arm.tar.xz
  GApps/keep-arm64.tar.xz
  GApps/movies-arm.tar.xz
  GApps/music-all.tar.xz
  GApps/projectfi-all.tar.xz
  GApps/slides-arm64.tar.xz
  GApps/maps-arm64.tar.xz
  GApps/street-arm.tar.xz
  GApps/docs-arm64.tar.xz
  GApps/fitness-all.tar.xz
  GApps/sheets-arm64.tar.xz
  GApps/newswidget-all.tar.xz
  GApps/newsstand-all.tar.xz
  GApps/translate-arm.tar.xz
  GApps/zhuyin-arm64.tar.xz
  GApps/dmagent-all.tar.xz
  GApps/pinyin-arm64.tar.xz
  GApps/gcs-all.tar.xz
  GApps/indic-arm64.tar.xz
  GApps/japanese-arm64.tar.xz
  GApps/korean-arm64.tar.xz
  GApps/vrservice-arm64.tar.xz
  GApps/moviesvrmode-arm.tar.xz
  GApps/photosvrmode-arm64.tar.xz
  GApps/googlenow-all.tar.xz
  "

  echo "> Building FreedomOS OpenGApps" 2>&1 | tee -a ${build_log}
  # Create needed folders
  mkdir -p ${tmp_root}/tools/opengapps_tmp/ >> ${build_log} 2>&1
  mkdir -p ${tmp_root}/tools/opengapps/ >> ${build_log} 2>&1
  # Copy OpenGapps files from repo
  cp -rvf ${download_root}/freedomos_opengapps/${GAPPS_TYPE}/${GAPPS_PLATFORM}/${GAPPS_ANDROID}/* -d ${tmp_root}/tools/opengapps_tmp/ >> ${build_log} 2>&1
  # Get the gapps-remove.txt list
  cp -vf ${tmp_root}/tools/opengapps_tmp/gapps-remove.txt ${tmp_root}/tools/gapps-remove.txt >> ${build_log} 2>&1
  # Remove all entries for android permisions
  sed -i '/permissions/d' ${tmp_root}/tools/gapps-remove.txt >> ${build_log} 2>&1
  # Remove all "/system/" from gapps-remove.txt file
  sed -i 's/\/system\///g' ${tmp_root}/tools/gapps-remove.txt >> ${build_log} 2>&1

  # Add gapps-remove.txt to the CLEAN_SYSTEM_LIST variable
  CLEAN_SYSTEM_LIST+="$(<${tmp_root}/tools/gapps-remove.txt)"

  # Add OPInCallUI to the remove list if Google Dialer is installed
  sed -i 's/FineOSDialer/OPInCallUI/g' ${tmp_root}/tools/opengapps_tmp/installer.sh >> ${build_log} 2>&1
  # Disable RAM clear after installation, the installer will do that later.
  sed -i '/-maxdepth 0 ! -path/d' ${tmp_root}/tools/opengapps_tmp/installer.sh >> ${build_log} 2>&1
  # Remove all set progress, to let FreedomOS aroma controller it
  sed -i '/set_progress/d' ${tmp_root}/tools/opengapps_tmp/installer.sh >> ${build_log} 2>&1
  # Remove ugly Opengapps header (sorry it's very ugly with aroma)
  # TODO: Do not use line numbers
  sed -ie '1051,1066d;' ${tmp_root}/tools/opengapps_tmp/installer.sh >> ${build_log} 2>&1

  # Remove all the unneeded files
  for i in ${RM_OPENGAPPS}
  do
    rm -rvf ${tmp_root}/tools/opengapps_tmp/${i} >> ${build_log} 2>&1
  done

  cd ${tmp_root}/tools/opengapps_tmp/
  # Make new zip
  zip -r9 ${tmp_root}/tools/opengapps/opengapps.zip * >> ${build_log} 2>&1
  cd - >> ${build_log}
  rm -rvf ${tmp_root}/tools/opengapps_tmp/ >> ${build_log} 2>&1
}
