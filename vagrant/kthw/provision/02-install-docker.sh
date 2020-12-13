#!/bin/bash

# defined docker version
DOCKER_VERSION="5:19.03.8~3-0~ubuntu-bionic"

# install packages to allow apt to use a repository over HTTPS
apt-get update && sudo apt-get install -y \
  apt-transport-https ca-certificates curl software-properties-common gnupg2 

# download gpg key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key --keyring /etc/apt/trusted.gpg.d/docker.gpg add - 

# add docker repo 
add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable" 

# install docker
apt-get update && sudo apt-get install -y \
  containerd.io=1.2.13-2 \
  docker-ce=$DOCKER_VERSION \
  docker-ce-cli=$DOCKER_VERSION

# set up docker daemon
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

# reload daemon and restart service
mkdir -p /etc/systemd/system/docker.service.d && systemctl daemon-reload && systemctl enable docker


# set non-root user use docker
usermod -aG docker vagrant