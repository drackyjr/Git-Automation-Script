#!/bin/bash

# Git Automation Script for Entry-Level Job Showcase
# Automates branch creation, switching, committing, and pushing
# Author: Entry-Level Developer Portfolio

# Color codes for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display usage information
usage() {
    echo -e "${BLUE}Git Automation Script${NC}"
    echo -e "${YELLOW}Usage: $0 [OPTIONS] <branch_name> <commit_message>${NC}"
    echo ""
    echo "Options:"
    echo "  -h, --help      Show this help message"
    echo "  -n, --new       Create a new branch (default: switch to existing)"
    echo "  -f, --force     Force push to remote (use with caution)"
    echo "  -v, --verbose   Verbose output"
    echo ""
    echo "Examples:"
    echo "  $0 feature/login-page \"Added login form validation\""
    echo "  $0 -n bugfix/header-fix \"Fixed navigation header issue\""
    echo "  $0 --force main \"Updated README documentation\""
}

# Function to check if we're in a git repository
check_git_repo() {
    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        echo -e "${RED}Error: Current directory is not a Git repository.${NC}"
        echo "Initialize a git repository with: git init"
        exit 1
    fi
}

# Function to check if there are changes to commit
check_changes() {
    if [ -z "$(git status --porcelain)" ]; then
        echo -e "${YELLOW}No changes to commit.${NC}"
        echo -e "${BLUE}Current repository status:${NC}"
        git status --short
        exit 0
    fi
}

# Function to check if branch exists
branch_exists() {
    local branch_name=$1
    git rev-parse --verify "$branch_name" >/dev/null 2>&1
}

# Function to create and switch to a new branch
create_new_branch() {
    local branch_name=$1
    local verbose=$2
    
    if branch_exists "$branch_name"; then
        echo -e "${RED}Error: Branch '$branch_name' already exists.${NC}"
        echo "Use without -n flag to switch to existing branch."
        exit 1
    fi
    
    if [ "$verbose" = true ]; then
        echo -e "${BLUE}Creating new branch: $branch_name${NC}"
    fi
    
    git checkout -b "$branch_name"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}SUCCESS: Created and switched to branch: $branch_name${NC}"
    else
        echo -e "${RED}FAILED: Could not create branch: $branch_name${NC}"
        exit 1
    fi
}

# Function to switch to existing branch
switch_to_branch() {
    local branch_name=$1
    local verbose=$2
    
    if ! branch_exists "$branch_name"; then
        echo -e "${RED}Error: Branch '$branch_name' does not exist.${NC}"
        echo "Use -n flag to create a new branch."
        echo "Available branches:"
        git branch -a
        exit 1
    fi
    
    if [ "$verbose" = true ]; then
        echo -e "${BLUE}Switching to branch: $branch_name${NC}"
    fi
    
    git checkout "$branch_name"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}SUCCESS: Switched to branch: $branch_name${NC}"
    else
        echo -e "${RED}FAILED: Could not switch to branch: $branch_name${NC}"
        exit 1
    fi
}

# Function to stage, commit, and push changes
commit_and_push() {
    local branch_name=$1
    local commit_message=$2
    local force_push=$3
    local verbose=$4
    
    # Stage all changes
    if [ "$verbose" = true ]; then
        echo -e "${BLUE}Staging changes...${NC}"
        git add -v .
    else
        git add .
    fi
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}FAILED: Could not stage changes${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}SUCCESS: Changes staged successfully${NC}"
    
    # Commit changes
    if [ "$verbose" = true ]; then
        echo -e "${BLUE}Committing changes...${NC}"
    fi
    
    git commit -m "$commit_message"
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}FAILED: Could not commit changes${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}SUCCESS: Changes committed successfully${NC}"
    
    # Push to remote
    if [ "$verbose" = true ]; then
        echo -e "${BLUE}Pushing to remote...${NC}"
    fi
    
    if [ "$force_push" = true ]; then
        git push --force origin "$branch_name"
    else
        git push origin "$branch_name" 2>/dev/null || git push --set-upstream origin "$branch_name"
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}SUCCESS: Pushed to remote branch: $branch_name${NC}"
    else
        echo -e "${RED}FAILED: Could not push to remote${NC}"
        echo -e "${YELLOW}Note: You may need to set up remote origin or handle authentication${NC}"
        exit 1
    fi
}

# Function to display current git status
show_status() {
    echo -e "${BLUE}Repository Status:${NC}"
    echo -e "${YELLOW}Current branch: $(git branch --show-current)${NC}"
    echo -e "${YELLOW}Modified files:${NC}"
    git status --short
    echo ""
}

# Main function
main() {
    local new_branch=false
    local force_push=false
    local verbose=false
    local branch_name=""
    local commit_message=""
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                usage
                exit 0
                ;;
            -n|--new)
                new_branch=true
                shift
                ;;
            -f|--force)
                force_push=true
                shift
                ;;
            -v|--verbose)
                verbose=true
                shift
                ;;
            *)
                if [ -z "$branch_name" ]; then
                    branch_name="$1"
                elif [ -z "$commit_message" ]; then
                    commit_message="$1"
                else
                    echo -e "${RED}Error: Too many arguments${NC}"
                    usage
                    exit 1
                fi
                shift
                ;;
        esac
    done
    
    # Validate required arguments
    if [ -z "$branch_name" ] || [ -z "$commit_message" ]; then
        echo -e "${RED}Error: Both branch name and commit message are required${NC}"
        usage
        exit 1
    fi
    
    # Validate commit message is not empty
    if [ "${#commit_message}" -lt 3 ]; then
        echo -e "${RED}Error: Commit message must be at least 3 characters long${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}=== Git Automation Script ===${NC}"
    echo ""
    
    # Check if we're in a git repository
    check_git_repo
    
    # Show current status if verbose
    if [ "$verbose" = true ]; then
        show_status
    fi
    
    # Check for changes to commit
    check_changes
    
    # Create new branch or switch to existing one
    if [ "$new_branch" = true ]; then
        create_new_branch "$branch_name" "$verbose"
    else
        switch_to_branch "$branch_name" "$verbose"
    fi
    
    # Commit and push changes
    commit_and_push "$branch_name" "$commit_message" "$force_push" "$verbose"
    
    echo ""
    echo -e "${GREEN}COMPLETED: Git workflow finished successfully${NC}"
    echo -e "${BLUE}Branch: $branch_name${NC}"
    echo -e "${BLUE}Commit: $commit_message${NC}"
    
    if [ "$verbose" = true ]; then
        echo ""
        echo -e "${BLUE}Latest commits:${NC}"
        git log --oneline -5
    fi
}

# Execute main function with all arguments
main "$@"
