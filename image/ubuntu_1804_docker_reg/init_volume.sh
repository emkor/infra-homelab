#!/usr/bin/env bash

set -e

echo "Formatting /dev/vdb..."
sudo parted /dev/vdb mklabel msdos
sudo parted -a opt /dev/vdb mkpart primary ext4 0% 100%
sudo mkfs.ext4 -L docker_volume /dev/vdb1