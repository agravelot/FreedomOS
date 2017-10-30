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

function download_opengapps {
  echo "> Downloading & Checking OpenGApps ..." 2>&1 | tee -a ${build_log}
  if [ ! -f  ${download_root}/${GAPPS_ZIP}.zip ]; then
    echo ">> File ${GAPPS_ZIP}.zip does not exist. Downloading ..." 2>&1 | tee -a ${build_log}

    if curl -Is ${ROM_LINK} | grep "200 OK" &> /dev/null
    then
      if [ $(which aria2c) ]; then
        aria2c -x 4 ${GAPPS_LINK} -d ${download_root}/
      else
        curl -L -o ${download_root}/${GAPPS_ZIP}.zip ${GAPPS_LINK} | tee -a ${build_log}
      fi
    else
      die "${GAPPS_ZIP} mirror OFFLINE! Check your connection" "10"
    fi
  else
    echo ">> Checking MD5 of ${GAPPS_ZIP}.zip" 2>&1 | tee -a ${build_log}

    if [[ ! -z ${GAPPS_MD5} ]]; then
        if [[ ${GAPPS_MD5} == $(md5sum ${download_root}/${GAPPS_ZIP}.zip | cut -d ' ' -f 1) ]]; then
          echo ">>> MD5 ${GAPPS_ZIP}.zip checksums OK." 2>&1 | tee -a ${build_log}
        else
          echo ">>> File ${GAPPS_ZIP}.zip is corrupt, restarting download" 2>&1 | tee -a ${build_log}
          rm -rvf ${download_root}/${GAPPS_ZIP}.zip.bak >> ${build_log} 2>&1
          mv -vf ${download_root}/${GAPPS_ZIP}.zip ${download_root}/${GAPPS_ZIP}.zip.bak >> ${build_log} 2>&1
          download_opengapps
        fi
    fi
  fi
  echo
}

function extract_opengapps {
    if [ ! -d ${rom_root}/${GAPPS_ZIP} ]; then
        echo ">> Extracting ${GAPPS_ZIP}" 2>&1 | tee -a ${build_log}
        mkdir -p ${rom_root}/${GAPPS_ZIP} >> ${build_log} 2>&1
        unzip -o ${download_root}/${GAPPS_ZIP}.zip -d ${rom_root}/${GAPPS_ZIP} >> ${build_log} 2>&1
    fi
}

