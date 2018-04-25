#!/usr/bin/env bash

set -e

# disable telemetry services
systemctl stop openstack-aodh-evaluator && systemctl disable openstack-aodh-evaluator
systemctl stop openstack-aodh-listener && systemctl disable openstack-aodh-listener
systemctl stop openstack-aodh-notifier && systemctl disable openstack-aodh-notifier
systemctl stop openstack-ceilometer-central && systemctl disable openstack-ceilometer-central
systemctl stop openstack-ceilometer-notification && systemctl disable openstack-ceilometer-notification
systemctl stop openstack-ceilometer-polling && systemctl disable openstack-ceilometer-polling
systemctl stop openstack-gnocchi-metricd && systemctl disable openstack-gnocchi-metricd
systemctl stop openstack-gnocchi-statsd && systemctl disable openstack-gnocchi-statsd

# set worker count for each service to 6 to save some RAM
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

# change allocation ratio to more strict
sed -i "s/cpu_allocation_ratio.*=.*/cpu_allocation_ratio=2.0/g" /etc/nova/nova.conf
sed -i "s/ram_allocation_ratio.*=.*/ram_allocation_ratio=1.0/g" /etc/nova/nova.conf

# create development project, add guest user, update project quotas, disable admin project
cd ~
source ~/keystonerc_admin
openstack project create --description 'development' development --domain default --enable
openstack role add --user admin --project development admin
openstack quota set --instances 40 --key-pairs 20 --floating-ips 40 --cores 40 --ram 40960 --gigabytes 400 --volumes 20 --per-volume-gigabytes 40 --snapshots 10 development
openstack user create --project development --password guest guest
openstack role add --user guest --project development _member_

openstack service delete aodh
openstack service delete gnocchi
openstack service delete ceilometer
