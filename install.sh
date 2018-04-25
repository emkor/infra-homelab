#!/usr/bin/env bash

set -e

cd ~/openstack-on-hp-z600

sudo yum install -y centos-release-openstack-queens
sudo yum update -y
sudo yum install -y openstack-packstack

packstack --allinone --provision-demo=n --os-neutron-ovs-bridge-mappings=extnet:br-ex --os-neutron-ovs-bridge-interfaces=br-ex:enp1s0 --os-neutron-ml2-type-drivers=vxlan,flat



