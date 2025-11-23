#!/bin/bash
# Install Git Hooks
# This script installs the git hooks for commit message validation
# Run this after cloning the repository

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
HOOKS_DIR="$REPO_ROOT/.git/hooks"

echo "Installing git hooks for TA_Time_Series_Methods repository..."
echo ""

# Check if we're in a git repository
if [ ! -d "$REPO_ROOT/.git" ]; then
    echo "Error: Not in a git repository"
    echo "Please run this script from the repository root or scripts directory"
    exit 1
fi

# Create hooks directory if it doesn't exist
mkdir -p "$HOOKS_DIR"

# Install prepare-commit-msg hook
echo "Installing prepare-commit-msg hook..."
cat > "$HOOKS_DIR/prepare-commit-msg" << 'EOF'
#!/bin/bash
# prepare-commit-msg hook
# This hook prepares the commit message template based on the commit message format requirements
# specified in .agents/TASKS.md (Task 4)

COMMIT_MSG_FILE=$1
COMMIT_SOURCE=$2
SHA1=$3

# Only run this hook for regular commits (not merges, squashes, etc.)
if [ -z "$COMMIT_SOURCE" ]; then
    # Check if the commit message is empty or just comments
    if ! grep -qv "^#" "$COMMIT_MSG_FILE"; then
        # Get a list of staged files
        STAGED_FILES=$(git diff --cached --name-only)
        
        # Create a template commit message
        cat > "$COMMIT_MSG_FILE" << EOFMSG
# [Action Verb] [what] [for/in/of] [component]
#
# - Change 1 with brief explanation
# - Change 2 with brief explanation  
# - Change 3 with brief explanation
#
# [Optional: Explain reasoning or impact of changes]
#
# ============================================================================
# COMMIT MESSAGE FORMAT REQUIREMENTS (from .agents/TASKS.md Task 4):
# ============================================================================
#
# Summary Line (REQUIRED, under 50 characters):
# - Use present tense imperative mood (e.g., "Add", "Update", "Fix")
# - Be specific and descriptive
# - Start with action verb
#
# Detailed Description (when applicable):
# - Explain WHAT was changed (specific files/sections)
# - Explain WHY it was changed (reasoning/purpose)
# - List affected components/files (at least 2-3 key files)
# - Include any important context or decision rationale
#
# BEST PRACTICES:
# - Use clear, descriptive commit messages that tell the story of what changed
# - Use present tense ("Add feature" not "Added feature")
# - Include the "why" not just the "what"
# - Be specific about what components/files are affected
#
# FORBIDDEN ELEMENTS:
# - NEVER include "Generated with Copilot"
# - NEVER include "Co-Authored-By: Copilot"
# - NEVER use generic messages like "Update files", "Fix issues", "Minor changes"
#
# ============================================================================
# STAGED FILES:
# ============================================================================
$(echo "$STAGED_FILES" | sed 's/^/# - /')
#
# ============================================================================
# Run 'git diff --cached' to review your changes before committing
# ============================================================================
EOFMSG
    fi
fi
EOF

chmod +x "$HOOKS_DIR/prepare-commit-msg"
echo "✓ prepare-commit-msg hook installed"

# Install commit-msg hook
echo "Installing commit-msg hook..."
cat > "$HOOKS_DIR/commit-msg" << 'EOF'
#!/bin/bash
# commit-msg hook
# This hook validates the commit message format based on requirements in .agents/TASKS.md (Task 4)

COMMIT_MSG_FILE=$1

# Read the commit message (excluding comments)
COMMIT_MSG=$(grep -v "^#" "$COMMIT_MSG_FILE")

# Check if commit message is empty
if [ -z "$COMMIT_MSG" ]; then
    echo "ERROR: Commit message is empty"
    echo "Please provide a descriptive commit message following the format in .agents/TASKS.md Task 4"
    exit 1
fi

# Get the summary line (first line)
SUMMARY_LINE=$(echo "$COMMIT_MSG" | head -n 1)

# Check if summary line exists
if [ -z "$SUMMARY_LINE" ]; then
    echo "ERROR: Commit message must have a summary line"
    exit 1
fi

# Check summary line length (should be under 50 characters, but we'll warn at 72)
SUMMARY_LENGTH=${#SUMMARY_LINE}
if [ $SUMMARY_LENGTH -gt 72 ]; then
    echo "WARNING: Summary line is too long ($SUMMARY_LENGTH characters)"
    echo "Recommended: under 50 characters, maximum 72 characters"
    echo "Summary: $SUMMARY_LINE"
fi

# Check for forbidden phrases
FORBIDDEN_PHRASES=("Generated with Copilot" "Co-Authored-By: Copilot" "Co-authored-by: GitHub Copilot")

for phrase in "${FORBIDDEN_PHRASES[@]}"; do
    if echo "$COMMIT_MSG" | grep -qi "$phrase"; then
        echo "ERROR: Commit message contains forbidden phrase: '$phrase'"
        echo "Please remove this phrase from your commit message"
        exit 1
    fi
done

# Check for generic/bad commit messages
BAD_PATTERNS=("^Update files" "^Fix issues" "^Minor changes" "^WIP" "^fix" "^update" "^minor")

for pattern in "${BAD_PATTERNS[@]}"; do
    if echo "$SUMMARY_LINE" | grep -qi "$pattern"; then
        echo "WARNING: Commit message appears to be generic: '$SUMMARY_LINE'"
        echo "Consider being more specific about what was changed and why"
        echo ""
        echo "Good examples:"
        echo "  - Add inline comments to Stata code for pedagogical clarity"
        echo "  - Update section titles to remove Exercise X terminology"
        echo "  - Fix unit root test implementation in IBEX-35 analysis"
        echo ""
        read -p "Continue with this commit message? [y/N] " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
done

# Check that summary line starts with capital letter
if ! echo "$SUMMARY_LINE" | grep -q "^[A-Z]"; then
    echo "WARNING: Summary line should start with a capital letter"
    echo "Summary: $SUMMARY_LINE"
fi

# Check for imperative mood by looking for common present tense verbs at the start
GOOD_VERBS=("Add" "Update" "Fix" "Remove" "Refactor" "Implement" "Create" "Delete" "Improve" "Enhance" "Modify" "Document" "Clean")
VERB_FOUND=false

for verb in "${GOOD_VERBS[@]}"; do
    if echo "$SUMMARY_LINE" | grep -q "^$verb "; then
        VERB_FOUND=true
        break
    fi
done

if [ "$VERB_FOUND" = false ]; then
    echo "WARNING: Summary line should start with an action verb in imperative mood"
    echo "Examples: Add, Update, Fix, Remove, Refactor, Implement, Create, etc."
    echo "Current summary: $SUMMARY_LINE"
fi

# Success
exit 0
EOF

chmod +x "$HOOKS_DIR/commit-msg"
echo "✓ commit-msg hook installed"

echo ""
echo "========================================="
echo "Git hooks installed successfully!"
echo "========================================="
echo ""
echo "The following hooks are now active:"
echo "  - prepare-commit-msg: Prepares commit message template"
echo "  - commit-msg: Validates commit message format"
echo ""
echo "For more information, see:"
echo "  - docs/GIT_COMMIT_GUIDE.md"
echo "  - docs/COMMIT_QUICK_REFERENCE.md"
echo ""
echo "To use the interactive commit helper:"
echo "  ./scripts/git_commit_helper.sh"
echo ""
