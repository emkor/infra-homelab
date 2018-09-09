#!/usr/bin/env bash

set -e

source ~/keystonerc_admin
export OS_PROJECT_NAME=development

mkdir ~/image && cd ~/image

# download and create images for Centos 7, Debian 8 and Debian 9
wget http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2 -O CentOS-7.qcow2
glance image-create --name CentOS-7 --architecture x86_64 --disk-format qcow2 --container-format bare --visibility public --protected True --min-disk 8 --file ./CentOS-7.qcow2
rm -f ./CentOS-7.qcow2

wget https://stable.release.core-os.net/amd64-usr/current/coreos_production_openstack_image.img.bz2
bunzip2 coreos_production_openstack_image.img.bz2
glance image-create --name CoreOS --architecture x86_64 --disk-format qcow2 --container-format bare --visibility public --protected True --min-disk 10 --file ./coreos_production_openstack_image.img
rm -f coreos_production_openstack_image.img

# Debian 9 causes errors when booting up!
#wget  http://cdimage.debian.org/cdimage/openstack/current-9/debian-9-openstack-amd64.qcow2 -O debian-9.qcow2
#glance image-create --name Debian-9 --architecture x86_64 --disk-format qcow2 --container-format bare --visibility public --protected True --min-disk 2 --file ./debian-9.qcow2
#rm debian-9.qcow2

wget  http://cdimage.debian.org/cdimage/openstack/current-8/debian-8-openstack-amd64.qcow2 -O debian-8.qcow2
glance image-create --name Debian-8 --architecture x86_64 --disk-format qcow2 --container-format bare --visibility public --protected True --min-disk 2 --file ./debian-8.qcow2
rm debian-8.qcow2

wget http://cloud-images.ubuntu.com/releases/server/16.04/release/ubuntu-16.04-server-cloudimg-amd64-disk1.img -O ubuntu-16.04.img
glance image-create --name Ubuntu-16-04 --architecture x86_64 --disk-format qcow2 --container-format bare --visibility public --protected True --min-disk 4 --file ./ubuntu-16.04.img
rm ubuntu-16.04.img

wget http://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img -O ubuntu-18.04.img
glance image-create --name Ubuntu-18-04 --architecture x86_64 --disk-format qcow2 --container-format bare --visibility public --protected True --min-disk 4 --file ./ubuntu-18.04.img
rm ubuntu-18.04.img

wget https://ftp.icm.edu.pl/pub/Linux/fedora/linux/releases/28/Cloud/x86_64/images/Fedora-Cloud-Base-28-1.1.x86_64.qcow2  -O fedora-28.qcow2
glance image-create --name Fedora-28 --architecture x86_64 --disk-format qcow2 --container-format bare --visibility public --protected True --min-disk 4 --file ./fedora-28.qcow2
rm fedora-28.qcow2

# to be able to remove image:
# openstack image set <image name> --unprotected