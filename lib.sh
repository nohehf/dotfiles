#!/bin/zsh
# A collection of custom bash functions

# git aliases (some from: https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh)
alias gp='git push'
alias gsw='git switch'
alias gpmr='git push --set-upstream origin $(git branch | grep "*" | cut -d" " -f 2) -o merge_request.create -o merge_request.title="$(git branch | grep "*" | cut -b3- | sed -e "s/\//: /g" -e "s/-/ /g")" -o merge_request.assign="$(git config --get user.name)"'
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --gpg-sign --message "--wip-- [skip ci]"'
alias gunwip='git rev-list --max-count=1 --format="%s" HEAD | grep -q "\--wip--" && git reset HEAD~1'
# clean branches that are already merged
alias gbclean="git branch -l | grep -v '\*' |  grep -x '.*/.*' | xargs git branch -d"

### GIT ###
# Function to format the branch name
format_branch_name() {
    local input="$1"
    # Ensure the input starts with a conventional commit type
    if [[ ! "$input" =~ ^[a-z]+: ]]; then
        input="feat:$input"
    fi
    # Remove the type part and replace spaces with hyphens
    local branch_name=$(echo "$input" | sed -E 's/^[a-z]+:? *//' | tr ' ' '-')
    echo "$(echo "$input" | grep -oE '^[a-z]+')/$branch_name"
}

# Function to format the commit message
format_commit_message() {
    local input="$1"
    
    # Convert branch name to commit message if needed
    # replace / with : and - with space
    input=$(echo "$input" | tr '/' ': ' | tr '-' ' ')

    # Ensure the input starts with a conventional commit type
    if [[ ! "$input" =~ ^[a-z]+: ]]; then
        input="feat:$input"
    fi
    # Ensure there is a space after the prefix
    input=$(echo "$input" | sed -E 's/^([a-z]+:)([^ ]+.*)$/\1 \2/')
    echo "$input"
}

# git add . if nothing is staged
git_smart_add() {
    if [[ -z $(git diff --name-only --cached) ]]; then
        git add .
    fi
}

# Git auto merge request
gamr() {
    # Execute the git commands
    git_smart_add

    # generate commit message if none is provided
    if [ "$#" -eq 0 ]; then
        commit_message=$(wrap_generate_commit_message)
    else
        commit_message=$1
    fi
    
    # Check if the commit message is empty
    if [ -z "$commit_message" ]; then
        echo "Error: Commit message is empty" >&2
        return 1
    fi

    # Check if wrap_generate_commit_message returned an error
    if [ $? -eq 1 ]; then
        echo "Error: Failed to generate commit message" >&2
        return 1
    fi


    # Get the commit message and format the branch name
    commit_message=$(format_commit_message "$commit_message")
    branch_name=$(format_branch_name "$commit_message")

    # Execute the git commands
    git_smart_add

    # Stash non staged changes for later
    stash_count=$(git stash list | wc -l)
    
    # Stash non staged changes for later, only if there are any 
    if [ $(git diff --name-only | wc -l) -gt 0 ]; then
        git stash push -m "non staged at $commit_message" --keep-index --include-untracked
    fi

    # compare the stash count to see if there are any stashed changes, if so, print a message
    if [ $(git stash list | wc -l) -gt $stash_count ]; then
        echo "Stashed non staged changes"
    fi

    git switch -c "$branch_name"
    git commit -m $commit_message
    gpmr
}

# Git auto commit
gac() {
    # Execute the git commands
    git_smart_add

    # generate commit message if none is provided
    if [ "$#" -eq 0 ]; then
        commit_message=$(wrap_generate_commit_message)
    else
        commit_message=$1
    fi

    # Check if the commit message is empty
    if [ -z "$commit_message" ]; then
        echo "Error: Commit message is empty" >&2
        return 1
    fi

    # Check if wrap_generate_commit_message returned an error
    if [ $? -eq 1 ]; then
        echo "Error: Failed to generate commit message" >&2
        return 1
    fi

    # Get the commit message and format the branch name
    commit_message=$(format_commit_message "$commit_message")

    git commit -m "$commit_message"
}

