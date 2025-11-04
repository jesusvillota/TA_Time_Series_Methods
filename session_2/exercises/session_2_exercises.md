# Session 2 Exercises: State Space, GARCH, and Extreme Values

Practice exercises for Topics 3, 4, and 5. Work through these to reinforce your understanding.

## Exercise Set 3: State Space Models and Kalman Filter

### Exercise 3.1: Trend/Cycle Decomposition
**Objective**: Decompose a time series into trend and cycle.

1. Load GDP data (or any trending series).
2. Create log GDP: `gen lngdp = ln(gdp)`
3. Estimate a state space model to decompose into trend and cycle.
4. Extract and plot:
   - Observed series
   - Trend component
   - Cyclical component
5. Interpret: When are periods of above-trend growth? Below-trend?

### Exercise 3.2: Time-Varying Beta
**Objective**: Estimate time-varying beta using Kalman filter.

1. Load stock return data and market return data.
2. Estimate time-varying beta using state space model (or alternative method).
3. Plot the time-varying beta over time.
4. Compare with:
   - Constant beta from OLS regression
   - Rolling window beta (e.g., 252-day window)
5. When does beta change most? What might explain this?

### Exercise 3.3: Dynamic Factor Model
**Objective**: Extract common factors from multiple series.

1. Collect returns on 5-10 stocks (or sectors).
2. Estimate a dynamic factor model using `dfactor`.
3. Extract the common factor.
4. Compare extracted factor with market return (if available).
5. Interpret factor loadings: which stocks load heavily on the factor?

### Exercise 3.4: Missing Data Handling
**Objective**: Use Kalman filter with missing observations.

1. Create a dataset with some missing observations (or use real data with gaps).
2. Estimate state space model with missing data.
3. Compare filtered and smoothed estimates.
4. How does Kalman filter handle missing data differently than simple interpolation?

---

## Exercise Set 4: GARCH Models and Volatility

### Exercise 4.1: ARCH Effects Testing
**Objective**: Detect volatility clustering.

1. Load financial return data (stocks, FX, etc.).
2. Estimate a simple mean equation (constant or ARMA).
3. Test residuals for ARCH effects using Engle's LM test.
4. Plot squared residuals. Do you see volatility clustering?
5. Interpret: Are ARCH effects present? What does this imply?

### Exercise 4.2: GARCH Model Estimation
**Objective**: Estimate and compare GARCH models.

1. Estimate the following models:
   - ARCH(1)
   - GARCH(1,1)
   - GARCH(2,2)
   - EGARCH(1,1)
2. Compare using information criteria.
3. For your chosen model:
   - Predict conditional volatility
   - Plot volatility over time
4. When is volatility highest? Does this coincide with market events?

### Exercise 4.3: Volatility Forecasting
**Objective**: Forecast volatility.

1. Split sample: use 80% for estimation, 20% for forecasting.
2. Estimate GARCH(1,1) on training sample.
3. Forecast volatility for test sample (1-step and multi-step ahead).
4. Compare forecasts with realized volatility (squared returns as proxy).
5. Evaluate forecast accuracy. How well does GARCH forecast volatility?

### Exercise 4.4: Leverage Effect
**Objective**: Detect and model asymmetric volatility.

1. Test for leverage effect:
   - Plot volatility following positive vs negative returns
   - Estimate EGARCH model
2. Interpret EGARCH coefficient on asymmetry.
3. Is there evidence of leverage effect? What does this mean?
4. Compare EGARCH volatility with GARCH volatility.

### Exercise 4.5: Multivariate GARCH - DCC
**Objective**: Model time-varying correlations.

1. Load returns on 2-3 assets (e.g., stock, bond, commodity).
2. Estimate DCC-GARCH model.
3. Extract time-varying correlations.
4. Plot correlations over time.
5. When do correlations increase? Decrease? Why might this happen?

### Exercise 4.6: Portfolio Volatility
**Objective**: Compute portfolio volatility using multivariate GARCH.

1. After estimating DCC-GARCH (from Exercise 4.5):
2. Define portfolio weights (e.g., 60% stock, 40% bond).
3. Compute portfolio volatility over time using conditional covariance matrix.
4. Compare with naive approach (constant correlation).
5. When is portfolio diversification most/least effective?

### Exercise 4.7: Principal Component Analysis
**Objective**: Use PCA for dimension reduction.

1. Load returns on 5-10 assets.
2. Perform PCA.
3. Create scree plot.
4. How many principal components explain 80% of variance?
5. Predict principal component scores.
6. What do the first few components represent?

---

## Exercise Set 5: Extreme Values and Copulas

### Exercise 5.1: Value at Risk (VaR)
**Objective**: Calculate VaR using different methods.

1. Using return data, calculate:
   - 95% VaR using normal distribution
   - 95% VaR using historical simulation
   - 95% VaR using GARCH (if you did Exercise 4.2)
2. Compare the three methods:
   - Which gives highest VaR?
   - Which is most conservative?
   - Plot VaR over time (for GARCH method).
3. Count violations (returns < VaR). Are they close to expected (5%)?

### Exercise 5.2: Conditional VaR (CVaR)
**Objective**: Calculate expected shortfall.

