#!/usr/bin/env bash

set -e

source ~/keystonerc_admin

# insert DNS addresses for whole OpenStack installation so VMs can reach Internet through server names
# steps taken from: https://docs.openstack.org/neutron/stein/admin/config-dns-res.html
echo "dnsmasq_dns_servers = 192.168.192.1" | sudo tee -a /etc/neutron/dhcp_agent.ini

neutron net-create external_network --provider:network_type flat --provider:physical_network extnet --router:external --shared
neutron subnet-create --name public_subnet --enable_dhcp=False --allocation-pool=start=192.168.193.1,end=192.168.193.199 \
  --gateway=192.168.192.1 external_network 192.168.192.0/23

openstack project create --enable development
openstack role add --user admin --project development admin
openstack user create --project development --password guest --enable guest
openstack role add --user guest --project development _member_
openstack quota set --instances 48 --key-pairs 48 --floating-ips 48 --cores 48 --ram 49152 --gigabytes 400 --volumes 48 --per-volume-gigabytes 40 --snapshots 48 --secgroups 48 --secgroup-rules 160 development

export OS_PROJECT_NAME=development

neutron router-create main_router
neutron router-gateway-set --fixed-ip ip_address=192.168.193.254 main_router external_network

neutron net-create private_network
neutron subnet-create --name private_subnet private_network 172.16.0.0/16
neutron router-interface-add main_router private_subnet

openstack flavor delete m1.tiny
openstack flavor create --public --vcpus=1 --ram=1024 --disk=5 m1.tiny
openstack flavor delete m1.small
openstack flavor create --public --vcpus=2 --ram=2048 --disk=10 m1.small
openstack flavor delete m1.medium
openstack flavor create --public --vcpus=4 --ram=4096 --disk=20 m1.medium
openstack flavor delete m1.large
openstack flavor create --public --vcpus=8 --ram=8192 --disk=40 m1.large
openstack flavor delete m1.xlarge
openstack flavor create --public --vcpus=16 --ram=16384 --disk=80 m1.xlarge
openstack flavor create --public --vcpus=24 --ram=24576 --disk=120 m1.xxlarge

openstack floating ip create --floating-ip-address 192.168.193.1 external_network
openstack floating ip create --floating-ip-address 192.168.193.2 external_network
openstack floating ip create --floating-ip-address 192.168.193.3 external_network
openstack floating ip create --floating-ip-address 192.168.193.4 external_network
openstack floating ip create --floating-ip-address 192.168.193.5 external_network
openstack floating ip create --floating-ip-address 192.168.193.6 external_network
openstack floating ip create --floating-ip-address 192.168.193.7 external_network
openstack floating ip create --floating-ip-address 192.168.193.8 external_network
openstack floating ip create --floating-ip-address 192.168.193.9 external_network
openstack floating ip create --floating-ip-address 192.168.193.10 external_network

openstack security group create --description "TCP+UDP+ICMP opened (ports 1-65535)" --project development all-open
openstack security group rule create --ingress --protocol icmp --remote-ip 10.0.0.0/8 --project development all-open
openstack security group rule create --egress --protocol icmp --remote-ip 0.0.0.0/0 --project development all-open
openstack security group rule create --ingress --protocol tcp --dst-port 1:65535 --remote-ip 0.0.0.0/0 --project development all-open
openstack security group rule create --egress --protocol tcp --dst-port 1:65535 --remote-ip 0.0.0.0/0 --project development all-open
openstack security group rule create --ingress --protocol udp --dst-port 1:65535 --remote-ip 0.0.0.0/0 --project development all-open
openstack security group rule create --egress --protocol udp --dst-port 1:65535 --remote-ip 0.0.0.0/0 --project development all-open

openstack security group create --description "No Internet access" --project development no-internet

# delete default rules which include opening to everything
for sgr in $(openstack security group rule list -c ID -f value no-internet); do openstack security group rule delete $sgr; done

openstack security group rule create --ingress --protocol icmp --remote-ip 10.0.0.0/8 --project development no-internet
openstack security group rule create --ingress --protocol icmp --remote-ip 172.16.0.0/12 --project development no-internet
openstack security group rule create --ingress --protocol icmp --remote-ip 192.168.0.0/16 --project development no-internet
openstack security group rule create --ingress --protocol icmp --remote-ip 169.254.0.0/16 --project development no-internet

openstack security group rule create --egress --protocol icmp --remote-ip 10.0.0.0/8 --project development no-internet
openstack security group rule create --egress --protocol icmp --remote-ip 172.16.0.0/12 --project development no-internet
openstack security group rule create --egress --protocol icmp --remote-ip 192.168.0.0/16 --project development no-internet
openstack security group rule create --egress --protocol icmp --remote-ip 169.254.0.0/16 --project development no-internet

openstack security group rule create --ingress --protocol tcp --dst-port 1:65535 --remote-ip 10.0.0.0/8 --project development no-internet
openstack security group rule create --ingress --protocol tcp --dst-port 1:65535 --remote-ip 172.16.0.0/12 --project development no-internet
openstack security group rule create --ingress --protocol tcp --dst-port 1:65535 --remote-ip 192.168.0.0/16 --project development no-internet
openstack security group rule create --ingress --protocol tcp --dst-port 1:65535 --remote-ip 169.254.0.0/16 --project development no-internet

openstack security group rule create --egress --protocol tcp --dst-port 1:65535 --remote-ip 10.0.0.0/8 --project development no-internet
openstack security group rule create --egress --protocol tcp --dst-port 1:65535 --remote-ip 172.16.0.0/12 --project development no-internet
openstack security group rule create --egress --protocol tcp --dst-port 1:65535 --remote-ip 192.168.0.0/16 --project development no-internet
openstack security group rule create --egress --protocol tcp --dst-port 1:65535 --remote-ip 169.254.0.0/16 --project development no-internet

openstack security group rule create --ingress --protocol udp --dst-port 1:65535 --remote-ip 10.0.0.0/8 --project development no-internet
openstack security group rule create --ingress --protocol udp --dst-port 1:65535 --remote-ip 172.16.0.0/12 --project development no-internet
openstack security group rule create --ingress --protocol udp --dst-port 1:65535 --remote-ip 192.168.0.0/16 --project development no-internet
openstack security group rule create --ingress --protocol udp --dst-port 1:65535 --remote-ip 169.254.0.0/16 --project development no-internet

openstack security group rule create --egress --protocol udp --dst-port 1:65535 --remote-ip 10.0.0.0/8 --project development no-internet
openstack security group rule create --egress --protocol udp --dst-port 1:65535 --remote-ip 172.16.0.0/12 --project development no-internet
openstack security group rule create --egress --protocol udp --dst-port 1:65535 --remote-ip 192.168.0.0/16 --project development no-internet
openstack security group rule create --egress --protocol udp --dst-port 1:65535 --remote-ip 169.254.0.0/16 --project development no-internet
