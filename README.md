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

### developer tools

```bash
xcode-select --install
```

### homebrew

See: [link](https://brew.sh/)
```bash
make brew
```

### dotfiles

```bash
cd ~
git clone https://github.com/nohehf/dotfiles.git
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

