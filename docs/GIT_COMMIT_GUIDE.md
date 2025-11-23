# Git Commit and Push Guidelines

This document describes the mandatory commit message format and version control process for the TA_Time_Series_Methods repository, as specified in `.agents/TASKS.md` (Task 4).

## Overview

All commits to this repository must follow a standardized format that ensures:
- Clear communication of changes
- Professional commit history
- Easy navigation and understanding of project evolution
- Consistent documentation standards

## Quick Start

### Using the Helper Script (Recommended)

The easiest way to ensure proper commit formatting is to use our helper script:

```bash
./scripts/git_commit_helper.sh
```

This interactive script will guide you through:
1. Staging changes
2. Reviewing changes
3. Generating a properly formatted commit message
4. Committing changes
5. Pushing to GitHub

### Manual Process

If you prefer to commit manually, follow the workflow below.

## Commit Workflow

### 1. Stage Changes

```bash
git add <files>
# or
git add .  # to stage all changes
```

### 2. Review Staged Changes

**ALWAYS** review your changes before committing:

```bash
git diff --staged
```

This shows you exactly what will be committed.

### 3. Create Commit Message

Follow the format specified below (see "Commit Message Format").

### 4. Commit Changes

```bash
git commit -m "Your properly formatted message"
```

The repository's git hooks will validate your message.

### 5. Push to GitHub

**ALWAYS** push after committing:

```bash
git push origin <branch-name>
```

Never leave commits unpushed unless explicitly instructed otherwise.

### 6. Verify Push

Check the output to ensure the push was successful:
- Look for confirmation message
- Verify no errors occurred

## Commit Message Format

### Summary Line (REQUIRED)

**Maximum 50 characters** (72 hard limit)

Format:
```
[Action Verb] [what] [for/in/of] [component]
```

Requirements:
- Use **present tense imperative mood** (e.g., "Add", not "Added" or "Adding")
- Start with a **capital letter**
- Be **specific and descriptive**
- Start with an **action verb**

Common action verbs:
- `Add` - Create new functionality or files
- `Update` - Modify existing functionality
- `Fix` - Correct bugs or issues
- `Remove` - Delete code or files
- `Refactor` - Restructure without changing behavior
- `Implement` - Realize a feature or requirement
- `Document` - Add or update documentation
- `Clean` - Code cleanup without functional changes
- `Improve` - Enhance existing functionality
- `Enhance` - Add improvements to existing features

### Detailed Description (When Applicable)

After the summary line, include:

1. **What was changed** (specific files/sections)
   - List affected components/files (at least 2-3 key files)
   - Be specific about which parts were modified

2. **Why it was changed** (reasoning/purpose)
   - Explain the motivation
   - Provide context for the decision

3. **Impact or implications** (optional)
   - Note any important side effects
   - Mention related components affected

Format:
```
[Summary line]

- Change 1 with brief explanation
- Change 2 with brief explanation  
- Change 3 with brief explanation

[Optional: Additional context, reasoning, or impact]
```

## Examples

### Good Examples ✅

```
Add inline comments to Stata code for clarity

- Document each line in empirical_applications.do
- Exclude plot and display sections per specifications
- Improve student understanding of statistical methods

Enhances pedagogical value of code examples.
```

```
Update section titles to remove Exercise X terminology

- Replace generic "Exercise X" with descriptive method names
- Apply pattern: [Method] + [for/in/of] + [Data/Geography]
- Update sessions/session_1/notebook_1.ipynb
- Update sessions/session_2/notebook_2.ipynb

Improves professional presentation and clarity.
```

```
Fix unit root test implementation in IBEX-35 analysis

- Correct ADF test specification in sessions/empirical_applications.do
- Update lag selection criteria to match theoretical requirements
- Add proper diagnostic output

Resolves issue #23 regarding incorrect p-values.
```

### Bad Examples ❌

```
Update files
```
*Too generic - doesn't explain what or why*

```
Fixed some stuff
```
*Vague and unprofessional*

```
Added feature
```
*No specifics about what feature*

```
WIP
```
*Not a complete thought*

```
Minor changes
```
*Too vague*

## Forbidden Elements

**NEVER** include in commit messages:
- `Generated with Copilot`
- `Co-Authored-By: Copilot`
- `Co-authored-by: GitHub Copilot`
- Generic messages like "Update files", "Fix issues", "Minor changes"
- Work-in-progress markers like "WIP", "TODO", "temp"

## Git Hooks

This repository includes two git hooks to enforce commit standards:

### 1. `prepare-commit-msg`

Automatically prepares a commit message template with:
- Format reminders
- List of staged files
- Guidelines and examples

### 2. `commit-msg`

Validates commit messages and checks for:
- Empty messages
- Message length (warns if > 72 characters)
- Forbidden phrases
- Generic/vague messages
- Proper capitalization
- Action verbs in imperative mood

## Installing Git Hooks

The hooks are already present in `.git/hooks/` but you may need to ensure they're executable:

```bash
chmod +x .git/hooks/prepare-commit-msg
chmod +x .git/hooks/commit-msg
```

## Template for Quick Reference

```bash
# Summary (< 50 chars)
[Verb] [what] [for/in/of] [component]

# Body
- What changed: specific files/sections
- Why changed: reasoning/purpose  
- Impact: affected components

# Optional: Additional context
```

## Common Scenarios

### Multiple File Changes

```
Refactor data loading pipeline for better performance

- Consolidate duplicate loading logic in data/loaders.py
- Add caching mechanism for frequently accessed datasets
- Update sessions/session_1/notebook_1.ipynb to use new API

Reduces execution time by ~40% for large datasets.
```

### Documentation Only

```
Document unit root testing procedures

- Add mathematical framework section to sessions/README.md
- Include interpretation guidelines for ADF test results
- Provide examples with IBEX-35 data

Addresses student questions from previous session.
```

### Bug Fix

```
Fix memory leak in VAR estimation loop

- Add proper cleanup in sessions/empirical_applications.do
- Release matrix references after each iteration
- Add diagnostic output for memory usage

Prevents crashes with large datasets (>10000 observations).
```

## Tips for Success

1. **Think before you commit**: What story does your commit tell?
2. **Be specific**: Reference files, functions, or sections changed
3. **Explain why**: Context helps future you and others
4. **Keep it atomic**: One logical change per commit
5. **Review before pushing**: Use `git log` to check your message
6. **Push regularly**: Don't let commits pile up locally

## Troubleshooting

### Hook Not Running

If the git hooks aren't executing:
```bash
chmod +x .git/hooks/prepare-commit-msg
chmod +x .git/hooks/commit-msg
```

### Message Too Long

Edit your commit message:
```bash
git commit --amend
```

### Forgot to Push

Push your commits:
```bash
git push origin <branch-name>
```

### Need to Change Last Commit Message

```bash
git commit --amend -m "New message"
git push origin <branch-name> --force-with-lease
```
**Warning**: Only use `--force-with-lease` if no one else has pulled your commits.

## Additional Resources

- Git Commit Best Practices: https://cbea.ms/git-commit/
- Conventional Commits: https://www.conventionalcommits.org/
- Repository Task Specifications: `.agents/TASKS.md` (Task 4)

## Questions or Issues?

If you encounter problems with the commit process or have suggestions for improvement, please:
1. Check this documentation first
2. Review `.agents/TASKS.md` (Task 4) for detailed requirements
3. Contact the repository maintainer

---

**Remember**: Good commit messages are a gift to your future self and your collaborators. Take the time to write them well!
