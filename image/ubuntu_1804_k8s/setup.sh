#!/usr/bin/env bash

set -e

PRIVATE_NETWORK_UUID="dd903afe-d743-4256-90b4-330b4d9d03d4"
EXTERNAL_NETWORK_UUID="07e092c6-482e-4889-96e9-4cfe97b9be2e"
UBUNTU_IMAGE_UUID="ec561efe-7ece-48a0-91f5-edbf04f9f04a"

sudo snap install juju --classic

juju add-cloud --local openstack-teczowa clouds.yaml
juju add-credential openstack-teczowa -f creds.yaml

mkdir -p ~/simplestreams/images
juju metadata generate-image -d ~/simplestreams -i $UBUNTU_IMAGE_UUID -s bionic -r RegionOne -u http://192.168.192.250:5000/v3

juju bootstrap openstack-teczowa juju-teczowa --config network=$PRIVATE_NETWORK_UUID --config external-network=$EXTERNAL_NETWORK_UUID --config use-floating-ip=true --metadata-source /home/ubuntu/simplestreams --credential guest --verbose

juju add-model k8s-test --verbose
juju model-config external-network=$EXTERNAL_NETWORK_UUID
juju model-config network=$PRIVATE_NETWORK_UUID
juju model-config use-floating-ip=true

juju deploy charmed-kubernetes --verbose

# to watch status:
watch -c juju status --color

# FROM https://ubuntu.com/kubernetes/docs/operations
# wait till installation is done, and then:
mkdir -p ~/.kube
juju scp kubernetes-master/0:config ~/.kube/config
kubectl config view

# to access GUI, use:
kubectl proxy

# then, navigate to: http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/