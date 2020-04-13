#!/usr/bin/env bash

set -e

yum install -y centos-release-openstack-stein

# workaround: puppet binaries look for leatherman_curl.so.1.3.0 at some point
yum erase leatherman-1.10.0-1.el7
yum install -y leatherman-1.3.0-9.el7

yum install -y openstack-packstack

nohup packstack --debug --allinone --default-password PASSWORD_GOES_HERE --provision-demo=n \
  --mariadb-install=y --os-glance-install=y --os-cinder-install=y --os-nova-install=y --os-neutron-install=y --os-swift-install=y \
  --os-horizon-install=y --os-heat-install=y --os-heat-cfn-install=y --os-client-install=y \
  --os-ceilometer-install=n --os-aodh-install=n --os-manila-install=n --os-ironic-install=n --os-trove-install=n \
  --os-magnum-install=n --os-sahara-install=n --os-panko-install=n \
  --ntp-servers=0.europe.pool.ntp.org,1.europe.pool.ntp.org,2.europe.pool.ntp.org,3.europe.pool.ntp.org \
  --service-workers=6 --novasched-cpu-allocation-ratio=2.0 --novasched-ram-allocation-ratio=1.0 \
  --os-neutron-ovs-bridge-interfaces=br-ex:eno1 \
  --os-neutron-ml2-tenant-network-types=vxlan \
  --os-neutron-ml2-mechanism-drivers=openvswitch \
  --os-neutron-ml2-type-drivers=vxlan,flat \
  --os-neutron-l2-agent=openvswitch \
  >"openstack_install_$(date -u +"%Y-%m-%dT%H:%M:%SZ").log" 2>&1 &
