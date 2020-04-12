#!/usr/bin/env bash

set -e

mkdir -p .terminfo/r
# on client
scp /usr/share/terminfo/r/rxvt-unicode-256color c30:.terminfo/r/

yum install -y epel-release
yum install -y sudo wget curl nano vim htop openstack-utils net-tools git zip unzip ncdu
yum update -y

# disable firewalld
systemctl disable firewalld
systemctl stop firewalld

# replace NetworkManager with network
systemctl disable NetworkManager
systemctl stop NetworkManager
systemctl enable network
systemctl start network

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py
rm -f get-pip.py

# for some reason, pip did not worked correctly out of the box in CentOS
wget https://bootstrap.pypa.io/ez_setup.py -O - | python
rm -f ./setuptools-*.zip

# disable SELinux
sed -i "s/SELINUX=.*/SELINUX=permissive/g" /etc/sysconfig/selinux
sed -i "s/SELINUXTYPE=.*/SELINUXTYPE=targeted/g" /etc/sysconfig/selinux
sed -i "s/SELINUX=.*/SELINUX=permissive/g" /etc/selinux/config
sed -i "s/SELINUXTYPE=.*/SELINUXTYPE=targeted/g" /etc/selinux/config

# echo name of the host to /etc/hosts (RabbitMQ cannot start server on "lenovo-c30" cause it doesn't know what host is this)
echo "127.0.0.1   $(hostname)" >> /etc/hosts

# reboot