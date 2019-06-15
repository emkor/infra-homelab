#!/usr/bin/env bash

parted -s /dev/sdb mklabel msdos
parted -s -a opt /dev/sdb mkpart primary ext4 0% 100%
mkfs.ext4 -L datapartition /dev/sdb1
e2label /dev/sdb1 hdd_cinder

parted -s /dev/sda mklabel msdos
parted -s -a opt /dev/sda mkpart primary ext4 0% 49%
mkfs.ext4 -L datapartition /dev/sda1
e2label /dev/sda1 hdd_glance
parted -s -a opt /dev/sda mkpart primary ext4 50% 100%
mkfs.ext4 -L datapartition /dev/sda2
e2label /dev/sda2 hdd_swift