# Press enter to keep the generated commit message, exit or control+c to abort or write your own commit message
wrap_generate_commit_message() {
    # Start spinner
    echo -n "Generating commit message... " >&2
    spin() {
        local -a spinner=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
        while :; do
            for i in "${spinner[@]}"; do
                echo -ne "\r$i" >&2
                sleep 0.1
            done
        done
    }
    spin &
    SPIN_PID=$!

    # Generate the commit message
    generated_message=$(ai-commit-message)

    # Stop spinner
    kill $SPIN_PID
    wait $SPIN_PID 2>/dev/null

    # Clear spinner line and show generated message
    echo -ne "\r\033[K" >&2
    # Bright green
    printf "✨Generated commit message: '\033[1;32m%s\033[0m'\n\n" "$generated_message" >&2

    # Prompt for user action
    echo "Press Enter to accept, Esc to abort, or type your own message:" >&2
    
    # Read user input
    read -r -s -k1 key

    if [[ $key == $'\x0a' ]]; then  # Enter key
        echo "Using generated message" >&2
        commit_message="$generated_message"
    elif [[ $key == $'\x1b' ]]; then  # Escape key
        echo "Aborted" >&2
        return 1
    else
        # If not Enter or Escape, assume user wants to type their own message
        echo "Enter your commit message:" >&2
        read -r custom_message
        commit_message="$custom_message"
    fi

    # Return the chosen commit message as the only stdout output
    echo "$commit_message"
    return 0
}


# The magic git command: g
# If on the default branch, and we have diffs it will run gamr
# else if we are on a feature branch, it will run gac
g() {
    if [ "$(git branch --show-current)" = "$(git symbolic-ref refs/remotes/origin/HEAD --short | sed 's/origin\///')" ]; then
        echo " gamr"
        gamr $@
    else
        echo "\ue729 gac"
        gac $@
    fi
}


# Git clean the current branch, and switch to the default branch
gbdone() {
    # get default branch name (remove origin/)
    default_branch=$(git symbolic-ref refs/remotes/origin/HEAD --short | sed 's/origin\///')
    current_branch=$(git branch --show-current)
    git checkout "$default_branch"
    git branch -d "$current_branch"
    git pull
}

# Rebase current branch on default branch
gbrebase() {
    default_branch=$(git symbolic-ref refs/remotes/origin/HEAD --short | sed 's/origin\///')
    current_branch=$(git branch --show-current)
    git switch "$default_branch"
    git pull
    git switch "$current_branch"
    git rebase "$default_branch"
}

# Merge current branch on default branch
gbmerge() {
    default_branch=$(git symbolic-ref refs/remotes/origin/HEAD --short | sed 's/origin\///')
    current_branch=$(git branch --show-current)
    git switch "$default_branch"
    git pull
    git switch "$current_branch"
    git merge "$default_branch"
}

# Globally disable / enable hooks, in .gitconfig
git_toggle_hooks() {
    # hooks path is /dev/null if disabled
    hooks_path=$(git config --global core.hooksPath)
    if [ "$hooks_path" = "/dev/null" ]; then
        git config --global --unset core.hooksPath
        echo "Hooks enabled globally in ~/.gitconfig"
    else
        git config --global core.hooksPath /dev/null
        echo "Hooks disabled globally in ~/.gitconfig"
    fi
}

# Source and export a given .env file
exsource () {
    set -o allexport
    source $@
    set +o allexport
}

function mkcd() {
  mkdir -p $@ && cd ${@:$#}
}

# Vscode c command, opens vscode in the current directory if no argument is given else opens vscode in the given directory
function c() {
  code ${1:-.}
}
