# Installation Guide for VS Code + Stata Kernel

This directory contains the LaTeX source files for the installation guide that helps students set up VS Code and Stata kernel for the "Methods for Time Series" course at CEMFI.

## Files

- `main.tex` - The main LaTeX document containing the complete installation guide
- `Makefile` - Helper file for compiling the LaTeX document
- `README.md` - This file

## Compiling the Guide

To compile the LaTeX document to PDF:

### Option 1: Using Make (Recommended)
```bash
cd /path/to/installation_guide
make
```

### Option 2: Using pdflatex directly
```bash
cd /path/to/installation_guide
pdflatex main.tex
pdflatex main.tex  # Run twice for proper cross-references
```

### Option 3: Using Overleaf
You can also upload the `main.tex` file to [Overleaf](https://www.overleaf.com) and compile it online.

## Viewing the PDF

After compilation, you'll find `installation_guide.pdf` in the same directory.

### On macOS:
```bash
make view
```

### On Linux:
```bash
make view-linux
```

### On Windows:
```bash
make view-windows
```

## Dependencies

The document uses standard LaTeX packages that should be available in most LaTeX distributions:
- geometry
- hyperref
- listings
- xcolor
- titling
- enumitem

If you encounter missing packages, you can install them using your LaTeX package manager (e.g., `tlmgr install <package>` for TeX Live).

## Content

The installation guide covers:

1. **Stata Installation** - Instructions for Windows, macOS, and Linux
2. **VS Code Setup** - Installing and configuring Visual Studio Code
3. **Python Environment** - Setting up UV and required Python packages
4. **Stata Kernel Configuration** - Installing and configuring the Jupyter Stata kernel
5. **Testing and Troubleshooting** - Verifying the setup and solving common issues

The guide is designed to be comprehensive and beginner-friendly, with step-by-step instructions for each operating system.
