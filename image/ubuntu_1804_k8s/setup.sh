#!/usr/bin/env bash

set -e

PRIVATE_NETWORK_UUID="5b21d621-448b-4071-a6c6-95b07afe118d"
EXTERNAL_NETWORK_UUID="48e05747-f3f7-4b03-a7a5-5e91ad31ec8a"
UBUNTU_IMAGE_UUID="95d3e694-dd18-4f4d-aeb2-7c297b69fe4f"

sudo snap install juju --classic

juju add-cloud --local openstack-teczowa clouds.yaml
juju add-credential openstack-teczowa -f creds.yaml

mkdir -p ~/simplestreams/images
juju metadata generate-image -d ~/simplestreams -i $UBUNTU_IMAGE_UUID -r RegionOne -u http://192.168.192.250:5000/v3

juju bootstrap openstack-teczowa juju-teczowa --config network=$PRIVATE_NETWORK_UUID --config external-network=$EXTERNAL_NETWORK_UUID --config use-floating-ip=true --metadata-source /home/ubuntu/simplestreams --credential guest --verbose

juju add-model k8s-test --verbose
juju model-config external-network=$EXTERNAL_NETWORK_UUID
juju model-config network=$PRIVATE_NETWORK_UUID
juju model-config use-floating-ip=true

juju deploy charmed-kubernetes --verbose

# to watch status:
#watch -c juju status --color

# FROM https://ubuntu.com/kubernetes/docs/operations
# wait till installation is done, and then:
#mkdir -p ~/.kube
#juju scp kubernetes-master/0:config ~/.kube/config
#kubectl config view

# to access GUI, use:
#kubectl proxy

# then, navigate to: http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/