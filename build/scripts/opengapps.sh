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
  setupwizardtablet
  books
  earth
  googleplus
  keep
  movies
  music
  projectfi
  slides
  maps
  street
  docs
  fitness
  sheets
  newswidget
  newsstand
  translate
  zhuyin
  dmagent
  pinyin
  gcs
  indic
  japanese
  korean
  vrservice
  moviesvrmode
  photosvrmode
  googlenow
  dmagent
  hangouts
  storagemanagergoogle
  clockgoogle
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

  # Remove ugly Opengapps header (sorry it's very ugly with aroma)
  logo_start=$(grep -nr '####' ${tmp_root}/tools/opengapps_tmp/installer.sh | gawk '{print $1}' FS=":" | head -1)
  logo_end=$(grep -nr '####' ${tmp_root}/tools/opengapps_tmp/installer.sh | gawk '{print $1}' FS=":" | tail -1)
  logo_end=$((logo_end+1))
  sed -ie "$logo_start,$logo_end d;" ${tmp_root}/tools/opengapps_tmp/installer.sh >> ${build_log} 2>&1
  # Add OPInCallUI to the remove list if Google Dialer is installed
  sed -i 's/FineOSDialer/OPInCallUI/g' ${tmp_root}/tools/opengapps_tmp/installer.sh >> ${build_log} 2>&1
  # Disable /tmp clear after installation, the installer will do that later for us.
  sed -i '/-maxdepth 0 ! -path/d' ${tmp_root}/tools/opengapps_tmp/installer.sh >> ${build_log} 2>&1
  # Remove all set progress, to let FreedomOS aroma controller it
  sed -i '/set_progress/d' ${tmp_root}/tools/opengapps_tmp/installer.sh >> ${build_log} 2>&1
  sed -i '/- Mounting/d' ${tmp_root}/tools/opengapps_tmp/installer.sh >> ${build_log} 2>&1
  sed -i '/- Gathering device & ROM information/d' ${tmp_root}/tools/opengapps_tmp/installer.sh >> ${build_log} 2>&1
  sed -i '/- Performing system space calculations/d' ${tmp_root}/tools/opengapps_tmp/installer.sh >> ${build_log} 2>&1
  sed -i '/- Removing existing\/obsolete Apps/d' ${tmp_root}/tools/opengapps_tmp/installer.sh >> ${build_log} 2>&1
  sed -i '/- Copying Log to $log_folder/d' ${tmp_root}/tools/opengapps_tmp/installer.sh >> ${build_log} 2>&1
  sed -i 's/ui_print "- /ui_print "/g' ${tmp_root}/tools/opengapps_tmp/installer.sh >> ${build_log} 2>&1
  sed -i '/ui_print " "/d' ${tmp_root}/tools/opengapps_tmp/installer.sh >> ${build_log} 2>&1
  sed -i '/ui_print "- Installation complete!"/d' ${tmp_root}/tools/opengapps_tmp/installer.sh >> ${build_log} 2>&1

  # Remove all the unneeded files
  for i in ${RM_OPENGAPPS}
  do
    rm -rvf ${tmp_root}/tools/opengapps_tmp/Core/${i}* >> ${build_log} 2>&1
    rm -rvf ${tmp_root}/tools/opengapps_tmp/GApps/${i}* >> ${build_log} 2>&1
    sed -i 0,/${i}/{/${i}/d} ${tmp_root}/tools/opengapps_tmp/installer.sh >> ${build_log} 2>&1
    sed -i '/${i}/d' ${tmp_root}/tools/opengapps_tmp/app_sizes.txt >> ${build_log} 2>&1
    sed -i '/${i}/d' ${tmp_root}/tools/opengapps_tmp/app_densities.txt >> ${build_log} 2>&1
  done

  cd ${tmp_root}/tools/opengapps_tmp/
  # Make new zip
  zip -r9 ${tmp_root}/tools/opengapps/opengapps.zip * >> ${build_log} 2>&1
  cd - >> ${build_log}
  rm -rvf ${tmp_root}/tools/opengapps_tmp/ >> ${build_log} 2>&1
}
