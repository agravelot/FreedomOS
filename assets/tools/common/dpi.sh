#!/sbin/sh
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

echo "Set DPI to $1"
dpi=$1

if grep -qr ro.sf.lcd_density= /system/build.prop ; then
  echo "DEBUG: ro.sf.lcd_density is set, add value $dpi"
  sed -i "s/ro.sf.lcd_density=.*/ro.sf.lcd_density=$dpi/" /system/build.prop
else
  echo "DEBUG: ro.sf.lcd_density is not set, change value $dpi"
  echo ro.sf.lcd_density=$dpi >> /system/build.prop
fi
