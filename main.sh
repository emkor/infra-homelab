#!/usr/bin/env bash

yum install -y sudo wget curl nano vim git htop

sudo systemctl disable firewalld
sudo systemctl stop firewalld
sudo systemctl disable NetworkManager
sudo systemctl stop NetworkManager
sudo systemctl enable network
sudo systemctl start network

sudo yum install -y centos-release-openstack-queens
sudo yum update -y
sudo yum install -y openstack-packstack
