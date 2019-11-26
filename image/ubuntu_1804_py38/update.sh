#!/usr/bin/env bash

set -e

sudo apt update
sudo apt install -y curl make zip software-properties-common
sudo apt install -y python3.8 python3.8-venv python3-distutils
sudo apt install -y python3-distutils

sudo rm -rf /usr/bin/python3
sudo rm -rf /usr/bin/python
sudo ln -s /usr/bin/python3.8 /usr/bin/python3
sudo ln -s /usr/bin/python3.8 /usr/bin/python

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python get-pip.py

rm -rf ./get-pip.py
sudo apt clean -y
sudo apt autoclean -y
sudo apt autoremove -y

python --version
pip --version

history -c
