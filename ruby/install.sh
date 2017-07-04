#!/usr/bin/env bash

DISTRO=$(uname -s)
chruby &> /dev/null
if ! command -v chruby 2> /dev/null; then
  echo "  Installing chruby for you."
  case $DISTRO in
    'Linux')
      cd $HOME/src
      rm -f chruby-0.3.9.tar.gz
      rm -rf chruby-0.3.9/
      wget -O chruby-0.3.9.tar.gz \
        https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz
      tar -xzvf chruby-0.3.9.tar.gz
      cd chruby-0.3.9/
      sudo make install
      cd $HOME/src
      rm -f chruby-0.3.9.tar.gz
      rm -rf chruby-0.3.9/
      ;;
    'Darwin')
      brew install chruby > /tmp/chruby_install.log
      ;;
    *)
      echo "Good luck with that"
      ;;
  esac
else
  echo
  echo "chruby already installed"
fi

if ! command -v ruby-install 2> /dev/null; then
  echo "  Installing ruby-install for you."
  case $DISTRO in
    'Linux')
      cd $HOME/src
      rm -f ruby-install-0.6.0.tar.gz
      rm -rf ruby-install-0.6.0/
      wget -O ruby-install-0.6.0.tar.gz \
        https://github.com/postmodern/ruby-install/archive/v0.6.0.tar.gz
      tar -xzvf ruby-install-0.6.0.tar.gz
      cd ruby-install-0.6.0/
      sudo make install
      cd $HOME/src
      rm -f ruby-install-0.6.0.tar.gz
      rm -rf ruby-install-0.6.0/
      ;;
    'Darwin')
      brew install ruby-install > /tmp/ruby-install_install.log
      ;;
    *)
      echo "Good luck with that"
      ;;
  esac
else
  echo
  echo "ruby-install already installed"
fi
