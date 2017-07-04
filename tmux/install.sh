#!/usr/bin/env bash

DISTRO=$(uname -s)
case $DISTRO in
  'Linux')
    VERSION="2.5"
    FILENAME="tmux-${VERSION}.tar.gz"
    TARBALL="https://github.com/tmux/tmux/releases/download/${VERSION}/${FILENAME}"
    command -v tmux &> /dev/null
    if [ "$?" -eq "0" ]; then
      INSTALLED_TMUX=$(tmux -V)
      EXPECTED_TMUX="tmux ${VERSION}"
      if [ "${EXPECTED_TMUX}" != "${INSTALLED_TMUX}" ]; then
        cd /tmp
        rm -rf tmux-${VERSION}*
        wget ${TARBALL}
        tar xvzf ${FILENAME}
        cd "tmux-${VERSION}"
        ./configure && make
        sudo make install
        rm -rf /tmp/tmux-${VERSION}*
        touch ~/.tmux.conf.local
      else
        echo
        echo "tmux ${VERSION} already installed"
        echo
      fi
    fi
    ;;
  'Darwin')
    BREW_COMMAND=/usr/local/bin/brew
    ${BREW_COMMAND} install tmux
    ;;
  *)
    echo "Good luck with that"
    ;;
esac
exit 0


