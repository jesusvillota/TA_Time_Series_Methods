# Scripts

This directory contains helper scripts for the TA_Time_Series_Methods repository.

## Available Scripts

### `install_git_hooks.sh`

A script to install git hooks for commit message validation.

#### Usage

```bash
./scripts/install_git_hooks.sh
```

#### What it does

This script installs two git hooks:
- `prepare-commit-msg` - Prepares a commit message template
- `commit-msg` - Validates commit message format

Run this script after cloning the repository to enable automatic commit message validation.

### `git_commit_helper.sh`

An interactive script that guides you through the proper git commit and push workflow as specified in `.agents/TASKS.md` (Task 4).

#### Usage

```bash
./scripts/git_commit_helper.sh
```

#### What it does

The script will:
1. Check for changes in the repository
2. Display current git status
3. Guide you through staging changes
4. Show a diff of staged changes for review
5. Help you create a properly formatted commit message
6. Commit the changes with your message
7. Push the changes to GitHub
8. Verify the push was successful

#### Features

- **Interactive prompts**: Asks for confirmation at each step
- **Colored output**: Uses colors to highlight important information
- **Validation**: Ensures you follow the proper workflow
- **Safety checks**: Reviews changes before committing
- **Error handling**: Provides clear error messages if something goes wrong

#### Requirements

- Must be run from the repository root directory
- Requires git to be configured with push access to the repository
- Executable permissions (automatically set during installation)

#### Example Session

```bash
$ ./scripts/git_commit_helper.sh
================================================================
Git Commit and Push Helper
Following the workflow specified in .agents/TASKS.md (Task 4)
================================================================

Step 1: Checking for changes...
✓ Changes detected

Step 2: Current repository status
On branch main
...

Step 3: Stage changes
Do you want to stage all changes? [y/N] y
✓ All changes staged

Step 4: Review staged changes
Running: git diff --staged
...

Do the staged changes look correct? [y/N] y

Step 5: Generate commit message

Commit message format requirements:
  - Summary line: under 50 characters, present tense imperative mood
  - Start with action verb (Add, Update, Fix, Remove, etc.)
  - Include detailed description of changes
  - List affected files/components

Recently staged files:
  - docs/GIT_COMMIT_GUIDE.md
  - scripts/git_commit_helper.sh

Enter commit message summary (press Enter when done):
Add git commit helper script

Enter detailed description (optional, press Ctrl+D when done):
You can list changes with bullet points, explain reasoning, etc.
- Implement interactive script for guided commit workflow
- Add validation and colored output for better UX
- Include comprehensive documentation

^D

Generated commit message:
---
Add git commit helper script

- Implement interactive script for guided commit workflow
- Add validation and colored output for better UX
- Include comprehensive documentation
---

Does this commit message look good? [y/N] y

Step 6: Committing changes
✓ Changes committed successfully

Step 7: Push to remote
Current branch: main

Push changes to origin/main? [y/N] y
Pushing to origin/main...
✓ Changes pushed successfully to GitHub

================================================================
✓ Commit and push workflow completed successfully!
================================================================
```

## Installation

The script is automatically executable. If needed, you can make it executable with:

```bash
chmod +x scripts/git_commit_helper.sh
```

## Documentation

For detailed information about the commit message format and version control process, see:
- `docs/GIT_COMMIT_GUIDE.md` - Complete commit guidelines
- `.agents/TASKS.md` (Task 4) - Original task specification

## Troubleshooting

### Script Won't Run

If you get a "Permission denied" error:
```bash
chmod +x scripts/git_commit_helper.sh
```

### No Changes Detected

Make sure you've actually modified files before running the script.

### Push Failed

Common causes:
- No push access to the repository
- Branch protection rules require pull request
- Network connectivity issues
- Authentication problems

Check the error message for specific details.

## Contributing

If you have suggestions for improving this script, please:
1. Follow the commit guidelines when submitting changes
2. Test the script thoroughly before committing
3. Update this README if you add new features

---

**Note**: This script is designed to be used by humans working directly with git. Automated agents should use the `report_progress` tool instead.
