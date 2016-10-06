zipadjust
---------
https://github.com/omnirom/android_packages_apps_OpenDelta/tree/android-4.4/jni

*zipadjust* can be built by calling:

gcc -o zipadjust zipadjust.c zipadjust_run.c -lz -static


minsignapk
----------
https://github.com/omnirom/android_packages_apps_OpenDelta/tree/android-4.4/server

*minsignapk* Java source is included, as well as a prebuilt
*minsignapk.jar* file that should work on most systems (JRE 7)


Example Usage
-------------

7za a -tzip -r build-unsigned.zip .\build\*

java -jar signapk.jar test.certificate.x509.pem test.key.pk8 build-unsigned.zip build.zip

zipadjust build.zip build-fixed.zip

java -jar minsignapk.jar test.certificate.x509.pem test.key.pk8 build-fixed.zip build-signed.zip
