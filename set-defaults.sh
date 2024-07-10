#!/bin/bash

# Finder
# always show hidden files
defaults write com.apple.finder AppleShowAllFiles -boolean true
killall Finder

# Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -int 0
defaults write com.apple.dock autohide-time-modifier -float 0.3
defaults write com.apple.dock tilesize -int 35
defaults write com.apple.dock size-immutable -bool true
killall Dock
