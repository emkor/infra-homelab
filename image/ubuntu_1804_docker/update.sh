#!/usr/bin/env bash

set -e

# pre install
sudo apt-get update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    make

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# install docker
sudo apt-get update
sudo apt-get install -y docker-ce

# post-installation steps
sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl enable docker

# install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# install ctop
sudo wget https://github.com/bcicen/ctop/releases/download/v0.7.1/ctop-0.7.1-linux-amd64 -O /usr/local/bin/ctop
sudo chmod +x /usr/local/bin/ctop

docker --version
docker-compose --version
ctop -v

history -c
