#!/bin/bash

# Test script for Git Automation Script
# This creates a simple test environment to demonstrate the script functionality

echo "Setting up test environment for Git Automation Script..."

# Create test directory
TEST_DIR="git-automation-test"
if [ -d "$TEST_DIR" ]; then
    echo "Cleaning up existing test directory..."
    rm -rf "$TEST_DIR"
fi

mkdir "$TEST_DIR"
cd "$TEST_DIR"

# Initialize git repository
echo "Initializing Git repository..."
git init
git config user.name "Test User"
git config user.email "test@example.com"

# Create some sample files
echo "Creating sample files..."
echo "# Test Project" > README.md
echo "console.log('Hello, World!');" > app.js
echo "body { margin: 0; }" > style.css

# Make initial commit
echo "Creating initial commit..."
git add .
git commit -m "Initial commit"

echo ""
echo "SUCCESS: Test environment ready!"
echo "Location: $(pwd)"
echo ""
echo "Now you can test the git-automation.sh script with commands like:"
echo "../git-automation.sh -n feature/new-feature \"Added awesome new feature\""
echo "../git-automation.sh -v main \"Updated documentation\""
echo ""
echo "Remember to copy git-automation.sh to this directory or use relative path!"
