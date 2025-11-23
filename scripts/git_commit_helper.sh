#!/bin/bash
# Git Commit Helper Script
# This script guides users through the proper commit and push workflow
# as specified in .agents/TASKS.md (Task 4)

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}================================================================${NC}"
echo -e "${BLUE}Git Commit and Push Helper${NC}"
echo -e "${BLUE}Following the workflow specified in .agents/TASKS.md (Task 4)${NC}"
echo -e "${BLUE}================================================================${NC}"
echo ""

# Step 1: Check if there are any changes
echo -e "${YELLOW}Step 1: Checking for changes...${NC}"
if ! git diff --quiet || ! git diff --cached --quiet; then
    echo -e "${GREEN}✓ Changes detected${NC}"
else
    echo -e "${RED}✗ No changes detected${NC}"
    echo "Nothing to commit. Make your changes first."
    exit 1
fi
echo ""

# Step 2: Show current status
echo -e "${YELLOW}Step 2: Current repository status${NC}"
git status
echo ""

# Step 3: Stage changes
echo -e "${YELLOW}Step 3: Stage changes${NC}"
read -p "Do you want to stage all changes? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git add .
    echo -e "${GREEN}✓ All changes staged${NC}"
else
    echo "Please stage your changes manually using: git add <files>"
    echo "Then run this script again."
    exit 1
fi
echo ""

# Step 4: Review staged changes
echo -e "${YELLOW}Step 4: Review staged changes${NC}"
echo "Running: git diff --staged"
echo ""
git diff --staged
echo ""

read -p "Do the staged changes look correct? [y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Please review and adjust your changes, then run this script again."
    exit 1
fi
echo ""

# Step 5: Generate commit message
echo -e "${YELLOW}Step 5: Generate commit message${NC}"
echo ""
echo "Commit message format requirements:"
echo "  - Summary line: under 50 characters, present tense imperative mood"
echo "  - Start with action verb (Add, Update, Fix, Remove, etc.)"
echo "  - Include detailed description of changes"
echo "  - List affected files/components"
echo ""

STAGED_FILES=$(git diff --cached --name-only | head -5)
echo "Recently staged files:"
echo "$STAGED_FILES" | sed 's/^/  - /'
echo ""

echo "Enter commit message summary (press Enter when done):"
read -r SUMMARY

if [ -z "$SUMMARY" ]; then
    echo -e "${RED}✗ Summary cannot be empty${NC}"
    exit 1
fi

echo ""
echo "Enter detailed description (optional, press Ctrl+D when done):"
echo "You can list changes with bullet points, explain reasoning, etc."
DESCRIPTION=$(cat)

# Build full commit message
COMMIT_MSG="$SUMMARY"
if [ ! -z "$DESCRIPTION" ]; then
    COMMIT_MSG="$COMMIT_MSG

$DESCRIPTION"
fi

echo ""
echo -e "${BLUE}Generated commit message:${NC}"
echo "---"
echo "$COMMIT_MSG"
echo "---"
echo ""

read -p "Does this commit message look good? [y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Commit cancelled. Please run the script again."
    exit 1
fi
echo ""

# Step 6: Commit changes
echo -e "${YELLOW}Step 6: Committing changes${NC}"
git commit -m "$COMMIT_MSG"
echo -e "${GREEN}✓ Changes committed successfully${NC}"
echo ""

# Step 7: Get current branch
CURRENT_BRANCH=$(git branch --show-current)
echo -e "${YELLOW}Step 7: Push to remote${NC}"
echo "Current branch: $CURRENT_BRANCH"
echo ""

read -p "Push changes to origin/$CURRENT_BRANCH? [y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Commit created but not pushed. Don't forget to push later!${NC}"
    exit 0
fi

# Step 8: Push to remote
echo "Pushing to origin/$CURRENT_BRANCH..."
if git push origin "$CURRENT_BRANCH"; then
    echo -e "${GREEN}✓ Changes pushed successfully to GitHub${NC}"
else
    echo -e "${RED}✗ Push failed${NC}"
    echo "Please resolve any issues and try: git push origin $CURRENT_BRANCH"
    exit 1
fi

echo ""
echo -e "${BLUE}================================================================${NC}"
echo -e "${GREEN}✓ Commit and push workflow completed successfully!${NC}"
echo -e "${BLUE}================================================================${NC}"
