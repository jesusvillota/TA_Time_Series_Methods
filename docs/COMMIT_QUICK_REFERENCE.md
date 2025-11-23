# Quick Commit Message Reference

A one-page reference for writing proper commit messages in this repository.

## Format

```
[Verb] [what] [for/in/of] [component]

- What changed: specific files/sections
- Why changed: reasoning/purpose
- Impact: affected components (optional)
```

## Rules

✅ **DO**
- Start with capital letter
- Use imperative mood (Add, Fix, Update)
- Keep summary under 50 characters
- Be specific about what changed
- Explain why the change was needed
- List affected files

❌ **DON'T**
- Use generic messages ("Update files", "Fix issues")
- Include "Generated with Copilot"
- Use past tense ("Added", "Fixed")
- Leave out important context
- Forget to push after committing

## Common Verbs

| Verb | Use When |
|------|----------|
| Add | Creating new functionality or files |
| Update | Modifying existing functionality |
| Fix | Correcting bugs or issues |
| Remove | Deleting code or files |
| Refactor | Restructuring without changing behavior |
| Implement | Realizing a feature or requirement |
| Document | Adding or updating documentation |
| Improve | Enhancing existing functionality |
| Clean | Code cleanup without functional changes |

## Quick Examples

### Good ✅
```
Add inline comments to Stata code

- Document empirical_applications.do
- Exclude plot sections per specs
- Improve student understanding
```

### Bad ❌
```
Updated files
```

## Workflow

1. `git add .` - Stage changes
2. `git diff --staged` - Review changes
3. `git commit -m "message"` - Commit with proper message
4. `git push origin <branch>` - Push to GitHub

## Helper Tool

```bash
./scripts/git_commit_helper.sh
```

Guides you through the entire process interactively.

## Full Documentation

See `docs/GIT_COMMIT_GUIDE.md` for complete guidelines and examples.
