#!/usr/bin/env bash

set -e

source ~/keystonerc_admin
export OS_PROJECT_NAME=development

# apply  fix from: https://www.savelono.com/cloud/openstack-rdo-queens-magnum-kubernetes-cluster-getting-past-volumetype-error.html
# append those lines in /etc/magnum/magnum.conf:
# [cinder]
# default_docker_volume_type = iscsi

# then:
openstack-service restart heat
openstack-service restart magnum

openstack coe cluster template create k8s-cluster-template \
                           --image fedora-atomic-latest \
                           --keypair openstack-hpz600 \
                           --external-network external_network \
                           --dns-nameserver 8.8.8.8 \
                           --fixed-network private_network \
                           --fixed-subnet private_subnet \
                           --master-flavor m1.medium \
                           --flavor m1.large \
                           --docker-volume-size 8 \
                           --network-driver flannel \
                           --public --tls-disabled \
                           --server-type vm \
                           --coe kubernetes

openstack coe cluster create k8s-cluster \
                  --cluster-template k8s-cluster-template \
                  --node-count 3 \
                  --master-count 1