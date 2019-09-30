#!/usr/bin/env bash

diskutil list | grep "/dev/disk2 (external, physical)"

if [ $? -ne 0 ]
then
  echo "SD card not found on disk2, aborting"
  exit 1
fi

diskutil unmountDisk /dev/disk2
sudo dd bs=1m if=~/Downloads/2019-07-10-raspbian-buster-lite.img of=/dev/rdisk2 conv=sync
sleep 2
touch /Volumes/boot/ssh
sleep 1
sudo diskutil eject /dev/rdisk2
