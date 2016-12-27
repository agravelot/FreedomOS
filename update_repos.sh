##!/bin/bash
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
# Contributors :

top_root=$PWD
rom_root=${top_root}/rom
build_root=${top_root}/build
scripts_root=${build_root}/scripts
tmp_root=${top_root}/tmp
assets_root=${top_root}/assets
output_root=${top_root}/output
download_root=${top_root}/download
device_root=${top_root}/device

test -d ${download_root} || mkdir -p ${download_root}

GIT_URL="
https://gitlab.com/Nevax/freedomos_opengapps.git
https://github.com/xpirt/sdat2img.git
https://github.com/xpirt/img2sdat.git
"
function confirm() {
  read -p "$1 ([Y/n]): "
  case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
      y|yes)  echo "yes" ;;
      "")     echo "yes" ;;
      *)      echo "no" ;;
  esac
}

for i in ${GIT_URL}
do
  folder_name=${i##*/}
  folder_name=${folder_name%%.*}
  if [[ ! -d ${download_root}/${folder_name} ]]; then
    echo "Cloning ${folder_name} repo"
    mkdir -p ${download_root}/${folder_name}
    git clone ${i} ${download_root}/${folder_name}
  else
    echo "Updating ${folder_name} repo"
    git --git-dir=${download_root}/${folder_name}/.git --work-tree=${download_root}/${folder_name} pull
  fi
done
