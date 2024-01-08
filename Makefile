UNAME := $(shell uname)
DOTFILE_PATH := $(shell pwd)

$(HOME)/.%: %
	ln -sf $(DOTFILE_PATH)/$^ $@

.PHONY: git
git: $(HOME)/.gitconfig $(HOME)/.githelpers $(HOME)/.gitignore

.PHONY: zsh
zsh: $(HOME)/.zshrc # $(HOME)/.zsh.d

fonts:
	@echo "Installing fonts..."
	zsh install-fonts.sh
	
iterm: defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$(DOTFILE_PATH)"

.PHONY: dotfiles
dotfiles: git zsh

brew:
	brew bundle --file=$(DOTFILE_PATH)/Brewfile
	brew bundle --force cleanup --file=$(DOTFILE_PATH)/Brewfile