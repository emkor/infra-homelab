#!/usr/bin/env bash

# This script should be applied on ubuntu_1804_mysql image (one with mysql server installed)

set -e

mysqladmin -u root -parthur create yourdb
echo "Your database to use: yourdb" >> ~/readme.txt

sudo apt update
sudo apt install -y apache2 php libapache2-mod-php php-mysql

sudo chown -R ubuntu:www-data /var/www
sudo chmod 775 /var/www
sudo chmod 775 /var/www/html
sudo chmod 644 /var/www/html/*
cp index.php /var/www/html
rm /var/www/html/index.html

sudo systemctl restart apache2
echo "apache2 content directory: /var/www/html" >> ~/readme.txt

sudo apt-get autoclean -y
sudo apt-get autoremove -y

echo "You can now remove obsolete files from ~ directory"
history -c

