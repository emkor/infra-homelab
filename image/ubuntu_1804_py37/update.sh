#!/usr/bin/env bash

set -e

sudo apt-get update
sudo apt-get install -y curl make zip software-properties-common

sudo add-apt-repository --yes --update ppa:deadsnakes/ppa
sudo apt install python3.7

sudo ln -s /usr/bin/python3.7 /usr/bin/python3
sudo ln -s /usr/bin/python3.7 /usr/bin/python

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python3 get-pip.py

rm -rf ./get-pip.py
sudo apt clean -y
sudo apt autoclean -y
sudo apt autoremove -y

python --version
pip --version

history -c
