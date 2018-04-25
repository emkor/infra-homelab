#!/usr/bin/env bash

set -e

source ~/keystonerc_admin
mkdir ~/image && cd ~/image

# download and create images for Centos 7, Debian 8 and Debian 9
wget http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2 -O CentOS-7.qcow2
glance image-create --name CentOS-7 --architecture x86_64 --disk-format qcow2 --container-format bare --visibility public --protected True --file ./CentOS-7.qcow2
rm -f ./CentOS-7.qcow2

wget https://stable.release.core-os.net/amd64-usr/current/coreos_production_openstack_image.img.bz2
bunzip2 coreos_production_openstack_image.img.bz2
glance image-create --name CoreOS --disk-format qcow2 --container-format bare --visibility public --protected True --file ./coreos_production_openstack_image.img
rm -f coreos_production_openstack_image.img
