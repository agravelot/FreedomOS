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
camera_list="
OnePlusCameraService
"

live_wallpaper_list="
LiveWallpapersPicker
"

document_list="
OPFilemanager
"

download_provider_list="
DownloadProviderUi
"

swiftkey_list="
SwiftKeyFactorySettings
com.touchtype
"

# Generate a list file with only the wanted apps.
rm -f /tmp/aroma/sapps.prop
cp /tmp/aroma/aromasapps.prop /tmp/aroma/sapps.prop

if [[ $(grep -c inclorexcl=1 /tmp/aroma/aromasapps.prop) == "1" ]]; then
  # If Include selected
  sed -i '/=1/d' /tmp/aroma/sapps.prop
  sed -i 's/=0//g' /tmp/aroma/sapps.prop
else
  # If Exclude selected
  sed -i '/=0/d' /tmp/aroma/sapps.prop
  sed -i 's/=1//g' /tmp/aroma/sapps.prop
fi

# Remove uneeded entry
sed -i '/inclorexcl/d' /tmp/aroma/sapps.prop

# Add unwanted file to sapps.prop
if [[ $(grep -c "DocumentsUI" /tmp/aroma/sapps.prop) == "1" ]]; then
  for app in $document_list; do
    echo -e $app >> /tmp/aroma/sapps.prop
  done
fi

if [[ $(grep -c "DownloadProvider" /tmp/aroma/sapps.prop) == "1" ]]; then
  for app in $download_provider_list; do
    echo -e $app >> /tmp/aroma/sapps.prop
  done
fi

if [[ $(grep -c "LiveWallpapers" /tmp/aroma/sapps.prop) == "1" ]]; then
  for app in $live_wallpaper_list; do
    echo -e $app >> /tmp/aroma/sapps.prop
  done
fi

if [[ $(grep -c "OnePlusCamera" /tmp/aroma/sapps.prop) == "1" ]]; then
  for app in $camera_list; do
    echo -e $app >> /tmp/aroma/sapps.prop
  done
fi

if [[ $(grep -c "SwiftKey" /tmp/aroma/sapps.prop) == "1" ]]; then
  for app in $swiftkey_list; do
    echo -e $app >> /tmp/aroma/sapps.prop
  done
fi