1. Calculate CVaR (Expected Shortfall) for:
   - Historical simulation method
   - GARCH method (if available)
2. Compare CVaR with VaR.
3. Why is CVaR often preferred as a risk measure?
4. When do CVaR and VaR differ most?

### Exercise 5.3: Extreme Value Theory
**Objective**: Apply EVT to tail risk estimation.

1. Focus on extreme losses (negative returns).
2. Select threshold (e.g., 95th percentile of losses).
3. Extract exceedances over threshold.
4. Estimate GPD parameters (if package available) or use Hill estimator.
5. Estimate high quantiles (e.g., 99.5% VaR) using EVT.
6. Compare EVT VaR with parametric VaR.

### Exercise 5.4: Tail Dependence
**Objective**: Estimate tail dependence between assets.

1. Select two return series (e.g., two stocks or stock/bond).
2. Estimate lower tail dependence:
   - Define threshold (e.g., 5th percentile)
   - Count joint exceedances
   - Estimate tail dependence coefficient
3. Estimate upper tail dependence similarly.
4. Are tail dependencies symmetric?
5. What are implications for portfolio risk?

### Exercise 5.5: Copula Modeling
**Objective**: Model dependence using copulas.

1. Transform returns to uniform marginals (using empirical CDF).
2. If copula package available:
   - Estimate Gaussian copula
   - Estimate t-copula
   - Compare tail dependence of both
3. If package not available:
   - Visualize dependence (scatter plot of uniform marginals)
   - Discuss limitations of linear correlation
4. Why are copulas useful for risk management?

### Exercise 5.6: Crisis Period Analysis
**Objective**: Analyze tail risk during financial crisis.

1. Filter data to crisis period (e.g., 2007-2009, or 2020 COVID).
2. Re-estimate:
   - VaR and CVaR
   - Tail dependence
   - Correlation (or DCC correlation if available)
3. Compare crisis period with normal period:
   - How does VaR change?
   - How does tail dependence change?
   - How do correlations change?
4. What are implications for diversification during crises?

---

## Challenge Exercises

### Challenge 1: Volatility Modeling Competition
1. Collect daily return data for a stock or index.
2. Estimate multiple volatility models:
   - GARCH(1,1)
   - EGARCH(1,1)
   - GARCH with t-distribution
   - Alternative models (if available)
3. Split sample and forecast volatility.
4. Compare forecast accuracy using:
   - MSE
   - MAE
   - Directional accuracy
5. Which model forecasts best? Why?

### Challenge 2: Portfolio Risk Management
1. Create portfolio of 3-5 assets.
2. Using multivariate GARCH (DCC), compute:
   - Portfolio volatility over time
   - Portfolio VaR and CVaR
   - Contribution of each asset to portfolio risk
3. Analyze:
   - When is portfolio risk highest?
   - Which assets contribute most to risk?
   - How does correlation affect diversification?
4. Write brief risk report summarizing findings.

### Challenge 3: Stress Testing
1. Using EVT and copula methods:
2. Simulate extreme scenarios:
   - High volatility scenario
   - Correlation breakdown scenario
   - Joint extreme events
3. Compute portfolio losses under each scenario.
4. Compare with normal period risk measures.
5. What are implications for capital requirements?

### Challenge 4: Dynamic Risk Measures
1. Combine methods from all topics:
   - Use GARCH for volatility forecasting
   - Use EVT for tail estimation
   - Use copulas for dependence
2. Compute dynamic VaR/CVaR that updates daily.
3. Backtest your model:
   - Compare predicted vs actual violations
   - Test model adequacy
4. How would you improve the model?

---

## Questions for Reflection

1. **Why use state space models instead of simple regressions?** When are they most useful?

2. **What is the leverage effect?** Why is it important for volatility modeling?

3. **How do GARCH models improve on ARCH models?** What does the GARCH term capture?

4. **Why is DCC-GARCH popular?** What are advantages over BEKK-GARCH?

5. **What is tail dependence?** Why is it important for portfolio risk?

6. **Why use copulas instead of correlation?** What are limitations of correlation?

7. **How does EVT differ from assuming normal distribution?** When is EVT most useful?

8. **What are limitations of VaR?** Why might CVaR be preferred?

9. **How do correlations change during crises?** What are implications for diversification?

10. **How would you combine methods from different topics?** (e.g., GARCH + EVT + copulas)

---

## Solutions Guide

*Solutions will be provided separately or discussed in class.*

**Tips for Success**:
- Start with univariate models before multivariate
- Always check model diagnostics
- Compare different methods and understand trade-offs
- Interpret results in risk management context
- Visualize results (plots are very helpful)
- Consider computational limitations of different methods

---

## Software Notes

**State Space Models**:
- Stata has built-in support via `sspace` and `dfactor`
- Some advanced models may require user-written packages

**GARCH Models**:
- Well-supported in Stata via `arch` and `mgarch`
- EGARCH and variants available

**Extreme Values and Copulas**:
- Limited built-in support in Stata
- May need user-written packages
- R or Python may be more comprehensive for EVT/copulas
- Consider these limitations in your analysis

---

**Good luck with your exercises!**
