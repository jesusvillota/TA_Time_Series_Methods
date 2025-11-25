* ============================================================================
* ARMA MODEL ESTIMATION AND SELECTION
* ============================================================================
*
* Script: 1_2_arma_models.do
* Purpose: ARMA Model Estimation and Selection
* Session: Session 1 • Part 2
* Author: Jesus Villota Miranda
* Date: 2025
*
* This script replicates exercises from the corresponding notebook:
* 1_2_arma_models.ipynb
*
* ============================================================================

* ----------------------------------------------------------------------------
* SETUP
* ----------------------------------------------------------------------------

clear all  // Clear memory and remove all variables
set more off  // Display all output without pausing
set seed 12345  // Set random seed for reproducibility

* Define paths (relative to dofiles/session1 directory)
global processed_data "../../data/processed"  // Path to processed data

* Create log file
log using "1_2_arma_models.log", replace text  // Start log file

display "============================================================================"
display "ARMA MODEL ESTIMATION AND SELECTION"
display "============================================================================"
display ""

* Session #1 • Part 2
*
* Linear Time Series Models
* -->
*
* ARMA Model Estimation and Selection
*
* Advanced Training School: Methods for Time Series
*
* Jesus Villota Miranda © 2025
*
* jesus.villota@cemfi.edu.es
* |
* LinkedIn

* 2.1 VIX Historical Evolution and Distribution
*
* #### Initial Data Exploration
*
* We begin by loading daily VIX data spanning **January 1990 to November 2025**, examining its temporal evolution and distributional characteristics.
*
* **What to Look For:**
* - **Level shifts**: Major crisis periods (2000-02 dot-com, 2008-09 financial crisis)
* - **Volatility clustering**: High-volatility episodes tend to persist
* - **Distributional shape**: Skewness and kurtosis indicate departure from normality

* Load VIX data from processed file
global processed_data "../../data/processed"  // Define path to processed data directory
use "$processed_data/vix_daily.dta", clear  // Load VIX daily dataset and clear memory

* Display first and last observations
list date vix in 1/5
list date vix in -5/-1

* Display summary information
describe
summarize vix

* Summary statistics for VIX
quietly summarize vix, detail
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

* 2.2 Log-VIX Transformation
*
* #### Why Log Transformation?
*
* **⚠️ The Problem with Raw VIX**
*
* Raw VIX exhibits:
* - **Positive skewness**: Long right tail from crisis episodes
* - **Excess kurtosis**: Fat tails beyond normal distribution
* - **Heteroskedasticity**: Variance changes over time
*
* These properties violate ARMA assumptions requiring **approximate normality** and **constant variance**.
*
* #### The Log Transformation Solution
*
* The natural logarithm transformation addresses these issues:
*
* $
* \text{Log-VIX}_t = \ln(\text{VIX}_t)
* $
*
* **Benefits**:
* 1. **Variance stabilization**: Reduces heteroskedasticity by compressing large values
* 2. **Symmetry improvement**: Reduces right skewness toward normality
* 3. **Interpretability**: Changes in log-VIX approximate *percentage changes* in VIX
*
* **Key Takeaway**: Log transformation is standard practice when modeling financial volatility indices, making the data more suitable for linear time series models like ARMA.

* Create log-VIX transformation
/* generate lgvix = ln(vix)  // Create natural log transformation of VIX */
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

* 2.3 Unit Root Testing for Stationarity
*
* #### Why Stationarity Matters
*
* **Critical Requirement**
*
* ARMA models are **only valid** for **stationary** processes. A non-stationary series:
* - Has time-varying mean and/or variance
* - Leads to spurious regression results
* - Violates asymptotic distribution theory for inference
*
* #### The DF-GLS Test
*
* We employ the **DF-GLS (Dickey-Fuller GLS)** test, which is more powerful than the standard ADF test, especially for series with persistent autocorrelation.
*
* **Hypotheses**:
* $
* \begin{aligned}
* H_0 &: \text{Series has a unit root (non-stationary)} \\
* H_1 &: \text{Series is stationary}
* \end{aligned}
* $
*
* **Decision Rule**:
* - If test statistic $
*
* **Expected Result for Log-VIX**: Given the mean-reverting nature of volatility, we anticipate **rejecting the unit root hypothesis**, confirming log-VIX is stationary and suitable for ARMA modeling.

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

* #### Interpretation of Unit Root Results
*
* **🔍 What the Results Reveal:**
*
* 1. **Stationarity Confirmation**: Rejection of the unit root null hypothesis validates that log-VIX fluctuates around a stable mean with bounded variance
*
* 2. **ARMA Validity**: Stationarity ensures:
* - Autocorrelations decay to zero (necessary for ARMA identification)
* - Maximum likelihood estimation is consistent
* - Standard errors and hypothesis tests are asymptotically valid
*
* 3. **Economic Interpretation**: Volatility is **mean-reverting**—extreme levels (both high and low) tend to return to long-run average, a key property exploited by volatility traders

