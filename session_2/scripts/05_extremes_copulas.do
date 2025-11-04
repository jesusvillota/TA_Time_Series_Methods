/*
================================================================================
TOPIC 5: Extreme Value Theory and Copulas
CEMFI Advanced Training School - Methods for Time Series
Practical Session 2
================================================================================

This script demonstrates:
1. Extreme Value Theory (GEV, GPD)
2. Value at Risk (VaR) and Conditional VaR (CVaR)
3. Copula functions for dependence modeling
4. Tail dependence estimation
5. Applications to financial crisis periods

Data: Financial returns during crisis periods, multiple asset returns
*/

* ============================================================================
* SETUP
* ============================================================================

clear all
set more off
set seed 12345

* Set working directory
cd "../../data/processed"

* Install required packages (if available)
* Note: Stata has limited built-in support for EVT and copulas
* May need to install user-written packages or use other software
* ssc install extreme, replace  // If available
* ssc install copula, replace   // If available

* ============================================================================
* PART 1: EXTREME VALUE THEORY
* ============================================================================

* ----------------------------------------------------------------------------
* 1.1 Data Loading
* ----------------------------------------------------------------------------

* Load financial return data (preferably crisis periods)
* use crisis_returns.dta, clear
* tsset date

* Focus on tail events - negative returns (losses)
* gen losses = -returns  // Convert returns to losses for EVT

* Or focus on extreme observations
* Example: Use only returns below 5th percentile
* summarize returns, detail
* local threshold = r(p5)
* gen extreme_returns = returns if returns <= `threshold'

* ----------------------------------------------------------------------------
* 1.2 Block Maxima Approach - Generalized Extreme Value (GEV)
* ----------------------------------------------------------------------------

* GEV distribution: F(x) = exp{ -[1 + ξ*(x-μ)/σ]^(-1/ξ) }

* Divide data into blocks (e.g., monthly or yearly)
* Extract maximum (or minimum) from each block

* Create block maxima
* egen year = year(date)
* egen month = month(date)
*
* * Monthly maxima of losses
* egen monthly_max_loss = max(losses), by(year month)

* If you have user-written package:
* gevfit monthly_max_loss
* Or use maximum likelihood estimation manually

* ----------------------------------------------------------------------------
* 1.3 Peak Over Threshold (POT) - Generalized Pareto Distribution (GPD)
* ----------------------------------------------------------------------------

* GPD: More efficient than block maxima
* Model exceedances over threshold u: P(X-u > y | X > u)

* Select threshold (critical step)
* Can use mean excess plot or other methods
* Example: use 95th percentile as threshold
summarize losses, detail
local threshold = r(p95)

* Extract exceedances
gen exceedances = losses - `threshold' if losses > `threshold'

* Estimate GPD parameters (if package available)
* gpdfit exceedances

* ----------------------------------------------------------------------------
* 1.4 Estimating Tail Index
* ----------------------------------------------------------------------------

* Tail index (ξ) determines tail behavior:
* - ξ > 0: Heavy tails (Pareto-type)
* - ξ = 0: Exponential tails (normal-like)
* - ξ < 0: Bounded tails

