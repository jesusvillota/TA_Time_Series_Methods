# Setup Guide: Running Stata Code in Jupyter Notebooks

This guide will help you set up your environment to run Stata code in Jupyter notebooks like `01_arma_unit_roots.ipynb`.

## Prerequisites

✅ **Stata is installed**: Found at `/Applications/Stata/StataMP.app`
✅ **Python 3.14.0 is installed**
✅ **uv is installed**: Fast Python package installer (see Step 1 for installation)

## Step 1: Install Required Python Packages

**Prerequisites**: Make sure you have `uv` installed. If not, install it:
```bash
# On macOS/Linux
curl -LsSf https://astral.sh/uv/install.sh | sh

# Or with Homebrew
brew install uv

# Or with pipx
pipx install uv
```

```bash
# Navigate to the project directory
cd /Users/jesusvillotamiranda/Library/CloudStorage/OneDrive-UniversidaddeLaRioja/GitHub/Repository/TA_Time_Series_Methods

# Install dependencies and create virtual environment automatically
# This uses pyproject.toml to manage dependencies
uv sync
```

This will:
- Create a virtual environment automatically (in `.venv` by default)
- Install all dependencies from `pyproject.toml`
- Make everything ready to use

After installation, activate the virtual environment:
```bash
source .venv/bin/activate
```

## Step 2: Install and Configure Stata Kernel

After installing the packages, you need to install the Stata kernel:

```bash
# Make sure you're in the project directory
uv run python -m stata_kernel.install
```

This command will:
- Install the Stata kernel for Jupyter
- Ask you to configure the Stata executable path

### Finding Your Stata Executable Path

On macOS, the Stata executable is typically located at:
- `/Applications/Stata/StataMP.app/Contents/MacOS/stata-mp` (for StataMP)
- `/Applications/Stata/StataSE.app/Contents/MacOS/stata-se` (for StataSE)
- `/Applications/Stata/StataIC.app/Contents/MacOS/stata-ic` (for StataIC)

Based on your installation, try:
```bash
/Applications/Stata/StataMP.app/Contents/MacOS/stata-mp
```

When running `uv run python -m stata_kernel.install`, it will prompt you for this path.

## Step 3: Make Stata Accessible from Command Line (Optional but Recommended)

Add Stata to your PATH so it's accessible from anywhere:

1. Open your shell configuration file:
   ```bash
   nano ~/.zshrc  # Since you're using zsh
   ```

2. Add this line:
   ```bash
   export PATH="/Applications/Stata/StataMP.app/Contents/MacOS:$PATH"
   ```

3. Reload your shell configuration:
   ```bash
   source ~/.zshrc
   ```

4. Test if it works:
   ```bash
   stata-mp -e "display \"Hello from Stata\""
   ```

## Step 4: Launch Jupyter and Open the Notebook

```bash
# Launch Jupyter Notebook
uv run jupyter notebook
```

Or if you prefer JupyterLab:
```bash
uv run jupyter lab
```

## Step 5: Select the Stata Kernel

1. Navigate to `session_1/notebooks/01_arma_unit_roots.ipynb`
2. Open the notebook
3. In the top-right corner, you should see "Kernel: Python 3" or similar
4. Click on it and select "Stata" from the kernel dropdown menu
5. If "Stata" doesn't appear, verify the kernel was installed correctly:
   ```bash
   jupyter kernelspec list
   ```
   You should see `stata` in the list.

## Step 6: Run the Notebook Cells

Once the Stata kernel is selected:

1. **Run cells sequentially**: Click on each cell and press `Shift + Enter` to execute
2. **Run all cells**: Go to `Cell` → `Run All`
3. **Run from top**: Go to `Cell` → `Run All Above`

**Note**: Some cells in the notebook have commented-out lines (lines starting with `*`). These are meant to be uncommented when you have the actual data files.

## Running Standalone Stata .do Files

You can also run Stata `.do` files directly from the command line (terminal) without using Jupyter notebooks. This is useful for batch processing or when you want to run scripts non-interactively.

### Method 1: Using Full Path to Stata (Recommended if Stata is not in PATH)

If Stata is not in your PATH (or if you haven't completed Step 3), use the full path to the Stata executable:

```bash
# Navigate to the scripts directory
cd session_1/scripts

# Run the .do file using full path (batch mode, non-interactive)
/Applications/Stata/StataMP.app/Contents/MacOS/stata-mp -b do 00_data_cleaning.do
```

**Note**: The script `00_data_cleaning.do` changes directory at the beginning (`cd "../.."`), so it expects to be run from `session_1/scripts/` to properly navigate to the project root.

### Method 2: Using Stata from PATH (If Step 3 was completed)

If you've added Stata to your PATH (Step 3), you can use the shorter command:

```bash
# Navigate to the scripts directory
cd session_1/scripts

# Run the .do file (batch mode, non-interactive)
stata-mp -b do 00_data_cleaning.do
```

**Note**: If you get a "command not found" error, use Method 1 instead (full path), or make sure you've completed Step 3 and restarted your terminal.

### Command Options

- `-b` flag: Runs Stata in batch mode (non-interactive, no GUI)
- The output will be saved to a `.log` file (e.g., `00_data_cleaning.log`) in the same directory
- You can view the log file to see the results and any errors

### Running from Cursor's Integrated Terminal

You can run these commands directly in Cursor's integrated terminal:
1. Open the terminal in Cursor (`Ctrl+`` ` or `View → Terminal`)
2. Navigate to the scripts directory
3. Run the command using Method 1 (full path) or Method 2 (if PATH is set)

## Troubleshooting

### Problem: "Stata kernel not found" when opening notebook

**Solution**:
```bash
# Reinstall the kernel
uv run python -m stata_kernel.install
```

### Problem: Stata commands fail with "command not found"

**Solution**: Make sure Stata is in your PATH or the kernel is configured with the correct Stata executable path.

### Problem: "No data file found" errors

**Solution**: The notebook expects data files in `data/processed/`. You may need to:
1. Download/prepare the data files (see `data/data_sources.md`)
2. Uncomment the `use` commands in the notebook
3. Comment out or modify commands that require data until you have it

### Problem: Kernel dies or notebook crashes

**Solution**:
1. Check Stata license is valid
2. Verify Stata executable path in kernel configuration
3. Try restarting Jupyter

### Problem: Can't find the Stata executable

**Solution**:
```bash
# Find all Stata executables
find /Applications -name "stata*" -type f 2>/dev/null
```

## Quick Start Commands Summary

```bash
# 1. Navigate to project
cd /Users/jesusvillotamiranda/Library/CloudStorage/OneDrive-UniversidaddeLaRioja/GitHub/Repository/TA_Time_Series_Methods

# 2. Install packages (creates .venv automatically)
uv sync

# 3. Install Stata kernel
uv run python -m stata_kernel.install

# 4. Launch Jupyter
uv run jupyter notebook
# or
uv run jupyter lab
```

## Next Steps

Once everything is set up:
1. Open `session_1/notebooks/01_arma_unit_roots.ipynb`
2. Select the Stata kernel
3. Start running cells!
4. Refer to `references/stata_cheatsheet.md` for Stata command reference
5. Check `references/common_pitfalls.md` if you encounter issues

---

**Note**: The first time you run Stata commands, it may take a moment to initialize. Subsequent commands will be faster.
