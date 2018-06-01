#!/usr/bin/env bash

set -e

echo 'Installing Python 3 development server...'

sudo apt-get update
sudo apt-get install -y python3-venv python3-pip

echo "alias python=python3" >> ~/.bashrc
echo "alias pip=pip3" >> ~/.bashrc
source ~/.bashrc

pip install wheel

# for testing if OS deps are available:
# python3 -m venv ~/.venv
# source ~/.venv/bin/activate
# pip install wheel
# pip install flask requests cryptography numpy scipy sqlalchemy Django cherrypy celery redis assertpy

sudo apt clean -y
sudo apt autoclean -y
sudo apt autoremove -y
history -c

echo 'Done!'