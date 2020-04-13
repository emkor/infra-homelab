#!/usr/bin/env bash

set -e

source ~/keystonerc_admin
export OS_PROJECT_NAME=development

# basic instructions from https://docs.openstack.org/image-guide/obtain-images.html

wget http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2 -O CentOS-7.qcow2
glance image-create --name "centos-7-$(date -u --rfc-3339=date)" --architecture x86_64 --disk-format qcow2 --container-format bare --visibility public --protected True --min-disk 8 --file ./CentOS-7.qcow2
rm -f ./CentOS-7.qcow2

wget http://cloud.centos.org/centos/8/x86_64/images/CentOS-8-GenericCloud-8.1.1911-20200113.3.x86_64.qcow2 -O CentOS-8.qcow2
glance image-create --name "centos-8-$(date -u --rfc-3339=date)" --architecture x86_64 --disk-format qcow2 --container-format bare --visibility public --protected True --min-disk 8 --file ./CentOS-8.qcow2
rm -f ./CentOS-8.qcow2

wget http://cdimage.debian.org/cdimage/openstack/current-9/debian-9-openstack-amd64.qcow2 -O debian-9.qcow2
glance image-create --name "debian-9-$(date -u --rfc-3339=date)" --architecture x86_64 --disk-format qcow2 --container-format bare --visibility public --protected True --min-disk 2 --file ./debian-9.qcow2
rm debian-9.qcow2

wget http://cdimage.debian.org/cdimage/openstack/current-10/debian-10-openstack-amd64.qcow2 -O debian-10.qcow2
glance image-create --name "debian-10-$(date -u --rfc-3339=date)" --architecture x86_64 --disk-format qcow2 --container-format bare --visibility public --protected True --min-disk 2 --file ./debian-10.qcow2
rm debian-10.qcow2

wget http://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img -O ubuntu-18.04.img
glance image-create --name "ubuntu-18.04-$(date -u --rfc-3339=date)" --architecture x86_64 --disk-format qcow2 --container-format bare --visibility public --protected True --min-disk 4 --file ./ubuntu-18.04.img
rm ubuntu-18.04.img

# to be able to remove image:
# openstack image set IMAGE_NAME --unprotected
# openstack image delete IMAGE_NAME
