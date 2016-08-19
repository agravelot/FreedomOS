#!/bin/bash
# FreedomOS device build script
# Author : Nevax
# Contributors : TimVNL, Mavy

function make_zip {

  ## user release build
  if [ "$BUILD" = 1 ];
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
    openssl md5 "${output_root}/${output_file}.zip" |cut -f 2 -d " " > "${output_root}/${output_file}.zip.md5"

    echo ">> SignApk....." 2>&1 | tee -a ${build_log}
    chmod +x ${build_root}/tools/signapk.jar >> ${build_log} 2>&1
    java -jar "${build_root}/tools/signapk.jar" "${build_root}/keys/certificate.pem" "${build_root}/keys/key.pk8" "${output_root}/${output_file}.zip" "${output_root}/${output_file}-signed.zip" >> ${build_log} 2>&1

    echo ">> Generating md5 hash" 2>&1 | tee -a ${build_log}
    openssl md5 "${output_root}/${output_file}-signed.zip" |cut -f 2 -d " " > "${output_root}/${output_file}-signed.zip.md5" 2>&1 | tee -a ${build_log}
    #We doesn't test the final, because it doesn't work with the signed zip.
    FINAL_ZIP=${output_file}-signed

  fi

  ## debug build
  if [ "$BUILD" = 2 ];
  then
    cd ${tmp_root}/

    echo "> Making zip file" 2>&1 | tee -a ${build_log}
    zip -r1 "${output_file}.zip" * -x "*EMPTY_DIRECTORY*" >> ${build_log} 2>&1

    echo ">> testing zip integrity" 2>&1 | tee -a ${build_log}
    zip -T "${output_file}.zip" >> ${build_log} 2>&1

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
  echo "> Build finished! You can find the build here: ${output_root}/${output_file}.zip" 2>&1 | tee -a ${build_log}
  echo "> You can find the log file here: ${build_log}" 2>&1 | tee -a ${build_log}
}
