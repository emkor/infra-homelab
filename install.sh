#!/usr/bin/env bash

set -e

yum install -y centos-release-openstack-stein

yum update -y

# workaround: puppet binaries look for leatherman_curl.so.1.3.0
yum erase leatherman-1.10.0-1.el7
yum install -y leatherman-1.3.0-9.el7

yum install -y openstack-packstack
packstack --answer-file=answers.cfg --debug