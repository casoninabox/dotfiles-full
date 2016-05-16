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

echo "Installing homesick"
sudo gem install homesick
homesick clone casoninabox/dotfiles-full
homesick symlink dotfiles-full

sudo chmod u+x ~/.install-mac.sh
~/.install-mac.sh