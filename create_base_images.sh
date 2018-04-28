#!/usr/bin/env bash

set -e

source ~/keystonerc_admin
export OS_PROJECT_NAME=development

mkdir ~/image && cd ~/image

# download and create images for Centos 7, Debian 8 and Debian 9
wget http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2 -O CentOS-7.qcow2
glance image-create --name CentOS-7 --architecture x86_64 --disk-format qcow2 --container-format bare --visibility public --protected True --file ./CentOS-7.qcow2
rm -f ./CentOS-7.qcow2

wget https://stable.release.core-os.net/amd64-usr/current/coreos_production_openstack_image.img.bz2
bunzip2 coreos_production_openstack_image.img.bz2
glance image-create --name CoreOS --disk-format qcow2 --container-format bare --visibility public --protected True --file ./coreos_production_openstack_image.img
rm -f coreos_production_openstack_image.img

wget  http://cdimage.debian.org/cdimage/openstack/current-9/debian-9-openstack-amd64.qcow2  -O debian-9.qcow2
glance image-create --name Debian-9 --disk-format qcow2 --container-format bare --visibility public --protected True --file ./debian-9.qcow2
rm debian-9.qcow2

wget  http://cdimage.debian.org/cdimage/openstack/current-8/debian-8-openstack-amd64.qcow2  -O debian-8.qcow2
glance image-create --name Debian-8 --disk-format qcow2 --container-format bare --visibility public --protected True --file ./debian-8.qcow2
rm debian-8.qcow2

wget http://cloud-images.ubuntu.com/releases/server/16.04/release/ubuntu-16.04-server-cloudimg-amd64-disk1.img -O ubuntu-16.04.img
glance image-create --name UbuntuServer16_04 --disk-format qcow2 --container-format bare --visibility public --protected True --file ./ubuntu-16.04.img
rm ubuntu-16.04.img

wget  http://cloud-images.ubuntu.com/releases/server/17.10/release/ubuntu-17.10-server-cloudimg-amd64.img -O ubuntu-17.10.img
glance image-create --name UbuntuServer16_04 --disk-format qcow2 --container-format bare --visibility public --protected True --file ./ubuntu-17.10.img
rm ubuntu-17.10.img
