# Data Sources Documentation

This document provides information about all datasets used in the practical sessions for the Methods for Time Series course.

## Overview

All datasets are real financial and economic data from publicly available sources. Data is typically downloaded for a 20-30 year period to ensure sufficient observations for time series analysis.

## Datasets by Topic

### Topic 1: ARMA and Unit Roots

#### Dataset 1: S&P 500 Index Returns
- **Source**: Yahoo Finance / FRED (Federal Reserve Economic Data)
- **Series**: S&P 500 Index (^GSPC or SP500)
- **Frequency**: Daily
- **Period**: 2000-01-01 to 2024-12-31 (or most recent)
- **Variables**:
  - `date`: Date
  - `sp500_close`: Closing price
  - `sp500_return`: Log returns (first difference of log prices)
- **Usage**: ARMA modeling of stock returns
- **Download Instructions**:
  - Via Stata: Use `freduse SP500, clear` (if FRED API key configured)
  - Via Yahoo Finance: Use `import fred` or download CSV from finance.yahoo.com
  - Manual download: https://fred.stlouisfed.org/series/SP500

#### Dataset 2: EUR/USD Exchange Rate
- **Source**: FRED / ECB Statistical Data Warehouse
- **Series**: EUR/USD exchange rate
- **Frequency**: Daily
- **Period**: 1999-01-01 to 2024-12-31
- **Variables**:
  - `date`: Date
  - `eurusd`: EUR/USD exchange rate (units of USD per EUR)
  - `lneurusd`: Natural log of exchange rate
  - `d_lneurusd`: First difference (returns)
- **Usage**: Unit root testing (exchange rates are classic example)
- **Download Instructions**:
  - FRED: `DEXUSEU` series
  - ECB: https://sdw.ecb.europa.eu/browse.do?node=2018794
  - Manual: https://fred.stlouisfed.org/series/DEXUSEU

### Topic 2: VAR and Cointegration

#### Dataset 3: Macro-Finance Variables
- **Source**: FRED / OECD / Banco de España
- **Series**: Multiple series for VAR analysis
- **Frequency**: Monthly or Quarterly
- **Period**: 1990-01 to 2024-12
- **Variables**:
  - `date`: Date
  - `gdp`: Real GDP (log or growth rate)
  - `inflation`: CPI inflation rate (year-over-year %)
  - `interest_rate`: Policy interest rate or 10-year bond yield
  - `stock_index`: Stock market index (log returns)
  - `unemployment`: Unemployment rate
- **Usage**: VAR modeling, Granger causality, cointegration, impulse responses
- **Download Instructions**:
  - FRED codes: GDPC1 (Real GDP), CPIAUCSL (CPI), FEDFUNDS (Fed Funds Rate), UNRATE (Unemployment)
  - Spanish data: Banco de España (if focusing on Spanish financial sector)
  - Use `freduse` command in Stata or download from FRED website

### Topic 3: State Space and Kalman Filter

#### Dataset 4: Multiple Stock Returns (Factor Model)
- **Source**: Yahoo Finance / CRSP
- **Series**: Returns on multiple stocks or sectors
- **Frequency**: Daily
- **Period**: 2010-01-01 to 2024-12-31
- **Variables**:
  - `date`: Date
  - `stock1_return`, `stock2_return`, ..., `stockN_return`: Returns on N stocks
  - Market index return (for factor model)
- **Usage**: Dynamic factor models, extracting common factors
- **Download Instructions**:
  - Use Yahoo Finance API or `import fred` for sector indices
  - Example stocks: Apple (AAPL), Microsoft (MSFT), Google (GOOGL), Amazon (AMZN)
  - Or use sector ETFs for cleaner factor structure

#### Dataset 5: Time-Varying Beta
- **Source**: Yahoo Finance
- **Series**: Stock returns and market returns
- **Frequency**: Daily
- **Period**: 2015-01-01 to 2024-12-31
- **Variables**:
  - `date`: Date
  - `stock_return`: Individual stock returns
  - `market_return`: Market portfolio returns (S&P 500)
