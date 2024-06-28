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
    # Ensure the input starts with a conventional commit type
    if [[ ! "$input" =~ ^[a-z]+: ]]; then
        input="feat:$input"
    fi
    # Ensure there is a space after the prefix
    input=$(echo "$input" | sed -E 's/^([a-z]+:)([^ ]+.*)$/\1 \2/')
    echo "$input"
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
    git add .
    git switch -c "$branch_name"
    git commit -m "$commit_message"
    gpmr
}
