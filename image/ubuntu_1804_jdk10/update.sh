#!/usr/bin/env bash

set -e

sudo apt-get update
sudo apt-get install -y curl make zip
sudo apt-get install -y default-jdk
#sudo update-alternatives --install "/usr/bin/java" java "/opt/java/jdk-10.0.1/bin/java" 1
#sudo update-alternatives --install "/usr/bin/javac" javac "/opt/java/jdk-10.0.1/bin/javac" 1

wget http://www-eu.apache.org/dist/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz -O apache-maven-3.5.4-bin.tar.gz
tar xvf apache-maven-3.5.4-bin.tar.gz
rm -rf apache-maven-3.5.4-bin.tar.gz
sudo mv ./apache-maven-3.5.4 /opt/

echo "PATH=/opt/apache-maven-3.5.4/bin:$PATH" >> ~/.bashrc
source ~/.bashrc

java -version
javac -version
mvn -version

sudo apt clean -y
sudo apt autoclean -y
sudo apt autoremove -y
echo 'Done!'

history -c