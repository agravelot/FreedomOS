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
#
#  Author : Nevax
#
# FreedomOS main build script
# Contributors : TimVNL, Mavy

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
  echo
  cleanup
  echo "Exiting..."
  exit
}

# error function
function die {
  code=-1
  err="Unknown error!"
  test "$1" && err=$1
  cd ${top_root}
  echo "${bold}${redt}${err}${normal}"
  echo "${bold}${redt}Check the build log: ${build_log}${normal}"
  exit -1
}

#set up environment variables, folder structure, and log files
function initialize {

  top_root=$PWD
  rom_root=${top_root}/rom
  build_root=${top_root}/build
  scripts_root=${build_root}/scripts
  tmp_root=${top_root}/tmp
  assets_root=${top_root}/assets
  output_root=${top_root}/output
  download_root=${top_root}/download
  device_root=${top_root}/device

  build_log=${output_root}/build.log
  config_file=${top_root}/.build.conf
  confirm_build=0

  img2sdat_repo=${download_root}/img2sdat
  sdat2img_repo=${download_root}/sdat2img
  busybox_repo=${download_root}/freedomos_busybox

  list_submodules="
  img2sdat
  sdat2img
  freedomos_busybox
  "

  redt=
  redb=
  greent=
  greenb=
  yellowt=
  yellowb=
  bluet=
  blueb=
  magentat=
  magentab=
  cyant=
  cyanb=
  whiteb=
  bold=
  italic=
  stand=
  underline=
  normal=
  clears=

  # create folder structure
  cd ${top_root}
  test -d ${tmp_root} || mkdir -p ${tmp_root}
  test -d ${rom_root} || mkdir -p ${rom_root}
  test -d ${output_root} || mkdir -p ${output_root}
  test -d ${download_root} || mkdir -p ${download_root}

  # test log file
  touch ${build_log}
  rm -f ${build_log}

  # Initialize environtment
  source ${scripts_root}/dat_to_dat.sh
  source ${scripts_root}/dat_to_files.sh
  source ${scripts_root}/dat_to_img.sh
  source ${scripts_root}/make_zip.sh
  source ${scripts_root}/add_files.sh
  source ${scripts_root}/opengapps.sh
  source ${scripts_root}/arise.sh
  source ${scripts_root}/busybox.sh

  HOST_ARCH=`uname -m`
  HOST_OS=`uname -s`
  HOST_OS_EXTRA=`uname -a`

  for i in $list_submodules; do
      if [[ ! -d ${download_root}/$i ]]; then
        die "Unable to find needed submodules [$i], please read README.md" "50"
      fi
  done

  if [[ ${BUILD_TYPE} != "nevax" && ${BUILD_TYPE} != "debug" ]]; then
    die "Bad build type" "60"
  fi

  if [[ -z ${device} || -z ${BUILD_TYPE} || -z ${VERSION} ]]; then
    die "Bad device" "61"
  fi

  if [[ -z ${VERSION} ]]; then
    die "Version not defined" "62"
  fi

  write_config

  # show the configuration
  source ${config_file}

  if [ $confirm_build -ne 1 ]; then
    review
  fi
}

function banner() {
  tput clear
  echo "----------------------------------------"
  echo "${bold}${redt} FreedomOS build script by Nevax ${normal}"
  echo "----------------------------------------"
  echo
}

function confirm() {
  read -p "$1 ([Y/n]): "
  case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
      y|yes)  echo "yes" ;;
      "")     echo "yes" ;;
      *)      echo "no" ;;
  esac
}

function configure {
  # Show device list
  banner
  echo "Available devices:"
  echo
  find . -name "*.fos" -exec basename \{} .fos \;
  echo
  read -p "Enter your device codename: " device
  echo

  if [ ! -f ${device_root}/${device}/${device}.fos ]; then
    die "Can not find ${device}.fos file!" "3"
  fi

  # Choose build method option
  banner
  echo "Choose the build method you want:"
  echo "1) user-release"
  echo "2) debug"
  echo
  read -p "enter build method [debug]: " BUILD

  case $BUILD in
  1)
    BUILD_TYPE=nevax
    echo "release selected"
    ;;
  *)
    BUILD_TYPE=debug
    echo "debug selected"
    ;;
  esac

  # Enter VERSION number option
  banner
  read -p "Enter the VERSION number [test] : " VERSION

  if [ -z "$VERSION" ];
  then
    VERSION="test"
  fi

  review
}

