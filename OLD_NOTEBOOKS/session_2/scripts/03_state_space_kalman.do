/*
================================================================================
TOPIC 3: State Space Models and Kalman Filter
CEMFI Advanced Training School - Methods for Time Series
Practical Session 2
================================================================================

This script demonstrates:
1. State space model representation
2. Kalman filter implementation
3. Dynamic factor models
4. Time-varying parameter models (e.g., time-varying beta)
5. Trend/cycle decomposition

Data: Multiple stock returns, market returns, macro variables
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
* ssc install sspace, replace
* ssc install dfactor, replace

* ============================================================================
* PART 1: STATE SPACE MODELS - TREND/CYCLE DECOMPOSITION
* ============================================================================

* ----------------------------------------------------------------------------
* 1.1 Data Loading
* ----------------------------------------------------------------------------

* Example: Decompose GDP into trend and cycle
* use gdp_data.dta, clear
* tsset date

* Create log GDP if needed
* gen lngdp = ln(gdp)

* ----------------------------------------------------------------------------
* 1.2 Unobserved Components Model (Local Linear Trend)
* ----------------------------------------------------------------------------

* State space form:
* Observation equation: y_t = μ_t + ε_t
* State equation 1: μ_t = μ_{t-1} + β_{t-1} + η_t
* State equation 2: β_t = β_{t-1} + ζ_t
*
* Where:
* - y_t: observed series (e.g., log GDP)
* - μ_t: unobserved trend (random walk with drift)
* - β_t: unobserved drift (random walk)
* - ε_t, η_t, ζ_t: error terms

* Estimate using sspace command
* sspace (trend lngdp, state) (drift trend, state noerror) ///
*     (lngdp trend, noerror), ///
*     covstate(diagonal) var(e.lngdp e.trend e.drift)

* ----------------------------------------------------------------------------
* 1.3 Predict Trend and Cycle
* ----------------------------------------------------------------------------

* After estimation:
* predict trend, state equation(trend)
* predict cycle, state equation(lngdp)
* gen cycle_component = lngdp - trend

* Plot decomposition
* tsline lngdp trend, title("GDP: Observed vs Trend")
* tsline cycle_component, title("Cyclical Component")

* ============================================================================
* PART 2: KALMAN FILTER - TIME-VARYING BETA
* ============================================================================

* ----------------------------------------------------------------------------
* 2.1 Data Preparation
* ----------------------------------------------------------------------------

* Load stock and market return data
* Example: Apple stock returns vs S&P 500
* use stock_data.dta, clear
* tsset date

* Variables:
* - stock_return: Individual stock returns (e.g., AAPL)
* - market_return: Market portfolio returns (e.g., S&P 500)

* ----------------------------------------------------------------------------
* 2.2 Time-Varying Beta Model
* ----------------------------------------------------------------------------

* Model: r_{i,t} = α_t + β_t * r_{m,t} + ε_t
* Where β_t follows: β_t = β_{t-1} + u_t (random walk)

* State space representation:
* Observation: r_{i,t} = α + β_t * r_{m,t} + ε_t
* State: β_t = β_{t-1} + u_t

* Estimate time-varying beta using sspace
* sspace (beta stock_return market_return, state) ///
*     (stock_return beta market_return, noerror), ///
*     covstate(diagonal) var(e.stock_return e.beta)

* Alternative: Using regression with time-varying parameters
* tvreg stock_return market_return, bw(0.1)
* This estimates locally weighted regression

* ----------------------------------------------------------------------------
* 2.3 Predict Time-Varying Beta
* ----------------------------------------------------------------------------

* After sspace estimation:
* predict beta_t, state equation(beta)

* Plot time-varying beta
* tsline beta_t, title("Time-Varying Beta") ///
*     ytitle("Beta") xtitle("Date") ///
*     note("CAPM beta estimated using Kalman filter")

* Compare with rolling window estimate
* rolling beta_roll=r(rmse), window(252) saving(beta_roll, replace): ///
*     regress stock_return market_return
* use beta_roll, clear
* merge 1:1 _n using stock_data

* Compare both estimates
* tsline beta_t beta_roll, title("Time-Varying Beta: Kalman vs Rolling Window")

* ============================================================================
* PART 3: DYNAMIC FACTOR MODELS
* ============================================================================

* ----------------------------------------------------------------------------
* 3.1 Data Preparation
* ----------------------------------------------------------------------------

* Load multiple stock returns (or macro variables)
* Example: Returns on 5 stocks or sectors
* use multi_stock_data.dta, clear
* tsset date

* Variables: stock1_return, stock2_return, ..., stock5_return

* ----------------------------------------------------------------------------
* 3.2 Dynamic Factor Model (Single Common Factor)
* ----------------------------------------------------------------------------

* Model: r_{i,t} = λ_i * f_t + ε_{i,t}
* Factor follows: f_t = φ * f_{t-1} + u_t
*
* Where:
* - f_t: unobserved common factor (e.g., market factor)
* - λ_i: factor loadings
* - ε_{i,t}: idiosyncratic shocks

* Use dfactor command
* dfactor (stock1 stock2 stock3 stock4 stock5 = , noconstant), ///
*     ar(1) noconstant

* This estimates a single-factor model with AR(1) factor dynamics

* ----------------------------------------------------------------------------
* 3.3 Extract Common Factor
* ----------------------------------------------------------------------------

* After estimation, predict the common factor
* predict factor, dynamic

* Plot the extracted factor
* tsline factor, title("Extracted Common Factor") ///
*     ytitle("Factor") xtitle("Date")

* Compare with market return (if available)
* tsline factor market_return, title("Common Factor vs Market Return")

* ----------------------------------------------------------------------------
* 3.4 Factor Loadings
* ----------------------------------------------------------------------------

* Display factor loadings
* estat ic
* Display results to see loadings (λ_i) for each stock

* Interpretation:
* - High loading → stock moves closely with common factor
* - Low loading → stock has more idiosyncratic variation

* ============================================================================
* PART 4: MISSING DATA HANDLING
* ============================================================================

* ----------------------------------------------------------------------------
* 4.1 Kalman Filter with Missing Observations
* ----------------------------------------------------------------------------

* Kalman filter naturally handles missing data
* Simply set missing values in your data

* Example: Some stock returns missing (non-trading days, etc.)
* replace stock_return = . if missing(some_condition)

* Kalman filter will use all available information to estimate

* Re-estimate model with missing data
* sspace (beta stock_return market_return, state) ///
*     (stock_return beta market_return, noerror), ///
*     covstate(diagonal) var(e.stock_return e.beta)

* Filtered estimates use all available data up to time t
* Smoothed estimates use full sample

* ============================================================================
* PART 5: ADVANCED APPLICATIONS
* ============================================================================

* ----------------------------------------------------------------------------
* 5.1 Multivariate State Space Models
* ----------------------------------------------------------------------------

* Can estimate models with multiple observed and state variables
* Example: Multiple stocks with time-varying betas

* ----------------------------------------------------------------------------
* 5.2 Structural Breaks
* ----------------------------------------------------------------------------

* State space models can capture structural breaks through
* - Time-varying parameters
* - Markov-switching models (advanced)

* ----------------------------------------------------------------------------
* 5.3 Forecasting with State Space Models
* ----------------------------------------------------------------------------

* After estimation, forecast future values
* predict y_forecast, y dynamic(t0)  // Forecast from period t0 onwards

* Plot forecasts
* tsline observed_var y_forecast, title("Observed vs Forecasted")

* ============================================================================
* INTERPRETATION AND SUMMARY
* ============================================================================

/*
PRACTICAL INSIGHTS:

State Space Models:
- Flexible framework for unobserved components
- Naturally handles missing data
- Can model time-varying parameters
- Useful for trend/cycle decomposition

Kalman Filter:
- Optimal filter for linear state space models
- Provides filtered (real-time) and smoothed (full sample) estimates
- Computationally efficient recursive algorithm
- Widely used in finance and macroeconomics

Dynamic Factor Models:
- Extract common movements across multiple series
- Useful for dimension reduction
- Applications: extracting business cycle, market factors, sentiment
- Can identify systematic vs idiosyncratic risk

Time-Varying Parameters:
- Allows relationships to change over time
- Examples: time-varying beta, time-varying volatility
- More realistic than constant parameter models
- Important for risk management

PRACTICAL TIPS:

1. State space models require careful specification
   - Need to identify observation and state equations
   - Error variances need to be properly specified

2. Kalman filter provides multiple estimates:
   - Filtered: using information up to time t
   - Smoothed: using full sample (retrospective)
   - Forecasted: future values

3. Dynamic factor models:
   - Number of factors chosen by information criteria or economic theory
   - Factor loadings show sensitivity to common factors
   - Extracted factors can be used in further analysis

4. Missing data:
   - Kalman filter handles missing data naturally
   - Uses all available information efficiently
   - No need for imputation

5. Computational considerations:
   - State space models can be computationally intensive
   - Convergence issues may arise with complex models
   - Start with simple models, then extend
*/

* ============================================================================
* END OF SCRIPT
* ============================================================================

* Save results
* estimates save state_space_results, replace
