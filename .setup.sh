#!/bin/zsh
# macOS setup script

# Ask once at the start
sudo -v

# Keep sudo alive until script finishes
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# macOS preferences
defaults write -g com.apple.trackpad.scaling -float 2.0
defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 15
defaults write -g com.apple.swipescrolldirection -bool false
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
killall cfprefsd
killall SystemUIServer

# Dock: clear apps and auto-hide
defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock autohide -bool true
killall Dock

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Set up Homebrew in current shell
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install packages from Brewfile
brew bundle --file=~/.Brewfile

# GitHub CLI auth
gh auth login

# Clone dotfiles
yadm clone https://github.com/Qrtn/dotfiles

echo "Done! Restart your terminal to apply changes."
