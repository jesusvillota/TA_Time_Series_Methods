/*
================================================================================
TOPIC 2: Multivariate VAR Models and Cointegration
CEMFI Advanced Training School - Methods for Time Series
Practical Session 1
================================================================================

This script demonstrates:
1. VAR model specification and lag selection
2. Granger causality testing
3. Johansen cointegration test
4. Impulse response functions and variance decomposition
5. VECM estimation

Data: Macro-finance variables (GDP, inflation, interest rates, stock returns)
*/

* ============================================================================
* SETUP
* ============================================================================

clear all
set more off
set seed 12345

* Set working directory
cd "../../data/processed"

* Install required packages (if not already installed)
* ssc install varsoc, replace
* ssc install varstable, replace
* ssc install johans, replace

* ============================================================================
* PART 1: VAR MODELING
* ============================================================================

* ----------------------------------------------------------------------------
* 1.1 Data Loading and Preparation
* ----------------------------------------------------------------------------

* Load macro-finance data
* Example: use macro_finance_data.dta, clear
* Or download from FRED using:
* freduse GDPC1 CPIAUCSL FEDFUNDS SP500 UNRATE, clear

* Variables should include:
* - date: date variable
* - gdp: Real GDP (or growth rate)
* - inflation: Inflation rate
* - interest_rate: Policy interest rate or bond yield
* - stock_index: Stock market index returns
* - unemployment: Unemployment rate

* Set time series
tsset date

* Ensure all variables are stationary (check unit roots first!)
* For VAR, all variables must be I(0) - stationary
* If variables are I(1), we'll use them in VECM later

* Create stationary transformations if needed
* gen gdp_growth = D.ln(gdp)  // GDP growth rate
* gen inflation = 100 * D.ln(cpi)  // Inflation rate
* gen stock_return = D.ln(stock_index)  // Stock returns

* Summary statistics
summarize gdp_growth inflation interest_rate stock_return

* ----------------------------------------------------------------------------
* 1.2 Lag Length Selection
* ----------------------------------------------------------------------------

* Use information criteria to select optimal lag length
* Create varlist of endogenous variables
local endog_vars "gdp_growth inflation interest_rate stock_return"

* Test lag length selection
varsoc `endog_vars', maxlag(8)
* Interpretation:
* - Look for lag with lowest AIC, BIC, or HQIC
* - BIC is often preferred (more conservative)
* - Different criteria may suggest different lags

* ----------------------------------------------------------------------------
* 1.3 Estimate VAR Model
* ----------------------------------------------------------------------------

* Estimate VAR with selected lag length (example: 2 lags)
var `endog_vars', lags(1/2)

* Display results
* Estimates are shown for each equation separately

* ----------------------------------------------------------------------------
* 1.4 Check VAR Stability
* ----------------------------------------------------------------------------

* Test if VAR is stable (all eigenvalues inside unit circle)
varstable, graph
* Interpretation:
* - If all eigenvalues inside unit circle → VAR is stable
* - Unstable VAR → cannot use for forecasting/IRF

* ----------------------------------------------------------------------------
* 1.5 Granger Causality Tests
* ----------------------------------------------------------------------------

* Test Granger causality between variables
* Granger causality: X Granger causes Y if past X helps predict Y

* Test if inflation Granger causes GDP growth
vargranger
* This tests all pairs of variables

* More detailed tests (example):
* Test if stock returns Granger cause GDP growth
* Test individual equations:
test [gdp_growth]L.stock_return [gdp_growth]L2.stock_return
* Low p-value → reject null → stock returns Granger cause GDP

* ----------------------------------------------------------------------------
* 1.6 Impulse Response Functions (IRF)
* ----------------------------------------------------------------------------

* Estimate IRFs to show dynamic effects
* IRF shows response of each variable to shock in one variable

* Create IRFs with Cholesky decomposition (ordering matters!)
* Ordering: gdp_growth → inflation → interest_rate → stock_return
* (Variables earlier in ordering can affect later ones contemporaneously)

irf create var_irf, set(myirfs) replace
irf graph oirf, impulse(stock_return) response(gdp_growth) ///
    xlabel(0(4)20) yline(0) name(irf1, replace)
irf graph oirf, impulse(interest_rate) response(inflation) ///
    xlabel(0(4)20) yline(0) name(irf2, replace)

* Combine graphs
graph combine irf1 irf2, title("Impulse Response Functions")

* Alternative: Orthogonalized IRFs with different orderings
* Experiment with different orderings to check robustness

* ----------------------------------------------------------------------------
* 1.7 Forecast Error Variance Decomposition (FEVD)
* ----------------------------------------------------------------------------

* FEVD shows proportion of forecast error variance explained by each shock

irf graph fevd, impulse(stock_return) response(gdp_growth) ///
    xlabel(0(4)20) name(fevd1, replace)
irf graph fevd, impulse(interest_rate) response(inflation) ///
    xlabel(0(4)20) name(fevd2, replace)

