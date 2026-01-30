#!/bin/zsh
# macOS setup script

set -e  # Exit on error

# Ask once at the start
sudo -v

# Keep sudo alive until script finishes
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Enable Touch ID for sudo
if ! grep -q "pam_tid.so" /etc/pam.d/sudo 2>/dev/null; then
  sudo sed -i '' '2i\
auth       sufficient     pam_tid.so
' /etc/pam.d/sudo
  echo "Touch ID enabled for sudo"
fi

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
if ! command -v brew &> /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Set up Homebrew in current shell
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install essentials first
brew install gh yadm

# GitHub CLI auth (needed for private repos)
gh auth login

# Clone dotfiles (brings in .Brewfile, .zshrc, etc.)
yadm clone https://github.com/Qrtn/dotfiles

# Install everything from Brewfile
brew bundle --file=~/.Brewfile

# Install Claude Code
npm install -g @anthropic-ai/claude-code

echo "Done! Restart your terminal to apply changes."
