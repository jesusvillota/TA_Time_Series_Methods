# Empirical Applications - Stata Script

## Overview

This folder contains the comprehensive Stata script that replicates all 29 empirical exercises from the Time Series Methods lecture slides.

## File Structure

- **`empirical_applications.do`** - Main Stata script with all exercises
- **`empirical_applications.log`** - Log file (generated when running the script)
- **`exercise*.png`** - Exported graphs (generated when running the script)

## Script Organization

The script is organized into the following sections:

### Section 0: Data Loading and Preparation
- Loads all raw CSV files from `../data/raw/`
- Handles both FRED format (observation_date, VALUE) and Yahoo Finance format (Date, OHLCV)
- Parses dates and converts to appropriate Stata formats (daily %td, monthly %tm, quarterly %tq)
- Creates standard transformations: returns, growth rates, spreads, inflation rates
- Creates temporary files for each dataset

### Part 1: Linear Time Series Models (9 exercises)
1. **Exercise 1**: Autocorrelation - Spanish data (GDP growth, IBEX-35 returns, sovereign spreads)
2. **Exercise 2**: Long-term sovereign spreads visualization
3. **Exercise 3**: Correlation between sovereign spreads across periods
4. **Exercise 4**: Autocorrelation with confidence intervals (ACF plots)
5. **Exercise 5**: Unit root tests for IBEX-35 (DF-GLS tests)
6. **Exercise 6**: Seasonality in Spanish inflation
7. **Exercise 7**: VIX index modeling (ARMA models, model selection, forecasting)
8. **Exercise 8**: VAR modeling (GDP and Credit, impulse response functions)
9. **Exercise 9**: Cointegration (unemployment rates, Johansen test, VECM)

### Part 2: Volatility Models (12 exercises)
10. **Exercise 10**: Returns vs squared returns persistence
11. **Exercise 11**: Volatility clustering visualization
12. **Exercise 12**: Leverage effect regression
13. **Exercise 13**: Non-normality (kernel density estimation)
14. **Exercise 14**: ARCH(1) model estimation and diagnostics
15. **Exercise 15**: ARCH(10) model estimation and diagnostics
16. **Exercise 16**: ARCH vs GARCH model comparison
17. **Exercise 17**: GARCH(1,1) model estimation and diagnostics
18. **Exercise 18**: Asymmetric GARCH (TARCH/GJR-GARCH)
19. **Exercise 19**: Extended model comparison
20. **Exercise 20**: Testing for Gaussianity (Jarque-Bera test)
21. **Exercise 21**: GARCH with Student t innovations

### Part 3: Multivariate Dependence (8 exercises)
22. **Exercise 22**: Time-varying correlations between Euro area stock indices
23. **Exercise 23**: Correlations between stock indices and sovereign bonds
24. **Exercise 24**: PCA on OIS rates (skipped - data not available)
25. **Exercise 25**: CCC-MGARCH model estimation
26. **Exercise 26**: DCC-MGARCH model estimation and comparison
27. **Exercise 27**: Asymmetric and tail dependence
28. **Exercise 28**: Copula analysis - CDF transforms
29. **Exercise 29**: Copula contour plots (requires additional tools)

### Part 4: Risk Management
- No empirical exercises (theoretical content only)

## How to Run

### Prerequisites
1. **Stata 15 or higher** (recommended for modern time series commands)
2. **Required Stata packages** (install if needed):
   ```stata
   ssc install dfgls
   ssc install varsoc
   ssc install varstable
   ssc install irf
   ```

### Running the Script

1. **Navigate to the Sessions folder:**
   ```bash
   cd /path/to/TA_Time_Series_Methods/Sessions
   ```

2. **Open Stata and run:**
   ```stata
   do empirical_applications.do
   ```

   Or from command line:
   ```bash
   stata -b do empirical_applications.do
   ```

### Expected Output

When you run the script, it will:
- Load and process all data from `../data/raw/`
- Display summary statistics and test results in the console
- Generate graphs (PNG files) for each exercise
- Create a log file (`empirical_applications.log`) with all output
- Display progress messages for each exercise

## Data Requirements

The script expects the following CSV files in `../data/raw/`:

### Stock Indices (Yahoo Finance format)
- `IBEX35.csv` - Spanish stock index
- `CAC40.csv` - French stock index
- `DAX.csv` - German stock index
- `FTSEMIB.csv` - Italian stock index
- `SP500.csv` - US stock index

### Bond Yields (FRED format, monthly)
- `BOND_10Y_DE.csv` - Germany 10-year bond
- `BOND_10Y_ES.csv` - Spain 10-year bond
- `BOND_10Y_FR.csv` - France 10-year bond
- `BOND_10Y_IT.csv` - Italy 10-year bond

### Macroeconomic Data (FRED format)
- `ESP_GDP.csv` - Spanish GDP growth (quarterly)
- `ESP_CPI.csv` - Spanish CPI (monthly)
- `ESP_CREDIT.csv` - Spanish credit data (quarterly)
- `ESP_UNEMP.csv` - Spanish unemployment (monthly)

### Volatility and Other Data
- `VIXCLS.csv` - VIX volatility index (daily)
- `CAUR.csv` - California unemployment (monthly)
- `TXUR.csv` - Texas unemployment (monthly)

## Notes and Limitations

### Data Not Available
- **Regional Spanish unemployment** (Madrid, Catalonia): Would need manual download from INE (Instituto Nacional de Estadística)
- **OIS rates**: Not available in raw data folder; Exercise 24 is skipped
- **Connecticut/Massachusetts unemployment**: Used California/Texas as proxy in Exercise 9

### Technical Considerations
1. **Date formats**: Script handles both FRED (observation_date) and Yahoo Finance (Date) formats
2. **Missing values**: Handled appropriately with `destring` and `force` options
3. **Time series gaps**: Financial data has gaps for weekends/holidays
4. **Memory**: Set to handle large datasets with `set maxvar 10000`

### Graph Exports
All graphs are exported as PNG files with descriptive names:
- `exercise1_*.png`
- `exercise2_*.png`
- etc.

### Customization
You can modify the script to:
- Change date ranges for specific analyses
- Add more diagnostic tests
- Export results to Excel or other formats
- Modify graph aesthetics

## Troubleshooting

### Common Issues

1. **"File not found" error**
   - Check that you're running from the Sessions folder
   - Verify all data files exist in `../data/raw/`

2. **"Command not found" error**
   - Install required packages (see Prerequisites)
   - Update Stata to version 15+

3. **Memory issues**
   - Increase Stata memory: `set mem 500m`
   - Or use: `set maxvar 32000`

4. **Date parsing errors**
   - Check CSV file formats match expected structure
   - Ensure no header rows are corrupted

## References

- **Data sources**: FRED (Federal Reserve Economic Data), Yahoo Finance, OECD
- **Lecture slides**: `../materials/empirical_applications.md`
- **Data metadata**: `../data/METADATA.md`

## Contact

For questions or issues, please contact the Teaching Assistant: Jesus Villota Miranda

---

**Last updated**: November 2025