* 2.4 ARMA Model Selection Using Information Criteria
*
* #### The Model Selection Problem
*
* With confirmed stationarity, we face the challenge: **Which ARMA(p,q) specification best represents the data?**
*
* **The Trade-off**
*
* - **Too few lags**: Model is **underfit** → fails to capture all autocorrelation → biased estimates
* - **Too many lags**: Model is **overfit** → captures noise as signal → inefficient estimates, poor forecasts
*
* #### Systematic Search Strategy
*
* We estimate a grid of candidate models and compare them using AIC and BIC:
*
* **Candidate Set**:
* - Pure AR models: ARMA(1,0) through ARMA(6,0)
* - Pure MA models: ARMA(0,1) through ARMA(0,3)
* - Mixed ARMA: ARMA(1,1) and ARMA(2,1)
*
* **Selection Criterion**:
* $
* \text{Optimal model} = \arg\min_{(p,q)} \text{AIC}(p,q) \quad \text{or} \quad \arg\min_{(p,q)} \text{BIC}(p,q)
* $
*
* **Expected Pattern**: For financial volatility series with **long memory** (persistent autocorrelation) and **transient shocks**, we typically expect:
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

* 2.5 ARMA(2,1) Estimation and Interpretation
*
* #### The Selected Model
*
* Based on information criteria, we estimate the **ARMA(2,1)** specification:
*
* $
* \text{lgvix}_t = \phi_1 \cdot \text{lgvix}_{t-1} + \phi_2 \cdot \text{lgvix}_{t-2} + \varepsilon_t + \theta_1 \cdot \varepsilon_{t-1}
* $
*
* **Estimation Method**: Maximum likelihood with **robust standard errors** (accounts for potential heteroskedasticity and autocorrelation in residuals)
*
* #### Understanding the Components
*
* **🔍 Coefficient Interpretation**
*
* 1. **$\phi_1$ (AR1 coefficient)**: Direct effect of yesterday's log-VIX on today
* - Positive $\phi_1$ → persistence (high volatility begets high volatility)
* - Magnitude indicates strength of one-period memory
*
* 2. **$\phi_2$ (AR2 coefficient)**: Direct effect of two-day-ago log-VIX on today
* - Controls for second-order dynamics
* - Often smaller in magnitude than $\phi_1$
*
* 3. **$\theta_1$ (MA1 coefficient)**: Effect of yesterday's forecast error (shock)
* - Captures how quickly market absorbs new information
* - Negative $\theta_1$ → overshooting correction
*
* 4. **Overall Persistence**: $\phi_1 + \phi_2$ measures long-run memory
* - If $\phi_1 + \phi_2 \approx 1$ → high persistence (slow mean reversion)
* - If $\phi_1 + \phi_2
*
* #### Model Quality Indicators
*
* After estimation, check:
* - **Statistical significance**: $p$-values $< 0.05$ for all coefficients
* - **Information criteria**: Confirm AIC/BIC are among the lowest
* - **Stationarity condition**: Verify $|\phi_1 + \phi_2| < 1$

* Estimate ARMA(2,1) model for log-VIX
arima lgvix, ar(1/2) ma(1) vce(robust)  // Estimate ARMA(2,1) with AR(1), AR(2), and MA(1) terms using robust SE

* Display full estimation results
estat ic  // Display information criteria for model comparison

* Interpret ARMA(2,1) coefficients
display ""
display "ARMA(2,1) Model Interpretation:"
display "================================"
display "Model: lgvix_t = φ₁·lgvix_{t-1} + φ₂·lgvix_{t-2} + ε_t + θ₁·ε_{t-1}"
display ""
display "AR(1) coefficient (φ₁): Shows effect of previous period's log-VIX"
display "AR(2) coefficient (φ₂): Shows effect of two-period lagged log-VIX"
display "MA(1) coefficient (θ₁): Shows effect of previous period's shock"
display ""
display "Persistence: Sum of AR coefficients indicates overall persistence"
display "If |φ₁ + φ₂| < 1, the process is stationary"

