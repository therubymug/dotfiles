#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

BREW_COMMAND=/usr/local/bin/brew

# Check for Homebrew
if test ! $(which brew)
then
  echo "  Installing Homebrew for you."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" > /tmp/homebrew-install.log
fi

${BREW_COMMAND} update

# Install homebrew 'essential' packages
BREWS=(ack ctags-exuberant chruby macvim markdown proctools redis ruby-install the_silver_searcher tmux wget)
for brew in ${BREWS[@]}; do
  ${BREW_COMMAND} list $brew > /dev/null 2>&1
  if [[ "$?" -eq "1" ]]; then
    echo "Installing $brew"
    ${BREW_COMMAND} install $brew
  fi
done

${BREW_COMMAND} upgrade --all
${BREW_COMMAND} cleanup
${BREW_COMMAND} prune

exit 0
