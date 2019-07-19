#!/usr/bin/env bash

set -e

# pre install
sudo apt-get update
sudo apt-get install -y curl make zip
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# install docker
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# post-installation steps
sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl enable docker

# install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# install ctop
sudo wget https://github.com/bcicen/ctop/releases/download/v0.7.2/ctop-0.7.2-linux-amd64 -O /usr/local/bin/ctop
sudo chmod +x /usr/local/bin/ctop

# include custom docker registry certificate file (ca.crt)
echo "192.168.193.1 docker-registry.cloud.local" | sudo tee -a /etc/hosts
sudo mkdir -p "/etc/docker/certs.d/docker-registry.cloud.local"
sudo cp ca.crt "/etc/docker/certs.d/docker-registry.cloud.local/"
sudo cp daemon.json /etc/docker/daemon.json
sudo systemctl restart docker

docker --version
docker-compose --version
ctop -v

history -c
