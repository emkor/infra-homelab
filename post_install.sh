#!/usr/bin/env bash

set -e

cd ~/openstack-on-hp-z600

# insert DNS addresses for OpenStack compute instances so those can reach Internet
sed -i "s/#dnsmasq_dns_servers =/dnsmasq_dns_servers = 1.1.1.1, 8.8.8.8, 8.8.4.4/g" /etc/neutron/dhcp_agent.ini

cd ~
source ~/keystonerc_admin
neutron net-create external_network --provider:network_type flat --provider:physical_network extnet  --router:external --shared
neutron subnet-create --name public_subnet --enable_dhcp=False --allocation-pool=start=192.168.193.1,end=192.168.193.250 \
                        --gateway=192.168.192.254 external_network 192.168.192.0/23

openstack project create --enable development
openstack role add --user admin --project development admin
openstack user create --project development --password guest --enable guest
openstack role add --user guest --project development _member_
openstack quota set --instances 40 --key-pairs 20 --floating-ips 40 --cores 40 --ram 40960 --gigabytes 400 --volumes 20 --per-volume-gigabytes 40 --snapshots 10 development

export OS_PROJECT_NAME=development

neutron router-create main_router
neutron router-gateway-set main_router external_network

neutron net-create private_network
neutron subnet-create --name private_subnet private_network 172.16.0.0/16
neutron router-interface-add main_router private_subnet