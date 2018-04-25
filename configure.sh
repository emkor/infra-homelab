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
