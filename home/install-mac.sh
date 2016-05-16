#!/usr/bin/env bash

mkdir -p ~/projects/go

system=(
  brew-cask
  bash
  coreutils
  findutils
  fzf
  git
  git-extras
)

neat=(
  archey
  cheat
  httpie
  lnav
  stormssh
  youtube-dl
  the_silver_searcher
  imagemagick
)

utils=(
  dfc
  hh
  htop
  iftop
  lighttpd
  mtr
  ncdu
  nmap
  thefuck
  tree
  trash
  wget
  tmux
)

programming=(
  android-platform-tools
  clib
  go
  node
  postgresql
  pgcli
  python
  python3
  jq
)

casks=(
  adobe-reader
  atom
  betterzipql
  kdiff3
  cakebrew
  caffeine
  commander-one
  dockertoolbox
  dropbox
  firefox
  google-chrome
  google-drive
  github-desktop
  handbrake
  licecap
  iterm2
  qlcolorcode
  qlmarkdown
  qlstephen
  quicklook-json
  quicklook-csv
  launchrocket
  private-eye
  satellite-eyes
  skype
  slack
  spotify
  transmission
  transmission-remote-gui
  vlc
  volumemixer
  webstorm
  mou
  virtualbox
)

pips=(
  pythonpy
)

npms=(
  gitjk
  n
  bower
  ionic
  ng6-cli
  speed-test
)

apms=(
  atom-beautify
  minimap
)

fonts=(
  font-source-code-pro
)

######################################## End of app list ########################################
set +e

if test ! $(which brew); then
  echo "Installing Xcode ..."
  xcode-select --install

  echo "Installing Homebrew ..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo "Updating Homebrew ..."
  brew update
  brew upgrade
fi
brew doctor
brew tap homebrew/dupes

fails=()

function print_red {
  red='\x1B[0;31m'
  NC='\x1B[0m' # no color
  echo -e "${red}$1${NC}"
}

function install {
  cmd=$1
  shift
  for pkg in $@;
  do
    exec="$cmd $pkg"
    echo "Executing: $exec"
    if $exec ; then
      echo "Installed $pkg"
    else
      fails+=($pkg)
      print_red "Failed to execute: $exec"
    fi
  done
}

function proceed_prompt {
  read -p "Proceed with installation? " -n 1 -r
  if [[ $REPLY =~ ^[Nn]$ ]]
  then
    exit 1
  fi
}

echo "Installing Resty ..."
curl -L http://github.com/micha/resty/raw/master/resty > .resty
. resty

echo "Installing ruby ..."
brew install ruby-install chruby
ruby-install ruby
chruby ruby-2.3.0
ruby -v

echo "Installing Java ..."
brew cask install java

echo "Installing Brews..."
brew info ${system[@]}
brew info ${neat[@]}
brew info ${utils[@]}
brew info ${programming[@]}
install 'brew install' ${system[@]}
install 'brew install' ${neat[@]}
install 'brew install' ${utils[@]}
install 'brew install' ${programming[@]}

echo "Tapping casks ..."
brew tap caskroom/fonts
brew tap caskroom/versions

echo "Installing Casks ..."
brew cask info ${casks[@]}
install 'brew cask install --appdir=/Applications' ${casks[@]}

# TODO: add info part of install or do reinstall?
install 'pip install --upgrade' ${pips[@]}
install 'npm install --global' ${npms[@]}
install 'apm install' ${apms[@]}
install 'brew cask install' ${fonts[@]}

echo "Upgrading bash ..."
sudo bash -c "echo $(brew --prefix)/bin/bash >> /private/etc/shells"

echo "Setting up go ..."
mkdir -p /usr/libs/go

echo "Upgrading ..."
pip install --upgrade setuptools
pip install --upgrade pip
gem update --system

echo "Cleaning up ..."
brew cleanup
brew cask cleanup
brew linkapps

for fail in ${fails[@]}
do
  echo "Failed to install: $fail"
done

echo "Setting mac defaults"
source .osx

echo "Done!"
