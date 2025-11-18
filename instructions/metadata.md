# Data Download Metadata

**Download Date:** November 15, 2025  
**Download Status:** Complete

This document provides metadata for all time series data downloaded for the empirical applications in the Time Series Methods course.

---

## 1. US Financial and Economic Data (FRED)

### 1.1 Stock Market Data

| File | Series ID | Description | Frequency | Start Date | End Date | Source |
|------|-----------|-------------|-----------|------------|----------|--------|
| `SP500.csv` | SP500 | S&P 500 Index | Daily | 2015-11-04 | 2025-11-03 | FRED |
| `VIXCLS.csv` | VIXCLS | CBOE Volatility Index (VIX) | Daily | 1990-01-02 | 2025-11-13 | FRED/CBOE |

**Note:** SP500.csv is present in the raw data folder but is NOT used in the empirical_applications.do script. The file has a limited date range (2015-2025) compared to what might be expected, and none of the 29 exercises require SP500 data.

### 1.2 Treasury Yields

| File | Series ID | Description | Frequency | Start Date | End Date | Source |
|------|-----------|-------------|-----------|------------|----------|--------|
| `GS10.csv` | GS10 | 10-Year Treasury Constant Maturity Rate | Daily | 1990-01-02 | 2025-11-13 | FRED |
| `DGS2.csv` | DGS2 | 2-Year Treasury Constant Maturity Rate | Daily | 1990-01-02 | 2025-11-13 | FRED |
| `DGS5.csv` | DGS5 | 5-Year Treasury Constant Maturity Rate | Daily | 1990-01-02 | 2025-11-13 | FRED |
| `DGS30.csv` | DGS30 | 30-Year Treasury Constant Maturity Rate | Daily | 1990-01-02 | 2025-11-13 | FRED |

### 1.3 Macroeconomic Data

| File | Series ID | Description | Frequency | Start Date | End Date | Source |
|------|-----------|-------------|-----------|------------|----------|--------|
| `GDPC1.csv` | GDPC1 | Real Gross Domestic Product | Quarterly | 1990-Q1 | 2025-Q3 | FRED/BEA |
| `CPIAUCSL.csv` | CPIAUCSL | Consumer Price Index for All Urban Consumers | Monthly | 1990-01 | 2025-10 | FRED/BLS |
| `FEDFUNDS.csv` | FEDFUNDS | Federal Funds Effective Rate | Monthly | 1990-01 | 2025-10 | FRED |
| `UNRATE.csv` | UNRATE | Unemployment Rate | Monthly | 1990-01 | 2025-10 | FRED/BLS |

### 1.4 State Unemployment Rates

| File | Series ID | Description | Frequency | Start Date | End Date | Source |
|------|-----------|-------------|-----------|------------|----------|--------|
| `CAUR.csv` | CAUR | California Unemployment Rate | Monthly | 1976-01 | 2025-10 | FRED/BLS |
| `TXUR.csv` | TXUR | Texas Unemployment Rate | Monthly | 1976-01 | 2025-10 | FRED/BLS |

### 1.5 Exchange Rates

| File | Series ID | Description | Frequency | Start Date | End Date | Source |
|------|-----------|-------------|-----------|------------|----------|--------|
| `DEXUSEU.csv` | DEXUSEU | US Dollar to Euro Exchange Rate | Daily | 1999-01-04 | 2025-10-31 | FRED |

---

## 2. European Financial Data

### 2.1 Stock Market Indices (Yahoo Finance)

| File | Ticker | Description | Frequency | Start Date | End Date | Observations | Source |
|------|--------|-------------|-----------|------------|----------|--------------|--------|
| `IBEX35.csv` | ^IBEX | IBEX 35 (Spain) | Daily | 1993-07-12 | 2025-11-14 | 8,197 | Yahoo Finance |
| `CAC40.csv` | ^FCHI | CAC 40 (France) | Daily | 1990-03-01 | 2025-11-14 | 9,070 | Yahoo Finance |
| `DAX.csv` | ^GDAXI | DAX (Germany) | Daily | 1990-01-02 | 2025-11-14 | 9,078 | Yahoo Finance |
| `FTSEMIB.csv` | FTSEMIB.MI | FTSE MIB (Italy) | Daily | 1997-12-31 | 2025-11-14 | 7,123 | Yahoo Finance |

**Note:** Yahoo Finance data has a 3-row header structure:
- Row 1: Column names (Price, Close, High, Low, Open, Volume)
- Row 2: Ticker symbols (^IBEX, ^FCHI, ^GDAXI, FTSEMIB.MI)
- Row 3: "Date" label with empty cells
- Row 4+: Actual data starting with dates in YYYY-MM-DD format

The data includes columns: Date, Open, High, Low, Close, Adj Close, Volume. The Stata script uses `rowrange(4)` to skip the header rows.

### 2.2 Government Bond Yields (10-Year)

