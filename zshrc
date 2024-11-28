# CodeWhisperer pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.pre.zsh"
# Starship
export STARSHIP_CONFIG=~/dotfiles/starship.toml
eval "$(starship init zsh)"

# antidote
source ~/.antidote/antidote.zsh
antidote load

# Load custom functions
source $HOME/lib.sh

# Load .env file in secrets
exsource $HOME/.secrets/.env

# To fix a gpg issue: https://github.com/keybase/keybase-issues/issues/2798
export GPG_TTY=$(tty)

# custom ai lib
export PATH="$HOME/code/ai/bin:$PATH"

# Python 
export PATH="$HOME/.pyenv/shims:$PATH"
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# k8s
autoload -U +X compinit && compinit
export KUBECONFIG="${KUBECONFIG}$(find $HOME/.kube/configs -type f -exec echo -n :{} \;)"
export KUBECONFIG="${KUBECONFIG}:$HOME/.kube/config"
alias k=kubectl
source <(kubectl completion zsh)

# Docker 
source <(docker completion zsh)

# zsh stuff
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# search history with up/down arrow keys (https://superuser.com/a/585004)
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# Lib postgres (to remove if installing the full postgres)
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# GO
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOPATH/bin

# Android
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

# opam configuration
[[ ! -r /Users/nohehf/.opam/opam-init/init.zsh ]] || source /Users/nohehf/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"


[[ -f "$HOME/fig-export/dotfiles/dotfile.zsh" ]] && builtin source "$HOME/fig-export/dotfiles/dotfile.zsh"

# CodeWhisperer post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.post.zsh"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
