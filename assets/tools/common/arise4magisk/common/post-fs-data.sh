#!/system/bin/sh

/data/magisk/sepolicy-inject --live "allow mediaserver mediaserver_tmpfs file { read write execute }" \
"allow audioserver audioserver_tmpfs file { read write execute }" 
