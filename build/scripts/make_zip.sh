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
# FreedomOS device build script
# Contributors : TimVNL, Mavy

function make_zip {

  ## user release build
  if [ "$BUILD_TYPE" = "nevax" ];
  then
    cd ${tmp_root}/

    echo "> Making zip file" 2>&1 | tee -a ${build_log}
    zip -r9 "${output_file}.zip" * -x "*EMPTY_DIRECTORY*" >> ${build_log} 2>&1
    cd ${top_root}

    echo ">> Copy Unsigned in output folder" 2>&1 | tee -a ${build_log}
    cp -v ${tmp_root}/${output_file}.zip ${output_root}/${output_file}.zip >> ${build_log} 2>&1

    echo ">> testing zip integrity" 2>&1 | tee -a ${build_log}
    zip -T ${output_root}/${output_file}.zip >> ${build_log} 2>&1

    echo ">> Generating md5 hash" 2>&1 | tee -a ${build_log}
    openssl md5 "${output_root}/${output_file}.zip" |cut -f 2 -d " " > "${output_root}/${output_file}.zip.md5" 2>&1 | tee -a ${build_log}

    echo ">> Signature of the ZIP file" 2>&1 | tee -a ${build_log}
    chmod +x ${build_root}/tools/signapk.jar >> ${build_log} 2>&1
    java -jar "${build_root}/tools/signapk.jar" "${build_root}/keys/certificate.pem" "${build_root}/keys/key.pk8" "${output_root}/${output_file}.zip" "${output_root}/${output_file}-signed.zip" >> ${build_log} 2>&1

    echo ">> Generating md5 hash" 2>&1 | tee -a ${build_log}
    openssl md5 "${output_root}/${output_file}-signed.zip" |cut -f 2 -d " " > "${output_root}/${output_file}-signed.zip.md5" 2>&1 | tee -a ${build_log}
    #We doesn't test the final, because it doesn't work with the signed zip.
    FINAL_ZIP=${output_file}-signed

  fi

  ## debug build
  if [ "$BUILD_TYPE" = "debug" ];
  then
    cd ${tmp_root}/

    echo "> Making zip file" 2>&1 | tee -a ${build_log}
    zip -r1 "${output_file}.zip" * -x "*EMPTY_DIRECTORY*" >> ${build_log} 2>&1

    cd ${top_root}
    echo ">> Move unsigned zip file in output folder" 2>&1 | tee -a ${build_log}
    mv -v "${tmp_root}/${output_file}.zip" "${output_root}/" >> ${build_log} 2>&1

    echo ">> Generating md5 hash"
    openssl md5 "${output_root}/${output_file}.zip" |cut -f 2 -d " " > "${output_root}/${output_file}.zip.md5" 2>&1 | tee -a ${build_log}
    FINAL_ZIP=${output_file}
  fi

  echo "> Cleaning tmp folder" 2>&1 | tee -a ${build_log}
  rm -rvf ${tmp_root} >> ${build_log} 2>&1

  echo ">" 2>&1 | tee -a ${build_log}
  echo "${greent}${bold}-> Build finished! You can find the build here: ${output_root}/${output_file}.zip ${normal}" 2>&1 | tee -a ${build_log}
  echo "${greent}${bold}-> You can find the log file here: ${build_log} ${normal}" 2>&1 | tee -a ${build_log}
}
