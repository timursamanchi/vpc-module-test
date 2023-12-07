#!/bin/bash

echo 'Coded by Tim Samanchi Dec 2023!' > /tmp/README.txt

sudo apt-get update
sudo apt-get -y upgrade

sudo fallocate -l 1G /var/swapfile
sudo chmod 600 /var/swapfile
sudo mkswap /var/swapfile
sudo swapon /var/swapfile
echo '/var/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
sudo sysctl -p

sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
    https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update
sudo apt-get -y install fontconfig openjdk-17-jre 
sudo apt-get -y install jenkins 
sudo apt-get -y install nginx
sudo apt -y install net-tools

sudo systemctl restart jenkins
sudo systemctl enable jenkins  
sudo systemctl restart nginx