#!/usr/bin/env bash

set -e

yum install -y https://rdoproject.org/repos/rdo-release.rpm
yum install -y centos-release-openstack-stein

yum update -y
yum install -y openstack-packstack

packstack --answer-file=packstack-answers.txt --debug