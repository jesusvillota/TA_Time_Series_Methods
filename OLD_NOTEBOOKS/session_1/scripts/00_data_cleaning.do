* ============================================================================
* Data Cleaning Script
* Advanced Training School: Methods for Time Series
* Session #1 - Cleaning Time Series Data
* Teaching Assistant: Jesus Villota Miranda
* ============================================================================
*
* This script processes raw time series data downloaded from FRED and prepares
* it for analysis in subsequent sessions.
*
* Data Sources:
*   - Raw CSV files are stored in data/raw/
*   - Processed Stata .dta files will be saved to data/processed/
*   - All data is publicly available from FRED
*
* Processing Steps:
*   1. Load raw CSV files
*   2. Parse and convert dates to Stata date formats
*   3. Create standard transformations (logs, returns, growth rates)
*   4. Handle missing values appropriately
*   5. Set up time series structure
*   6. Add variable labels
*   7. Save processed datasets
*
* ============================================================================

* ----------------------------------------------------------------------------
* 1) Setup
* ----------------------------------------------------------------------------

clear all
set more off

* Set working directory to project root
cd "../.."

* ----------------------------------------------------------------------------
* 2) S&P 500 Index Data
* ----------------------------------------------------------------------------

* Load S&P 500 raw data
import delimited "data/raw/SP500.csv", clear

* Display first few observations
list in 1/10

* Check data structure
describe

* Parse dates from observation_date column (FRED format: YYYY-MM-DD)
gen date_numeric = date(observation_date, "YMD")
drop observation_date

* Format as Stata daily date
format date_numeric %td
rename date_numeric date

* Check for duplicates
duplicates report date
duplicates drop date, force

* Sort by date
sort date

* Rename price variable (column name matches filename: SP500)
rename sp500 sp500_close

* Check for missing values
count if missing(sp500_close)
summarize sp500_close, detail

* Set time series (required before using D. operator)
tsset date

* Create log price and log returns
gen log_sp500 = ln(sp500_close)
gen sp500_return = D.log_sp500

* Drop log price (keep only close and return)
drop log_sp500

* Check returns summary
summarize sp500_return, detail

* Add variable labels
label var date "Date"
label var sp500_close "S&P 500 Closing Price"
label var sp500_return "S&P 500 Log Returns"

* Set time series
tsset date

* Check time series structure
tsset

* Save processed S&P 500 data
save "data/processed/sp500_data.dta", replace

display "S&P 500 data processed and saved successfully!"
describe

* ----------------------------------------------------------------------------
* 3) EUR/USD Exchange Rate Data
* ----------------------------------------------------------------------------

* Load EUR/USD raw data
import delimited "data/raw/DEXUSEU.csv", clear

* Display first few observations
list in 1/10

* Check data structure
describe

* Parse dates from observation_date column
gen date_numeric = date(observation_date, "YMD")
drop observation_date

* Format as Stata daily date
format date_numeric %td
rename date_numeric date

* Check for duplicates
duplicates report date
duplicates drop date, force

* Sort by date
sort date

* Rename exchange rate variable (column name matches filename: DEXUSEU)
rename dexuseu eurusd

* Check for missing values
count if missing(eurusd)
summarize eurusd, detail

* Set time series (required before using D. operator)
tsset date

* Create log exchange rate and first difference
gen lneurusd = ln(eurusd)
gen d_lneurusd = D.lneurusd

* Check summary statistics
summarize eurusd lneurusd d_lneurusd, detail

* Add variable labels
label var date "Date"
label var eurusd "EUR/USD Exchange Rate"
label var lneurusd "Log EUR/USD Exchange Rate"
label var d_lneurusd "First Difference of Log EUR/USD"

* Set time series
tsset date

* Check time series structure
tsset

* Save processed EUR/USD data
save "data/processed/eurusd_data.dta", replace

display "EUR/USD data processed and saved successfully!"
describe

* ----------------------------------------------------------------------------
* 4) Macro-Finance Data
* ----------------------------------------------------------------------------

* ----------------------------------------------------------------------------
* 4.1 Real GDP (Quarterly)
* ----------------------------------------------------------------------------

* Load Real GDP data (quarterly)
import delimited "data/raw/GDPC1.csv", clear

* Parse dates from observation_date column
gen date_numeric = date(observation_date, "YMD")
drop observation_date

* Convert to quarterly format
* First convert to daily, then to quarterly
format date_numeric %td
gen year = year(date_numeric)
gen month = month(date_numeric)
gen quarter = ceil(month/3)
gen date_q = yq(year, quarter)
format date_q %tq

