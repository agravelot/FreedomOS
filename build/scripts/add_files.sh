#!/bin/bash
# FreedomOS device build script
# Author : Nevax
# Contributors : TimVNL, Mavy

function add_files {

  echo ">> Add META-INF files" 2>&1 | tee -a ${build_log}
  mkdir -p ${tmp_root}/META-INF/com/google/android/ >> ${build_log} 2>&1
  cp -vrf ${device_root}/${device}/aroma/* ${tmp_root}/META-INF/com/google/android/ >> ${build_log} 2>&1

  echo ">>> Add aroma bin" 2>&1 | tee -a ${build_log}
  cp -vf ${assets_root}/META-INF/update-binary/${AROMA_VERSION}/update-binary ${tmp_root}/META-INF/com/google/android/ >> ${build_log} 2>&1

  echo ">>> Add update-binary bin" 2>&1 | tee -a ${build_log}
  cp -vf ${assets_root}/META-INF/update-binary-installer/${BUILD_METHOD}/update-binary-installer ${tmp_root}/META-INF/com/google/android/ >> ${build_log} 2>&1

  echo ">> Add tools" 2>&1 | tee -a ${build_log}
  mkdir -p ${tmp_root}/tools >> ${build_log} 2>&1
  for i in ${TOOLS_LIST}
  do
    cp -rvf ${assets_root}/tools/${i} ${tmp_root}/tools/ >> ${build_log} 2>&1
  done

  echo ">> Add FreedomOS wallpapers by badboy47" 2>&1 | tee -a ${build_log}
  mkdir -p ${tmp_root}/media/wallpaper >> ${build_log} 2>&1
  cp -v ${assets_root}/media/wallpaper/* ${tmp_root}/media/wallpaper >> ${build_log} 2>&1

  echo ">> Set Assert in updater-script" 2>&1 | tee -a ${build_log}
  sed -i.bak "s:!assert!:$ASSERT:" ${tmp_root}/META-INF/com/google/android/updater-script >> ${build_log} 2>&1

  if [ ! -z $ASSERT_2 ];
  then
    echo ">> Set Assert in updater-script" 2>&1 | tee -a ${build_log}
    sed -i.bak "s:!assert2!:$ASSERT_2:" ${tmp_root}/META-INF/com/google/android/updater-script >> ${build_log} 2>&1
  fi

  echo ">> Set VERSION in aroma" 2>&1 | tee -a ${build_log}
  sed -i.bak "s:!version!:$VERSION:" ${tmp_root}/META-INF/com/google/android/aroma-config >> ${build_log} 2>&1

  echo ">> Set device in aroma" 2>&1 | tee -a ${build_log}
  sed -i.bak "s:!device!:${device}:" ${tmp_root}/META-INF/com/google/android/aroma-config >> ${build_log} 2>&1

  echo ">> Set date in aroma" 2>&1 | tee -a ${build_log}
  sed -i.bak "s:!date!:$(date +"%d%m%y"):" ${tmp_root}/META-INF/com/google/android/aroma-config >> ${build_log} 2>&1

  echo ">> Set date in en.lang" 2>&1 | tee -a ${build_log}
  sed -i.bak "s:!date!:$(date +"%d%m%y"):" ${tmp_root}/META-INF/com/google/android/aroma/langs/en.lang >> ${build_log} 2>&1

  echo ">> Set date in fr.lang" 2>&1 | tee -a ${build_log}
  sed -i.bak "s:!date!:$(date +"%d%m%y"):" ${tmp_root}/META-INF/com/google/android/aroma/langs/fr.lang >> ${build_log} 2>&1

  rm -rvf ${tmp_root}/META-INF/com/google/android/aroma-config.bak >> ${build_log} 2>&1
  rm -rvf ${tmp_root}/META-INF/com/google/android/aroma/langs/*.lang.bak >> ${build_log} 2>&1

}