* Display FEVD table
irf table fevd, impulse(stock_return interest_rate) ///
    response(gdp_growth inflation)

* ----------------------------------------------------------------------------
* 1.8 VAR Forecasting
* ----------------------------------------------------------------------------

* Generate forecasts
fcast compute var_fcast, step(12)  // Forecast 12 periods ahead

* Graph forecasts
fcast graph var_fcast, observed

* Evaluate forecast accuracy (if you have out-of-sample data)
* Compare forecasted vs actual values

* ============================================================================
* PART 2: COINTEGRATION ANALYSIS
* ============================================================================

* ----------------------------------------------------------------------------
* 2.1 Preliminary Unit Root Tests
* ----------------------------------------------------------------------------

* Before cointegration, check if variables are I(1)
* Cointegration requires variables to be integrated of same order (usually I(1))

* Test levels (should have unit roots)
dfuller gdp, lags(10) trend
dfuller inflation, lags(10)
dfuller interest_rate, lags(10)
dfuller stock_index, lags(10) trend

* Test first differences (should be stationary)
dfuller D.gdp, lags(10)
dfuller D.inflation, lags(10)
dfuller D.interest_rate, lags(10)
dfuller D.stock_index, lags(10)

* If all are I(1), proceed with cointegration tests

* ----------------------------------------------------------------------------
* 2.2 Engle-Granger Two-Step Procedure
* ----------------------------------------------------------------------------

* Step 1: Estimate long-run relationship
* Example: Test if GDP and consumption are cointegrated
* regress gdp consumption
* predict residuals, residuals

* Step 2: Test residuals for unit root
* dfuller residuals, noconstant
* If residuals are stationary → cointegration exists

* ----------------------------------------------------------------------------
* 2.3 Johansen Cointegration Test
* ----------------------------------------------------------------------------

* More powerful test for multiple variables
* Can test for multiple cointegrating relationships

* Select variables that are I(1) for cointegration test
* Example: test cointegration between GDP, consumption, investment
local coint_vars "gdp consumption investment"

* Johansen test with trend
johans `coint_vars', lags(2) trend(constant)
* Interpretation:
* - Trace statistic: test H0: r cointegrating vectors vs H1: > r vectors
* - Max eigenvalue: test H0: r vs H1: r+1 vectors
* - Look at critical values to determine number of cointegrating relationships

* Johansen test without trend
johans `coint_vars', lags(2)

* ----------------------------------------------------------------------------
* 2.4 Vector Error Correction Model (VECM)
* ----------------------------------------------------------------------------

* If cointegration found, estimate VECM
* VECM combines short-run dynamics with long-run equilibrium

* Estimate VECM (example: 1 cointegrating relationship, 2 lags)
vec `coint_vars', lags(2) rank(1) trend(constant)

* Display cointegrating equation
* This shows the long-run relationship

* Display adjustment coefficients (speed of adjustment)
* Negative coefficient → error correction (adjusts back to equilibrium)

* ----------------------------------------------------------------------------
* 2.5 Impulse Responses from VECM
* ----------------------------------------------------------------------------

* Can also compute IRFs from VECM
* Shows both short-run and long-run responses

* irf create vecm_irf, set(myirfs) replace
* irf graph oirf, impulse(gdp) response(consumption)

* ============================================================================
* INTERPRETATION AND SUMMARY
* ============================================================================

/*
PRACTICAL INSIGHTS:

For VAR Models:
- VAR models capture dynamic interactions between multiple time series
- Useful for understanding transmission mechanisms (e.g., monetary policy)
- Granger causality ≠ true causality (correlation in time)
- IRF ordering matters (Cholesky decomposition assumes causal ordering)
- VAR requires all variables to be stationary (I(0))

For Cointegration:
- Cointegration means variables move together in long run despite short-run deviations
- If cointegration exists, use VECM instead of VAR in levels
- VECM captures both short-run dynamics and long-run equilibrium
- Important for policy analysis (e.g., money demand, consumption-income)

PRACTICAL TIPS:

1. Always check unit roots before VAR/cointegration
   - VAR requires I(0) variables
   - Cointegration requires I(1) variables

2. Lag selection is important
   - Use information criteria (AIC, BIC)
   - Too few lags: misspecification
   - Too many lags: overfitting

3. VAR stability is crucial
   - Unstable VAR cannot be used for forecasting
   - Check eigenvalues

4. IRF interpretation
   - Ordering matters in Cholesky decomposition
   - Try different orderings for robustness
   - Economic theory should guide ordering

5. Cointegration testing
   - Use both Engle-Granger and Johansen tests
   - Johansen more powerful for multiple variables
   - Test residuals if using Engle-Granger

6. VECM vs VAR
   - If cointegration: use VECM
   - If no cointegration but variables I(1): use VAR in first differences
   - If variables I(0): use VAR in levels
*/

* ============================================================================
* END OF SCRIPT
* ============================================================================

* Save results
* estimates save var_results, replace
* irf save myirfs, replace
