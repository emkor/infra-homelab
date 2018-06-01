#!/usr/bin/env bash

set -e

echo 'Installing PostgreSQL server...'

sudo apt update
sudo apt install -y postgresql postgresql-contrib

sudo -u postgres psql -c "ALTER ROLE postgres WITH PASSWORD 'arthur';"

sudo service postgresql stop
sudo sed -i "s/127.0.0.1\/32/0.0.0.0\/0/g" /etc/postgresql/10/main/pg_hba.conf
sudo sed -i "s/#listen_addresses = 'localhost'.*/listen_addresses = '0.0.0.0'/g" /etc/postgresql/10/main/postgresql.conf
sudo sed -i "s/shared_buffers = 128MB.*/shared_buffers = 256MB/g" /etc/postgresql/10/main/postgresql.conf
sudo sed -i "s/#random_page_cost = 4.0.*/random_page_cost = 2.0/g" /etc/postgresql/10/main/postgresql.conf
sudo service postgresql start

cp ./readme.txt ~/readme.txt

sudo apt clean -y
sudo apt autoclean -y
sudo apt autoremove -y
history -c

echo 'Done!'