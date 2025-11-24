# TA Sessions: Methods for Time Series

**Teaching Assistant Repository for CEMFI Advanced Training School**

Course: [Methods for Time Series](https://www.cemfi.es/programs/cat/course.asp?cu=32)  
Instructor: Enrique Sentana, CEMFI  
Dates: 24-28 November 2025  
Practical Sessions: Tuesday and Thursday, 19:30-20:30

## Overview

This repository contains comprehensive practical materials for the "Methods for Time Series" course at CEMFI. The course covers econometric techniques commonly used in financial markets, with applications to economic forecasting, portfolio management, financial consulting, and risk control.

## Course Topics

1. **Univariate linear time series models**: ARMA and unit roots
2. **Multivariate linear time series models**: VAR, cointegration, and impulse-response analysis
3. **Linear state space models**: Kalman filter, dynamic factor models
4. **Volatility and correlation**: GARCH and stochastic volatility, principal components, and other covariance structures
5. **Beyond second moments**: extreme values, copulas, and nonlinear dependence

## Repository Structure

**Note**: This structure only includes non-gitignored files and directories. Some directories may exist locally but are excluded from version control. See `.gitignore` for the complete exclusion list.

```
TA_Time_Series_Methods/
├── README.md                          # This file
├── SETUP_GUIDE.md                     # Setup instructions
├── pyproject.toml                     # Python project configuration
├── uv.lock                            # Dependency lock file
├── data/                              # Financial datasets
│   ├── raw/                          # Original data files
│   └── processed/                    # Cleaned data ready for analysis
├── notebooks/                         # Practical session materials
│   ├── session_1/                    # Tuesday session materials
│   │   ├── 1_1_simul_univariate.ipynb
│   │   ├── 1_2_data_cleaning.ipynb
│   │   ├── 1_3_stationarity_unit_roots.ipynb
│   │   └── 1_4_arma_models.ipynb
│   ├── session_2/                     # Thursday session materials
│   │   ├── 2_1_simul_multivariate.ipynb
│   │   ├── 2_2_simul_kalman.ipynb
│   │   ├── 2_3_simul_gdp_gdi.ipynb
│   │   └── 2_4_volatility.ipynb
│   ├── notebook_styles.css           # Notebook styling
│   └── README.md                      # Notebooks documentation
├── dofiles/                           # Stata .do files and outputs
│   └── empirical_applications.do     # Comprehensive Stata script
└── guides/                            # Setup and data guides
    ├── data_download_guide.pdf
    └── installation_guide.pdf
```

## Software Requirements

### Stata
- Stata version 14 or higher recommended
- Required user-written packages will be listed in each notebook/script

### Jupyter Notebook (Optional)
- Python 3.7+
- Jupyter Notebook or JupyterLab
- Stata kernel for Jupyter (for running notebooks)
  - Installation: `pip install stata_kernel`
  - Configure: `python -m stata_kernel.install`

### Required Stata Packages
You may need to install additional packages. Run:
```stata
ssc install estout, replace
ssc install asdoc, replace
```

Some topics may require specialized packages which will be noted in the respective materials.

## Quick Start

### Option 1: Using Jupyter Notebooks (Recommended for Learning)

1. Ensure you have Jupyter and Stata kernel installed
2. Navigate to the session folder (e.g., `notebooks/session_1/`)
3. Open the notebook file (`.ipynb`)
4. Follow the narrative and execute cells step-by-step

### Option 2: Using Standalone Stata Scripts

1. Open Stata
2. Navigate to the dofiles folder (e.g., `dofiles/`)
3. Open and run the `.do` file
4. Review comments and output

## Session Schedule

### Session 1 (Tuesday, Nov 26, 19:30-20:30)

**Topics Covered:**
- Univariate time series model simulations
- Data loading and preparation
- Stationarity and unit root tests
- ARMA models

**Materials:**
- `notebooks/session_1/1_1_simul_univariate.ipynb` - Univariate simulations
- `notebooks/session_1/1_2_data_cleaning.ipynb` - Data preparation
- `notebooks/session_1/1_3_stationarity_unit_roots.ipynb` - Unit root tests
- `notebooks/session_1/1_4_arma_models.ipynb` - ARMA modeling
- Stata scripts available in `dofiles/`

### Session 2 (Thursday, Nov 28, 19:30-20:30)

**Topics Covered:**
- Multivariate time series simulations
- State space models and Kalman filtering
- GDP/GDI simulations
- Volatility modeling

**Materials:**
- `notebooks/session_2/2_1_simul_multivariate.ipynb` - Multivariate simulations
- `notebooks/session_2/2_2_simul_kalman.ipynb` - Kalman filter
- `notebooks/session_2/2_3_simul_gdp_gdi.ipynb` - GDP/GDI analysis
- `notebooks/session_2/2_4_volatility.ipynb` - Volatility models
- Stata scripts available in `dofiles/`

## Data

Data files are stored in:
- `data/raw/`: Original downloaded data
- `data/processed/`: Cleaned and formatted data ready for analysis

If you need to download data yourself, see the guides in the `guides/` folder for instructions.

## Reference Materials

Setup and data download guides are available in the `guides/` folder:
- **data_download_guide.pdf**: Instructions for downloading and preparing data
- **installation_guide.pdf**: Software installation and setup instructions

## Exercises

Practice exercises are integrated into the notebooks. Additional empirical applications and exercises are available in:
- `dofiles/empirical_applications.do` - Comprehensive Stata script with 29 empirical exercises
- See `notebooks/README.md` for detailed documentation on the exercises

## Pedagogical Approach

Each topic follows this structure:

1. **Motivation**: Why this method matters in finance
2. **Brief Theory**: Key concepts and assumptions
3. **Data Preparation**: Loading and exploring financial data
4. **Implementation**: Step-by-step Stata commands
5. **Interpretation**: What the results mean
6. **Diagnostics**: How to check model adequacy
7. **Practical Tips**: Common issues and solutions
8. **Extensions**: Additional exercises for self-study

## Notes

- Materials are designed to be comprehensive references, not just live session materials
- All code is extensively commented
- Jupyter notebooks provide interactive learning with step-by-step explanations
- Stata `.do` files in `dofiles/` contain comprehensive empirical applications
- Students can work at their own pace and revisit materials as needed

## Contact

For questions about the practical sessions, contact the Teaching Assistant.

---

**Last Updated**: November 2025  
**Course Link**: https://www.cemfi.es/programs/cat/course.asp?cu=32
