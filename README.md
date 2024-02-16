# dotfiles & mac config

Steps & files used while configuring my macbook.

Sources:

- <https://registerspill.thorstenball.com/p/new-year-new-job-new-machine>

## OS Settings

### General

- Rename macbook

_Note: Might want to set a proper hostname: [link](https://gist.github.com/a1ip/68db7b4e137d958da58e587a3a44dab8)_

### Dock

- Reduce dock size to ~15%
- Minimize windows using: Scale effect
- Automatically hide and show the dock
- Remove all apps from dock
- Make dock faster:

```bash
defaults write com.apple.dock autohide-delay -int 0
defaults write com.apple.dock autohide-time-modifier -float 0.3
killall Dock
```

### Display

- Set resolution to: More Space

### Keyboard

- Press 🌐 key to: Show emoji & symbols
- Set key repeat to fastest
- Set delay until repeat to 1 before fastest
- Set keyboard brightness to 50%
- Turn off keyboard backlight off after 5 seconds
- In keyboard > keyboard shortcuts:
- Input Sources > Disable `select previous input source` -> very important as it conflicts with vscode intellisense shortcut

### Trackpad

- Increase tracking speed to 6/10
- Set click to light
- Enable tap to click
- Disable natural scrolling

## Devtools setup

```bash
cd ~
git clone https://github.com/nohehf/dotfiles.git
```

### developer tools

```bash
xcode-select --install
```

### non homebrew installs

This script will install necessary tools for this to work + some dependencies I want to manage outside of brew.
It is usefull for package managers, brew itself...

```bash
sh install.sh
```

Then to install all, simply run

```bash
just
```

### homebrew

Now that brew is installed, run

```bash
make brew
```

to install all brew dependencies as specified in `Brewfile` (and vscode extensions in `vscode/Brewfile`)

### dotfiles

This command will create symlinks between the files in this repo to `~.dotfile-name`

```bash
make dotfiles
```

### Setup keys & passwords

## GPG

Export from system 1: `gpg --armour --export-secret-keys nohehf > key`
On system 2:

```sh
gpg --import <key>
gpg --edit-key nohehf
trust
5
save
```

> ⚠️ Never commit this file

> Note: a better way of managing keys (with sub-keys would be preferable)

#### Setup raycast

- Disable spotlight shortcut
- Enable raycast shortcut to `cmd + space`
- Import `Raycast.rayconfig` in raycast settings

#### Setup terminal

# todo:

- bitwarden cli
- find a way to show gwip state in starship
- manual installs
- synced vscode config
