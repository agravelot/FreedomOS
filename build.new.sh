#!/bin/bash
# FreedomOS build script
# Author : Nevax
# Contributor : TimVNL

source _build_op2.sh
source _build_op3.sh

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
  echo
  cleanup
  echo "Exiting..."
  exit
}

# test if running as root
if [ "$EUID" -ne 0 ]; then
  die "Please, run this script as root! Aborting." "7"
fi

# error function
function die {
  code=-1
  err="Unknown error!"
  test "$1" && err=$1
  cd ${top_root}
  echo "$err"
  echo "Check the build log: ${build_log}"
  exit -1
}

#set up environment variables, folder structure, and log files
function initialize {
  SDAT2IMG_LINK="https://raw.githubusercontent.com/xpirt/sdat2img/master/sdat2img.py"

  top_root=$PWD
  build_root=${top_root}/build
  rom_root=${top_root}/rom
  output_root=${top_root}/output
  download_root=${top_root}/download
  build_log=${top_root}/build/build.log
  config_file=${top_root}/.build.conf
  confirm_build=0

  # create folder structure
  cd ${top_root}
  test -d ${build_root} || mkdir -p ${build_root}
  test -d ${rom_root} || mkdir -p ${rom_root}
  test -d ${output_root} || mkdir -p ${output_root}

  # test log file
  touch ${build_log}
  rm -f ${build_log}

  if [ ! -f "${config_file}" ]; then
    configure
  fi

  # show the configuration
  source ${config_file}

  if [ $confirm_build -ne 1 ]; then
    review
  fi
}

function banner() {
  tput clear
  echo "----------------------------------------"
  echo " FreedomOS build script by Nevax $normal"
  echo "----------------------------------------"
  echo
}

function confirm() {
  read -p "$1 ([y]es or [N]o): "
  case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
      y|yes)  echo "yes" ;;
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

  if [ ! -f ${top_root}/device/${device}/${device}.fos ]; then
    echo "Can not find ${device}.fos file!"
    exit
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
    BUILD_TYPE=user-release
    echo "user-release selected"
    ;;
  *)
    BUILD=2
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
  source ${top_root}/device/${device}/${device}.fos
  output_file="FreedomOS-${CODENAME}-${BUILD_TYPE}-${VERSION}.zip"


  # Show Build review
  banner
  echo "Build review:"
  echo
  echo "Device target: ${device}"
  echo "Build type: ${BUILD_TYPE}"
  echo "Build version: ${VERSION}"
  echo "Arch: ${ARCH}"
  echo "Codename: ${CODENAME}"
  echo "Assert: ${ASSERT}"
  echo "ROM name: ${ROM_NAME}"
  echo "ROM Link: ${ROM_LINK}"
  echo "ROM MD5: ${ROM_MD5}"
  echo "SuperSU zip: ${SU}"
  echo "Xposed apk: ${XPOSED_APK}"
  echo "Audio mod: ${DIVINE}"
  echo "Output file: ${output_file}"
  echo

  if [[ "yes" == $(confirm "All options correct?") ]]
  then
    confirm_build=1
    echo "Saving configuration to ${config_file}"
    echo "device=$device" > ${config_file}
    echo "BUILD=$BUILD" >> ${config_file}
    echo "BUILD_TYPE=$BUILD_TYPE" >> ${config_file}
    echo "VERSION=$VERSION" >> ${config_file}
  else
    configure
  fi
}

function cleanup {
  echo "> Starting cleanup..."
  if mount | grep "$build_root/mount" > /dev/null;
  then
  	echo ">> Unmount rom"
  	umount ${build_root}/mount/
  fi
  echo ">> Cleaning ${build_root} ..."
  rm -rvf ${build_root}/*

  echo
  echo ">> Cleaning ${output_root} ..."
  #TODO: Delete only the file with the same name
  rm -f ${output_root}/${output_file}
  rm -f ${output_root}/${output_file}.md5
}

function build {
  banner
  echo "> $device build starting now."
  echo

  case $device in
    OnePlus3) build_op3 ;;
    OnePlus2) build_op2 ;;
  esac
}

function update_tools {
  echo "> Updating sdat2img tools ..."
  if curl -Is ${SDAT2IMG_LINK} | grep "200 OK" &> /dev/null
  then
    curl -o ${download_root}/sdat2img.py ${SDAT2IMG_LINK} >> ${build_log} 2>&1
  else
    echo "sdat2img tools mirror is OFFLINE! sdat2img tools not updated!"
  fi
  chmod +x ${download_root}/sdat2img.py
}

function download_rom {
  echo
  echo "> Downloading & Checking ROM ..."
  if [ ! -f  ${download_root}/${ROM_NAME}.zip ]; then
    echo ">> File ${ROM_NAME}.zip does not exist. Downloading ..." >&2

    if curl -Is ${ROM_LINK} | grep "200 OK" &> /dev/null
    then
      #TODO Ask user for delete or change name of the old corrupted zip
      rm -vf ${download_root}/${ROM_NAME}.zip
      curl -o ${download_root}/${ROM_NAME}.zip ${ROM_LINK}
    else
      die "${ROM_NAME} mirror OFFLINE! Check your connection" "10"
    fi
  else
    echo ">> Checking MD5 of ${ROM_NAME}"

    if [[ ${ROM_MD5} == $(md5sum ${download_root}/${ROM_NAME}.zip | cut -d ' ' -f 1) ]]; then
      echo ">>> MD5 ${ROM_NAME}.zip checksums OK."
    else
      echo ">>> File ${ROM_NAME}.zip is corrupt" >&2

      rm -vf ${download_root}/${ROM_NAME}.zip
      download_rom
    fi
  fi
  echo
}

function extract_rom {
  echo
  echo "Extracting ROM ..."
  echo
  if [ -f ${rom_root}/${device}/${ROM_NAME}/system.new.dat ]; then
    echo "${rom_root}/${device}/${ROM_NAME} dir exist."
  else
    echo
    echo "Extracting rom zip"
    mkdir -p ${rom_root}/${device}/${ROM_NAME}
    unzip -o ${download_root}/${ROM_NAME}.zip -d ${rom_root}/${device}/${ROM_NAME} >> ${build_log} 2>&1
    echo Done!
  fi
}

set -e

initialize

if [ $confirm_build -eq 1 ]; then
  update_tools
  download_rom
  extract_rom
  build
fi

exit
