#!/usr/bin/env bash

set -e

source ~/keystonerc_admin
mkdir ~/image && cd ~/image

# download and create images for Centos 7, Debian 8 and Debian 9
wget http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2 -O CentOS-7.qcow2
glance image-create --name CentOS-7 --architecture x86_64 --disk-format qcow2 --container-format bare --visibility public --protected True --file ./CentOS-7.qcow2
rm -f ./CentOS-7.qcow2