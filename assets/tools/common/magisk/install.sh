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
echo "Installing Magisk apk"
mount /data
if [[ ! -d /data/app/ ]]; then
  mkdir -p /data/app/
fi
cp -rvf /tmp/tools/magisk/Magisk /data/app/
cd /data/app/Magisk
chown 1000.1000 . -R
chown 1000:1000 . -R
chmod 755 -R .
chmod 755 lib/
find -type f -name '.apk' -exec chmod 644 {} \;
find -type f -name '.so' -exec chmod 755 {} \;
chcon -R -t apk_data_file /data/app/Magisk/
cd -
exit 0
