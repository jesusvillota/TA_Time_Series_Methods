/*
================================================================================
TOPIC 1: Univariate ARMA Models and Unit Root Tests
CEMFI Advanced Training School - Methods for Time Series
Practical Session 1
================================================================================

This script demonstrates:
1. ARMA model identification and estimation
2. Diagnostic checking
3. Unit root testing (ADF, PP, KPSS)

Data: S&P 500 returns and EUR/USD exchange rate
*/

* ============================================================================
* SETUP
* ============================================================================

clear all
set more off
set seed 12345

* Set working directory (adjust path as needed)
cd "../../data/processed"

* ============================================================================
* PART 1: ARMA MODELING - S&P 500 RETURNS
* ============================================================================

* ----------------------------------------------------------------------------
* 1.1 Data Loading and Preparation
* ----------------------------------------------------------------------------

* Load S&P 500 data
* Note: In practice, download from FRED or Yahoo Finance
* Example: use sp500_data.dta, clear
* Or: import delimited "../raw/sp500.csv", clear

* For demonstration, we assume data structure:
* - date: date variable
* - sp500_close: closing price
* - sp500_return: log returns (or create below)

* Create log returns if not already in dataset
* gen log_price = ln(sp500_close)
* gen sp500_return = D.log_price  // First difference of logs

* Set time series
tsset date

* Drop missing values (first observation after differencing)
* drop if missing(sp500_return)

* ----------------------------------------------------------------------------
* 1.2 Exploratory Data Analysis
* ----------------------------------------------------------------------------

* Summary statistics
summarize sp500_return, detail

* Plot returns
tsline sp500_return, title("S&P 500 Daily Returns") ///
    ytitle("Returns") xtitle("Date") ///
    note("Source: FRED / Yahoo Finance")

* ----------------------------------------------------------------------------
* 1.3 Model Identification: ACF and PACF
* ----------------------------------------------------------------------------

* Plot Autocorrelation Function (ACF)
ac sp500_return, lags(20) ///
    title("ACF of S&P 500 Returns") ///
    ytitle("Autocorrelation") ///
    name(acf, replace)

* Plot Partial Autocorrelation Function (PACF)
pac sp500_return, lags(20) ///
    title("PACF of S&P 500 Returns") ///
    ytitle("Partial Autocorrelation") ///
    name(pacf, replace)

* Combine plots
graph combine acf pacf, ///
    title("ACF and PACF of S&P 500 Returns")

* Interpretation:
* - ACF cuts off after lag q → suggests MA(q) component
* - PACF cuts off after lag p → suggests AR(p) component
* - Both decay slowly → may need differencing (but returns should be stationary)
* - No significant lags → white noise (efficient market hypothesis)

* ----------------------------------------------------------------------------
* 1.4 Formal Tests for Autocorrelation
* ----------------------------------------------------------------------------

* Ljung-Box test (H0: no autocorrelation)
wntestq sp500_return, lags(10)
* Low p-value → reject H0 → autocorrelation present → ARMA model may be appropriate

* Portmanteau test
wntestb sp500_return, lags(10)
* Provides additional check for white noise

* ----------------------------------------------------------------------------
* 1.5 Model Estimation
* ----------------------------------------------------------------------------

* Estimate AR(1) model
arima sp500_return, ar(1)
estat ic  // Information criteria (AIC, BIC)
estimates store ar1

* Estimate MA(1) model
arima sp500_return, ma(1)
estat ic
estimates store ma1

* Estimate ARMA(1,1) model (often a good starting point)
arima sp500_return, ar(1) ma(1)
estat ic
estimates store arma11

* Estimate ARMA(2,2) model
arima sp500_return, ar(1/2) ma(1/2)
estat ic
estimates store arma22

* Compare models using information criteria
* Lower AIC/BIC = better model
estimates stats ar1 ma1 arma11 arma22

* Display selected model (ARMA(1,1) if it has lowest IC)
estimates restore arma11
estimates replay

* ----------------------------------------------------------------------------
* 1.6 Diagnostic Checks
* ----------------------------------------------------------------------------

* Predict residuals
predict residuals, residuals

* Plot residuals
tsline residuals, title("Residuals from ARMA(1,1) Model") ///
    ytitle("Residuals") xtitle("Date") ///
    note("Should appear random with no pattern")

* ACF of residuals (should show no autocorrelation)
ac residuals, lags(20) title("ACF of Residuals - Should be White Noise")

* Ljung-Box test on residuals (H0: residuals are white noise)
wntestq residuals, lags(10)
* If p-value > 0.05 → cannot reject white noise → model is adequate
* If p-value < 0.05 → remaining autocorrelation → need higher-order model

* Test for normality of residuals
swilk residuals  // Shapiro-Wilk test
* Histogram with normal overlay
histogram residuals, normal ///
    title("Distribution of Residuals") ///
    note("Red line: normal distribution")

