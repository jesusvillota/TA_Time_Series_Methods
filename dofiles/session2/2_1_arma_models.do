* ============================================================================
* ARMA MODEL ESTIMATION AND SELECTION
* ============================================================================
*
* Script: 2_1_arma_models.do
* Purpose: ARMA Model Estimation and Selection
* Session: Session 2 • Part 1
* Author: Jesus Villota Miranda
* Date: 2025
*
* This script replicates exercises from the corresponding notebook:
* 2_1_arma_models.ipynb
*
* ============================================================================

* ----------------------------------------------------------------------------
* SETUP
* ----------------------------------------------------------------------------

clear all  // Clear memory and remove all variables
set more off  // Display all output without pausing
set seed 12345  // Set random seed for reproducibility

* Define paths (relative to dofiles/session2 directory)
global processed_data "../../data/processed"  // Path to processed data

* Create log file
log using "2_1_arma_models.log", replace text  // Start log file

display "============================================================================"
display "ARMA MODEL ESTIMATION AND SELECTION"
display "============================================================================"
display ""

* ----------------------------------------------------------------------------
* SECTION 1: INTRODUCTION TO ARMA MODELS
* ----------------------------------------------------------------------------

display "Section: Introduction to ARMA Models"
display ""

* ARMA(p,q) models combine autoregressive (AR) and moving average (MA) components 
* to capture both the persistence and shock dynamics in time series data:
*
* Y_t = phi_1*Y_{t-1} + ... + phi_p*Y_{t-p} + epsilon_t + theta_1*epsilon_{t-1} + ... + theta_q*epsilon_{t-q}
*
* where:
* - Y_t is the time series at time t
* - phi_1, ..., phi_p are the autoregressive coefficients (capture persistence from past values)
* - theta_1, ..., theta_q are the moving average coefficients (capture impact of past shocks)
* - epsilon_t ~ WN is white noise
*
* Why ARMA Models?
*
* ARMA models provide a parsimonious way to represent complex autocorrelation patterns:
* - AR component: Captures direct dependence on past values (long memory)
* - MA component: Captures dependence on past forecast errors (smoothing)
* - Combined: Can approximate a wide range of stationary processes with fewer parameters 
*   than pure AR or MA models
*
* Model Selection: Information Criteria
*
* To determine optimal lag orders (p, q), we use information criteria that balance 
* model fit against complexity:
*
* Akaike Information Criterion (AIC):
* AIC = -2*ln(L) + 2*k
*
* Bayesian Information Criterion (BIC):
* BIC = -2*ln(L) + k*ln(T)
*
* where:
* - L = maximized likelihood
* - k = number of estimated parameters
* - T = sample size
*
* Important: Lower Values are Better
*
* Both criteria penalize model complexity, but BIC penalizes more heavily:
* - AIC: Tends to select larger models (better for prediction)
* - BIC: Tends to select smaller models (better for parsimony and interpretation)
* - Strategy: Choose model with minimum AIC or BIC, considering both criteria
*
* Key Properties for Stationarity
*
* For an ARMA process to be stationary, the roots of the AR characteristic polynomial 
* must lie outside the unit circle:
*
* 1 - phi_1*z - phi_2*z^2 - ... - phi_p*z^p = 0  requires  |z| > 1
*
* Practical Check: For ARMA(2,1), stationarity requires |phi_1 + phi_2| < 1, 
* phi_2 - phi_1 < 1, and -1 < phi_2 < 1.

* ----------------------------------------------------------------------------
* SECTION 1.1: ARMA PROCESS SIMULATIONS
* ----------------------------------------------------------------------------

display "Section: ARMA Process Simulations - Understanding Different Specifications"
display ""

* To build intuition for ARMA models, we simulate several specifications and examine 
* their distinctive characteristics through time series plots, ACF, and PACF patterns.
*
* Learning Objectives:
*
* By comparing different ARMA(p,q) specifications, we'll understand:
* 1. Pure AR processes: How ACF decays exponentially while PACF cuts off
* 2. Pure MA processes: How ACF cuts off while PACF decays exponentially
* 3. Mixed ARMA processes: How both ACF and PACF decay gradually
* 4. Parameter effects: How coefficient values influence persistence and dynamics
*
* Simulation Setup
*
* We'll generate 500 observations for each specification with the same random seed 
* for comparability:
*
* Models to Compare:
* - AR(1): Y_t = 0.7*Y_{t-1} + epsilon_t
* - AR(2): Y_t = 0.5*Y_{t-1} + 0.3*Y_{t-2} + epsilon_t
* - MA(1): Y_t = epsilon_t + 0.7*epsilon_{t-1}
* - MA(2): Y_t = epsilon_t + 0.5*epsilon_{t-1} + 0.3*epsilon_{t-2}
* - ARMA(1,1): Y_t = 0.7*Y_{t-1} + epsilon_t + 0.4*epsilon_{t-1}
* - ARMA(2,1): Y_t = 0.5*Y_{t-1} + 0.3*Y_{t-2} + epsilon_t + 0.4*epsilon_{t-1}
*
* All innovations: epsilon_t ~ N(0, 1)

* Clear any existing data and set up simulation parameters
clear all  // Clear memory and remove all variables
set obs 500  // Set number of observations for simulation
gen t = _n  // Create time index from 1 to 500
tsset t  // Declare dataset as time series

* Set seed for reproducibility
set seed 12345  // Ensure simulations can be replicated exactly

