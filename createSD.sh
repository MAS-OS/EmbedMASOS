#! /bin/bash

sudo apt install rpi-imager
cat base/2022-01-28-raspios-bullseye-armhf-lite.zip/* > /tmp/distro.zip
sudo rpi-imager /tmp/distro.zip /dev/mmcblk0
sudo rm /tmp/distro.zip
sudo mkdir /tmp/distro
sudo mount /dev/mmcblk0p2 /tmp/distro/

sudo cp src/EmbedMAS /tmp/distro/opt/ -rv
sudo cp src/EmbedMAS/etc/rc.local /tmp/distro/etc/rc.local
sudo umount /tmp/distro
