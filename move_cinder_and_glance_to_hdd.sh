#!/usr/bin/env bash

set -e

echo 'Assuming /dev/sda1 is a partition for Glance images...'
echo 'Assuming /dev/sdb1 is a partition for Cinder volumes...'

if [ -f /dev/sda1 ] ; then {
    if [ -f /dev/sdb1 ] ; then {

        systemctl stop openstack-cinder-api.service
        systemctl stop openstack-cinder-volume.service
        systemctl stop openstack-cinder-scheduler.service
        systemctl stop openstack-glance-api.service
        systemctl stop openstack-glance-registry.service

        mkdir /backup
        mv /var/lib/cinder /backup
        mv /var/lib/glance /backup

        mkdir /var/lib/cinder
        mkdir /var/lib/glance

        mount /dev/sda1 /var/lib/glance
        mount /dev/sdb1 /var/lib/cinder

        cp -R /backup/cinder /var/lib/
        cp -R /backup/glance /var/lib/

        chown -R cinder:cinder /var/lib/cinder
        chown root:root /var/lib/cinder/cinder-volumes

        chown -R glance:nobody /var/lib/glance
        chown -R glance:glance /var/lib/glance/images

        systemctl start openstack-cinder-scheduler.service
        systemctl start openstack-cinder-volume.service
        systemctl start openstack-cinder-api.service
        systemctl start openstack-glance-registry.service
        systemctl start openstack-glance-api.service

        echo 'You can now remove backups at /backup'
        echo 'Make sure to edit /etc/fstab!'
    }
    fi
}
fi