function review {
  # Set environment based on current config

  if [[ -f ${device_root}/${device}/${device}.fos ]]; then
    source ${device_root}/${device}/${device}.fos
  else
    echo "Unable to find your device in the device tree"
    echo -e "Please pick one of them:\n"
    ls device -lUx
    echo
    die "Unable to find your device ${device}" "51"
  fi
  output_file="${ZIP_NAME}-${CODENAME}-${BUILD_TYPE}-${VERSION}"

  # Show Build review
  banner 2>&1 | tee -a ${build_log}
  echo "============================================" 2>&1 | tee -a ${build_log}
  echo "TARGET_DEVICE=${device}" 2>&1 | tee -a ${build_log}
  echo "BUILD_TYPE=${BUILD_TYPE}" 2>&1 | tee -a ${build_log}
  echo "VERSION=${VERSION}" 2>&1 | tee -a ${build_log}
  echo "TARGET_ARCH=${TARGET_ARCH}" 2>&1 | tee -a ${build_log}
  echo "CODENAME=${CODENAME}" 2>&1 | tee -a ${build_log}
  echo "ASSERT=${ASSERT}" 2>&1 | tee -a ${build_log}
  echo "ROM_NAME=${ROM_NAME}" 2>&1 | tee -a ${build_log}
  echo "ROM_LINK=${ROM_LINK}" 2>&1 | tee -a ${build_log}
  echo "ROM_MD5=${ROM_MD5}" 2>&1 | tee -a ${build_log}
  echo "HOST_ARCH=${HOST_ARCH}" 2>&1 | tee -a ${build_log}
  echo "HOST_OS=${HOST_OS}" 2>&1 | tee -a ${build_log}
  echo "HOST_OS_EXTRA=${HOST_OS_EXTRA}" 2>&1 | tee -a ${build_log}
  echo "OUPUT_DIR=${output_root}/" 2>&1 | tee -a ${build_log}
  echo "OUTPUT_FILE=${output_file}.zip" 2>&1 | tee -a ${build_log}
  echo "============================================" 2>&1 | tee -a ${build_log}
  echo 2>&1 | tee -a ${build_log}

  confirm_build=1
  write_config
}

function write_config() {
  echo "Saving configuration to ${config_file}" 2>&1 | tee -a ${build_log}
  echo "device=$device" > ${config_file} 2>&1 | tee -a ${build_log}
  echo "BUILD_TYPE=$BUILD_TYPE" >> ${config_file} 2>&1 | tee -a ${build_log}
  echo "VERSION=$VERSION" >> ${config_file} 2>&1 | tee -a ${build_log}
}

function cleanup {
  echo "> Starting cleanup..." 2>&1 | tee -a ${build_log}
  if mount | grep "${tmp_root}/mount" > /dev/null;
  then
  	echo ">> Unmount rom" 2>&1 | tee -a ${build_log}
  	umount ${tmp_root}/mount/ >> ${build_log} 2>&1
  fi
  echo ">> Cleaning ${tmp_root} ..." 2>&1 | tee -a ${build_log}
  rm -rvf ${tmp_root}/* >> ${build_log} 2>&1

  echo ">> Cleaning ${output_root} ..." 2>&1 | tee -a ${build_log}
  rm -fv ${output_root}/${output_file}.zip >> ${build_log} 2>&1
  rm -fv ${output_root}/${output_file}.zip.md5 >> ${build_log} 2>&1
}

function build {
  case $BUILD_METHOD in
    dat_to_dat) dat_to_dat ;;
    dat_to_files) dat_to_files ;;
    dat_to_img) dat_to_img ;;
    *) die "Unknow build method" "11";;
  esac
}

function download_rom {
  echo "> Downloading & Checking ROM ..." 2>&1 | tee -a ${build_log}
  if [ ! -f  ${download_root}/${ROM_NAME}.zip ]; then
    echo ">> File ${ROM_NAME}.zip does not exist. Downloading ..." 2>&1 | tee -a ${build_log}

    if curl -Is ${ROM_LINK} | grep "200 OK" &> /dev/null
    then
      if [ $(which aria2c) ]; then
        aria2c -x 4 ${ROM_LINK} -d ${download_root}/
      else
        curl -o ${download_root}/${ROM_NAME}.zip ${ROM_LINK} | tee -a ${build_log}
      fi
    else
      die "${ROM_NAME} mirror OFFLINE! Check your connection" "10"
    fi
  else
    if [[ ! -z ${ROM_MD5} ]]; then
        echo ">> Checking MD5 of ${ROM_NAME}.zip" 2>&1 | tee -a ${build_log}
        if [[ ${ROM_MD5} == $(md5sum ${download_root}/${ROM_NAME}.zip | cut -d ' ' -f 1) ]]; then
          echo ">>> MD5 ${ROM_NAME}.zip checksums OK." 2>&1 | tee -a ${build_log}
        else
          echo ">>> File ${ROM_NAME}.zip is corrupt, restarting download" 2>&1 | tee -a ${build_log}
          rm -rvf ${download_root}/${ROM_NAME}.zip.bak >> ${build_log} 2>&1
          mv -vf ${download_root}/${ROM_NAME}.zip ${download_root}/${ROM_NAME}.zip.bak >> ${build_log} 2>&1
          download_rom
        fi
    fi
  fi
  echo
}

function extract_rom {
  if [ ! -f ${rom_root}/${device}/${ROM_NAME}/system.new.dat ]; then
    echo ">> Extracting rom zip" 2>&1 | tee -a ${build_log}
    mkdir -p ${rom_root}/${device}/${ROM_NAME} >> ${build_log} 2>&1
    unzip -o ${download_root}/${ROM_NAME}.zip -d ${rom_root}/${device}/${ROM_NAME} >> ${build_log} 2>&1
  fi
}

set -e

# test if running as root
if [ "$EUID" -ne 0 ]; then
  die "Please, run this script as root! Aborting." "7"
fi

# set variables from arguments
while getopts d:t:v: option
do
 case "${option}"
 in
 d) device=${OPTARG};;
 t) BUILD_TYPE=${OPTARG};;
 v) VERSION=$OPTARG;;
 esac
done

initialize

if [ $confirm_build -eq 1 ]; then
  cleanup
  download_rom
  extract_rom
  if [[ "$GAPPS_BUILD" == true ]]; then
    download_opengapps
    extract_opengapps
    build_opengapps
  fi
  build
  add_files
  build_arise
  if [[ "$BUILD_BUSYBOX" == true ]]; then
      build_busybox
  fi
  make_zip
fi

exit
