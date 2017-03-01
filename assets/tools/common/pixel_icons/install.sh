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
# FreedomOS app list generator

# The installer list contain only the ticked apps in the aroma settings, but
# some apps have more than one file to remove.
# So here we declare the uneeded depencies that will be added to the sapps.prop

# Pixel Icons not correctly provided by Open-GApps, so i add my own
if [[ $(grep -c "PixelIcons=1" /tmp/aroma/gapps.prop) == "1" ]]; then
  echo -n -e "ui_print Installing pixelicons\n" >> /proc/self/fd/1
  mkdir -p /system/app/PixelIcons
  cp /tmp/tools/pixel_icons/PixelIcons.apk /system/app/PixelIcons/
fi
