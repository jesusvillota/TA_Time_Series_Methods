TASK 1
<task1>
Add inline comments to each line of stata code where you explain what that line of code is doing.
This way students can understand easily what that line is doing by just reading the inline comment to the right of that code line.
Important: do NOT include inline comments in these two cases: 
    1) Plots (adding inline comments to each line of the plot yields an error)
    2) Displays (it doesn't make sense, because displays are just printing text)
</task1>

TASK 2
<task2>
Update section titles to remove "Exercise X" terminology and use descriptive, technical titles focused on concepts and methods.

Pattern: [Statistical Method/Concept] + [for/in/of] + [Data/Asset/Geography]

Guidelines:
- Use descriptive titles that focus on the econometric concept or technique being explored
- Include data/geography context when relevant (e.g., "for IBEX-35", "in Spanish Markets")
- Use technical but clear language (proper econometric terminology)
- Avoid internal organizational terms like "Exercise X"
- Apply to both main section titles and subsection titles for consistency

Examples:
✅ GOOD: "Unit Root Tests for IBEX-35 Index and Returns"
✅ GOOD: "Autocorrelation Patterns in Spanish Markets"
✅ GOOD: "Sovereign Spread Correlation Dynamics Across Periods"
❌ AVOID: "Exercise 5 - Unit Root Tests for IBEX-35"
❌ AVOID: "Analyzing the Data"
❌ AVOID: "Looking at Correlations"
</task2>

TASK 3
<task3>
Create didactic and visual markdown explanations that combine theoretical rigor with pedagogical clarity.

Structure and Content Guidelines:
1. **Hierarchical Organization**: Use subsections with descriptive titles (#### Mathematical Framework, #### Interpretation of Results, etc.)
2. **Multi-layered Explanations**: Combine multiple approaches:
   - Mathematical formulations with proper LaTeX notation
   - Intuitive verbal descriptions
   - Bulleted lists for key properties or steps
   - Explicit interpretation sections

Visual Design Standards:
1. **Colored Information Boxes**: Use gradient backgrounds with left borders to highlight different types of information:
   - **Warning/Problem boxes** (red tones): `background: linear-gradient(135deg, #fff5f5 0%, #ffe5e5 100%); border-left: 4px solid #dc2626`
   - **Insight/Explanation boxes** (blue tones): `background: #f0f9ff; border-left: 4px solid #3b82f6`
   - **Key Takeaway boxes** (green tones): `background: #f0fdf4; border-left: 4px solid #10b981`
   - **Important Note boxes** (amber tones): `background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%); border-left: 4px solid #f59e0b`

2. **Box Formatting**: Always include:
   - `padding: 18px` (or 16px-20px range)
   - `border-radius: 8px` (or 6px-8px range)
   - `margin: 20px 0` (or 16px-20px range)
   - Bold headers with emoji indicators when appropriate (🔍, ⚠️, etc.)

3. **Typography Emphasis**:
   - Use **bold** for key terms and important phrases
   - Use *italics* for emphasis and technical nuances
   - Use inline code formatting with backticks for variable names, test statistics, and R² values

4. **Mathematical Clarity**:
   - Use proper LaTeX with `$$` for display equations and aligned environments
   - Include verbal descriptions immediately after equations
   - Use `\text{}` within equations for clarity
   - Define all notation explicitly

5. **Structured Lists**: Create clear enumerations:
   - Numbered lists for sequential steps or objectives
   - Bulleted lists for properties or key points
   - Use sub-bullets for hierarchical information

6. **Interpretation Sections**: Always include explicit interpretation blocks that:
   - Connect theoretical concepts to empirical results
   - Explain "what the results reveal" in practical terms
   - Use numbered points (1., 2., 3.) to organize multiple insights
   - Reference specific visualizations or output when applicable

7. **Progressive Disclosure**: Structure explanations from general to specific:
   - Start with high-level concept or problem statement
   - Present mathematical framework
   - Provide detailed interpretation
   - Conclude with key lessons or takeaways

Example Pattern (DO NOT copy literally, adapt to context):
```markdown
#### Descriptive Subsection Title

<div style="background: [gradient/solid]; border-left: 4px solid [color]; padding: 18px; border-radius: 8px; margin: 20px 0;">

**Problem/Concept Introduction**: Clear statement using bold and emphasis

</div>

#### Mathematical Framework

Formal presentation with equations:

$$
\text{equation with proper notation}
$$

where:
- Variable definitions
- Parameter explanations

**Key Properties**:
1. First property with intuitive explanation
2. Second property linking theory to practice

<div style="background: [color]; border-left: 4px solid [color]; padding: 16px; border-radius: 6px; margin: 16px 0;">

**Why This Matters**: Intuitive explanation connecting math to real-world implications

</div>

#### Interpretation of Results

<div style="background: [gradient]; border-left: 4px solid [color]; padding: 18px; border-radius: 8px; margin: 20px 0;">

**🔍 What the Analysis Reveals:**

1. **First Finding**: Description with emphasis on practical meaning
2. **Second Finding**: Connection to theoretical expectations
3. **Key Implication**: Bottom-line takeaway

</div>
```

Key Principles:
- **Didactic**: Build understanding incrementally, define terms, explain "why" not just "what"
- **Visual**: Use color, spacing, and structure to guide the eye and organize information hierarchically
- **Rigorous**: Maintain technical accuracy while ensuring accessibility
- **Actionable**: Connect theory to practice, equations to interpretation, methods to conclusions
</task3>

TASK 4: Commit and push changes to GitHub
<task4>
Implement mandatory commit message generation and version control process for all repository commits and pushes.

This is a CRITICAL REQUIREMENT for ALL commits and pushes. Must be used EVERY TIME before creating any git commit or push. No exceptions.

## Process Overview

The agent MUST follow this complete workflow when committing and pushing changes:

1. **Stage Changes** - Ensure all relevant changes are staged using `git add`
2. **Review Changes** - Run `git diff --staged` to review all staged modifications
3. **Generate Commit Message** - Create a descriptive commit message following the format below
4. **Commit Changes** - Execute `git commit` with the generated message
5. **Verify Commit** - Confirm the commit was successful
6. **Push to Remote** - Execute `git push origin [branch-name]` to push changes to GitHub
7. **Confirm Push** - Verify that the push to GitHub was successful

## Mandatory Commit Process

BEFORE ANY "git commit" COMMAND:

1. ALWAYS run `git diff --staged` first to see changes
2. ALWAYS analyze the staged changes thoroughly
3. ALWAYS generate a commit message following the format below
4. NEVER commit without following this process

## Required Commit Message Format

### Summary Line (under 50 characters)

- Use present tense imperative mood
- Be specific and descriptive
- Example: "Add inline comments to Stata code", "Update section titles to remove Exercise X terminology"

### Detailed Description (when applicable)

- Explain WHAT was changed (specific files/sections)
- Explain WHY it was changed (reasoning/purpose)
- List affected components/files (at least 2-3 key files)
- Include any important context or decision rationale

### Format Template

```markdown
[Action Verb] [what] [for/in/of] [component]

- Change 1 with brief explanation
- Change 2 with brief explanation
- Change 3 with brief explanation

[Optional: Explain reasoning or impact of changes]
```

## Best Practices

- Use clear, descriptive commit messages that tell the story of what changed
- Use present tense ("Add feature" not "Added feature")
- Include the "why" not just the "what"
- Start summary with action verb (Add, Update, Fix, Remove, Refactor, etc.)
- Be specific about what components/files are affected
- Include file paths when referencing specific files

## Mandatory Push Process

AFTER EACH "git commit":

1. ALWAYS run `git push origin [current-branch]` to push to GitHub
2. ALWAYS verify the push was successful (check output for confirmation)
3. NEVER leave commits without pushing to the remote repository
4. If push fails, diagnose and resolve the issue before proceeding

### Push Verification

- Look for output confirming successful push to GitHub
- Verify no errors occurred during the push
- If authentication issues arise, troubleshoot and retry

## FORBIDDEN Elements

- NEVER include "Generated with Copilot"
- NEVER include "Co-Authored-By: Copilot"
- NEVER use generic messages like "Update files", "Fix issues", or "Minor changes"
- NEVER commit without pushing (unless explicitly instructed otherwise)
- NEVER leave work uncommitted and unpushed at the end of a task

## Example Workflow

```bash
# 1. Stage changes
git add materials/sessions/notebook_1.ipynb src/utils/helpers.py

# 2. Review staged changes
git diff --staged

# 3. Create and execute commit with proper message
git commit -m "Add inline comments to Stata code for pedagogical clarity

- Document each line of code with explanation of functionality
- Applied to all Stata scripts in empirical_applications.do
- Excluded plots and display sections per specifications
- Improves student understanding of statistical methods"

# 4. Push to GitHub
git push origin main

# 5. Verify successful push
# Output should show: "... main -> main"
```

## Reminder

- If you complete any task that involves modifying files, STOP before finishing and follow this complete commit and push workflow
- NEVER mark a task as complete without committing and pushing changes
- ALWAYS verify both commit and push succeeded before considering work done
</task4>
