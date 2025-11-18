# Data Files Needed - Upload Checklist

This document lists all the data files you need to upload to the `data/` folder for the course materials.

## File Organization

**Two locations for data:**
- `data/raw/` - Original downloaded files (CSV, Excel, etc.)
- `data/processed/` - Cleaned Stata .dta files ready for analysis

---

## 📁 Data Files by Topic

### **Topic 1: ARMA and Unit Roots**

#### ✅ Required Files:

1. **`data/processed/sp500_data.dta`** (or `sp500_returns.dta`)
   - **Source**: FRED (SP500) or Yahoo Finance (^GSPC)
   - **Period**: 2000-01-01 to 2024-12-31 (daily)
   - **Required variables**:
     - `date` (Stata date format)
     - `sp500_close` (closing prices)
     - `sp500_return` (log returns - can be created from prices)
   - **Usage**: ARMA modeling

2. **`data/processed/eurusd_data.dta`**
   - **Source**: FRED (DEXUSEU) or ECB
   - **Period**: 1999-01-01 to 2024-12-31 (daily)
   - **Required variables**:
     - `date` (Stata date format)
     - `eurusd` (EUR/USD exchange rate)
     - `lneurusd` (log exchange rate - can be created)
   - **Usage**: Unit root testing

---

### **Topic 2: VAR and Cointegration**

#### ✅ Required Files:

3. **`data/processed/macro_finance_data.dta`**
   - **Source**: FRED (multiple series) or OECD/Banco de España
   - **Period**: 1990-01 to 2024-12 (monthly or quarterly)
   - **Required variables**:
     - `date` (Stata date format)
     - `gdp` (Real GDP, or `gdp_growth` if already transformed)
     - `inflation` (CPI inflation rate, %)
     - `interest_rate` (Policy rate or 10-year bond yield)
     - `stock_index` (Stock market index, or `stock_return` if already transformed)
     - `unemployment` (Unemployment rate, %)
     - Optional: `consumption`, `investment` (for cointegration exercises)
   - **Usage**: VAR modeling, Granger causality, cointegration, VECM
   - **Note**: Variables should be stationary for VAR (use growth rates/returns)

**FRED Series Codes** (if downloading from FRED):
- GDPC1 (Real GDP)
- CPIAUCSL (CPI)
- FEDFUNDS (Fed Funds Rate) or GS10 (10-year Treasury)
- SP500 (Stock Index)
- UNRATE (Unemployment Rate)

---

### **Topic 3: State Space and Kalman Filter**

#### ✅ Required Files:

4. **`data/processed/gdp_data.dta`** (for trend/cycle decomposition)
   - **Source**: FRED (GDPC1)
   - **Period**: 1990-01 to 2024-12 (quarterly recommended)
   - **Required variables**:
     - `date`
     - `gdp` (Real GDP)
     - `lngdp` (log GDP - can be created)
   - **Usage**: Trend/cycle decomposition

5. **`data/processed/multi_stock_data.dta`** (for dynamic factor models)
   - **Source**: Yahoo Finance or FRED
   - **Period**: 2010-01-01 to 2024-12-31 (daily)
   - **Required variables**:
     - `date`
     - `stock1_return`, `stock2_return`, `stock3_return`, `stock4_return`, `stock5_return`
     - Optional: `market_return` (for comparison)
   - **Usage**: Dynamic factor models
   - **Note**: Can use individual stocks (AAPL, MSFT, GOOGL, AMZN, etc.) or sector ETFs

6. **`data/processed/stock_data.dta`** (for time-varying beta)
   - **Source**: Yahoo Finance
   - **Period**: 2015-01-01 to 2024-12-31 (daily)
   - **Required variables**:
     - `date`
     - `stock_return` (individual stock returns, e.g., Apple)
     - `market_return` (S&P 500 returns)
   - **Usage**: Time-varying beta estimation

---

### **Topic 4: GARCH and Volatility**

#### ✅ Required Files:

7. **`data/processed/returns_data.dta`**
   - **Can reuse**: Same as `sp500_data.dta` from Topic 1
   - **Or alternative**: FX returns, commodity returns
   - **Required variables**:
     - `date`
     - `returns` (daily log returns)
   - **Usage**: GARCH modeling, volatility forecasting
   - **Note**: Can be same as S&P 500 returns from Topic 1

8. **`data/processed/portfolio_returns.dta`** (for multivariate GARCH)
   - **Source**: Yahoo Finance / FRED
   - **Period**: 2010-01-01 to 2024-12-31 (daily)
   - **Required variables**:
     - `date`
     - `stock_return` (S&P 500 returns)
     - `bond_return` (10-year Treasury or bond ETF returns)
     - `commodity_return` (GSCI, CRB index, or oil/gold prices)
     - `fx_return` (EUR/USD returns - can reuse from Topic 1)
   - **Usage**: Multivariate GARCH (DCC, BEKK), dynamic correlations, portfolio volatility
   - **Note**: Minimum 2-3 assets required; 4 is recommended