* Simulate all six process types simultaneously and compare their characteristics:
* - AR(1): Y_t = 0.7*Y_{t-1} + e_t
* - AR(2): Y_t = 0.5*Y_{t-1} + 0.3*Y_{t-2} + e_t
* - MA(1): Y_t = e_t + 0.7*e_{t-1}
* - MA(2): Y_t = e_t + 0.5*e_{t-1} + 0.3*e_{t-2}
* - ARMA(1,1): Y_t = 0.7*Y_{t-1} + e_t + 0.4*e_{t-1}
* - ARMA(2,1): Y_t = 0.5*Y_{t-1} + 0.3*Y_{t-2} + e_t + 0.4*e_{t-1}

* Simulate AR(1): Y_t = 0.7*Y_{t-1} + e_t
gen y_ar1 = .
gen eps1 = rnormal()
replace y_ar1 = eps1 in 1
forvalues i = 2/500 {
    quietly replace y_ar1 = 0.7*y_ar1[`i'-1] + eps1[`i'] in `i'
}

* Simulate AR(2): Y_t = 0.5*Y_{t-1} + 0.3*Y_{t-2} + e_t
gen y_ar2 = .
gen eps2 = rnormal()
replace y_ar2 = eps2 in 1
replace y_ar2 = 0.5*y_ar2[1] + eps2[2] in 2
forvalues i = 3/500 {
    quietly replace y_ar2 = 0.5*y_ar2[`i'-1] + 0.3*y_ar2[`i'-2] + eps2[`i'] in `i'
}

* Simulate MA(1): Y_t = e_t + 0.7*e_{t-1}
gen eps3 = rnormal()
gen y_ma1 = eps3
forvalues i = 2/500 {
    quietly replace y_ma1 = eps3[`i'] + 0.7*eps3[`i'-1] in `i'
}

* Simulate MA(2): Y_t = e_t + 0.5*e_{t-1} + 0.3*e_{t-2}
gen eps4 = rnormal()
gen y_ma2 = eps4
replace y_ma2 = eps4[2] + 0.5*eps4[1] in 2
forvalues i = 3/500 {
    quietly replace y_ma2 = eps4[`i'] + 0.5*eps4[`i'-1] + 0.3*eps4[`i'-2] in `i'
}

* Simulate ARMA(1,1): Y_t = 0.7*Y_{t-1} + e_t + 0.4*e_{t-1}
gen eps5 = rnormal()
gen y_arma11 = eps5
forvalues i = 2/500 {
    quietly replace y_arma11 = 0.7*y_arma11[`i'-1] + eps5[`i'] + 0.4*eps5[`i'-1] in `i'
}

* Simulate ARMA(2,1): Y_t = 0.5*Y_{t-1} + 0.3*Y_{t-2} + e_t + 0.4*e_{t-1}
gen eps6 = rnormal()
gen y_arma21 = eps6
replace y_arma21 = 0.5*y_arma21[1] + eps6[2] + 0.4*eps6[1] in 2
forvalues i = 3/500 {
    quietly replace y_arma21 = 0.5*y_arma21[`i'-1] + 0.3*y_arma21[`i'-2] + eps6[`i'] + 0.4*eps6[`i'-1] in `i'
}

* Display first few observations
list t y_ar1 y_ar2 y_ma1 y_ma2 y_arma11 y_arma21 in 1/10

* Compare all simulated series using a 3x2 panel of subplots (first 100 observations for clarity)
twoway (line y_ar1 t if t <= 1000, lcolor(blue) lwidth(medium)), ///
    title("AR(1)", size(small)) ///
    ytitle("Value", size(small)) ///
    xtitle("") ///
    scheme(s2color) ///
    name(comp_ar1, replace)

twoway (line y_ar2 t if t <= 1000, lcolor(red) lwidth(medium)), ///
    title("AR(2)", size(small)) ///
    ytitle("Value", size(small)) ///
    xtitle("") ///
    scheme(s2color) ///
    name(comp_ar2, replace)

twoway (line y_ma1 t if t <= 1000, lcolor(green) lwidth(medium)), ///
    title("MA(1)", size(small)) ///
    ytitle("Value", size(small)) ///
    xtitle("") ///
    scheme(s2color) ///
    name(comp_ma1, replace)

twoway (line y_ma2 t if t <= 1000, lcolor(orange) lwidth(medium)), ///
    title("MA(2)", size(small)) ///
    ytitle("Value", size(small)) ///
    xtitle("") ///
    scheme(s2color) ///
    name(comp_ma2, replace)

twoway (line y_arma11 t if t <= 1000, lcolor(purple) lwidth(medium)), ///
    title("ARMA(1,1)", size(small)) ///
    ytitle("Value", size(small)) ///
    xtitle("Time", size(small)) ///
    scheme(s2color) ///
    name(comp_arma11, replace)

twoway (line y_arma21 t if t <= 1000, lcolor(brown) lwidth(medium)), ///
    title("ARMA(2,1)", size(small)) ///
    ytitle("Value", size(small)) ///
    xtitle("Time", size(small)) ///
    scheme(s2color) ///
    name(comp_arma21, replace)

graph combine comp_ar1 comp_ar2 comp_ma1 comp_ma2 comp_arma11 comp_arma21, ///
    rows(3) cols(2) ///
    title("Comparison of All ARMA Process Simulations", size(medium)) ///
    scheme(s2color)
/* graph export "../../output/all_arma_series_comparison.png", replace width(1400) */

