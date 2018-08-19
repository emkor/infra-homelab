#!/usr/bin/env bash

set -e

yum install -y centos-release-openstack-queens
yum update -y
yum install -y openstack-packstack

packstack --answer-file=~/openstack-on-hp-z600/files/packstack-answers.txt
