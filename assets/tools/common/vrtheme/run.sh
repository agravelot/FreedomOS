#!/sbin/sh
# Copyright 2017 Antoine GRAVELOT
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

ui_print() {
  echo -n -e "ui_print $1\n" >> /proc/self/fd/$outfd
  echo -n -e "ui_print $1\n" >> /tmp/fos_logs/themeinstall.log
}

outfd=1

rm -rf /data/tmp
rm -rf /data/vrtheme-backup
mkdir -p /data/tmp
cp -r /tmp/tools/vrtheme /data/tmp/vrtheme
mkdir -p /data/tmp/vrtheme/apply

rm -f /tmp/aroma/theme.prop
cp /tmp/aroma/aromatheme.prop /tmp/aroma/theme.prop

if [[ $(grep -c inclorexcl=1 /tmp/aroma/theme.prop) == "1" ]]; then
  # If Include selected
  sed -i '/=0/d' /tmp/aroma/theme.prop
  sed -i 's/=1//g' /tmp/aroma/theme.prop
else
  # If Exclude selected
  sed -i '/=1/d' /tmp/aroma/theme.prop
  sed -i 's/=0//g' /tmp/aroma/theme.prop
fi

if [[ $(grep -c inclorexcl /tmp/aroma/theme.prop) == "1" ]]; then
  sed -i '/inclorexcl/d' /tmp/aroma/theme.prop
  if [[ -s /tmp/aroma/theme.prop ]]; then
    ui_print "   Applying VRThemes"
    for theme in $(cat /tmp/aroma/theme.prop); do
      cp -r /tmp/tools/themes/$theme/* /data/tmp/vrtheme/apply
    done
    chmod 755 -R /data/tmp/vrtheme
    #mount /system
    sh /data/tmp/vrtheme/installtheme.sh >> /tmp/fos_logs/themeinstall.log
  fi
else
  echo "No theme allowed on this build!"
  exit 0
fi
