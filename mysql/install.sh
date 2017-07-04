#!/usr/bin/env bash

DISTRO=$(uname -s)
case $DISTRO in
  'Linux')
    DEBIAN_FRONTEND=noninteractive

    sudo apt update
    sudo apt-get install -yq libmysqlclient-dev
    ;;
  'Darwin')
    brew install mysql
    ;;
  *)
    echo "Good luck with that"
    ;;
esac
