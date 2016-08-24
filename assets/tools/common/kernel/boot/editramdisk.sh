#!/sbin/sh

mkdir /tmp/ramdisk
cp /tmp/boot.img-ramdisk.gz /tmp/ramdisk/
cd /tmp/ramdisk/
gunzip -c /tmp/ramdisk/boot.img-ramdisk.gz | cpio -i
rm /tmp/ramdisk/boot.img-ramdisk.gz
rm /tmp/boot.img-ramdisk.gz

#cp -R /tmp/patch/* .

#Don't force encryption
if  grep -qr forceencrypt /tmp/ramdisk/fstab.qcom; then
   sed -i "s/forceencrypt/encryptable/" /tmp/ramdisk/fstab.qcom
fi

#Remove verify flag
if  grep -qr ",verify" /tmp/ramdisk/fstab.qcom; then
   sed -i "s/,verify//" /tmp/ramdisk/fstab.qcom
fi

#Remove verify flag
if  grep -qr "verify," /tmp/ramdisk/fstab.qcom; then
   sed -i "s/verify,//" /tmp/ramdisk/fstab.qcom
fi

if  ! grep -qr "noatime," /tmp/ramdisk/fstab.qcom; then
   sed -i "s/ro,/ro,noatime,/" /tmp/ramdisk/fstab.qcom
fi

#Remove verify flag
if  grep -qr ",verify" /tmp/ramdisk/charger.fstab.qcom; then
   sed -i "s/,verify//" /tmp/ramdisk/charger.fstab.qcom
fi

#Remove verify flag
if  grep -qr "verify," /tmp/ramdisk/charger.fstab.qcom; then
   sed -i "s/verify,//" /tmp/ramdisk/charger.fstab.qcom
fi

if  ! grep -qr "noatime," /tmp/ramdisk/charger.fstab.qcom; then
   sed -i "s/ro,/ro,noatime,/" /tmp/ramdisk/charger.fstab.qcom
fi

#Remove verify flag
if  grep -qr ",verify" /tmp/ramdisk/fstab_nodata.qcom; then
   sed -i "s/,verify//" /tmp/ramdisk/fstab_nodata.qcom
fi

#Remove verify flag
if  grep -qr "verify," /tmp/ramdisk/fstab_nodata.qcom; then
   sed -i "s/verify,//" /tmp/ramdisk/fstab_nodata.qcom
fi

if  ! grep -qr "noatime," /tmp/ramdisk/fstab_nodata.qcom; then
   sed -i "s/ro,/ro,noatime,/" /tmp/ramdisk/fstab_nodata.qcom
fi

#Remove verity key
rm -f /tmp/ramdisk/verity_key

#echo "persist.service.adb.enable=1" >> /tmp/ramdisk/default.prop
#echo "persist.service.debuggable=1" >> /tmp/ramdisk/default.prop
#echo "persist.sys.usb.config=ptp,adb" >> /tmp/ramdisk/default.prop
#echo "ro.secure=0" >> /tmp/ramdisk/default.prop
#echo "ro.adb.secure=0" >> /tmp/ramdisk/default.prop

find . | cpio -o -H newc | gzip > /tmp/boot.img-ramdisk.gz
rm -r /tmp/ramdisk
