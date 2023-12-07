#!/bin/bash

echo 'Coded by Tim Samanchi Dec 2023!' > /tmp/README.txt
echo "# $(date) Installation is starting." >> /tmp/README.txt

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

wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update && sudo apt-get -y install terraform

sudo apt-get -y install nginx
# configure nginx
echo "# $(date) Configure NGINX..." >> /temp/README.txt
unlink /etc/nginx/sites-enabled/default

tee /etc/nginx/conf.d/jenkins.conf <<EOF
upstream jenkins {
    server 127.0.0.1:8080;
}
server {
    listen 80 default_server;
    listen [::]:80  default_server;
    location / {
        proxy_pass http://jenkins;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF
systemctl reload nginx
echo "# $(date) Reload NGINX to pick up the new configuration..." >> /tmp/README.txt

sudo apt-get -y install net-tools
sudo apt-get -y install python3 
sudo apt-get -y install python3-pip
sudo apt-get -y install awscli
sudo pip3 install awsebcli

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
# Add your user to the docker group to run Docker commands without sudo (optional)
sudo usermod -aG docker $USER

# Print a message indicating the installation is complete
echo "# $(date) Docker has been successfully installed." >> /tmp/README.txt

# Download kubectl binary
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.23.6/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
source ~/.bashrc
echo 'Kubernetes (Kubectl) has been successfully installed.' >> /tmp/README.txt

sudo curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | sudo tar xz -C /usr/local/bin
echo "# $(date) EKSCTL tools has been installed successfully..." >> /tmp/README.txt

sudo apt-get -y install git 
sudo apt-get -y install unzip
sudo apt-get -y install build-essential 
sudo apt-get -y install software-properties-common
sudo apt-get -y install ca-certificates 
sudo apt-get -y install apt-transport-https 
sudo apt-get -y install gnupg 
sudo apt-get -y install gnupg-agent 
sudo apt-get -y install gnome-terminal
sudo apt-get -y install lsb-release
lsb_release -a >> /tmp/README.txt              

sudo systemctl enable docker.service
sudo systemctl enable containerd.service

sudo systemctl restart jenkins
sudo systemctl enable jenkins  
sudo systemctl restart nginx