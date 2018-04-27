#!/usr/bin/env bash

set -e

cd ~/openstack-on-hp-z600

yum install -y centos-release-openstack-queens
yum update -y
yum install -y openstack-packstack

packstack --answer-file=files/packstack-answers.txt