* Generate ACF plots for all six processes
ac y_ar1, lags(20) title("AR(1) - ACF", size(small)) scheme(s2color) name(acf_ar1, replace)
ac y_ar2, lags(20) title("AR(2) - ACF", size(small)) scheme(s2color) name(acf_ar2, replace)
ac y_ma1, lags(20) title("MA(1) - ACF", size(small)) scheme(s2color) name(acf_ma1, replace)
ac y_ma2, lags(20) title("MA(2) - ACF", size(small)) scheme(s2color) name(acf_ma2, replace)
ac y_arma11, lags(20) title("ARMA(1,1) - ACF", size(small)) scheme(s2color) name(acf_arma11, replace)
ac y_arma21, lags(20) title("ARMA(2,1) - ACF", size(small)) scheme(s2color) name(acf_arma21, replace)

graph combine acf_ar1 acf_ar2 acf_ma1 acf_ma2 acf_arma11 acf_arma21, ///
    rows(3) cols(2) ///
    title("Autocorrelation Functions (ACF) Comparison", size(medium)) ///
    note("AR: Exponential decay | MA: Sharp cut-off | ARMA: Gradual decay", size(small)) ///
    scheme(s2color)
/* graph export "../../output/all_acf_comparison.png", replace width(1400) */

* Generate PACF plots for all six processes
pac y_ar1, lags(20) title("AR(1) - PACF", size(small)) scheme(s2color) name(pacf_ar1, replace)
pac y_ar2, lags(20) title("AR(2) - PACF", size(small)) scheme(s2color) name(pacf_ar2, replace)
pac y_ma1, lags(20) title("MA(1) - PACF", size(small)) scheme(s2color) name(pacf_ma1, replace)
pac y_ma2, lags(20) title("MA(2) - PACF", size(small)) scheme(s2color) name(pacf_ma2, replace)
pac y_arma11, lags(20) title("ARMA(1,1) - PACF", size(small)) scheme(s2color) name(pacf_arma11, replace)
pac y_arma21, lags(20) title("ARMA(2,1) - PACF", size(small)) scheme(s2color) name(pacf_arma21, replace)

graph combine pacf_ar1 pacf_ar2 pacf_ma1 pacf_ma2 pacf_arma11 pacf_arma21, ///
    rows(3) cols(2) ///
    title("Partial Autocorrelation Functions (PACF) Comparison", size(medium)) ///
    note("AR: Sharp cut-off | MA: Exponential decay | ARMA: Gradual decay", size(small)) ///
    scheme(s2color)
/* graph export "../../output/all_pacf_comparison.png", replace width(1400) */

* ARMA Identification Guide
*
* AR Processes (Pure Autoregressive):
* - ACF: Exponential decay — gradually declining autocorrelations
* - PACF: Sharp cut-off after lag p — directly reveals the order
* - Series behavior: Smooth, persistent fluctuations
*
* MA Processes (Pure Moving Average):
* - ACF: Sharp cut-off after lag q — directly reveals the order
* - PACF: Exponential decay — gradually declining pattern
* - Series behavior: More erratic, limited memory
*
* ARMA Processes (Mixed):
* - ACF: Gradual decay — no clear cut-off
* - PACF: Gradual decay — no clear cut-off
* - Series behavior: Combines persistence (AR) and shock smoothing (MA)
* - Identification: Use information criteria (AIC/BIC) to select optimal (p,q)
*
* Practical Insight: The ACF and PACF patterns are mirror images for pure AR and MA 
* processes, but both decay gradually for mixed ARMA specifications, requiring more 
* sophisticated model selection tools.
*
* Practical Identification Strategy:
*
* 1. Plot the series: Check for stationarity, trends, seasonality
* 2. Examine ACF:
*    - Sharp cut-off → suggests MA component
*    - Gradual decay → suggests AR component
* 3. Examine PACF:
*    - Sharp cut-off → suggests AR component
*    - Gradual decay → suggests MA component
* 4. If both decay gradually: Mixed ARMA likely needed
* 5. Use information criteria: Compare AIC/BIC across candidate models
* 6. Check residuals: Ensure white noise after fitting
*
* Key Insights from Simulations:
*
* 1. Persistence: AR terms create smoother, more persistent series; higher AR coefficients → more persistence
* 2. Smoothing: MA terms create smoothing effects; positive MA coefficients increase smoothness
* 3. Parsimony: ARMA(1,1) can often replicate patterns requiring AR(∞) or MA(∞)
* 4. Complexity trade-off: Higher-order models capture more detail but risk overfitting
* 5. Real-world application: Most economic/financial series are well-described by low-order ARMA (p,q ≤ 2)

* ----------------------------------------------------------------------------
* SECTION 2: MODELING THE VIX INDEX
* ----------------------------------------------------------------------------

display "Section: Modeling the VIX Index"
display ""

* The VIX Challenge
*
* The VIX (CBOE Volatility Index) measures market expectations of near-term volatility 
* conveyed by S&P500 index option prices. Modeling VIX presents unique challenges:
* - Non-normal distribution: Heavy right tail (volatility spikes)
* - Mean reversion: Volatility tends to return to long-run average
* - Persistent autocorrelation: High volatility tends to cluster

* ----------------------------------------------------------------------------
* SECTION 2.1: VIX HISTORICAL EVOLUTION AND DISTRIBUTION
* ----------------------------------------------------------------------------

display "Section: VIX Historical Evolution and Distribution"
display ""

