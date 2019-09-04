#!/usr/bin/env bash

set -e

sudo systemctl mask apt-daily.service apt-daily-upgrade.service
sudo apt-get update
sudo apt-get install -y curl make zip
sudo apt-get install -y python3-venv python3-distutils python3-setuptools python3-wheel python3-pip

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python3 get-pip.py

rm -rf ./get-pip.py
sudo apt clean -y
sudo apt autoclean -y
sudo apt autoremove -y

sudo ln -s /usr/bin/python3 /usr/bin/python

python --version
pip --version
echo 'Done!'
history -c

# for testing if OS deps are available:
# python3 -m venv ~/.venv
# source ~/.venv/bin/activate
# pip install wheel
# pip install flask requests cryptography numpy scipy sqlalchemy Django cherrypy celery redis assertpy