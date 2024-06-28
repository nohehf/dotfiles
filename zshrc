# CodeWhisperer pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.pre.zsh"
# Starship
export STARSHIP_CONFIG=~/dotfiles/starship.toml
eval "$(starship init zsh)"

# To fix a gpg issue: https://github.com/keybase/keybase-issues/issues/2798
export GPG_TTY=$(tty)

# Python 
export PATH="$HOME/.pyenv/shims:$PATH"
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# git aliases (some from: https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh)
alias gp='git push'
alias gsw='git switch'
alias gpmr='git push --set-upstream origin $(git branch | grep "*" | cut -d" " -f 2) -o merge_request.create -o merge_request.title="$(git branch | grep "*" | cut -b3- | sed -e "s/\//: /g" -e "s/-/ /g")" -o merge_request.assign="$(git config --get user.name)"'
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --gpg-sign --message "--wip-- [skip ci]"'
alias gunwip='git rev-list --max-count=1 --format="%s" HEAD | grep -q "\--wip--" && git reset HEAD~1'
alias gbclean="git branch -l | grep -v '\*' |  grep -x '.*/.*' | xargs git branch -d"

# Load custom functions
source $HOME/lib.sh

function mkcd() {
  mkdir -p $@ && cd ${@:$#}
}

# k8s
autoload -U +X compinit && compinit
export KUBECONFIG="${KUBECONFIG}$(find $HOME/.kube/configs -type f -exec echo -n :{} \;)"
export KUBECONFIG="${KUBECONFIG}:$HOME/.kube/config"
alias k=kubectl
source <(kubectl completion zsh)

# Vscode c command, opens vscode in the current directory if no argument is given else opens vscode in the given directory
function c() {
  code ${1:-.}
}

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

# JAVA
# default: java 17 (temurin)
export PATH="/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home/bin/:$PATH"

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