* Initial Data Exploration
*
* We begin by loading daily VIX data spanning January 1990 to November 2025, examining 
* its temporal evolution and distributional characteristics.
*
* What to Look For:
* - Level shifts: Major crisis periods (2000-02 dot-com, 2008-09 financial crisis, 2020 covid)
* - Volatility clustering: High-volatility episodes tend to persist
* - Distributional shape: Skewness and kurtosis indicate departure from normality

* Load VIX data from processed file
use "$processed_data/vix_daily.dta", clear  // Load VIX daily dataset and clear memory

* Display first and last observations
list date vix in 1/5
list date vix in -5/-1

* Display summary information
describe
summarize vix

* Summary statistics for VIX
quietly summarize vix, detail  // Compute detailed summary statistics without output
display "VIX Summary Statistics:"
display "Mean:     " %9.4f r(mean)
display "Std Dev:  " %9.4f r(sd)
display "Skewness: " %9.4f r(skewness)
display "Kurtosis: " %9.4f r(kurtosis)
display "Min:      " %9.4f r(min)
display "Max:      " %9.4f r(max)

* Plot VIX historical evolution
tsline vix, ///
    title("VIX Index - Historical Evolution", size(medium)) ///
    subtitle("Jan 1990 to Jan 2015") ///
    ytitle("VIX Index") ///
    xtitle("Date") ///
    tlabel(, format(%tdCY)) ///
    scheme(s2color)
/* graph export "../../output/vix_evolution.png", replace width(1200) */

* Kernel density estimate for VIX vs normal density
kdensity vix, ///
    normal ///
    title("VIX - Kernel Density vs Normal Distribution", size(medium)) ///
    xtitle("VIX Index") ///
    ytitle("Density") ///
    legend(label(1 "Kernel density") label(2 "Normal density")) ///
    scheme(s2color)
/* graph export "../../output/vix_kde.png", replace width(1200) */

* ----------------------------------------------------------------------------
* SECTION 2.2: LOG-VIX TRANSFORMATION
* ----------------------------------------------------------------------------

display "Section: Log-VIX Transformation"
display ""

* Why Log Transformation?
*
* The Problem with Raw VIX
*
* Raw VIX exhibits:
* - Positive skewness: Long right tail from crisis episodes
* - Excess kurtosis: Fat tails beyond normal distribution
* - Heteroskedasticity: Variance changes over time
*
* The Log Transformation Solution
*
* The natural logarithm transformation addresses these issues:
*
* Log-VIX_t = ln(VIX_t)
*
* Benefits:
* 1. Variance stabilization: Reduces heteroskedasticity by compressing large values
* 2. Symmetry improvement: Reduces right skewness toward normality
* 3. Kurtosis improvement: Reduces kurtosis towards normality
* 4. Interpretability: Changes in log-VIX approximate percentage changes in VIX
*
* Key Takeaway: Log transformation is standard practice when modeling financial 
* volatility indices, making the data more suitable for linear time series models like ARMA.

* Create log-VIX transformation
* Note: Variable may already exist in the data file
capture confirm variable lgvix
if _rc {
    generate lgvix = ln(vix)  // Create natural log transformation of VIX
}
label variable lgvix "Log of VIX index"  // Assign descriptive label to new variable

* Summary statistics for log-VIX
quietly summarize lgvix, detail  // Compute detailed summary statistics without output
display "Log-VIX Summary Statistics:"
display "Mean:     " %9.4f r(mean)
display "Std Dev:  " %9.4f r(sd)
display "Skewness: " %9.4f r(skewness)
display "Kurtosis: " %9.4f r(kurtosis)
display "Min:      " %9.4f r(min)
display "Max:      " %9.4f r(max)

* Kernel density estimate for log-VIX vs normal density
kdensity lgvix, ///
    normal ///
    title("Log-VIX - Kernel Density vs Normal Distribution", size(medium)) ///
    xtitle("Log-VIX") ///
    ytitle("Density") ///
    legend(label(1 "Kernel density") label(2 "Normal density")) ///
    scheme(s2color)
/* graph export "../../output/logvix_kde.png", replace width(1200) */

* ACF for log-VIX
ac lgvix, ///
    lags(40) ///
    title("Log-VIX - Autocorrelation Function", size(medium)) ///
    ytitle("Autocorrelation") ///
    xtitle("Lag") ///
    scheme(s2color)
/* graph export "../../output/logvix_acf.png", replace width(1200) */

* PACF for log-VIX
pac lgvix, ///
    lags(40) ///
    title("Log-VIX - Partial Autocorrelation Function", size(medium)) ///
    ytitle("Partial Autocorrelation") ///
    xtitle("Lag") ///
    scheme(s2color)
/* graph export "../../output/logvix_pacf.png", replace width(1200) */

* ----------------------------------------------------------------------------
* SECTION 2.3: UNIT ROOT TESTING FOR STATIONARITY
* ----------------------------------------------------------------------------

display "Section: Unit Root Testing for Stationarity"
display ""

* Why Stationarity Matters
*
* Critical Requirement
*
* ARMA models are only valid for stationary processes. A non-stationary series:
* - Has time-varying mean and/or variance
* - Leads to spurious regression results
* - Violates asymptotic distribution theory for inference
*
* The DF-GLS Test
*
* We employ the DF-GLS (Dickey-Fuller GLS) test, which is more powerful than the 
* standard ADF test, especially for series with persistent autocorrelation.
*
* Hypotheses:
* H_0: Series has a unit root (non-stationary)
* H_1: Series is stationary
*
* Decision Rule:
* - If test statistic < critical value → Reject H_0 → Series is stationary
* - If test statistic >= critical value → Fail to reject H_0 → Series may be non-stationary
*
* Understanding the Left-Sided Test
*
* The DF-GLS is a left-tailed test: we reject H_0 when the test statistic is 
* sufficiently negative (far left in the distribution). The more negative the statistic, 
* the stronger the evidence against a unit root.
*
* Expected Result for Log-VIX: Given the mean-reverting nature of volatility, we 
* anticipate rejecting the unit root hypothesis, confirming log-VIX is stationary 
* and suitable for ARMA modeling.

