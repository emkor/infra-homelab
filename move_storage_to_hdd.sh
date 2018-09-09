#!/usr/bin/env bash

set -e

echo 'Assuming /dev/sda1 is a partition for Glance images...'
echo 'Assuming /dev/sda2 is a partition for Swift objects...'
echo 'Assuming /dev/sdb1 is a partition for Cinder volumes...'

if [ -f /dev/sda1 ] ; then {
    if [ -f /dev/sda2 ] ; then {
        if [ -f /dev/sdb1 ] ; then {

            systemctl stop openstack-cinder-api
            systemctl stop openstack-cinder-volume
            systemctl stop openstack-cinder-scheduler
            systemctl stop openstack-glance-api
            systemctl stop openstack-glance-registry
            systemctl stop openstack-swift-proxy
            systemctl stop openstack-swift-account-auditor
            systemctl stop openstack-swift-account-reaper
            systemctl stop openstack-swift-account-replicator
            systemctl stop openstack-swift-account
            systemctl stop openstack-swift-container-auditor
            systemctl stop openstack-swift-container-replicator
            systemctl stop openstack-swift-container-sync
            systemctl stop openstack-swift-container-updater
            systemctl stop openstack-swift-container
            systemctl stop openstack-swift-object-auditor
            systemctl stop openstack-swift-object-expirer
            systemctl stop openstack-swift-object-reconstructor
            systemctl stop openstack-swift-object-replicator
            systemctl stop openstack-swift-object-updater
            systemctl stop openstack-swift-object

            mkdir -p /backup
            mv /var/lib/cinder /backup
            mv /var/lib/glance /backup
            mv /var/lib/swift /backup

            mkdir /var/lib/cinder
            mkdir /var/lib/glance
            mkdir /var/lib/swift

            mount /dev/sda1 /var/lib/glance
            mount /dev/sda2 /var/lib/swift
            mount /dev/sdb1 /var/lib/cinder

            cp -R /backup/cinder /var/lib/
            cp -R /backup/glance /var/lib/
            cp -R /backup/swift /var/lib/

            chown -R cinder:cinder /var/lib/cinder
            chown root:root /var/lib/cinder/cinder-volumes

            chown -R glance:nobody /var/lib/glance
            chown -R glance:glance /var/lib/glance/images

            chown -R swift:swift /var/lib/swift
            chown -R glance:glance /var/lib/glance/images

            systemctl start openstack-cinder-scheduler
            systemctl start openstack-cinder-volume
            systemctl start openstack-cinder-api
            systemctl start openstack-glance-registry
            systemctl start openstack-glance-api
            systemctl start openstack-swift-object
            systemctl start openstack-swift-object-updater
            systemctl start openstack-swift-object-replicator
            systemctl start openstack-swift-object-reconstructor
            systemctl start openstack-swift-object-expirer
            systemctl start openstack-swift-object-auditor
            systemctl start openstack-swift-account
            systemctl start openstack-swift-account-auditor
            systemctl start openstack-swift-account-reaper
            systemctl start openstack-swift-account-replicator
            systemctl start openstack-swift-container
            systemctl start openstack-swift-container-auditor
            systemctl start openstack-swift-container-replicator
            systemctl start openstack-swift-container-sync
            systemctl start openstack-swift-container-updater
            systemctl start openstack-swift-proxy

            echo 'You can now remove backups at /backup'
            echo 'Make sure to edit /etc/fstab!'
        }
        fi
    }
    fi
}
fi