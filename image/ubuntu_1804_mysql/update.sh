#!/usr/bin/env bash

set -e

echo 'Installing MySQL server...'

sudo apt update
sudo apt install -y mysql-server

sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'arthur'; FLUSH PRIVILEGES;"
mysql -u root -parthur -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'arthur';"

sudo cp my.cnf /etc/mysql/my.cnf
sudo chmod 664 /etc/mysql/my.cnf
sudo service mysql restart

cp ./readme.txt ~/readme.txt

sudo apt clean -y
sudo apt autoclean -y
sudo apt autoremove -y
history -c

echo 'Now you can remove temporary files'