* Hill estimator (for heavy tails)
* ssc install hill, replace  // If available
* hill losses, threshold(`threshold')

* ----------------------------------------------------------------------------
* 1.5 Quantile Estimation
* ----------------------------------------------------------------------------

* Estimate high quantiles (e.g., 99th percentile)
* Using EVT, can extrapolate beyond observed data

* If GPD fitted:
* VaR_α = u + (σ/ξ) * [((n_u/n)*(1-α))^(-ξ) - 1]
* Where:
* - u: threshold
* - n_u: number of exceedances
* - n: total observations
* - α: confidence level (e.g., 0.01 for 99% VaR)

* ============================================================================
* PART 2: VALUE AT RISK (VaR) AND CONDITIONAL VaR (CVaR)
* ============================================================================

* ----------------------------------------------------------------------------
* 2.1 Parametric VaR (Normal Distribution)
* ----------------------------------------------------------------------------

* Simplest approach: assume returns ~ N(μ, σ²)
* VaR_α = μ + σ * Φ^(-1)(α)
* Where Φ^(-1)(α) is quantile of standard normal

summarize returns, detail
scalar mu = r(mean)
scalar sigma = r(sd)

* 95% VaR (5% quantile)
scalar var_95_normal = mu + sigma * invnormal(0.05)
display "95% VaR (Normal): " var_95_normal

* 99% VaR
scalar var_99_normal = mu + sigma * invnormal(0.01)
display "99% VaR (Normal): " var_99_normal

* ----------------------------------------------------------------------------
* 2.2 Historical Simulation VaR
* ----------------------------------------------------------------------------

* Non-parametric: use empirical quantile
* VaR = α-th quantile of returns

* 95% VaR (5th percentile)
summarize returns, detail
scalar var_95_historical = r(p5)
display "95% VaR (Historical): " var_95_historical

* 99% VaR (1st percentile)
scalar var_99_historical = r(p1)
display "99% VaR (Historical): " var_99_historical

* ----------------------------------------------------------------------------
* 2.3 VaR using GARCH Volatility
* ----------------------------------------------------------------------------

* Combine GARCH volatility with VaR
* VaR_α,t = μ_t + σ_t * z_α
* Where σ_t is conditional volatility from GARCH

* First estimate GARCH (from Topic 4)
* arch returns, arch(1) garch(1)
* predict cond_vol, variance
* replace cond_vol = sqrt(cond_vol)

* Estimate conditional mean (if non-zero)
* predict cond_mean, xb

* Compute VaR for each period
* gen var_95_garch = cond_mean + cond_vol * invnormal(0.05)
* gen var_99_garch = cond_mean + cond_vol * invnormal(0.01)

* Plot VaR
* tsline returns var_95_garch, title("Returns and 95% VaR (GARCH)") ///
*     yline(0) legend(label(1 "Returns") label(2 "VaR"))

* ----------------------------------------------------------------------------
* 2.4 Conditional VaR (CVaR / Expected Shortfall)
* ----------------------------------------------------------------------------

* CVaR = E[Returns | Returns < VaR]
* Average loss given that loss exceeds VaR

* Historical CVaR
* gen var_95_flag = (returns <= var_95_historical)
* summarize returns if var_95_flag == 1
* scalar cvar_95_historical = r(mean)

* ----------------------------------------------------------------------------
* 2.5 VaR Backtesting
* ----------------------------------------------------------------------------

* Check if VaR model performs well
* Count violations (returns < VaR)
gen violations_95 = (returns < var_95_garch) if !missing(var_95_garch)

* Expected violations: α * T (e.g., 5% of observations)
* Actual violations should be close to expected

* Kupiec test (unconditional coverage)
* Tests if violation rate equals α

* ============================================================================
* PART 3: COPULA FUNCTIONS
* ============================================================================

* ----------------------------------------------------------------------------
* 3.1 Motivation for Copulas
* ----------------------------------------------------------------------------

* Copulas model dependence structure separately from marginals
* C(u₁, u₂, ..., uₙ) = P(U₁ ≤ u₁, U₂ ≤ u₂, ..., Uₙ ≤ uₙ)
* Where Uᵢ = Fᵢ(Xᵢ) are uniform transforms

* Allows modeling nonlinear dependence and tail dependence

* ----------------------------------------------------------------------------
* 3.2 Gaussian Copula
* ----------------------------------------------------------------------------

* Simplest copula, but no tail dependence
* If you have copula package:
* copula gaussian returns1 returns2

* ----------------------------------------------------------------------------
* 3.3 t-Copula
* ----------------------------------------------------------------------------

* Allows tail dependence (more realistic for finance)
* copula t returns1 returns2

* ----------------------------------------------------------------------------
* 3.4 Archimedean Copulas
* ----------------------------------------------------------------------------

* Include Clayton, Gumbel, Frank copulas
* Different tail dependence properties:
* - Clayton: lower tail dependence
* - Gumbel: upper tail dependence
* - Frank: symmetric, no tail dependence

* If package available:
* copula clayton returns1 returns2
* copula gumbel returns1 returns2

* ----------------------------------------------------------------------------
* 3.5 Estimating Copula Parameters
* ----------------------------------------------------------------------------

* Two-step procedure:
* 1. Estimate marginal distributions F₁, F₂, ...
* 2. Transform to uniform: Uᵢ = Fᵢ(Xᵢ)
* 3. Estimate copula on uniform marginals

* Example for two series:
* Step 1: Estimate marginals (e.g., using empirical CDF)
* egen rank1 = rank(returns1), field
* gen u1 = rank1 / _N

* Step 2: Estimate copula on (u1, u2)

* ============================================================================
* PART 4: TAIL DEPENDENCE
* ============================================================================

* ----------------------------------------------------------------------------
* 4.1 Tail Dependence Coefficients
* ----------------------------------------------------------------------------

* Lower tail dependence: λ_L = lim P(X₁ < F₁⁻¹(u) | X₂ < F₂⁻¹(u)) as u→0
* Upper tail dependence: λ_U = lim P(X₁ > F₁⁻¹(u) | X₂ > F₂⁻¹(u)) as u→1

* Estimates probability of joint extreme events

* ----------------------------------------------------------------------------
* 4.2 Non-parametric Estimation
* ----------------------------------------------------------------------------

* Empirical estimation of tail dependence
* Use extreme observations to estimate

* Example: Lower tail dependence
* local quantile = 0.05  // 5th percentile
* summarize returns1, detail
* scalar threshold1 = r(p5)
* summarize returns2, detail
* scalar threshold2 = r(p5)

* Count joint exceedances
* gen joint_lower = (returns1 < threshold1 & returns2 < threshold2)
* summarize joint_lower
* scalar n_joint = r(sum)
*
* * Count individual exceedances
* gen lower1 = (returns1 < threshold1)
* summarize lower1
* scalar n1 = r(sum)
*
* * Tail dependence estimate
* scalar tail_dep = n_joint / n1

* ----------------------------------------------------------------------------
* 4.3 Tail Dependence from Copula
* ----------------------------------------------------------------------------

* If copula estimated, can compute tail dependence analytically
* Different copulas have different tail dependence:
* - Gaussian: λ_L = λ_U = 0 (no tail dependence)
* - t-copula: λ_L = λ_U > 0 (symmetric tail dependence)
* - Clayton: λ_L > 0, λ_U = 0
* - Gumbel: λ_L = 0, λ_U > 0

* ============================================================================
* PART 5: APPLICATIONS TO FINANCIAL CRISES
* ============================================================================

* ----------------------------------------------------------------------------
* 5.1 Crisis Period Analysis
* ----------------------------------------------------------------------------

* Filter data to crisis periods
* Example: 2007-2009 financial crisis
* keep if date >= td(01jan2007) & date <= td(31dec2009)

* Re-estimate VaR and tail dependence during crisis
* Compare with normal periods

* ----------------------------------------------------------------------------
* 5.2 Portfolio Tail Risk
* ----------------------------------------------------------------------------

* For portfolio of multiple assets:
* 1. Model marginals (e.g., GARCH-EVT)
* 2. Model dependence (copula)
* 3. Simulate portfolio returns
* 4. Compute portfolio VaR/CVaR

* ----------------------------------------------------------------------------
* 5.3 Stress Testing
* ----------------------------------------------------------------------------

* Use EVT and copulas for stress testing
* Simulate extreme scenarios
* Assess portfolio vulnerability

* ============================================================================
* INTERPRETATION AND SUMMARY
* ============================================================================

/*
PRACTICAL INSIGHTS:

Extreme Value Theory:
- Focuses on tail behavior, not entire distribution
- Useful for rare events (financial crises, market crashes)
- GEV (block maxima) vs GPD (peak over threshold)
- GPD more efficient, but threshold selection critical
- Tail index determines tail heaviness

VaR and CVaR:
- VaR: maximum loss at confidence level (e.g., 95%)
- CVaR: expected loss given VaR is exceeded
- CVaR more informative (coherent risk measure)
- Parametric, historical, GARCH-based approaches
- Backtesting essential to validate models

Copulas:
- Separate dependence from marginals
- Flexible: any marginals + any copula
- Capture nonlinear dependence
- Different copulas have different properties
- t-copula popular in finance (tail dependence)

Tail Dependence:
- Measures joint extreme events
- Important for portfolio risk
- Gaussian copula has no tail dependence (limitation)
- t-copula and Archimedean copulas allow tail dependence
- Critical during crises (correlations increase)

PRACTICAL TIPS:

1. Threshold selection for EVT
   - Too low: bias (not truly extreme)
   - Too high: variance (few observations)
   - Use mean excess plot or other diagnostics

2. VaR methods comparison
   - Historical: simple but backward-looking
   - Parametric: assumes distribution (may be wrong)
   - GARCH: accounts for volatility clustering
   - EVT: focuses on tail, more appropriate for extreme quantiles

3. Copula choice
   - Gaussian: simple but no tail dependence
   - t-copula: symmetric tail dependence
   - Clayton/Gumbel: asymmetric tail dependence
   - Choose based on data and economic theory

4. Tail dependence in crises
   - Correlations increase during crises
   - Diversification benefits decrease
   - Important for portfolio risk management
   - Stress testing should account for tail dependence

5. Computational considerations
   - EVT and copulas computationally intensive
   - Stata has limited built-in support
   - May need user-written packages or other software (R, Python)
   - MCMC methods often needed for estimation

6. Practical applications
   - Risk management (VaR, CVaR)
   - Regulatory capital requirements
   - Portfolio optimization under tail risk
   - Stress testing and scenario analysis
*/

* ============================================================================
* END OF SCRIPT
* ============================================================================

* Note: Stata has limited built-in support for advanced EVT and copula methods
* For comprehensive analysis, consider using R (copula, evd packages) or Python
* This script provides framework; implementation may require additional packages
