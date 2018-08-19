#!/usr/bin/env bash

set -e

yum install -y epel-release
yum install -y sudo wget curl nano vim htop

# disable firewalld
systemctl disable firewalld
systemctl stop firewalld

# replace NetworkManager with network
systemctl disable NetworkManager
systemctl stop NetworkManager
systemctl enable network
systemctl start network

# for some reason, pip did not worked correctly out of the box in CentOS
wget https://bootstrap.pypa.io/ez_setup.py -O - | python

# disable SELinux
sed -i "s/SELINUX=.*/SELINUX=permissive/g" /etc/sysconfig/selinux
sed -i "s/SELINUXTYPE=.*/SELINUXTYPE=targeted/g" /etc/sysconfig/selinux
sed -i "s/SELINUX=.*/SELINUX=permissive/g" /etc/selinux/config
sed -i "s/SELINUXTYPE=.*/SELINUXTYPE=targeted/g" /etc/selinux/config