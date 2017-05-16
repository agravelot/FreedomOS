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
#
# FreedomOS app remover

prop=$1
outfd=$2
pkg_list="$(cat /tmp/aroma/${prop})"

ui_print() {
  echo -n -e "ui_print $1\n" >> /proc/self/fd/$outfd
  echo -n -e "ui_print $1\n" >> /tmp/fos_logs/apps_remover
}

echo "##################################"
echo "$prop"
echo "##################################"
echo "$pkg_list"

for pkg in $pkg_list; do
  ui_print "   Removing $pkg"
  found=false
  for dir in /system/app /system/priv-app /system/reserve /system; do
    if [[ -d $dir/$pkg ]]; then
      echo -e "\tPackage : [$pkg], found at $dir/$pkg" >> /tmp/fos_logs/apps_remover
      rm -rvf $dir/$pkg >> /tmp/fos_logs/apps_remover
      found=true
    fi
  done
  if [[ ! $found ]]; then
    ui_print "   ERROR: Unable to found $pkg"
  fi
  echo "" >> /tmp/fos_logs/apps_remover
done