| File | Series ID | Country | Frequency | Start Date | End Date | Source |
|------|-----------|---------|-----------|------------|----------|--------|
| `BOND_10Y_DE.csv` | IRLTLT01DEM156N | Germany | Monthly | 1990-01 | 2025-09 | FRED/OECD |
| `BOND_10Y_FR.csv` | IRLTLT01FRM156N | France | Monthly | 1990-01 | 2025-09 | FRED/OECD |
| `BOND_10Y_IT.csv` | IRLTLT01ITM156N | Italy | Monthly | 1991-03 | 2025-09 | FRED/OECD |
| `BOND_10Y_ES.csv` | IRLTLT01ESM156N | Spain | Monthly | 1990-01 | 2025-09 | FRED/OECD |
| `BOND_10Y_PT.csv` | IRLTLT01PTM156N | Portugal | Monthly | 1993-07 | 2025-09 | FRED/OECD |
| `BOND_10Y_GR.csv` | IRLTLT01GRM156N | Greece | Monthly | 1997-06 | 2025-09 | FRED/OECD |
| `BOND_10Y_IE.csv` | IRLTLT01IEM156N | Ireland | Monthly | 1990-01 | 2025-09 | FRED/OECD |

---

## 3. Spanish Macroeconomic Data

### 3.1 National Indicators

| File | Series ID | Description | Frequency | Start Date | End Date | Source |
|------|-----------|-------------|-----------|------------|----------|--------|
| `ESP_GDP.csv` | CPMNACSCAB1GQES | Spain Real GDP (Level) | Quarterly | 1995-Q1 | 2025-Q3 | FRED/OECD |
| `ESP_CPI.csv` | ESPCPIALLMINMEI | Spain Consumer Price Index | Monthly | 1990-01 | 2025-03 | FRED/OECD |
| `ESP_CREDIT.csv` | QESN628BIS | Spain Credit to Non-Financial Sector | Quarterly | 1990-Q1 | 2025-Q2 | FRED/BIS |
| `ESP_UNEMP.csv` | LRHUTTTTESQ156S | Spain Unemployment Rate | Quarterly | 1986-Q2 | 2025-Q2 | FRED/OECD |

### 3.2 Regional Data

**Note:** Regional unemployment data for Madrid and Catalonia should be downloaded manually from:
- **INE (Instituto Nacional de Estadística):** https://www.ine.es/
- Navigate to: Labor Market Statistics > EPA (Labor Force Survey) > Regional Data
- Required series: Quarterly unemployment rates (1976-2025) for:
  - Comunidad de Madrid
  - Cataluña

**Workaround:** In the empirical applications script, California and Texas unemployment rates (CAUR.csv, TXUR.csv) are used as substitutes for Madrid and Catalonia data when regional Spanish data is not available.

### 3.3 Variable Name Mapping

The following table maps CSV files to Stata variable names used in the empirical applications script:

| File | Series ID | Stata Variable | Description | Transformation |
|------|-----------|----------------|-------------|----------------|
| ESP_GDP.csv | CPMNACSCAB1GQES | `gdp_esp` | Spain Real GDP (Level) | - |
| | | `dgdp` | Spain Real GDP Growth Rate (YoY %) | `dgdp = 100 * (log_gdp - L4.log_gdp)` |
| ESP_UNEMP.csv | LRHUTTTTESQ156S | `unemp_esp` | Spain Unemployment Rate (%) | - |
| ESP_CREDIT.csv | QESN628BIS | `credit_esp` | Spain Credit to Non-Financial Sector (Level) | - |
| | | `dcredit` | Spain Credit Growth Rate (YoY %) | `dcredit = 100 * (log_credit - L4.log_credit)` |

**Note:** Growth rates are computed as year-over-year percentage changes from log levels using 4-period lags (L4) for quarterly data.

---

## 4. Data Processing Notes

### 4.1 File Format
All CSV files follow FRED/Yahoo Finance standard format:
- **FRED files:** Two columns (`observation_date`, `VALUE`) where the first column is named `observation_date` and contains dates, and the second column contains the series values (named with the Series ID)
- **Yahoo Finance files:** Seven columns (Date, Open, High, Low, Close, Adj Close, Volume)

### 4.2 Date Formats
- **FRED daily:** YYYY-MM-DD
- **FRED monthly:** YYYY-MM-DD (first day of month)
- **FRED quarterly:** YYYY-MM-DD (first day of quarter)
- **Yahoo Finance:** YYYY-MM-DD

### 4.3 Missing Values
- FRED uses "." for missing values
- Yahoo Finance uses "null" or omits rows

### 4.4 Frequencies
- **Daily:** Stock indices, VIX, Treasury yields, EUR/USD
- **Monthly:** CPI, unemployment rates, Fed Funds rate, bond yields
- **Quarterly:** GDP, credit data, Spanish unemployment (ESP_UNEMP.csv)

---

