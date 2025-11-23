# Data Download Guide for Time Series Course

This directory contains the LaTeX source files for the data download guide that helps students download all required time series data for the "Methods for Time Series" course at CEMFI.

## Files

- `main.tex` - The main LaTeX document containing the complete data download guide
- `Makefile` - Helper file for compiling the LaTeX document
- `README.md` - This file

## Compiling the Guide

To compile the LaTeX document to PDF:

### Option 1: Using Make (Recommended)
```bash
cd /path/to/data_instalation_guide
make
```

### Option 2: Using pdflatex directly
```bash
cd /path/to/data_instalation_guide
pdflatex main.tex
pdflatex main.tex  # Run twice for proper cross-references
```

### Option 3: Using Overleaf
You can also upload the `main.tex` file to [Overleaf](https://www.overleaf.com) and compile it online.

## Viewing the PDF

After compilation, you'll find `data_instalation_guide.pdf` in the same directory.

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
- booktabs
- array
- float

If you encounter missing packages, you can install them using your LaTeX package manager (e.g., `tlmgr install <package>` for TeX Live).

## Content

The data download guide covers:

1. **US Financial and Economic Data** - Downloading from FRED (Federal Reserve Economic Data)
   - Macroeconomic indicators (GDP, CPI, Fed Funds Rate, Unemployment)
   - Treasury yields (2Y, 5Y, 10Y, 30Y)
   - Financial market data (VIX, Exchange rates)
   - State unemployment rates

2. **European Stock Market Indices** - Downloading from Yahoo Finance
   - IBEX 35 (Spain)
   - CAC 40 (France)
   - DAX (Germany)
   - FTSE MIB (Italy)

3. **European Sovereign Bond Yields** - 10-year government bonds for Eurozone countries
   - Germany, France, Italy, Spain, Portugal, Greece, Ireland

4. **Spanish Macroeconomic Data** - Spanish economic indicators
   - GDP, CPI, Credit, Unemployment

5. **Download Workflow** - Step-by-step process to efficiently download all required data

6. **Troubleshooting** - Solutions to common download issues

The guide is designed to be comprehensive and beginner-friendly, with detailed instructions for each data source and file format requirements.

## Data Storage

All downloaded data should be saved to the `data/raw/` folder in the project root. The course processing scripts will clean and prepare the data, saving processed versions to `data/processed/`.

