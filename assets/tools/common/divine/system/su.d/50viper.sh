#! /system/bin/sh
/su/bin/supolicy --live "allow mediaserver mediaserver_tmpfs:file { execute };"
supolicy --live "allow mediaserver mediaserver_tmpfs:file { execute };"
