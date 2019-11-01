#!/usr/bin/env bash

set -e

sudo apt-get update
sudo apt-get install -y curl make zip
sudo apt-get install -y python3-distutils python3-setuptools python3.6-venv python3.6-dev

sudo ln -s /usr/bin/python3 /usr/bin/python

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python3 get-pip.py

pip install --upgrade pip wheel

rm -rf ./get-pip.py
sudo apt clean -y
sudo apt autoclean -y
sudo apt autoremove -y

python -m venv --help # testing if venv module is available
python --version
pip --version

history -c