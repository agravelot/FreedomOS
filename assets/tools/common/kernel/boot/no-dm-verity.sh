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

found_fstab=false

cd /tmp/ramdisk

for fstab in fstab.*; do
	[ -f "$fstab" ] || continue
	echo "Found fstab: $fstab"
	sed -i "
		s/,verify\b//g
		s/\bverify,//g
		s/\bverify\b//g
		s/,support_scfs\b//g
		s/\bsupport_scfs,//g
		s/\bsupport_scfs\b//g
	" "$fstab"
	found_fstab=true
done

$found_fstab || echo "Unable to find the fstab!"

setprop ro.config.dmverity false
rm -f /tmp/ramdisk/verity_key
rm -f /tmp/ramdisk/sbin/firmware_key.cer

exit 0