* Rename GDP variable (column name matches filename: GDPC1)
rename gdpc1 gdp

* Set time series (required before using D. operator)
rename date_q date
tsset date

* Create log GDP and growth rate
gen lngdp = ln(gdp)
gen gdp_growth = D.lngdp

* Keep only quarterly date and variables
keep date gdp lngdp gdp_growth

* Remove duplicates and sort
duplicates drop date, force
sort date

* Save temporary GDP file
save "data/processed/temp_gdp.dta", replace

describe
summarize gdp lngdp gdp_growth, detail

* ----------------------------------------------------------------------------
* 4.2 CPI (Monthly)
* ----------------------------------------------------------------------------

* Load CPI data (monthly)
import delimited "data/raw/CPIAUCSL.csv", clear

* Parse dates from observation_date column
gen date_numeric = date(observation_date, "YMD")
drop observation_date

* Convert to monthly format
format date_numeric %td
gen year = year(date_numeric)
gen month = month(date_numeric)
gen date_m = ym(year, month)
format date_m %tm

* Rename CPI variable (column name matches filename: CPIAUCSL)
rename cpiaucsl cpi

* Set time series (required before using D. operator)
rename date_m date
tsset date

* Create inflation rate (monthly change, annualized percentage)
* First create log of CPI, then take first difference
gen ln_cpi = ln(cpi)
gen inflation = 100 * D.ln_cpi

* Keep only monthly date and variables
keep date cpi inflation

* Remove duplicates and sort
duplicates drop date, force
sort date

* Save temporary CPI file
save "data/processed/temp_cpi.dta", replace

describe
summarize cpi inflation, detail

* ----------------------------------------------------------------------------
* 4.3 Interest Rate (Monthly)
* ----------------------------------------------------------------------------

* Load interest rate data (Fed Funds Rate - monthly)
import delimited "data/raw/FEDFUNDS.csv", clear

* Parse dates from observation_date column
gen date_numeric = date(observation_date, "YMD")
drop observation_date

* Convert to monthly format
format date_numeric %td
gen year = year(date_numeric)
gen month = month(date_numeric)
gen date_m = ym(year, month)
format date_m %tm

* Rename interest rate variable (column name matches filename: FEDFUNDS)
rename fedfunds interest_rate

* Keep only monthly date and variables
keep date_m interest_rate

* Rename date variable
rename date_m date

* Remove duplicates and sort
duplicates drop date, force
sort date

* Save temporary interest rate file
save "data/processed/temp_interest.dta", replace

describe
summarize interest_rate, detail

* ----------------------------------------------------------------------------
* 4.4 Unemployment Rate (Monthly)
* ----------------------------------------------------------------------------

* Load unemployment rate data (monthly)
import delimited "data/raw/UNRATE.csv", clear

* Parse dates from observation_date column
gen date_numeric = date(observation_date, "YMD")
drop observation_date

* Convert to monthly format
format date_numeric %td
gen year = year(date_numeric)
gen month = month(date_numeric)
gen date_m = ym(year, month)
format date_m %tm

* Rename unemployment variable (column name matches filename: UNRATE)
rename unrate unemployment

* Keep only monthly date and variables
keep date_m unemployment

* Rename date variable
rename date_m date

* Remove duplicates and sort
duplicates drop date, force
sort date

* Save temporary unemployment file
save "data/processed/temp_unemployment.dta", replace

describe
summarize unemployment, detail

* ----------------------------------------------------------------------------
* 4.5 Stock Index Returns (Monthly from S&P 500)
* ----------------------------------------------------------------------------

* Load processed S&P 500 data
use "data/processed/sp500_data.dta", clear

* Convert daily date to monthly
gen year = year(date)
gen month = month(date)
gen date_m = ym(year, month)
format date_m %tm

* Aggregate to monthly: take last observation of each month
* For returns, we can sum daily returns to get monthly returns
bysort date_m: egen stock_return = total(sp500_return)

* Keep only one observation per month (last day of month)
bysort date_m: keep if _n == _N

* Keep only monthly date and return
keep date_m stock_return

* Rename date variable
rename date_m date

* Sort
sort date

* Save temporary stock return file
save "data/processed/temp_stock.dta", replace

describe
summarize stock_return, detail

* ----------------------------------------------------------------------------
* 4.6 Merge All Macro-Finance Series
* ----------------------------------------------------------------------------

* First, process GDP quarterly to monthly conversion
* Load GDP quarterly data
use "data/processed/temp_gdp.dta", clear

* Extract year and quarter from quarterly date
gen year = year(date)
gen quarter = quarter(date)

