#!/usr/bin/env bash

set -e

sudo yum install -y centos-release-openstack-queens
sudo yum update -y
sudo yum install -y openstack-packstack


packstack --allinone --provision-demo=n --os-neutron-ovs-bridge-mappings=extnet:br-ex --os-neutron-ovs-bridge-interfaces=br-ex:enp1s0 --os-neutron-ml2-type-drivers=vxlan,flat

sudo cp files/ifcfg-br-ex /etc/sysconfig/network-scripts/ifcfg-br-ex
sudo cp files/ifcfg-enp1s0 /etc/sysconfig/network-scripts/ifcfg-enp1s0
systemctl restart network

cd ~
source keystonerc_admin
neutron net-create external_network --provider:network_type flat --provider:physical_network extnet  --router:external
neutron subnet-create --name public_subnet --enable_dhcp=False --allocation-pool=start=192.168.193.1,end=192.168.193.250 \
                        --gateway=192.168.192.254 external_network 192.168.192.0/23

neutron router-create main_router
neutron router-gateway-set main_router external_network

neutron net-create private_network
neutron subnet-create --name private_subnet private_network 172.16.0.0/16
neutron router-interface-add main_router private_subnet

# insert DNS addresses for Openstack compute instances
sed -i "s/#dnsmasq_dns_servers =/dnsmasq_dns_servers = 1.1.1.1, 8.8.8.8, 8.8.4.4/g" /etc/neutron/dhcp_agent.ini

# disable telemetry services
systemctl stop openstack-aodh-evaluator && systemctl disable openstack-aodh-evaluator
systemctl stop openstack-aodh-listener && systemctl disable openstack-aodh-listener
systemctl stop openstack-aodh-notifier && systemctl disable openstack-aodh-notifier
systemctl stop openstack-ceilometer-central && systemctl disable openstack-ceilometer-central
systemctl stop openstack-ceilometer-notification && systemctl disable openstack-ceilometer-notification
systemctl stop openstack-ceilometer-polling && systemctl disable openstack-ceilometer-polling
systemctl stop openstack-gnocchi-metricd && systemctl disable openstack-gnocchi-metricd
systemctl stop openstack-gnocchi-statsd && systemctl disable openstack-gnocchi-statsd

# set worker count for each service to 6
sed -i "s/workers.*=.*/workers=6/g" /etc/glance/glance-api.conf
sed -i "s/workers.*=.*/workers=6/g" /etc/glance/glance-registry.conf
sed -i "s/workers.*=.*/workers=6/g" /etc/nova/nova.conf
sed -i "s/workers.*=.*/workers=6/g" /etc/swift/proxy-server.conf
sed -i "s/workers.*=.*/workers=6/g" /etc/swift/account-server.conf
sed -i "s/workers.*=.*/workers=6/g" /etc/swift/container-server.conf
sed -i "s/workers.*=.*/workers=6/g" /etc/swift/object-server.conf
sed -i "s/api_workers.*=.*/api_workers=6/g" /etc/neutron/neutron.conf
sed -i "s/rpc_workers.*=.*/rpc_workers=6/g" /etc/neutron/neutron.conf
sed -i "s/osapi_volume_worker.*=.*/osapi_volume_worker=6/g" /etc/cinder/cinder.conf