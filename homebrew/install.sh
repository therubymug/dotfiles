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
  ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)" > /tmp/homebrew-install.log
fi

# Install homebrew 'essential' packages
BREWS=(ack ctags-exuberant chruby macvim markdown proctools redis ruby-install the_silver_searcher tmux wget)
for brew in ${BREWS[@]}; do
  $BREW_COMMAND list $brew > /dev/null 2>&1
  if [[ "$?" -eq "1" ]]; then
    echo "Installing $brew"
    brew install $brew
  fi
done

brew upgrade --all
brew cleanup
brew prune

exit 0
