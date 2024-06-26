#!/bin/bash
# This file is intended to install some tools without using brew. This is usefull for package managers or some languages to manage multiple versions.

# Check if a binary exists
function binExists(){
    command -v $1 > /dev/null
    exists=$?
    if [ $exists -ne 0 ]; then 
        return 1
    else
        return 0
    fi
}

# Install a binary if the specified binary does not exist
# usage: installBin "command-to-check" "optional-message" && installation-script
function installBin() {
    binExists $1
    exists=$?
    if [ $exists -ne 0 ]; then 
        if [ -z "$2" ]; then
            echo "Installing $1..."
        else
            echo "Installing $2..."
        fi
        return 0
    else
        echo "$1 already installed, skipping..."
        return 1
    fi
}

# Brew
installBin "brew" && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Just (replacement for make)
installBin "just" && brew install just

# Rust via rustup
# TODO: Rust might be managed by nix
installBin "cargo" "Rust (via rustup)" && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Nix via determinate systems nix installer
# TODO: remove nix if not used more
installBin "nix" && curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# jdkman
installBin "jdk" && curl -s "https://get.sdkman.io" | bash

exit 0
