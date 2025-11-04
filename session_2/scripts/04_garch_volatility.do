/*
================================================================================
TOPIC 4: GARCH Models and Volatility Modeling
CEMFI Advanced Training School - Methods for Time Series
Practical Session 2
================================================================================

This script demonstrates:
1. ARCH/GARCH model estimation
2. GARCH variants (EGARCH, TGARCH)
3. Multivariate GARCH (BEKK, DCC)
4. Volatility forecasting
5. Principal Component Analysis for covariance structures

Data: Financial returns (stocks, FX, commodities)
*/

* ============================================================================
* SETUP
* ============================================================================

clear all
set more off
set seed 12345

* Set working directory
cd "../../data/processed"

* Install required packages
* ssc install garch, replace
* ssc install mgarch, replace
* ssc install dvech, replace

* ============================================================================
* PART 1: UNIVARIATE GARCH MODELS
* ============================================================================

* ----------------------------------------------------------------------------
* 1.1 Data Loading and Preparation
* ----------------------------------------------------------------------------

* Load financial return data
* Example: S&P 500 returns or FX returns
* use returns_data.dta, clear
* tsset date

* Variables:
* - returns: Daily returns (log differences)
* - Other series: stock2, fx_return, etc.

* Summary statistics
summarize returns, detail

* ----------------------------------------------------------------------------
* 1.2 Test for ARCH Effects
* ----------------------------------------------------------------------------

* First, estimate ARMA model (or just use returns directly)
* regress returns  // Mean equation (may be just constant or include ARMA)

* Test for ARCH effects in residuals
predict residuals, residuals
gen residuals_sq = residuals^2

* Ljung-Box test on squared residuals
wntestq residuals_sq, lags(10)

* Engle's LM test for ARCH
estat archlm, lags(1/5)
* If p-value < 0.05 → ARCH effects present → GARCH model needed

* ----------------------------------------------------------------------------
* 1.3 ARCH Model Estimation
* ----------------------------------------------------------------------------

* Estimate ARCH(1) model
arch returns, arch(1)

* Estimate ARCH(q) model
arch returns, arch(1/5)  // ARCH(5)

* Display results and information criteria
estat ic

* ----------------------------------------------------------------------------
* 1.4 GARCH Model Estimation
* ----------------------------------------------------------------------------

* GARCH(1,1) is the most common specification
* Model: σ²_t = ω + α*ε²_{t-1} + β*σ²_{t-1}

* Estimate GARCH(1,1)
arch returns, arch(1) garch(1)
estat ic
estimates store garch11

* Estimate GARCH with ARMA in mean equation
arch returns L.returns, arch(1) garch(1)  // AR(1)-GARCH(1,1)

* Estimate GARCH(2,2)
arch returns, arch(1/2) garch(1/2)
estat ic
estimates store garch22

* Compare models
estimates stats garch11 garch22

* ----------------------------------------------------------------------------
* 1.5 GARCH Variants
* ----------------------------------------------------------------------------

* EGARCH (Exponential GARCH) - captures asymmetry
* Allows negative shocks to have different impact than positive shocks
arch returns, earch(1) egarch(1)
* Leverage effect: negative returns increase volatility more
estat ic
estimates store egarch

* TGARCH/GTARCH (Threshold GARCH) - alternative asymmetry model
* arch returns, arch(1) garch(1) tarch(1)
* Allows different ARCH coefficients for positive/negative shocks

* GJR-GARCH (Glosten-Jagannathan-Runkle)
* Similar to TGARCH, asymmetric response to shocks

* ----------------------------------------------------------------------------
* 1.6 Predict Volatility
* ----------------------------------------------------------------------------

* After GARCH estimation, predict conditional variance
predict cond_var, variance

* Predict conditional standard deviation (volatility)
predict cond_vol, variance
replace cond_vol = sqrt(cond_vol)

* Plot volatility
tsline cond_vol, title("Conditional Volatility from GARCH(1,1)") ///
    ytitle("Volatility") xtitle("Date")

