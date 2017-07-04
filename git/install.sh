#!/usr/bin/env bash

DISTRO=$(uname -s)
case $DISTRO in
  'Linux')
    DEBIAN_FRONTEND=noninteractive
    HUB_VERSION="2.3.0"
    HUB_TAR="v${HUB_VERSION}.tar.gz"

    sudo apt-add-repository -y ppa:git-core/ppa
    sudo apt-get update
    sudo apt-get install -yq git git-core

    cd /tmp
    wget https://github.com/github/hub/archive/${HUB_TAR}
    tar xvzf ${HUB_TAR}
    cd "hub-${HUB_VERSION}"
    ./script/build
    sudo mv bin/hub /usr/local/bin/
    cd /tmp
    rm -rf hub* ${HUB_TAR}
    ;;
  'Darwin')
    brew install git hub
    ;;
  *)
    echo "Good luck with that"
    ;;
esac
