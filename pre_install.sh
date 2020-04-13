#!/usr/bin/env bash

set -e

yum install -y epel-release
yum install -y sudo wget curl nano vim net-tools git zip unzip
yum install -y openstack-utils ncdu htop
yum update -y

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py
rm -f get-pip.py
pip install --upgrade pip

# for some reason, pip did not worked correctly out of the box in CentOS
wget https://bootstrap.pypa.io/ez_setup.py -O - | python
rm -f ./setuptools-*.zip

# disable firewalld
systemctl disable firewalld
systemctl stop firewalld

# replace NetworkManager with network
systemctl disable NetworkManager
systemctl stop NetworkManager
systemctl enable network
systemctl start network

# disable SELinux
sed -i "s/SELINUX=.*/SELINUX=permissive/g" /etc/sysconfig/selinux
sed -i "s/SELINUXTYPE=.*/SELINUXTYPE=targeted/g" /etc/sysconfig/selinux
sed -i "s/SELINUX=.*/SELINUX=permissive/g" /etc/selinux/config
sed -i "s/SELINUXTYPE=.*/SELINUXTYPE=targeted/g" /etc/selinux/config

# echo name of the host to /etc/hosts (RabbitMQ cannot start server on "lenovo-c30" cause it doesn't know what host is this)
echo "127.0.0.1   $(hostname)" >> /etc/hosts

# reboot