* Compare with squared returns (proxy for realized volatility)
gen returns_sq = returns^2
tsline cond_var returns_sq, title("Conditional Variance vs Squared Returns")

* ----------------------------------------------------------------------------
* 1.7 Volatility Forecasting
* ----------------------------------------------------------------------------

* Forecast volatility h steps ahead
* First, estimate model on training sample
* preserve
* keep if date <= cutoff_date
* arch returns, arch(1) garch(1)
*
* * Forecast variance
* predict forecast_var, variance dynamic(cutoff_date)  // Forecast from cutoff
* restore

* ----------------------------------------------------------------------------
* 1.8 Model Diagnostics
* ----------------------------------------------------------------------------

* Test standardized residuals for remaining ARCH effects
predict residuals_garch, residuals
predict cond_var_garch, variance
gen std_residuals = residuals_garch / sqrt(cond_var_garch)

* Ljung-Box test on standardized residuals
wntestq std_residuals, lags(10)

* Test squared standardized residuals (should be white noise)
gen std_residuals_sq = std_residuals^2
wntestq std_residuals_sq, lags(10)

* Normality test of standardized residuals
swilk std_residuals
histogram std_residuals, normal title("Standardized Residuals")

* ============================================================================
* PART 2: MULTIVARIATE GARCH MODELS
* ============================================================================

* ----------------------------------------------------------------------------
* 2.1 Data Preparation
* ----------------------------------------------------------------------------

* Load multiple return series
* Example: Stock, bond, commodity, FX returns
* use portfolio_returns.dta, clear
* tsset date

* Variables:
* - stock_return
* - bond_return
* - commodity_return
* - fx_return

* ----------------------------------------------------------------------------
* 2.2 Dynamic Conditional Correlation (DCC) GARCH
* ----------------------------------------------------------------------------

* DCC allows time-varying correlations while keeping parsimony
* Two-step estimation: first univariate GARCH, then correlation

* Estimate DCC-GARCH
mgarch dcc (stock_return bond_return = , noconstant), ///
    arch(1) garch(1)

* Predict conditional covariances and correlations
predict H*, variance
predict corr_stock_bond, corr(stock_return bond_return)

* Plot dynamic correlation
tsline corr_stock_bond, title("Dynamic Correlation: Stock-Bond") ///
    ytitle("Correlation") xtitle("Date") ///
    note("Time-varying correlation from DCC-GARCH")

* ----------------------------------------------------------------------------
* 2.3 BEKK GARCH
* ----------------------------------------------------------------------------

* BEKK is more general but less parsimonious
* Guarantees positive definite covariance matrix

* Estimate BEKK-GARCH
mgarch bekk (stock_return bond_return = , noconstant), arch(1) garch(1)

* Predict covariances
predict H*, variance

* ----------------------------------------------------------------------------
* 2.4 Constant Conditional Correlation (CCC) GARCH
* ----------------------------------------------------------------------------

* Simpler model: constant correlations, time-varying variances
mgarch ccc (stock_return bond_return = , noconstant), arch(1) garch(1)

* Use when correlations are stable over time

* ----------------------------------------------------------------------------
* 2.5 Portfolio Volatility
* ----------------------------------------------------------------------------

* After estimating multivariate GARCH, compute portfolio volatility
* Portfolio weights (example: 60% stock, 40% bond)
scalar w_stock = 0.6
scalar w_bond = 0.4

* Predict portfolio variance: σ²_p = w'*H*w
* Where H is conditional covariance matrix, w is weight vector

* This requires matrix operations (see Stata matrix commands)
* Can compute for each time period

* ============================================================================
* PART 3: PRINCIPAL COMPONENT ANALYSIS (PCA)
* ============================================================================

* ----------------------------------------------------------------------------
* 3.1 PCA for Portfolio Construction
* ----------------------------------------------------------------------------

* Use PCA to reduce dimension of covariance matrix
* Extract principal components (factors) from return covariance

* Prepare data: correlation matrix or covariance matrix
* First compute sample covariance/correlation matrix
* corr stock_return bond_return commodity_return fx_return, means

* Principal components analysis
pca stock_return bond_return commodity_return fx_return

