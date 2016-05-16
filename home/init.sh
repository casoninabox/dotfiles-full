echo "Installing homesick"
sudo gem install homesick
homesick clone casoninabox/dotfiles-full
homesick symlink dotfiles-full

sudo chmod u+x ~/.install-mac.sh
~/.install-mac.sh