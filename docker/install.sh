#!/usr/bin/env bash

DISTRO=$(uname -s)
case $DISTRO in
  'Linux')
    DEBIAN_FRONTEND=noninteractive
    COMPOSE_VERSION=1.14.0

    sudo apt-get remove -y --purge docker docker-engine docker.io
    sudo apt update

    sudo apt-get install -yq \
      linux-image-extra-$(uname -r) \
      linux-image-extra-virtual

    sudo apt-get install -yq \
      apt-transport-https \
      ca-certificates \
      curl \
      software-properties-common

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) \
      stable"
    sudo apt update
    sudo apt install -yq docker-ce

    groups ${USER} | grep docker &> /dev/null
    if [[ "$?" -eq "1" ]]; then
      sudo groupadd docker
      sudo usermod -aG docker ${USER}
    fi
    sudo systemctl enable docker
    sudo curl -o /usr/local/bin/docker-compose -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)"
    sudo chmod +x /usr/local/bin/docker-compose
    ;;
  'Darwin')
    # https://download.docker.com/mac/stable/Docker.dmg
    ;;
  *)
    echo "Good luck with that"
    ;;
esac