* Display eigenvalues and eigenvectors
* Eigenvalues show variance explained by each component
* First few components typically explain most variance

* Predict principal components (scores)
predict pc1 pc2 pc3 pc4, score

* ----------------------------------------------------------------------------
* 3.2 Scree Plot and Variance Explained
* ----------------------------------------------------------------------------

* Scree plot shows eigenvalues
screeplot, title("Scree Plot: Principal Components")

* Proportion of variance explained
* estat loadings
* Display to see variance explained by each component

* ----------------------------------------------------------------------------
* 3.3 Portfolio Construction Using PCA
* ----------------------------------------------------------------------------

* Use first few principal components to model covariance structure
* Reduces dimension from N assets to k factors (k << N)

* Factor model: r_t = Λ * f_t + ε_t
* Where Λ is factor loading matrix, f_t are principal components

* This can be used for portfolio optimization with reduced dimensions

* ============================================================================
* PART 4: VOLATILITY MODELING COMPARISON
* ============================================================================

* ----------------------------------------------------------------------------
* 4.1 Compare Different GARCH Specifications
* ----------------------------------------------------------------------------

* Estimate multiple models
arch returns, arch(1) garch(1)
estat ic
estimates store garch11

arch returns, earch(1) egarch(1)
estat ic
estimates store egarch

* Compare using information criteria
estimates stats garch11 egarch

* ----------------------------------------------------------------------------
* 4.2 Out-of-Sample Forecasting Comparison
* ----------------------------------------------------------------------------

* Split sample into estimation and forecast periods
* Estimate on training sample, forecast on test sample
* Compare forecast accuracy (MSE, MAE, etc.)

* ----------------------------------------------------------------------------
* 4.3 Realized Volatility Comparison
* ----------------------------------------------------------------------------

* Compare GARCH volatility with realized volatility (if available)
* Realized volatility: sum of intraday squared returns
* Can also use daily squared returns as proxy

gen realized_vol = sqrt(returns_sq)

* Compare GARCH forecast with realized
* tsline cond_vol realized_vol, title("GARCH vs Realized Volatility")

* ============================================================================
* INTERPRETATION AND SUMMARY
* ============================================================================

/*
PRACTICAL INSIGHTS:

Univariate GARCH:
- GARCH models capture volatility clustering (high volatility followed by high)
- Financial returns show ARCH effects (heteroskedasticity)
- GARCH(1,1) is often sufficient and widely used
- EGARCH/TGARCH capture leverage effect (asymmetry)
- Volatility forecasts are important for risk management and VaR

Multivariate GARCH:
- Needed for portfolio risk management
- DCC is popular: flexible yet parsimonious
- BEKK is more general but has many parameters
- Time-varying correlations important (e.g., flight to quality in crises)

Volatility Forecasting:
- GARCH models provide volatility forecasts
- Important for:
  * Risk management (VaR, CVaR)
  * Option pricing
  * Portfolio optimization
  * Hedge ratios

PCA:
- Dimension reduction for large portfolios
- Identify common risk factors
- Useful when N (assets) is large relative to T (observations)

PRACTICAL TIPS:

1. Always test for ARCH effects first
   - Use Engle's LM test
   - If no ARCH effects, GARCH may not be needed

2. GARCH(1,1) is often sufficient
   - Parsimonious and performs well
   - Only use higher orders if diagnostics suggest

3. Check standardized residuals
   - Should be white noise
   - Should be approximately normal
   - If not, consider alternative distributions (t-distribution, etc.)

4. Volatility forecasting
   - GARCH volatility is conditional (changes over time)
   - Long-run volatility is unconditional variance
   - Forecasts converge to long-run volatility

5. Multivariate models
   - Start with DCC (more manageable)
   - BEKK for smaller systems
   - Consider CCC if correlations are stable

6. Computational considerations
   - Multivariate GARCH can be computationally intensive
   - Start with 2-3 assets, then expand
   - Convergence issues more common with many assets
*/

* ============================================================================
* END OF SCRIPT
* ============================================================================

* Save results
* estimates save garch_results, replace