- **Usage**: Estimating time-varying beta using Kalman filter
- **Download Instructions**:
  - Same as above, focus on one stock vs market

### Topic 4: GARCH and Volatility

#### Dataset 6: High-Frequency Financial Returns
- **Source**: Yahoo Finance / FRED
- **Series**: Stock index returns, FX returns, or commodity returns
- **Frequency**: Daily
- **Period**: 2000-01-01 to 2024-12-31
- **Variables**:
  - `date`: Date
  - `returns`: Daily returns (log differences)
  - `volatility`: Realized volatility (if available)
- **Usage**: GARCH modeling, volatility forecasting
- **Download Instructions**:
  - Use same data as Topic 1 (S&P 500 returns) or FX returns
  - Add: Oil prices (CL=F), Gold (GC=F), Bitcoin (BTC-USD) for interesting volatility patterns

#### Dataset 7: Portfolio Returns (Multivariate GARCH)
- **Source**: Yahoo Finance
- **Series**: Returns on multiple assets (stocks, bonds, commodities)
- **Frequency**: Daily
- **Period**: 2010-01-01 to 2024-12-31
- **Variables**:
  - `date`: Date
  - `stock_return`: Stock index returns
  - `bond_return`: Bond index returns (e.g., 10-year Treasury)
  - `commodity_return`: Commodity index returns
  - `fx_return`: Currency returns
- **Usage**: Multivariate GARCH (BEKK, DCC), dynamic correlations
- **Download Instructions**:
  - Stock: S&P 500 (^GSPC)
  - Bond: 10-year Treasury (^TNX) or Bond ETF
  - Commodity: GSCI or CRB Index
  - FX: EUR/USD returns

### Topic 5: Extreme Values and Copulas

#### Dataset 8: Financial Crisis Period Data
- **Source**: FRED / Yahoo Finance
- **Series**: Stock returns during crisis periods
- **Frequency**: Daily
- **Period**: 2007-01-01 to 2009-12-31 (Financial Crisis)
  - Extended: 2020-01-01 to 2020-12-31 (COVID-19)
- **Variables**:
  - `date`: Date
  - `returns`: Extreme returns (tail events)
  - Multiple series for copula analysis
- **Usage**: Extreme value theory, VaR/CVaR, copula modeling
- **Download Instructions**:
  - Focus on crisis periods for extreme events
  - Use same stock/FX data but filter to crisis dates
  - Add: VIX (volatility index) for stress testing

## Data Processing Notes

### Common Transformations

1. **Returns Calculation**:
   ```stata
   gen log_price = ln(price)
   gen returns = D.log_price  // First difference of logs
   ```

2. **Date Formatting**:
   ```stata
   gen date_numeric = date(date_string, "YMD")
   format date_numeric %td
   tsset date_numeric
   ```

3. **Handling Missing Values**:
   - Financial markets have holidays/weekends
   - Use calendar alignment or interpolate if needed
   - Document any imputation methods

### Data Quality Checks

- Check for outliers (data errors vs true extreme events)
- Verify date alignment across series
- Handle corporate actions (splits, dividends) for stock data
- Check for structural breaks (document if found)

## Data Files Location

- **Raw data**: `data/raw/` - Original downloaded files
- **Processed data**: `data/processed/` - Cleaned, formatted data ready for analysis
- Each processed dataset should have a `.dta` file with clear variable labels

## Replication Instructions

To replicate the analyses:

1. Download data from sources listed above
2. Save raw files in `data/raw/`
3. Run data preparation scripts (to be created) to generate processed data
4. Processed data will be saved in `data/processed/`

## Notes

- All data is publicly available; no proprietary datasets are used
- Data downloads may require API keys (FRED) or manual downloads
- Dates should be updated when new data becomes available
- Students may need to adjust download dates based on data availability at their institution

## Future Additions

If you have access to additional datasets (e.g., Banco de España data, proprietary financial data), please document them here and add to the repository.

---

**Last Updated**: November 2025
