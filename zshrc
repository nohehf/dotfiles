# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"

# zsh stuff
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Starship
export STARSHIP_CONFIG=~/dotfiles/starship.toml
eval "$(starship init zsh)"

# To fix a gpg issue: https://github.com/keybase/keybase-issues/issues/2798
export GPG_TTY=$(tty)

# git aliases (some from: https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh)
alias gp='git push'
alias gsw='git switch'
alias gpmr='git push --set-upstream origin $(git branch | grep "*" | cut -d" " -f 2) -o merge_request.create -o merge_request.title="$(git branch | grep "*" | cut -b3- | sed -e "s/\//: /g" -e "s/-/ /g")" -o merge_request.assign="$(git config --get user.name)"'
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --gpg-sign --message "--wip-- [skip ci]"'
alias gunwip='git rev-list --max-count=1 --format="%s" HEAD | grep -q "\--wip--" && git reset HEAD~1'

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