* 2.6 Residual Diagnostics: Validating Model Adequacy
*
* #### The Crucial Test
*
* **Why Residual Checks Matter**
*
* A well-specified ARMA model should capture **all** systematic patterns in the data. If the model is correct, residuals $\hat{\varepsilon}_t$ should be **white noise**:
*
* $
* \hat{\varepsilon}_t \sim \text{WN}(0, \sigma^2) \quad \Rightarrow \quad \begin{cases}
* E[\hat{\varepsilon}_t] = 0 \\
* \text{Var}(\hat{\varepsilon}_t) = \sigma^2 \\
* \text{Cov}(\hat{\varepsilon}_t, \hat{\varepsilon}_s) = 0 \quad \forall t \neq s
* \end{cases}
* $
*
* **If residuals are NOT white noise** → model is misspecified → inference is invalid
*
* #### Diagnostic Tools
*
* **1. ACF and PACF of Residuals**
* - Plot autocorrelations at multiple lags
* - *Ideal outcome*: All spikes within confidence bands
* - *Problem signs*: Significant spikes → remaining autocorrelation
*
* **2. Ljung-Box Q-Test**
* - Formal test for joint significance of autocorrelations
* - $H_0$: No autocorrelation up to lag $K$
* - $H_1$: At least one autocorrelation is non-zero
*
* **Success Criteria**:
* - ACF/PACF show **no significant spikes**
* - Ljung-Box test yields **$p$-value $> 0.05$** → fail to reject white noise hypothesis
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
graph export "../../output/arma21_resid_pacf.png", replace width(1200)

* Ljung-Box Q-test for residual autocorrelation
wntestq resid_arma21, lags(20)  // Test for white noise in residuals up to lag 20
display "H0: No autocorrelation in residuals up to lag 20"
display "If p-value > 0.05, we fail to reject H0 (residuals are white noise)"

* 2.7 Fitted vs Empirical ACF/PACF Comparison
*
* #### Model Validation Through ACF Matching
*
* **The Theoretical Foundation**
*
* An ARMA model implies a **specific theoretical ACF pattern**. For ARMA(2,1):
*
* $
* \rho(k) = \text{Cov}(Y_t, Y_{t-k}) / \text{Var}(Y_t)
* $
*
* is determined by the estimated parameters $\hat{\phi}_1, \hat{\phi}_2, \hat{\theta}_1$.
*
* **Validation Logic**:
* - Compute ACF from **fitted values** generated by the model
* - Compare with ACF from **empirical data**
* - Close match → model captures true autocorrelation structure
* - Systematic deviations → model may be misspecified
*
* #### What to Examine
*
* 1. **Overall shape**: Do both ACFs decay at similar rates?
* 2. **Key lags**: Are lag-1, lag-2 autocorrelations similar?
* 3. **Tail behavior**: Does the fitted ACF converge to zero smoothly like the empirical ACF?
*
* **Expected Outcome**: For a correctly specified ARMA(2,1), the fitted ACF should closely track the empirical ACF across all lags, providing visual confirmation that the model has successfully replicated the data's correlation structure.

* Compare fitted ACF from ARMA(2,1) with empirical ACF
* First, compute empirical ACF values
quietly corrgram lgvix, lags(40)  // Compute correlogram for log-VIX up to 40 lags

* Get fitted values and compute their ACF
predict fitted_lgvix, xb  // Generate linear prediction (fitted values) from ARMA model
quietly corrgram fitted_lgvix, lags(40)  // Compute correlogram for fitted values up to 40 lags

display "The fitted ARMA(2,1) model should closely match the empirical ACF pattern"
display "Any systematic deviations suggest model misspecification"

* 2.8 Out-of-Sample Forecasting and Evaluation
*
* #### The Ultimate Test: Predictive Performance
*
* **From Fitting to Forecasting**
*
* While in-sample diagnostics validate model specification, **out-of-sample forecasting** tests the model's practical value:
* - Can the model predict future VIX values accurately?
* - How does forecast accuracy deteriorate as the horizon increases?
* - Are confidence intervals properly calibrated?
*
* #### Dynamic Forecasting Framework
*
* We employ **dynamic multi-step forecasting**:
*
* $
* \hat{Y}_{T+h|T} = \phi_1 \hat{Y}_{T+h-1|T} + \phi_2 \hat{Y}_{T+h-2|T} + \theta_1 \hat{\varepsilon}_{T+h-1|T}
* $
*
* where:
* - $\hat{Y}_{T+h|T}$ is the $h$-step ahead forecast made at time $T$
* - Past forecasts replace actual values as horizon extends
* - Forecast errors compound, widening confidence intervals
*
* **Confidence Intervals**:
* $
* \text{95\% CI: } \quad \hat{Y}_{T+h|T} \pm 1.96 \times \sqrt{\text{MSE}(h)}
* $
*
* #### Performance Metrics
*
* **Forecast Accuracy Measures**
*
* 1. **Mean Error (ME)**: $\frac{1}{n}\sum (Y_t - \hat{Y}_t)$
* - Measures bias (should be ≈ 0 for unbiased forecasts)
*
* 2. **Mean Absolute Error (MAE)**: $\frac{1}{n}\sum |Y_t - \hat{Y}_t|$
* - Average magnitude of errors (lower = better)
*
* 3. **Root Mean Squared Error (RMSE)**: $\sqrt{\frac{1}{n}\sum (Y_t - \hat{Y}_t)^2}$
* - Penalizes large errors more heavily
* - Standard metric for comparing forecast methods
*
* #### Interpretation Guidelines
*
* **Good forecasts exhibit**:
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
graph export "../../output/vix_forecast.png", replace width(1200)

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

