#!/usr/bin/env bash

set -e

curl https://download.java.net/java/GA/jdk10/10.0.1/fb4372174a714e6b8c52526dc134031e/10/openjdk-10.0.1_linux-x64_bin.tar.gz -O openjdk-10.0.1_linux-x64_bin.tar.gz
tar xvf openjdk-10.0.1_linux-x64_bin.tar.gz
sudo mkdir -p /opt/java
sudo mv ./jdk-10.0.1 /opt/java
sudo update-alternatives --install "/usr/bin/java" java "/opt/java/jdk-10.0.1/bin/java" 1
sudo update-alternatives --install "/usr/bin/javac" javac "/opt/java/jdk-10.0.1/bin/javac" 1

curl http://ftp.ps.pl/pub/apache/maven/maven-3/3.5.3/binaries/apache-maven-3.5.3-bin.tar.gz -O apache-maven-3.5.3-bin.tar.gz
tar xvf apache-maven-*.tar.gz
sudo mv ./apache-maven-3.5.3 /opt/

echo "PATH=/opt/apache-maven-3.5.3/bin:$PATH" >> ~/.bashrc
source ~/.bashrc

java -version
javac -version
mvn -version

rm -rf openjdk-10*_bin.tar.gz
rm -rf apache-maven-*.tar.gz

echo 'Done!'

history -c