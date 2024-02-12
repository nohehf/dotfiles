UNAME := $(shell uname)
DOTFILE_PATH := $(shell pwd)

$(HOME)/.%: %
	ln -sf $(DOTFILE_PATH)/$^ $@

.PHONY: git
git: $(HOME)/.gitconfig $(HOME)/.githelpers $(HOME)/.gitignore

.PHONY: zsh
zsh: $(HOME)/.zshrc # $(HOME)/.zsh.d

.PHONY: vscode
vscode: 
	ln -sf $(DOTFILE_PATH)/vscode/settings.json $(HOME)/Library/Application\ Support/Code/User/settings.json

fonts:
	@echo "Installing fonts..."
	zsh install-fonts.sh
	
iterm: defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$(DOTFILE_PATH)"

.PHONY: dotfiles
dotfiles: git zsh vscode

brew:
	brew bundle --file=$(DOTFILE_PATH)/Brewfile
	brew bundle --force cleanup --file=$(DOTFILE_PATH)/Brewfile
	brew bundle --file=$(DOTFILE_PATH)/vscode/Brewfile

.PHONY: install
install:
	install.sh
