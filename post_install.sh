#!/usr/bin/env bash

set -e

cd ~/openstack-on-hp-z600

# insert DNS addresses for OpenStack compute instances so those can reach Internet
sed -i "s/#dnsmasq_dns_servers =/dnsmasq_dns_servers = 192.168.192.254/g" /etc/neutron/dhcp_agent.ini

mkdir -p ~/.ssh
cp ./files/ssh_config ~/.ssh/config

cd ~
source ~/keystonerc_admin
neutron net-create external_network --provider:network_type flat --provider:physical_network extnet  --router:external --shared
neutron subnet-create --name public_subnet --enable_dhcp=False --allocation-pool=start=192.168.193.1,end=192.168.193.250 \
                        --gateway=192.168.192.254 external_network 192.168.192.0/23

openstack project create --enable development
openstack role add --user admin --project development admin
openstack user create --project development --password guest --enable guest
openstack role add --user guest --project development _member_
openstack quota set --instances 40 --key-pairs 20 --floating-ips 40 --cores 40 --ram 40960 --gigabytes 400 --volumes 40 --per-volume-gigabytes 40 --snapshots 20 development

export OS_PROJECT_NAME=development

neutron router-create main_router
neutron router-gateway-set main_router external_network

neutron net-create private_network
neutron subnet-create --name private_subnet private_network 172.16.0.0/16
neutron router-interface-add main_router private_subnet

cd ~/openstack-on-hp-z600
openstack keypair create --public-key ./files/openstack-hpz600.pub openstack-hpz600

openstack security group create --description "Open ICMP, SSH, HTTP, HTTPS etc." --project development development
openstack security group rule create --ingress --protocol icmp --remote-ip 0.0.0.0/0 --project development development
openstack security group rule create --egress --protocol icmp --remote-ip 0.0.0.0/0 --project development development

openstack security group rule create --ingress --protocol tcp --dst-port 22 --remote-ip 0.0.0.0/0 --project development development
openstack security group rule create --egress --protocol tcp --dst-port 22 --remote-ip 0.0.0.0/0 --project development development

openstack security group rule create --ingress --protocol tcp --dst-port 80 --remote-ip 0.0.0.0/0 --project development development
openstack security group rule create --egress --protocol tcp --dst-port 80 --remote-ip 0.0.0.0/0 --project development development

openstack security group rule create --ingress --protocol tcp --dst-port 443 --remote-ip 0.0.0.0/0 --project development development
openstack security group rule create --egress --protocol tcp --dst-port 443 --remote-ip 0.0.0.0/0 --project development development

openstack security group rule create --ingress --protocol tcp --dst-port 800 --remote-ip 0.0.0.0/0 --project development development
openstack security group rule create --egress --protocol tcp --dst-port 800 --remote-ip 0.0.0.0/0 --project development development

openstack security group rule create --ingress --protocol tcp --dst-port 8080 --remote-ip 0.0.0.0/0 --project development development
openstack security group rule create --egress --protocol tcp --dst-port 8080 --remote-ip 0.0.0.0/0 --project development development

openstack security group rule create --ingress --protocol tcp --dst-port 3306 --remote-ip 0.0.0.0/0 --project development development
openstack security group rule create --egress --protocol tcp --dst-port 3306 --remote-ip 0.0.0.0/0 --project development development

openstack security group rule create --ingress --protocol tcp --dst-port 5432 --remote-ip 0.0.0.0/0 --project development development
openstack security group rule create --egress --protocol tcp --dst-port 5432 --remote-ip 0.0.0.0/0 --project development development

# re-create default m1 flavors
openstack flavor delete m1.tiny
openstack flavor create --public --vcpus=1 --ram=512 --disk=2 m1.tiny
openstack flavor delete m1.small
openstack flavor create --public --vcpus=1 --ram=1024 --disk=5 m1.small
openstack flavor delete m1.medium
openstack flavor create --public --vcpus=2 --ram=2048 --disk=10 m1.medium
openstack flavor delete m1.large
openstack flavor create --public --vcpus=4 --ram=4096 --disk=20 m1.large
openstack flavor delete m1.xlarge
openstack flavor create --public --vcpus=8 --ram=8192 --disk=40 m1.xlarge
openstack flavor delete m1.xxlarge
openstack flavor create --public --vcpus=16 --ram=16384 --disk=80 m1.xxlarge

# create compute-specific c1 flavors
openstack flavor create --public --vcpus=2 --ram=1024 --disk=2 c1.small
openstack flavor create --public --vcpus=4 --ram=2048 --disk=4 c1.medium
openstack flavor create --public --vcpus=8 --ram=4096 --disk=8 c1.large
openstack flavor create --public --vcpus=16 --ram=8192 --disk=16 c1.xlarge
openstack flavor create --public --vcpus=32 --ram=16384 --disk=32 c1.xxlarge