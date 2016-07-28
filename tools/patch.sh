#!/bin/bash

echo 'boot-recovery ' > /cache/recovery/command
echo '--update_package=/sdcard/FreedomOS_patch.zip' >> /cache/recovery/command
reboot recovery
