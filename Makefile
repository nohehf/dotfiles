UNAME := $(shell uname)
DOTFILE_PATH := $(shell pwd)

$(HOME)/.%: %
	ln -sf $(DOTFILE_PATH)/$^ $@

git: $(HOME)/.gitconfig $(HOME)/.githelpers $(HOME)/.gitignore
zsh: $(HOME)/.zshrc $(HOME)/.zsh.d

fonts:
	@echo "Installing fonts..."
	zsh install-fonts.sh
	
iterm: defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$(DOTFILE_PATH)"

all: git zsh
