#!/usr/bin/env bash

set -e

sudo apt update
sudo apt-get install -y curl make zip software-properties-common
sudo apt install -y python3.7 python3.7-venv python3-distutils

sudo ln -s /usr/bin/python3.7 /usr/bin/python

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python get-pip.py

rm -rf ./get-pip.py
sudo apt clean -y
sudo apt autoclean -y
sudo apt autoremove -y

python --version
pip --version

history -c
