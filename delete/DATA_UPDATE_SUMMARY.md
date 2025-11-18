# Data Update Summary

## Date: November 17, 2025

## Changes Made to empirical_applications.do

### 1. ESP_GDP.csv Loading (Lines 358-382)

**Previous status:** Skipped with error message
**New implementation:**
- Loads `ESP_GDP.csv` with series ID `CPMNACSCAB1GQES`
- Parses quarterly dates (1995-Q1 to 2025-Q3)
- Creates variable `gdp_esp` (GDP levels)
- Computes `dgdp` (year-over-year GDP growth rate)
- Saves as temporary file `esp_gdp`

### 2. ESP_UNEMP.csv Loading (Lines 437-457)

**Previous status:** Skipped with error message
**New implementation:**
- Loads `ESP_UNEMP.csv` with series ID `LRHUTTTTESQ156S`
- Parses quarterly dates (1986-Q2 to 2025-Q2)
- Creates variable `unemp_esp` (unemployment rate %)
- Saves as temporary file `esp_unemp`

### 3. Exercise 1 Update (Line 531-533)

**Previous:** Note about GDP data not available
**New:** Removed note, proceeds directly to analysis

### 4. Exercise 4 Update (Line 689-694)

**Previous:** Note about GDP data not available
**New:** Removed note, proceeds directly to analysis

### 5. Exercise 8 Implementation (Lines 948-1018)

**Previous status:** Completely skipped
**New implementation:**
- Loads and merges GDP and Credit data
- Computes summary statistics
- Creates time series plots for both variables
- Performs VAR lag selection using information criteria
- Estimates VAR(2) model
- Conducts Granger causality tests
- Generates impulse response functions (IRFs)
- Creates forecast error variance decomposition (FEVD)
- Exports graph: `exercise8_gdp_credit.png`

## Data Files Verified

### ESP_GDP.csv
- Format: FRED CSV (observation_date, CPMNACSCAB1GQES)
- Frequency: Quarterly
- Observations: 123
- Date range: 1995-01-01 to 2025-07-01
- Values: GDP levels (112,609 to 422,712)

### ESP_UNEMP.csv
- Format: FRED CSV (observation_date, LRHUTTTTESQ156S)
- Frequency: Quarterly
- Observations: 157
- Date range: 1986-04-01 to 2025-04-01
- Values: Unemployment rates (7.97% to 26.30%)

## Variable Name Mapping

| File | Series ID | Stata Variable | Description |
|------|-----------|----------------|-------------|
| ESP_GDP.csv | CPMNACSCAB1GQES | gdp_esp | Spain Real GDP (Level) |
| | | dgdp | Spain Real GDP Growth Rate (YoY %) |
| ESP_UNEMP.csv | LRHUTTTTESQ156S | unemp_esp | Spain Unemployment Rate (%) |

## Testing Recommendations

1. Run the entire script to verify no syntax errors
2. Check that Exercise 8 produces expected output:
   - VAR estimation results
   - Granger causality test results
   - IRF graphs
   - FEVD graphs
3. Verify the merged dataset has sufficient observations for VAR analysis
4. Check the `exercise8_gdp_credit.png` graph is created

## Notes

- Both datasets are quarterly frequency (not monthly as originally expected)
- The script computes GDP growth rates from levels
- The unemployment data is already in rate format (no transformation needed)
- VAR analysis requires stationary data; growth rates should be stationary
