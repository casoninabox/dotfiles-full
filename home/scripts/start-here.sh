echo "Installing homesick"
sudo gem install homesick
homesick clone casoninabox/dotfiles-full
homesick symlink dotfiles-full

# Then run instal-mac.sh
