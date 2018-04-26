#!/usr/bin/env bash

set -e

cd ~/openstack-on-hp-z600

sudo yum install -y centos-release-openstack-queens
sudo yum update -y
sudo yum install -y openstack-packstack

packstack --answer-file=files/packstack-answers.txt
