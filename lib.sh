#!/bin/bash
# A collection of custom bash functions

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
    # Check if the correct number of arguments are passed
    if [ "$#" -ne 1 ]; then
        echo "Usage: $0 'commit message'"
        exit 1
    fi

    # Get the commit message and format the branch name
    commit_message=$(format_commit_message "$1")
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
    git commit -m "$commit_message"
    gpmr
}


# Git auto commit
gac() {
    # Check if the correct number of arguments are passed
    if [ "$#" -ne 1 ]; then
        echo "Usage: $0 'commit message'"
        exit 1
    fi

    # Get the commit message and format the branch name
    commit_message=$(format_commit_message "$1")

    # Execute the git commands
    git_smart_add
    git commit -m "$commit_message"
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
