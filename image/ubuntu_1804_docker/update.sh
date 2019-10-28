#!/usr/bin/env bash

set -e

# disable annoying apt-daily-upgrade.service
sudo systemctl mask apt-daily.service apt-daily-upgrade.service
sudo systemctl stop apt-daily.service
sudo systemctl kill --kill-who=all apt-daily.service
# wait until `apt-get updated` has been killed
while ! (sudo systemctl list-units --all apt-daily.service | fgrep -q dead)
do
  sleep 1;
done

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

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

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

sudo systemctl restart docker

docker --version
docker-compose --version
ctop -v

history -c
