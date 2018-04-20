#!/usr/bin/env bash

yum install -y sudo wget curl nano vim htop

sudo systemctl disable firewalld
sudo systemctl stop firewalld
sudo systemctl disable NetworkManager
sudo systemctl stop NetworkManager
sudo systemctl enable network
sudo systemctl start network

sudo yum install -y centos-release-openstack-queens
sudo yum update -y
sudo yum install -y openstack-packstack

packstack --allinone --provision-demo=n --os-neutron-ovs-bridge-mappings=extnet:br-ex --os-neutron-ovs-bridge-interfaces=br-ex:enp1s0 --os-neutron-ml2-type-drivers=vxlan,flat

sudo cp files/ifcfg-br-ex /etc/sysconfig/network-scripts/ifcfg-br-ex
sudo cp files/ifcfg-enp1s0 /etc/sysconfig/network-scripts/ifcfg-enp1s0
systemctl restart network

source keystonerc_admin
neutron net-create external_network --provider:network_type flat --provider:physical_network extnet  --router:external
neutron subnet-create --name public_subnet --enable_dhcp=False --allocation-pool=start=192.168.193.1,end=192.168.193.250 \
                        --gateway=192.168.192.254 external_network 192.168.192.0/23

neutron router-create main_router
neutron router-gateway-set main_router external_network

neutron net-create private_network
neutron subnet-create --name private_subnet private_network 172.16.0.0/16
neutron router-interface-add main_router private_subnet