* ----------------------------------------------------------------------------
* 1.7 Test for ARCH Effects (Preview of Topic 4)
* ----------------------------------------------------------------------------

* Check for heteroskedasticity in residuals (ARCH effects)
predict residuals2, residuals
gen residuals_sq = residuals2^2

* Simple regression of squared residuals on lagged squared residuals
regress residuals_sq L.residuals_sq L2.residuals_sq L3.residuals_sq

* LM test for ARCH effects (more formal test)
estat archlm, lags(1/5)
* Interpretation:
* - If p-value < 0.05, ARCH effects present → need GARCH model (Topic 4)
* - This is very common in financial returns

* ============================================================================
* PART 2: UNIT ROOT TESTS - EUR/USD EXCHANGE RATE
* ============================================================================

* ----------------------------------------------------------------------------
* 2.1 Data Loading
* ----------------------------------------------------------------------------

* Load EUR/USD exchange rate data
* use eurusd_data.dta, clear
* tsset date

* Create log exchange rate if needed
* gen lneurusd = ln(eurusd)

* Plot log exchange rate (likely non-stationary)
tsline lneurusd, title("EUR/USD Exchange Rate (log)") ///
    ytitle("Log Exchange Rate") xtitle("Date") ///
    note("Exchange rates often have unit roots")

* ----------------------------------------------------------------------------
* 2.2 Augmented Dickey-Fuller (ADF) Test
* ----------------------------------------------------------------------------

* ADF test with trend (H0: unit root, H1: stationary)
dfuller lneurusd, lags(10) trend
* Interpretation:
* - MacKinnon approximate p-value > 0.05 → cannot reject unit root → non-stationary
* - If p-value < 0.05 → reject unit root → stationary

* ADF test without trend
dfuller lneurusd, lags(10)

* ADF test with drift only (no trend)
dfuller lneurusd, lags(10) drift

* Note: Choose test specification based on visual inspection of the series
* - Trend: if series shows clear trend
* - Drift: if series shows drift but no trend
* - None: if series appears to wander around zero

* ----------------------------------------------------------------------------
* 2.3 Phillips-Perron (PP) Test
* ----------------------------------------------------------------------------

* PP test with trend (alternative to ADF, non-parametric)
pperron lneurusd, lags(10) trend

* PP test without trend
pperron lneurusd, lags(10)

* Interpretation similar to ADF
* PP test is robust to serial correlation and heteroskedasticity

* ----------------------------------------------------------------------------
* 2.4 KPSS Test
* ----------------------------------------------------------------------------

* KPSS test (H0: stationary, H1: unit root)
* NOTE: Null and alternative are OPPOSITE of ADF!
* May need to install: ssc install kpss

* kpss lneurusd, lags(10) trend
* Interpretation:
* - If p-value < 0.05 → reject stationarity → unit root present
* - If p-value > 0.05 → cannot reject stationarity → stationary

* ----------------------------------------------------------------------------
* 2.5 Test First Difference
* ----------------------------------------------------------------------------

* If unit root found in levels, test first difference (returns)
gen d_lneurusd = D.lneurusd

* ADF test on first difference
dfuller d_lneurusd, lags(10)
* Interpretation:
* - If p-value < 0.05 → first difference is stationary → original series is I(1)
* - This confirms the original series has one unit root

* Plot first difference
tsline d_lneurusd, title("First Difference of EUR/USD (Returns)") ///
    ytitle("Returns") xtitle("Date") ///
    note("Should appear stationary")

* ============================================================================
* INTERPRETATION AND SUMMARY
* ============================================================================

/*
PRACTICAL INSIGHTS:

For S&P 500 Returns:
- Returns are typically stationary (no unit root)
- Weak autocorrelation is common in daily returns
- ARCH effects are almost always present (see Topic 4)
- ARMA models can capture short-term dynamics but may not forecast well

For Exchange Rates:
- Exchange rate levels typically have unit roots (random walk behavior)
- First differences (returns) are stationary
- This supports the efficient market hypothesis (unpredictable exchange rates)
- For forecasting, model returns, not levels

PRACTICAL TIPS:

1. Always check for unit roots before estimating ARMA models
   - ARMA requires stationarity
   - If unit root, take first differences

2. Information criteria (AIC, BIC) help choose model order
   - BIC penalizes complexity more than AIC
   - BIC often preferred for forecasting

3. Diagnostic checks are essential
   - White noise residuals
   - Check for ARCH effects (if present, use GARCH in Topic 4)

4. Multiple unit root tests provide robustness
   - ADF and PP test same null (unit root)
   - KPSS tests opposite (stationarity)
   - Use all three for confirmation

5. Financial returns often show:
   - Little serial correlation in mean (ARMA may not help much)
   - Strong serial correlation in variance (need GARCH)
*/

* ============================================================================
* END OF SCRIPT
* ============================================================================

* Save log file
* log close
* log using 01_arma_unit_roots, replace text
* (Run script)
* log close
