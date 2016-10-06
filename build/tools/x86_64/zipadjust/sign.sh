#!/bin/sh
zss="$(cd "$(dirname "$0")"; pwd)";
bin="$zss/bin";
chmod -R 755 "$bin" "$zss"/*.sh;
cd "$zss";

if [ ! "$1" -o ! "$2" ]; then
  echo "Missing parameter(s)!";
  exit 1;
elif [ ! -f "$bin/${1}.certificate.x509.pem" -o ! -f "$bin/${1}.key.pk8" -o ! -f "$2" ]; then
  echo "File(s) not found!";
  exit 1;
fi;

echo "Signing Files using \"$1\" keys . . .";
java -jar "$bin/signapk.jar" "$bin/${1}.certificate.x509.pem" "$bin/${1}.key.pk8" "$2" ${1}-filesigned.zip;

echo -e "\nZipadjusting . . .";
"$bin/zipadjust" ${1}-filesigned.zip ${1}-zipadjusted.zip > /dev/null;

echo -e "\nSigning Whole File using \"$1\" keys . . .";
java -jar "$bin/minsignapk.jar" "$bin/${1}.certificate.x509.pem" "$bin/${1}.key.pk8" ${1}-zipadjusted.zip ${1}-signed.zip;

cp -fp ${1}-signed.zip "$(dirname $2)/$(basename $2 .zip)-signed.zip";
rm ${1}-*.zip;
exit 0;
