#!/sbin/sh

dd if=/dev/block/bootdevice/by-name/boot of=/tmp/boot.img
/tmp/unpackbootimg -i /tmp/boot.img -o /tmp/

mkdir /tmp/ramdisk
cp /tmp/boot.img-ramdisk.gz /tmp/ramdisk/
cd /tmp/ramdisk/
gunzip -c /tmp/ramdisk/boot.img-ramdisk.gz | cpio -i
rm /tmp/boot.img-ramdisk.gz
rm /tmp/ramdisk/boot.img-ramdisk.gz

find . | cpio -o -H newc | gzip > /tmp/boot.img-ramdisk.gz
rm -r /tmp/ramdisk

/tmp/mkbootimg --kernel /tmp/zImage --ramdisk /tmp/boot.img-ramdisk.gz --cmdline "androidboot.hardware=qcom user_debug=31 msm_rtb.filter=0x237 ehci-hcd.park=3 lpm_levels.sleep_disabled=1 cma=32M@0-0xffffffff" --base 0x80000000 --pagesize 4096 --ramdisk_offset 0x01000000 --tags_offset 0x00000100 -o /tmp/newboot.img
dd if=/tmp/newboot.img of=/dev/block/bootdevice/by-name/boot
