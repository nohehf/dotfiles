set shell := ["zsh", "-c"]

UNAME := `uname`
DOTFILE_PATH := `pwd`
HOME := `echo ~`

# Setups all the things
setup: install brew dotfiles fonts iterm

# Install dependencies in install.sh
install:
    @echo "Installing dependencies..."
    sh install.sh

# Sets mac os settings (defaults write...)
# - settings for the dock
set-defaults:
    @echo "Setting macos settings/defaults..."
    sh set-defaults.sh 

brew:
    brew bundle --file=Brewfile
    brew bundle --force cleanup --file=Brewfile
    brew bundle --file=vscode/Brewfile

# Symlink dotfiles
# if only one argument is passed, the target is ~/.<source>
_symlink source *target:
    @echo 'creating symlink {{DOTFILE_PATH}}/{{source}} <-> {{HOME}}/{{ if target == "" { "." + source } else { target } }}'
    ln -sf '{{DOTFILE_PATH}}/{{source}}' '{{HOME}}/{{ if target == "" { "." + source } else { target } }}'

_git_sym: (_symlink "gitconfig") (_symlink "githelpers") (_symlink "gitignore")
_zsh_sym: (_symlink "zshrc")
_vscode_sym: (_symlink "vscode/settings.json" "Library/Application Support/Code/User/settings.json") (_symlink "vscode/keybindings.json" "Library/Application Support/Code/User/keybindings.json")

# Install symlinks for dotfiles in the repo to the home directory (eg. creates a symlink ./filename to ~/.<filename>)
dotfiles: _git_sym _zsh_sym _vscode_sym

# Install (nerd) fonts
fonts:
    @echo "Installing fonts..."
    sh install-fonts.sh

# Set iterm preferences to the dotfiles directory
iterm:
    defaults write com.googlecode.iterm2 PrefsCustomFolder -string "{{DOTFILE_PATH}}"
