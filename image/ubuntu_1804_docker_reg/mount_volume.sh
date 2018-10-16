#!/usr/bin/env bash

set -e

echo "Mounting /dev/vdb1 at /mnt/docker_volume"
sudo mkdir -p /mnt/docker_volume
sudo mount -o defaults /dev/vdb1 /mnt/docker_volume
sudo chown -R ubuntu:ubuntu /mnt/docker_volume