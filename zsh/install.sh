#!/usr/bin/env sh

DISTRO=$(uname -s)
case $DISTRO in
  'Linux')
    DEBIAN_FRONTEND=noninteractive
    sudo apt-get install -yq zsh zsh-common
    ;;
  'Darwin')
    # already installed in MacOS
    ;;
  *)
    echo "Good luck with that"
    ;;
esac
