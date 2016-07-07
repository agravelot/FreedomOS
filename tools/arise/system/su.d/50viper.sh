#! /system/bin/sh

supolicy --live "allow mediaserver mediaserver_tmpfs:file { execute };"
/system/bin/supolicy --live "allow mediaserver mediaserver_tmpfs:file { execute };"
/su/bin/supolicy --live "allow mediaserver mediaserver_tmpfs:file { execute };"
/system/xbin/supolicy --live "allow mediaserver mediaserver_tmpfs:file { execute };"
/su/xbin/supolicy --live "allow mediaserver mediaserver_tmpfs:file { execute };"

