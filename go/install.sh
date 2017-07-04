#!/usr/bin/env bash

DISTRO=$(uname -s)
case $DISTRO in
  'Linux')
    VERSION="1.8.3"
    OS="linux"
    ARCH="amd64"
    FILENAME="go$VERSION.$OS-$ARCH.tar.gz"

    command -v go &> /dev/null
    if [ "$?" -eq "0" ]; then
      INSTALLED_GO=$(go version)
      EXPECTED_GO="go version go${VERSION} ${OS}/${ARCH}"
      if [ "${INSTALLED_GO}" != "${EXPECTED_GO}" ]; then
        cd ${SOURCE_DIR}
        wget https://storage.googleapis.com/golang/${FILENAME}
        sudo tar -C /usr/local -xzf ${FILENAME}
        rm ${FILENAME}
      else
        echo
        echo "${EXPECTED_GO} already installed"
        echo
      fi
    fi
    ;;
  'Darwin')
    brew install go
    ;;
  *)
    echo "Good luck with that"
    ;;
esac