function build_opengapps() {

  # Set unneeded Open Gapps files
  RM_OPENGAPPS="
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
  googlenow
  dmagent
  hangouts
  storagemanagergoogle
  clockgoogle
  dialergoogle
  contactsgoogle
  duo
  "

  echo "> Building FreedomOS OpenGApps" 2>&1 | tee -a ${build_log}
  # Create needed folders
  mkdir -p ${tmp_root}/tools/opengapps_tmp/ >> ${build_log} 2>&1
  mkdir -p ${tmp_root}/tools/opengapps/ >> ${build_log} 2>&1
  # Copy OpenGapps files from repo
  cp -rvf ${rom_root}/${GAPPS_ZIP}/* -d ${tmp_root}/tools/opengapps_tmp/ >> ${build_log} 2>&1
  # Keep all /system/app installed, since we need them
  sed -i '/\/system\/app/d' ${tmp_root}/tools/opengapps_tmp/gapps-remove.txt >> ${build_log} 2>&1
  # Get the gapps-remove.txt list
  cp -vf ${tmp_root}/tools/opengapps_tmp/gapps-remove.txt ${tmp_root}/tools/gapps-remove.txt >> ${build_log} 2>&1
  # Remove all "/system/" from gapps-remove.txt file, since we are already in system/ dir
  sed -i 's/\/system\///g' ${tmp_root}/tools/gapps-remove.txt >> ${build_log} 2>&1

  # Add gapps-remove.txt to the CLEAN_SYSTEM_LIST variable
  CLEAN_SYSTEM_LIST+="$(<${tmp_root}/tools/gapps-remove.txt)"

  # Remove ugly Opengapps header (sorry it's very ugly with aroma)
  logo_start=$(grep -nr '####' ${tmp_root}/tools/opengapps_tmp/installer.sh | gawk '{print $1}' FS=":" | head -1)
  logo_end=$(grep -nr '####' ${tmp_root}/tools/opengapps_tmp/installer.sh | gawk '{print $1}' FS=":" | tail -1)
  logo_end=$((logo_end+3))
  sed -ie "$logo_start,$logo_end d;" ${tmp_root}/tools/opengapps_tmp/installer.sh >> ${build_log} 2>&1
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
  sed -i '/Installation complete!/d' ${tmp_root}/tools/opengapps_tmp/installer.sh >> ${build_log} 2>&1
  sed -i '/Unmounting/d' ${tmp_root}/tools/opengapps_tmp/installer.sh >> ${build_log} 2>&1
  sed -i '/app\/Calculator/d' ${tmp_root}/tools/opengapps_tmp/installer.sh >> ${build_log} 2>&1
  sed -i '/\/system\/app\/Gmail2/d' ${tmp_root}/tools/opengapps_tmp/installer.sh >> ${build_log} 2>&1
  sed -i '/\/system\/app\/CalendarGoogle/d' ${tmp_root}/tools/opengapps_tmp/installer.sh >> ${build_log} 2>&1

  rm -rvf ${tmp_root}/tools/opengapps_tmp/META-INF/com/google/android/aroma >> ${build_log} 2>&1

  # Remove all the unneeded files
  for i in ${RM_OPENGAPPS}
  do
    rm -rvf ${tmp_root}/tools/opengapps_tmp/Core/${i}* >> ${build_log} 2>&1
    rm -rvf ${tmp_root}/tools/opengapps_tmp/GApps/${i}* >> ${build_log} 2>&1
    sed -i 0,/${i}/{/${i}/d} ${tmp_root}/tools/opengapps_tmp/installer.sh >> ${build_log} 2>&1
    sed -i '/'${i}'/d' ${tmp_root}/tools/opengapps_tmp/app_sizes.txt >> ${build_log} 2>&1
    sed -i '/'${i}'/d' ${tmp_root}/tools/opengapps_tmp/app_densities.txt >> ${build_log} 2>&1
  done

  if [[ $GAPPS_TYPE == "aroma" ]]; then
      MINIFY_OPENGAPPS="
      gmscore
      photosvrmode
      photos
      drive
      androidpay
      youtube
      messenger
      playgames
      "
  else
      MINIFY_OPENGAPPS=""
  fi


  MINIFY_DPI="
  160
  240
  320
  480
  640
  213-240
  560-640
  "

  # Minify the opengapps packages
  for i in ${MINIFY_OPENGAPPS}
  do
    cd ${tmp_root}/tools/opengapps_tmp
    find . -type f -name "${i}-*" >> ${build_log} 2>&1
    if [ $? -eq 0 ]
    then
        cd "$(dirname "$(find . -type f -name "${i}-*")")"
        archiveNameWithExtension=$(ls ${i}-*) # Get the filename with the extension
        archiveNameWithoutExtension="${archiveNameWithExtension%%.*}" # Remove the extension from archiveNameWithExtension
        echo " - Minify ${i}" 2>&1 | tee -a ${build_log}
        tar xvf ${archiveNameWithExtension} >> ${build_log} 2>&1 # Extract archive of the app to minify
        rm -v ${archiveNameWithExtension} >> ${build_log} 2>&1 # Remove the older archive since we're going to build a new one
        for y in ${MINIFY_DPI}
        do
          rm -rvf ${archiveNameWithoutExtension}/${y} >> ${build_log} 2>&1
        done
        tar --remove-files -cf - "${archiveNameWithoutExtension}" | lzip -m 273 -s 128MiB -o "${archiveNameWithoutExtension}.tar" >> ${build_log} 2>&1 #.lz is added by lzip; specify the compression parameters manually to get good results
    else
        echo " - Unable to found ${i}" 2>&1 | tee -a ${build_log}
    fi
  done

  if [[ -f ${tmp_root}/tools/opengapps_tmp/installer.she ]]
  then
    rm -vf ${tmp_root}/tools/opengapps_tmp/installer.she
  fi

  cd ${tmp_root}/tools/opengapps_tmp/

  # Make new zip
  zip -r9 ${tmp_root}/tools/opengapps/opengapps.zip * >> ${build_log} 2>&1
  cd ${top_root} >> ${build_log}
  rm -rvf ${tmp_root}/tools/opengapps_tmp/ >> ${build_log} 2>&1
}