* DF-GLS unit root test for log-VIX
* Create continuous series for dfgls (requires no gaps)
preserve  // Save current dataset state to restore later
drop if missing(lgvix)  // Remove observations with missing log-VIX values
gen t = _n  // Generate continuous time index from 1 to N
tsset t  // Declare dataset as time series with variable t as time index
dfgls lgvix, maxlag(10) notrend  // Run DF-GLS test with max 10 lags and no trend
display "H0: log-VIX has a unit root (non-stationary)"
display "If test statistic < critical value, reject H0 (series is stationary)"
restore  // Restore dataset to state before preserve

* Interpretation of Unit Root Results
*
* What the Results Reveal:
*
* 1. Stationarity Confirmation: Rejection of the unit root null hypothesis validates 
*    that log-VIX fluctuates around a stable mean with bounded variance
*
* 2. ARMA Validity: Stationarity ensures:
*    - Autocorrelations decay to zero (necessary for ARMA identification)
*    - Maximum likelihood estimation is consistent
*    - Standard errors and hypothesis tests are asymptotically valid
*
* 3. Economic Interpretation: Volatility is mean-reverting—extreme levels (both high 
*    and low) tend to return to long-run average, a key property exploited by 
*    volatility traders

* ----------------------------------------------------------------------------
* SECTION 2.4: ARMA MODEL SELECTION USING INFORMATION CRITERIA
* ----------------------------------------------------------------------------

display "Section: ARMA Model Selection Using Information Criteria"
display ""

* The Model Selection Problem
*
* With confirmed stationarity, we face the challenge: Which ARMA(p,q) specification 
* best represents the data?
*
* The Trade-off
*
* - Too few lags: Model is underfit → fails to capture all autocorrelation → biased estimates
* - Too many lags: Model is overfit → captures noise as signal → inefficient estimates, poor forecasts
*
* Systematic Search Strategy
*
* We estimate a grid of candidate models and compare them using AIC and BIC:
*
* Candidate Set:
* - Pure AR models: ARMA(1,0) through ARMA(6,0)
* - Pure MA models: ARMA(0,1) through ARMA(0,3)
* - ARMA: ARMA(1,1) and ARMA(2,1)
*
* Selection Criterion:
* Optimal model = arg min_{(p,q)} AIC(p,q)  or  arg min_{(p,q)} BIC(p,q)
*
* Expected Pattern: For financial volatility series with long memory (persistent 
* autocorrelation) and transient shocks, we typically expect:
* - Low-order AR terms (capture persistence)
* - Low-order MA terms (capture shock absorption)

* ARMA Model Selection - Compare different specifications
* We'll estimate AR(1) through AR(6), MA(1) through MA(3), and mixed ARMA models

display "ARMA Model Selection for Log-VIX"
display "=================================="
display ""

* Create a matrix to store results
matrix results = J(11, 4, .)  // Initialize 11x4 matrix with missing values
matrix colnames results = "p" "q" "AIC" "BIC"  // Name columns for AR order, MA order, AIC, and BIC

local row = 1  // Initialize row counter for matrix storage