## 5. Suggested Data Transformations

### 5.1 For ARMA/Unit Root Analysis
- Compute log returns for stock indices: `ret = diff(log(Close))`
- Compute first differences for interest rates: `diff(rate)`
- Seasonally adjust quarterly data if needed

### 5.2 For VAR/Cointegration
- All variables should be in same frequency (monthly or quarterly)
- Use end-of-month values for daily data
- Consider log transformations for levels

### 5.3 For GARCH/Volatility
- Daily log returns: `ret = 100 * diff(log(price))`
- Squared returns for volatility proxy: `ret^2`
- Overnight return calculations if needed

### 5.4 For Copulas/Dependence
- Standardized returns (mean 0, variance 1)
- Empirical CDF transformation for copula estimation
- Consider time-varying correlation (DCC framework)

---

## 6. Data Quality and Status

### 6.1 Data Loading Status

**Successfully Loaded Data Files:**

**Spanish Data:**
- ESP_GDP.csv (Quarterly, 1995-Q1 to 2025-Q3)
- ESP_UNEMP.csv (Quarterly, 1986-Q2 to 2025-Q2)
- ESP_CPI.csv (Monthly, 1990-01 to 2025-03)
- ESP_CREDIT.csv (Quarterly, 1990-Q1 to 2025-Q2)

**Stock Indices (Yahoo Finance):**
- IBEX35.csv (Daily, 1993-07-12 to 2025-11-14)
- CAC40.csv (Daily, 1990-03-01 to 2025-11-14)
- DAX.csv (Daily, 1990-01-02 to 2025-11-14)
- FTSEMIB.csv (Daily, 1997-12-31 to 2025-11-14)

**Bond Yields (FRED/OECD):**
- BOND_10Y_DE.csv (Monthly, 1990-01 to 2025-09)
- BOND_10Y_ES.csv (Monthly, 1990-01 to 2025-09)
- BOND_10Y_FR.csv (Monthly, 1990-01 to 2025-09)
- BOND_10Y_IT.csv (Monthly, 1991-03 to 2025-09)
- BOND_10Y_PT.csv (Monthly, 1993-07 to 2025-09)
- BOND_10Y_GR.csv (Monthly, 1997-06 to 2025-09)
- BOND_10Y_IE.csv (Monthly, 1990-01 to 2025-09)

**US Data:**
- VIXCLS.csv (Daily, 1990-01-02 to 2025-11-13)
- CAUR.csv (Monthly, 1976-01 to 2025-08)
- TXUR.csv (Monthly, 1976-01 to 2025-08)

### 6.2 Missing Data Files

**Documented Missing Data:**
- Madrid unemployment rate (quarterly, 1976-2025) - Manual download from INE required
- Catalonia unemployment rate (quarterly, 1976-2025) - Manual download from INE required
- OIS rates (27 series, different maturities) - Not available

**Workarounds:**
- Exercise 9: Uses California/Texas unemployment (CAUR.csv, TXUR.csv) as substitute for Madrid/Catalonia
- Exercise 24: Skipped with explanatory note (OIS rate data not available)

### 6.3 Known Issues and Limitations

1. **SP500.csv:**
   - File exists in raw data folder but is NOT used in the empirical_applications.do script
   - Date range: 2015-11-04 to 2025-11-03 (doesn't match documented range)
   - Not required for any of the 29 exercises

2. **Exercise 24 (OIS Rates PCA):**
   - Data not available in raw data folder
   - Exercise is skipped with explanatory note
   - Would require 27 OIS rate series for different maturities

3. **Exercise 29 (Copula Contour Plots):**
   - Contour plots require specialized commands or external tools (R/Python)
   - Exercise is marked as "completed (plotting requires additional tools)"
   - Would require packages like 'copula' in R or visualization libraries in Python

4. **Exercise 9 (Cointegration):**
   - Original slides use Madrid and Catalonia unemployment data
   - Implementation uses California and Texas as substitute
   - Properly documented in script comments

### 6.4 Date Coverage
- Most series start: 1990 or earlier
- All series end: November 2025
- Sufficient observations for all empirical applications

### 6.5 Data Sources Hierarchy
- **Primary:** Federal Reserve Economic Data (FRED)
- **Secondary:** Yahoo Finance (stock indices), OECD (international data)
- **Tertiary:** BIS (credit data), CBOE (VIX)

---

## 7. Citation Requirements

When using this data, please cite:

- **FRED:** Federal Reserve Bank of St. Louis, Economic Data, https://fred.stlouisfed.org/
- **CBOE VIX:** © 2016 Chicago Board Options Exchange, Inc. (Reprinted with permission)
- **Yahoo Finance:** Yahoo Finance, https://finance.yahoo.com/
- **OECD:** OECD (2025), OECD Statistics, https://stats.oecd.org/
- **BIS:** Bank for International Settlements, https://www.bis.org/statistics/

---