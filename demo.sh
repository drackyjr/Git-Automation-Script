#!/bin/bash

# Demonstration script showing various features of git-automation.sh
# This script shows different use cases and scenarios

SCRIPT_NAME="./git-automation.sh"

echo "Git Automation Script - Feature Demonstration"
echo "============================================="
echo ""

# Check if the main script exists
if [ ! -f "$SCRIPT_NAME" ]; then
    echo "Error: $SCRIPT_NAME not found in current directory"
    echo "Please ensure git-automation.sh is in the same directory as this demo script"
    exit 1
fi

# Make sure script is executable
chmod +x "$SCRIPT_NAME"

echo "Step 1: Showing help documentation..."
echo "Command: $SCRIPT_NAME --help"
echo "----------------------------------------"
$SCRIPT_NAME --help
echo ""
read -p "Press Enter to continue to next demonstration..."

echo ""
echo "Step 2: Checking repository status..."
echo "Command: git status"
echo "----------------------------------------"
git status
echo ""
read -p "Press Enter to continue..."

echo ""
echo "Step 3: Creating some changes to demonstrate..."
echo "Adding content to demonstrate the script..."
echo "Current timestamp: $(date)" >> demo-file.txt
echo "Random number: $RANDOM" >> demo-file.txt

echo ""
echo "Step 4: Showing what changed..."
echo "Command: git status --short"
echo "----------------------------------------"
git status --short
echo ""
read -p "Press Enter to continue..."

echo ""
echo "Step 5: Demonstrating new branch creation with verbose output..."
echo "Command: $SCRIPT_NAME -v -n demo/feature-$(date +%H%M) \"Demo: Added timestamp and random data\""
echo "----------------------------------------"
BRANCH_NAME="demo/feature-$(date +%H%M)"
$SCRIPT_NAME -v -n "$BRANCH_NAME" "Demo: Added timestamp and random data"
echo ""
read -p "Press Enter to continue..."

echo ""
echo "Step 6: Showing recent commit history..."
echo "Command: git log --oneline -3"
echo "----------------------------------------"
git log --oneline -3
echo ""
read -p "Press Enter to continue..."

echo ""
echo "Step 7: Switching back to main branch..."
echo "Command: git checkout main"
echo "----------------------------------------"
git checkout main

echo ""
echo "Step 8: Making another change..."
echo "Updated at: $(date)" >> README.md

echo ""
echo "Step 9: Demonstrating regular commit to existing branch..."
echo "Command: $SCRIPT_NAME main \"Updated README with current timestamp\""
echo "----------------------------------------"
$SCRIPT_NAME main "Updated README with current timestamp"

echo ""
echo "Demonstration completed!"
echo "You have seen:"
echo "  - Help documentation display"
echo "  - New branch creation with verbose output"
echo "  - Automated staging, committing, and pushing"
echo "  - Branch switching and management"
echo "  - Error handling and user feedback"
echo ""
echo "This script demonstrates practical Git workflow automation"
echo "suitable for entry-level developer portfolios!"