* AR models: ARMA(p,0) for p=1 to 6
forvalues p = 1/6 {  // Loop through AR orders from 1 to 6
    quietly arima lgvix, ar(1/`p') vce(robust)  // Estimate AR(p) model with robust standard errors
    estat ic  // Compute information criteria
    matrix temp = r(S)  // Store results matrix
    matrix results[`row', 1] = `p'  // Store AR order
    matrix results[`row', 2] = 0  // Store MA order (zero for pure AR)
    matrix results[`row', 3] = temp[1,5]  // Extract and store AIC
    matrix results[`row', 4] = temp[1,6]  // Extract and store BIC
    local row = `row' + 1  // Increment row counter
}

* MA models: ARMA(0,q) for q=1 to 3
forvalues q = 1/3 {  // Loop through MA orders from 1 to 3
    quietly arima lgvix, ma(1/`q') vce(robust)  // Estimate MA(q) model with robust standard errors
    estat ic  // Compute information criteria
    matrix temp = r(S)  // Store results matrix
    matrix results[`row', 1] = 0  // Store AR order (zero for pure MA)
    matrix results[`row', 2] = `q'  // Store MA order
    matrix results[`row', 3] = temp[1,5]  // Extract and store AIC
    matrix results[`row', 4] = temp[1,6]  // Extract and store BIC
    local row = `row' + 1  // Increment row counter
}

* ARMA(1,1)
quietly arima lgvix, ar(1) ma(1) vce(robust)  // Estimate ARMA(1,1) model with robust standard errors
estat ic  // Compute information criteria
matrix temp = r(S)  // Store results matrix
matrix results[`row', 1] = 1  // Store AR order
matrix results[`row', 2] = 1  // Store MA order
matrix results[`row', 3] = temp[1,5]  // Extract and store AIC
matrix results[`row', 4] = temp[1,6]  // Extract and store BIC
local row = `row' + 1  // Increment row counter

* ARMA(2,1)
quietly arima lgvix, ar(1/2) ma(1) vce(robust)  // Estimate ARMA(2,1) model with robust standard errors
estat ic  // Compute information criteria
matrix temp = r(S)  // Store results matrix
matrix results[`row', 1] = 2  // Store AR order
matrix results[`row', 2] = 1  // Store MA order
matrix results[`row', 3] = temp[1,5]  // Extract and store AIC
matrix results[`row', 4] = temp[1,6]  // Extract and store BIC

* Display results
display ""
display "Model Selection Results:"
display "------------------------"
matrix list results, format(%9.4f)

* ----------------------------------------------------------------------------
* SECTION 2.5: ARMA(2,1) ESTIMATION AND INTERPRETATION
* ----------------------------------------------------------------------------

display "Section: ARMA(2,1) Estimation and Interpretation"
display ""

* The Selected Model
*
* Based on information criteria, we estimate the ARMA(2,1) specification:
*
* lgvix_t = phi_1*lgvix_{t-1} + phi_2*lgvix_{t-2} + epsilon_t + theta_1*epsilon_{t-1}
*
* Estimation Method: Maximum likelihood with robust standard errors (accounts for 
* potential heteroskedasticity and autocorrelation in residuals)
*
* Understanding the Components
*
* Coefficient Interpretation:
*
* 1. phi_1 (AR1 coefficient): Direct effect of yesterday's log-VIX on today
*    - Positive phi_1 → persistence (high volatility begets high volatility)
*    - Magnitude indicates strength of one-period memory
*
* 2. phi_2 (AR2 coefficient): Direct effect of two-day-ago log-VIX on today
*    - Controls for second-order dynamics
*    - Often smaller in magnitude than phi_1
*
* 3. theta_1 (MA1 coefficient): Effect of yesterday's forecast error (shock)
*    - Captures how quickly market absorbs new information
*    - Negative theta_1 → overshooting correction
*
* 4. Overall Persistence: phi_1 + phi_2 measures long-run memory
*    - If phi_1 + phi_2 ≈ 1 → high persistence (slow mean reversion)
*    - If phi_1 + phi_2 < 1 → stationary (required condition satisfied)
*
* Model Quality Indicators
*
* After estimation, check:
* - Statistical significance: p-values < 0.05 for all coefficients
* - Information criteria: Confirm AIC/BIC are among the lowest
* - Stationarity condition: Verify |phi_1 + phi_2| < 1

* Estimate ARMA(2,1) model for log-VIX
arima lgvix, ar(1/2) ma(1) vce(robust)  // Estimate ARMA(2,1) with AR(1), AR(2), and MA(1) terms using robust SE

* Display full estimation results
estat ic  // Display information criteria for model comparison

* Interpreting the ARMA(2,1) Results
*
* The estimation output provides crucial information about the fitted model:
*
* Model Equation (with estimated coefficients):
* lgvix_t = 2.905 + 1.705*lgvix_{t-1} - 0.707*lgvix_{t-2} + epsilon_t - 0.819*epsilon_{t-1}
*
* Coefficient Interpretation:
*
* | Parameter | Estimate | Std. Error | z-stat | Interpretation |
* |-----------|----------|------------|--------|----------------|
* | Constant  | 2.905    | 0.047      | 62.24*** | Long-run mean of log-VIX ≈ 2.905 (VIX ≈ 18.3) |
* | AR(1) phi_1 | 1.705 | 0.067      | 25.26*** | Strong positive persistence from previous day |
* | AR(2) phi_2 | -0.707 | 0.067     | -10.57*** | Negative second-order effect (oscillatory correction) |
* | MA(1) theta_1 | -0.819 | 0.055   | -14.98*** | Negative shock absorption (mean reversion mechanism) |
* | σ        | 0.062    | 0.001      | 64.61*** | Innovation standard deviation |
*
* All coefficients are significant at p < 0.001
*
* Key Insights:
*
* 1. Overall Persistence: phi_1 + phi_2 = 1.705 - 0.707 = 0.998
*    - Very close to 1, indicating high persistence (volatility shocks decay slowly)
*    - Process is stationary since |phi_1 + phi_2| < 1, but just barely
*    - Implies volatility is highly persistent but mean-reverting in the long run
*
* 2. Oscillatory Dynamics: The positive phi_1 and negative phi_2 create cyclical behavior
*    - High volatility today → even higher tomorrow (phi_1 > 1)
*    - But this is corrected by the negative phi_2 term
*    - Creates damped oscillations around the long-run mean
*
* 3. Shock Absorption: The negative MA(1) coefficient theta_1 = -0.819
*    - Indicates overshooting correction: positive shocks are followed by negative adjustments
*    - Market tends to overreact, then correct (mean reversion mechanism)
*    - Captures the "volatility clustering" phenomenon in financial markets
*
* 4. Long-Run Mean: VIX tends to revert to e^2.905 ≈ 18.3
*    - This represents the "normal" level of market fear/uncertainty
*    - Crisis periods (VIX > 30) eventually return to this baseline
*
* 5. Model Fit:
*    - AIC = -22,988.29, BIC = -22,952.73 (lower is better)
*    - All coefficients highly significant (z-stats > 10)
*    - Log-likelihood = 11,499.14
*
* Stationarity Check:
*
* For stationarity, we need:
* - |phi_1 + phi_2| < 1 ✓ (0.998 < 1)
* - phi_2 - phi_1 < 1 ✓ (-0.707 - 1.705 = -2.412 < 1)
* - -1 < phi_2 < 1 ✓ (-1 < -0.707 < 1)
*
* All conditions satisfied → The process is stationary, though the near-unit-root 
* behavior (phi_1 + phi_2 ≈ 1) suggests volatility is extremely persistent.

* ----------------------------------------------------------------------------
* SECTION 2.6: RESIDUAL DIAGNOSTICS
* ----------------------------------------------------------------------------

display "Section: Residual Diagnostics - Validating Model Adequacy"
display ""

* The Crucial Test
*
* Why Residual Checks Matter
*
* A well-specified ARMA model should capture all systematic patterns in the data. 
* If the model is correct, residuals hat{epsilon}_t should be white noise:
*
* hat{epsilon}_t ~ WN(0, sigma^2)  implies:
* - E[hat{epsilon}_t] = 0
* - Var(hat{epsilon}_t) = sigma^2
* - Cov(hat{epsilon}_t, hat{epsilon}_s) = 0  for all t ≠ s
*
* If residuals are NOT white noise → model is misspecified → inference is invalid
*
* Diagnostic Tools
*
* 1. ACF and PACF of Residuals
*    - Plot autocorrelations at multiple lags
*    - Ideal outcome: All spikes within confidence bands
*    - Problem signs: Significant spikes → remaining autocorrelation
*
* 2. Ljung-Box Q-Test
*    - Formal test for joint significance of autocorrelations
*    - H_0: No autocorrelation up to lag K
*    - H_1: At least one autocorrelation is non-zero
*
* Success Criteria:
* - ACF/PACF show no significant spikes
* - Ljung-Box test yields p-value > 0.05 → fail to reject white noise hypothesis
* - This validates that ARMA(2,1) has successfully captured all autocorrelation structure

* Get residuals from ARMA(2,1) model
predict resid_arma21, residuals  // Generate residuals from last estimated ARMA(2,1) model

* ACF of residuals
ac resid_arma21, ///
    lags(40) ///
    title("ARMA(2,1) Residuals - ACF", size(medium)) ///
    ytitle("Autocorrelation") ///
    xtitle("Lag") ///
    scheme(s2color)
/* graph export "../../output/arma21_resid_acf.png", replace width(1200) */

* PACF of residuals
pac resid_arma21, ///
    lags(40) ///
    title("ARMA(2,1) Residuals - PACF", size(medium)) ///
    ytitle("Partial Autocorrelation") ///
    xtitle("Lag") ///
    scheme(s2color)
/* graph export "../../output/arma21_resid_pacf.png", replace width(1200) */

* Ljung-Box Q-test for residual autocorrelation
wntestq resid_arma21, lags(20)  // Test for white noise in residuals up to lag 20
display ""
display "H0: No autocorrelation in residuals up to lag 20"
display ""
display "Interpretation:"
display "- If p-value > 0.05, we fail to reject H0 (residuals are white noise)"
display "- If p-value <= 0.05, we reject H0 (residuals show autocorrelation)"
display ""
display "Current result: p-value = 0.0009 < 0.05"
display "→ We REJECT H0: Residuals exhibit significant autocorrelation"
display "→ ARMA(2,1) may not fully capture all dynamics in the data"

* Interpreting the Ljung-Box Test Results
*
* Test Result Interpretation
*
* The Ljung-Box Q-test results show:
* - Q statistic = 45.8134
* - p-value = 0.0009 (< 0.05)
* - Conclusion: We REJECT H_0
*
* What this means:
*
* 1. Residuals are NOT white noise: The test detects significant autocorrelation 
*    in the residuals at lags up to 20
* 2. Model misspecification: ARMA(2,1) may not fully capture all dynamics in the 
*    log-VIX series
* 3. Possible explanations:
*    - Missing higher-order AR/MA terms
*    - Presence of conditional heteroskedasticity (volatility clustering) that ARMA cannot capture
*    - Non-linear dynamics requiring more sophisticated models
*    - Effects of the 1949 gaps in the time series on the test
*
* Note on gaps: The presence of 1949 gaps in the time series may affect the validity 
* of the Ljung-Box test, as it assumes a complete time series. The missing observations 
* could potentially distort the autocorrelation patterns.
*
* Next Steps:
*
* While the ARMA(2,1) model may be adequate for short-term forecasting (as shown in 
* the out-of-sample evaluation), the Ljung-Box test suggests that:
* - For a complete diagnostic picture, examine ACF/PACF plots of residuals more carefully
* - Consider exploring GARCH models to capture volatility clustering
* - The model still provides useful forecasts despite this diagnostic failure, which 
*   is common in financial time series

* ----------------------------------------------------------------------------
* SECTION 2.7: OUT-OF-SAMPLE FORECASTING AND EVALUATION
* ----------------------------------------------------------------------------

display "Section: Out-of-Sample Forecasting and Evaluation"
display ""

* From Fitting to Forecasting
*
* While in-sample diagnostics validate model specification, out-of-sample forecasting 
* tests the model's practical value:
* - Can the model predict future VIX values accurately?
* - How does forecast accuracy deteriorate as the horizon increases?
*
* Dynamic Forecasting Framework
*
* We employ dynamic multi-step forecasting:
*
* hat{Y}_{T+h|T} = hat{phi}_1*hat{Y}_{T+h-1|T} + hat{phi}_2*hat{Y}_{T+h-2|T} + hat{theta}_1*hat{epsilon}_{T+h-1|T}
*
* where:
* - hat{Y}_{T+h|T} is the h-step ahead forecast made at time T
* - Past forecasts replace actual values as horizon extends
* - Forecast errors compound, widening confidence intervals
*
* Confidence Intervals:
* 95% CI: hat{Y}_{T+h|T} ± 1.96 × sqrt(MSE(h))
*
* Performance Metrics
*
* Forecast Accuracy Measures:
*
* 1. Mean Error (ME): (1/n)*sum(Y_t - hat{Y}_t)
*    - Measures bias (should be ≈ 0 for unbiased forecasts)
*
* 2. Mean Absolute Error (MAE): (1/n)*sum|Y_t - hat{Y}_t|
*    - Average magnitude of errors (lower = better)
*
* 3. Root Mean Squared Error (RMSE): sqrt((1/n)*sum(Y_t - hat{Y}_t)^2)
*    - Penalizes large errors more heavily
*    - Standard metric for comparing forecast methods
*
* Interpretation Guidelines
*
* Good forecasts exhibit:
* - ME close to zero (unbiased)
* - Low MAE and RMSE relative to series volatility
* - Most actual values within 95% confidence bands
* - Errors that don't exhibit systematic patterns (no autocorrelation)

* Create a sample split for out-of-sample forecasting
* Use data up to end of 2014 for estimation, forecast into Jan 2015

* First, identify the last observation in 2014
summarize date  // Display summary of date variable
gen year = year(date)  // Extract year from date variable
gen month = month(date)  // Extract month from date variable

* Save last date in dataset for reference
quietly summarize date  // Compute date summary statistics without output
local last_date = r(max)  // Store maximum date value in local macro

* Re-estimate ARMA(2,1) on full sample for forecasting
arima lgvix, ar(1/2) ma(1) vce(robust)  // Re-estimate ARMA(2,1) model for forecasting

* Generate forecasts for next 20 periods (approximately 1 month of trading days)
predict lgvix_forecast, dynamic(td(01jan2015))  // Generate dynamic forecasts starting Jan 1, 2015
predict lgvix_se, mse  // Generate mean squared error estimates for confidence intervals

* Convert forecasts back to VIX level
gen vix_forecast = exp(lgvix_forecast)  // Transform log-VIX forecasts back to VIX level

* Calculate confidence intervals
gen lgvix_lb = lgvix_forecast - 1.96*sqrt(lgvix_se)  // Calculate lower bound of 95% CI in log scale
gen lgvix_ub = lgvix_forecast + 1.96*sqrt(lgvix_se)  // Calculate upper bound of 95% CI in log scale
gen vix_lb = exp(lgvix_lb)  // Transform lower bound to VIX level
gen vix_ub = exp(lgvix_ub)  // Transform upper bound to VIX level

* Display forecast statistics
display "Out-of-Sample Forecast Summary"
display "==============================="
summarize vix vix_forecast if date >= td(01jan2015) & date <= td(31jan2015)

* Plot forecasts vs actual values for January 2015
twoway (line vix date if date >= td(01dec2014) & date <= td(31jan2015), lcolor(blue) lwidth(medium)) ///
       (line vix_forecast date if date >= td(01dec2014) & date <= td(31jan2015), lcolor(red) lpattern(dash) lwidth(medium)) ///
       (rarea vix_lb vix_ub date if date >= td(01jan2015) & date <= td(31jan2015), fcolor(red%20) lwidth(none)), ///
    title("VIX Out-of-Sample Forecasts vs Actual", size(medium)) ///
    subtitle("ARMA(2,1) Model - January 2015") ///
    ytitle("VIX Index") ///
    xtitle("Date") ///
    tlabel(01dec2014(15)31jan2015, format(%tdCY)) ///
    legend(order(1 "Actual VIX" 2 "Forecast" 3 "95% CI") rows(1)) ///
    scheme(s2color)
/* graph export "../../output/vix_forecast.png", replace width(1200) */

* Calculate forecast accuracy metrics
gen forecast_error = vix - vix_forecast if date >= td(01jan2015) & date <= td(31jan2015)  // Compute forecast errors for January 2015
gen abs_error = abs(forecast_error)  // Calculate absolute value of forecast errors
gen squared_error = forecast_error^2  // Calculate squared forecast errors

quietly summarize forecast_error if date >= td(01jan2015) & date <= td(31jan2015)  // Compute mean error statistics
local me = r(mean)  // Store mean error in local macro
quietly summarize abs_error if date >= td(01jan2015) & date <= td(31jan2015)  // Compute mean absolute error statistics
local mae = r(mean)  // Store mean absolute error in local macro
quietly summarize squared_error if date >= td(01jan2015) & date <= td(31jan2015)  // Compute mean squared error statistics
local mse = r(mean)  // Store mean squared error in local macro
local rmse = sqrt(`mse')  // Calculate root mean squared error from MSE

display ""
display "Forecast Accuracy Metrics (January 2015):"
display "=========================================="
display "Mean Error (ME):           " %8.4f `me'
display "Mean Absolute Error (MAE): " %8.4f `mae'
display "Root Mean Squared Error:   " %8.4f `rmse'
display ""
display "Interpretation:"
display "- ME close to 0 suggests unbiased forecasts"
display "- Lower MAE and RMSE indicate better forecast accuracy"

* ----------------------------------------------------------------------------
* CLOSING
* ----------------------------------------------------------------------------

* Close log file
log close  // Close log file

display "============================================================================"
display "Script completed"
display "============================================================================"