* Summary: Complete ARMA Modeling Workflow for VIX
*
* #### 🎯 Key Findings and Lessons
*
* **1. Data Preparation and Transformation**
* - **Raw VIX characteristics**: Highly right-skewed distribution with extreme volatility spikes during financial crises (2000-02, 2008-09)
* - **Log transformation**: Successfully normalizes distribution, reduces skewness from severe to moderate, and stabilizes variance
* - **Lesson**: Transformations are essential preprocessing steps for non-normal financial data
*
* **2. Stationarity Verification**
* - **DF-GLS test results**: Strong rejection of unit root hypothesis for log-VIX
* - **Implication**: Volatility exhibits mean reversion—periods of extreme values (high or low) are temporary
* - **Practical insight**: This mean-reverting property is exploited in volatility arbitrage strategies
*
* **3. Model Selection Process**
* - **Systematic comparison**: Evaluated pure AR (up to order 6), pure MA (up to order 3), and mixed ARMA specifications
* - **Winner: ARMA(2,1)**: Minimizes both AIC and BIC, capturing:
* - Two-period autoregressive memory ($\phi_1$, $\phi_2$)
* - One-period moving average shock absorption ($\theta_1$)
* - **Parsimony principle**: Adding more parameters didn't improve fit enough to offset complexity penalty
*
* **4. Model Adequacy Validation**
* - **Residual diagnostics**:
* - ACF/PACF show no significant autocorrelation → all structure captured
* - Ljung-Box Q-test confirms white noise residuals ($p > 0.05$)
* - **Fitted vs empirical ACF**: Close alignment confirms theoretical model matches empirical patterns
* - **Conclusion**: ARMA(2,1) is a well-specified, parsimonious representation
*
* **5. Forecasting Performance**
* - **Out-of-sample testing**: Dynamic forecasts for January 2015 demonstrate:
* - ME ≈ 0 → forecasts are approximately unbiased
* - Reasonable MAE and RMSE given VIX volatility
* - Most actual values fall within 95% confidence intervals
* - **Practical value**: Model provides useful short-term volatility forecasts for risk management
*
* #### 💡 Broader Implications
*
* **For Practitioners**:
* 1. **Risk Management**: VIX forecasts enable better Value-at-Risk (VaR) and Expected Shortfall calculations
* 2. **Portfolio Hedging**: Predict when to increase/decrease option-based volatility hedges
* 3. **Trading Strategies**: Mean reversion property suggests contrarian volatility positions
*
* **For Researchers**:
* 1. **Baseline Model**: ARMA(2,1) serves as benchmark for more complex models (GARCH, stochastic volatility)
* 2. **Limitations**: ARMA doesn't capture:
* - Volatility clustering (conditional heteroskedasticity) → use GARCH extensions
* - Non-linear dynamics → use threshold or regime-switching models
* - Leverage effects → use asymmetric volatility models
* 3. **Next Steps**: Session 2 explores GARCH family models that address these limitations
*
* #### ⚠️ Important Caveats
*
* - **Sample period**: Results based on 1990-2015 data; structural changes in volatility dynamics may occur
* - **Normal times bias**: Model estimated during relatively calm periods may underpredict in true crisis
* - **Forecast horizon**: Accuracy deteriorates rapidly beyond 5-10 days due to error compounding
* - **Model class**: Linear ARMA cannot capture the non-linear volatility dynamics that GARCH models address (covered in Session 2)
*
* #### What We Learned About the Complete ARMA Workflow
*
* This exercise demonstrated the **seven essential steps** of rigorous time series modeling:
*
* 1. ✅ **Explore** → Visualize temporal patterns and distributions
* 2. ✅ **Transform** → Apply necessary transformations for normality
* 3. ✅ **Test** → Verify stationarity prerequisites
* 4. ✅ **Select** → Compare candidate models systematically
* 5. ✅ **Estimate** → Fit chosen model with appropriate inference
* 6. ✅ **Diagnose** → Validate through comprehensive residual checks
* 7. ✅ **Forecast** → Evaluate predictive performance out-of-sample
*
* **Mastering this workflow** provides the foundation for modeling any stationary time series, from macroeconomic indicators to financial asset returns.


* Close log file
log close  // Close log file

display "============================================================================"
display "Script completed"
display "============================================================================"