---

### **Topic 5: Extreme Values and Copulas**

#### ✅ Required Files:

9. **`data/processed/crisis_returns.dta`** (for extreme values)
   - **Source**: Same as returns data but filtered to crisis periods
   - **Periods**:
     - 2007-01-01 to 2009-12-31 (Financial Crisis)
     - 2020-01-01 to 2020-12-31 (COVID-19) - optional
   - **Required variables**:
     - `date`
     - `returns` (extreme returns/losses)
   - **Usage**: Extreme value theory, VaR/CVaR, tail risk
   - **Note**: Can be created by filtering `returns_data.dta` to crisis dates

10. **`data/processed/multi_asset_returns.dta`** (for copulas)
    - **Can reuse**: Same as `portfolio_returns.dta` from Topic 4
    - **Required variables**:
      - `date`
      - Multiple return series (minimum 2, recommended 3-5)
    - **Usage**: Copula modeling, tail dependence

---

## 📋 Minimum Essential Files (If Limited Time/Resources)

If you can only upload a few files, prioritize these **3 essential files**:

1. **`sp500_data.dta`** - Used in Topics 1, 4, 5
2. **`macro_finance_data.dta`** - Used in Topic 2
3. **`portfolio_returns.dta`** - Used in Topics 3, 4, 5

With these three files, you can demonstrate most techniques (though some topics may have fewer examples).

---

## 📝 File Format Requirements

### Stata .dta Files (for `data/processed/`):

**Required structure:**
- Date variable must be Stata date format (`%td` for daily, `%tm` for monthly, `%tq` for quarterly)
- Use `tsset date` command works correctly
- Variable names should be clear and descriptive
- Include variable labels: `label var date "Date"`
- Missing values handled appropriately

**Example Stata code to prepare data:**
```stata
* Load raw data
import delimited "../raw/sp500.csv", clear

* Convert date
gen date_numeric = date(date_string, "YMD")
format date_numeric %td
drop date_string
rename date_numeric date

* Create returns
gen log_price = ln(close)
gen sp500_return = D.log_price

* Label variables
label var date "Date"
label var sp500_return "S&P 500 Log Returns"

* Set time series
tsset date

* Save processed data
save "../processed/sp500_data.dta", replace
```

---

## 🔄 Data Reuse Opportunities

Many datasets can be reused across topics:

- **S&P 500 returns** → Topics 1, 4, 5
- **EUR/USD** → Topics 1, 4, 5
- **Portfolio returns** → Topics 3, 4, 5
- **Macro data** → Topic 2 (can also use GDP for Topic 3)

**Recommendation**: Start with the essential files and expand as needed.

---

## 📥 Download Sources Quick Reference

### FRED (Federal Reserve Economic Data)
- Website: https://fred.stlouisfed.org/
- Stata command: `freduse SERIES_CODE, clear` (requires API key)
- Or: Download CSV manually

### Yahoo Finance
- Website: https://finance.yahoo.com/
- Download CSV or use API
- Ticker symbols: ^GSPC (S&P 500), ^TNX (10-year Treasury), etc.

### ECB Statistical Data Warehouse
- Website: https://sdw.ecb.europa.eu/
- For European data (EUR/USD, European macro)

---

## ✅ Checklist Summary

### Essential Files (Minimum):
- [ ] `data/processed/sp500_data.dta`
- [ ] `data/processed/macro_finance_data.dta`
- [ ] `data/processed/portfolio_returns.dta`

### Complete Set (All Topics):
- [ ] `data/processed/sp500_data.dta` (Topic 1, 4, 5)
- [ ] `data/processed/eurusd_data.dta` (Topic 1)
- [ ] `data/processed/macro_finance_data.dta` (Topic 2)
- [ ] `data/processed/gdp_data.dta` (Topic 3)
- [ ] `data/processed/multi_stock_data.dta` (Topic 3)
- [ ] `data/processed/stock_data.dta` (Topic 3)
- [ ] `data/processed/returns_data.dta` (Topic 4) - can reuse sp500_data
- [ ] `data/processed/portfolio_returns.dta` (Topic 4)
- [ ] `data/processed/crisis_returns.dta` (Topic 5) - can filter from returns_data
- [ ] `data/processed/multi_asset_returns.dta` (Topic 5) - can reuse portfolio_returns

---

## 🚀 Next Steps

1. **Download data** from sources listed in `data/data_sources.md`
2. **Save raw files** to `data/raw/` (CSV, Excel, etc.)
3. **Clean and format** data in Stata
4. **Save processed files** to `data/processed/` as `.dta` files
5. **Test** that files load correctly in the scripts/notebooks

---

**Questions?** Refer to `data/data_sources.md` for detailed download instructions for each dataset.
