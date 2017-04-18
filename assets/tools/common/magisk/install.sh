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

APP_PATH="/data/app/com.topjohnwu.magisk-1"
# Remove old conflict installation
rm -r /data/app/Magisk

echo "Installing Magisk apk"
mount /data
if [[ ! -d /data/app/ ]]; then
  mkdir -p /data/app/
fi

# If Magisk already installed in user apps
ls /data/app | grep com.topjohnwu.magisk-
if [ "$?" -eq "0" ];
then
  echo "Masgisk Manager installation detected!"
  echo "Keep it in place"
else
  echo "No Magisk installation found, Installing..."
  cp -rvf /tmp/tools/magisk/com.topjohnwu.magisk-1 /data/app/
  chown 1000.1000 $APP_PATH -R
  chown 1000:1000 $APP_PATH -R
  chmod 755 -R $APP_PATH
  chmod 755 $APP_PATH/lib/
  find -$APP_PATH type f -name '.apk' -exec chmod 644 {} \;
  find $APP_PATH -type f -name '.so' -exec chmod 755 {} \;
  chcon -R -t apk_data_file $APP_PATH
fi
exit 0
