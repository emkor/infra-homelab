#!/usr/bin/env bash

set -e

yum install -y sudo wget curl nano vim

# disable firewalld
sudo systemctl disable firewalld
sudo systemctl stop firewalld

# replace NetworkManager with network
sudo systemctl disable NetworkManager
sudo systemctl stop NetworkManager
sudo systemctl enable network
sudo systemctl start network

# for some reason, pip did not worked correctly out of the box in CentOS
wget https://bootstrap.pypa.io/ez_setup.py -O - | python

# disable SELinux
sed -i "s/SELINUX=.*/SELINUX=permissive/g" /etc/sysconfig/selinux
sed -i "s/SELINUXTYPE=.*/SELINUXTYPE=targeted/g" /etc/sysconfig/selinux
sed -i "s/SELINUX=.*/SELINUX=permissive/g" /etc/selinux/config
sed -i "s/SELINUXTYPE=.*/SELINUXTYPE=targeted/g" /etc/selinux/config