* Create monthly dates for all three months in each quarter
expand 3
bysort date: gen month_in_quarter = _n  // 1, 2, or 3
gen month = (quarter - 1) * 3 + month_in_quarter
gen date_m = ym(year, month)
format date_m %tm

* Keep only one observation per month (carry forward quarterly values)
bysort date_m: keep if _n == 1

* Drop old quarterly date variable before renaming
drop date

* Rename and keep variables
rename date_m date
keep date gdp lngdp gdp_growth

* Sort by date
sort date

* Save temporary expanded GDP
save "data/processed/temp_gdp_monthly.dta", replace

* Now start with CPI as base (monthly) and merge all series
use "data/processed/temp_cpi.dta", clear

* Merge with interest rate
merge 1:1 date using "data/processed/temp_interest.dta", nogen

* Merge with unemployment
merge 1:1 date using "data/processed/temp_unemployment.dta", nogen

* Merge with stock returns
merge 1:1 date using "data/processed/temp_stock.dta", nogen

* Merge with GDP (monthly version)
merge 1:1 date using "data/processed/temp_gdp_monthly.dta", nogen

* Sort by date
sort date

* Add variable labels
label var date "Date (Monthly)"
label var cpi "Consumer Price Index"
label var inflation "Inflation Rate (Monthly % Change)"
label var interest_rate "Interest Rate (%)"
label var unemployment "Unemployment Rate (%)"
label var stock_return "Stock Market Return (Monthly)"
label var gdp "Real GDP (Quarterly, interpolated)"
label var lngdp "Log Real GDP"
label var gdp_growth "GDP Growth Rate (Quarterly)"

* Set time series
tsset date

* Check time series structure
tsset

* Display summary
describe
summarize, detail

* Save processed macro-finance data
save "data/processed/macro_finance_data.dta", replace

display "Macro-finance data processed and saved successfully!"

* Clean up temporary files
erase "data/processed/temp_gdp.dta"
erase "data/processed/temp_cpi.dta"
erase "data/processed/temp_interest.dta"
erase "data/processed/temp_unemployment.dta"
erase "data/processed/temp_stock.dta"
erase "data/processed/temp_gdp_monthly.dta"

display "Temporary files cleaned up."

* ----------------------------------------------------------------------------
* 5) Data Quality Checks
* ----------------------------------------------------------------------------

* Check S&P 500 data
use "data/processed/sp500_data.dta", clear
tsset date

display "=== S&P 500 Data Quality Check ==="
display "Date range: " %td r(tmin) " to " %td r(tmax)
display "Number of observations: " _N
count if missing(sp500_close)
count if missing(sp500_return)
summarize sp500_return, detail

* Check EUR/USD data
use "data/processed/eurusd_data.dta", clear
tsset date

display "=== EUR/USD Data Quality Check ==="
display "Date range: " %td r(tmin) " to " %td r(tmax)
display "Number of observations: " _N
count if missing(eurusd)
count if missing(lneurusd)
count if missing(d_lneurusd)
summarize eurusd lneurusd d_lneurusd, detail

* Check Macro-Finance data
use "data/processed/macro_finance_data.dta", clear
tsset date

display "=== Macro-Finance Data Quality Check ==="
display "Date range: " %tm r(tmin) " to " %tm r(tmax)
display "Number of observations: " _N
display "Missing values per variable:"
count if missing(cpi)
display "  CPI: " r(N)
count if missing(inflation)
display "  Inflation: " r(N)
count if missing(interest_rate)
display "  Interest Rate: " r(N)
count if missing(unemployment)
display "  Unemployment: " r(N)
count if missing(stock_return)
display "  Stock Return: " r(N)
count if missing(gdp)
display "  GDP: " r(N)

summarize, detail

* ----------------------------------------------------------------------------
* 6) Summary
* ----------------------------------------------------------------------------

display ""
display "=========================================="
display "Data Cleaning Complete!"
display "=========================================="
display ""
display "All raw data has been processed and cleaned."
display "The following files are now available in data/processed/:"
display ""
display "1. sp500_data.dta: Daily S&P 500 index prices and log returns"
display "2. eurusd_data.dta: Daily EUR/USD exchange rates with log and first-difference transformations"
display "3. macro_finance_data.dta: Monthly macro-finance dataset with CPI, inflation, interest rates,"
display "   unemployment, stock returns, and GDP"
display ""
display "Next Steps:"
display "- These cleaned datasets are ready for use in subsequent analysis scripts"
display "- All datasets have proper time series structure (tsset)"
display "- Variable labels are included for clarity"
display "- Missing values have been documented (expected for financial data due to weekends/holidays)"
display ""
