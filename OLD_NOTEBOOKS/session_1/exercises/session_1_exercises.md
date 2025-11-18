# Session 1 Exercises: ARMA Models and VAR/Cointegration

Practice exercises for Topics 1 and 2. Work through these to reinforce your understanding.

## Exercise Set 1: ARMA Models and Unit Roots

### Exercise 1.1: Data Exploration
**Objective**: Load and explore financial time series data.

1. Load the S&P 500 index data (or any stock index data you have access to).
2. Create log returns: `gen returns = D.ln(price)`
3. Set up time series: `tsset date`
4. Generate summary statistics and plot the returns series.
5. Comment on any obvious patterns you observe (trends, volatility clustering, etc.).

### Exercise 1.2: Unit Root Testing
**Objective**: Test for stationarity using multiple tests.

1. Test the log price series for unit roots using:
   - ADF test with trend
   - ADF test without trend
   - PP test
   - KPSS test (if available)
2. Test the returns series for unit roots using the same tests.
3. Interpret the results. What do you conclude about:
   - The stationarity of prices?
   - The stationarity of returns?
4. Explain why these results make economic sense.

### Exercise 1.3: ARMA Model Identification
**Objective**: Identify appropriate ARMA model using ACF/PACF.

1. Plot ACF and PACF of the returns series (use 20-30 lags).
2. Based on the plots, suggest candidate ARMA models (e.g., AR(1), MA(1), ARMA(1,1)).
3. Use the Ljung-Box test to check for autocorrelation in returns.
4. Interpret: Is there evidence of serial correlation?

### Exercise 1.4: ARMA Model Estimation
**Objective**: Estimate and compare ARMA models.

1. Estimate the following models:
   - AR(1)
   - MA(1)
   - ARMA(1,1)
   - ARMA(2,2)
2. For each model:
   - Report information criteria (AIC, BIC)
   - Test residuals for autocorrelation (Ljung-Box)
   - Test for ARCH effects
3. Compare models using information criteria.
4. Which model would you choose? Justify your choice.

### Exercise 1.5: Diagnostic Checking
**Objective**: Verify model adequacy.

1. For your chosen ARMA model:
   - Plot residuals
   - Plot ACF of residuals
   - Perform Ljung-Box test on residuals
   - Test for normality (Shapiro-Wilk or histogram)
2. Are the residuals white noise? If not, what might this indicate?
3. Are ARCH effects present? What does this suggest for further modeling?

### Exercise 1.6: Exchange Rate Unit Root Testing
**Objective**: Apply unit root tests to exchange rate data.

1. Load EUR/USD exchange rate data (or any FX rate).
2. Test the log exchange rate for unit roots.
3. If unit root is found, test the first difference.
4. Interpret results in the context of exchange rate theory (random walk hypothesis).
5. Compare your findings with the stock returns results. Why might they differ?

---

## Exercise Set 2: VAR Models and Cointegration

### Exercise 2.1: VAR Data Preparation
**Objective**: Prepare data for VAR analysis.

1. Collect/load data for the following variables (monthly or quarterly):
   - GDP growth rate
   - Inflation rate
   - Interest rate (policy rate or 10-year bond yield)
   - Stock market returns
2. Ensure all variables are stationary (check unit roots).
3. If necessary, transform variables to achieve stationarity.
4. Create summary statistics for all variables.

### Exercise 2.2: Lag Length Selection
**Objective**: Choose optimal lag length for VAR.

1. Use `varsoc` to test lag lengths from 1 to 8.
2. Compare AIC, BIC, and HQIC.
3. Which lag length do the different criteria suggest?
4. Which would you choose? Why?
5. Consider both statistical and economic reasoning.

### Exercise 2.3: VAR Estimation and Stability
**Objective**: Estimate VAR and check stability.

1. Estimate a VAR model with your chosen lag length.
2. Check VAR stability using `varstable`.
3. Are all eigenvalues inside the unit circle?
4. If unstable, what might be wrong? How would you proceed?

### Exercise 2.4: Granger Causality
**Objective**: Test for Granger causality.

1. Use `vargranger` to test all pairs of variables.
2. Interpret the results:
   - Which variables Granger cause which?
   - What are the economic implications?
3. Remember: Granger causality ≠ true causality. Explain this distinction.
4. Can you think of economic stories that explain your findings?

### Exercise 2.5: Impulse Response Functions
**Objective**: Analyze dynamic responses using IRFs.

1. Create IRFs for the following shocks:
   - Interest rate shock → response of GDP growth
   - Interest rate shock → response of inflation
   - Stock return shock → response of GDP growth
2. Plot IRFs and interpret:
   - What is the immediate impact?
   - How long do effects last?
   - Do effects die out or persist?
3. How do these findings relate to economic theory?

### Exercise 2.6: Variance Decomposition
**Objective**: Understand sources of forecast error variance.

1. Compute forecast error variance decomposition (FEVD).
2. Focus on:
   - What fraction of GDP growth forecast error is due to its own shocks?
   - What fraction is due to other variables' shocks?
3. Interpret the economic meaning of these decompositions.
4. How do the proportions change as forecast horizon increases?

### Exercise 2.7: Cointegration Testing
**Objective**: Test for cointegration between economic variables.

1. Test the following pairs/groups for cointegration:
   - GDP and consumption
   - Interest rates and inflation
   - Multiple macro variables (if data available)
2. Use Johansen test (`johans`).
3. Interpret:
   - How many cointegrating relationships exist?
   - What is the economic interpretation?
4. If cointegration is found, what does this imply about the long-run relationship?

### Exercise 2.8: VECM Estimation
**Objective**: Estimate Vector Error Correction Model.

1. If cointegration was found in Exercise 2.7:
   - Estimate a VECM model
   - Interpret the cointegrating equation
   - Interpret the adjustment coefficients (speed of adjustment)
2. What do the adjustment coefficients tell you about adjustment to long-run equilibrium?
3. Compare VECM results with VAR results. When should you use each?

---

## Challenge Exercises

### Challenge 1: Forecast Comparison
1. Estimate an ARMA model for stock returns.
2. Estimate a VAR model including stock returns and other variables.
3. Split your sample: use 80% for estimation, 20% for forecasting.
4. Generate 1-step and multi-step ahead forecasts from both models.
5. Compare forecast accuracy (MSE, MAE, etc.).
6. Which model forecasts better? Why might this be?

### Challenge 2: Structural Break
1. Test for structural breaks in your data (e.g., around 2008 financial crisis).
2. Estimate separate models for pre-crisis and post-crisis periods.
3. Compare parameter estimates. Have relationships changed?
4. Discuss implications for forecasting and policy analysis.

### Challenge 3: Extended VAR
1. Estimate a VAR with 5-6 variables.
2. Test for cointegration using Johansen test.
3. If cointegration exists, estimate VECM.
4. Compute IRFs and FEVD.
5. Write a brief economic interpretation of your findings.

---

## Questions for Reflection

1. **Why is stationarity important for ARMA models?** What problems arise if you use non-stationary data?

2. **When would you prefer AIC over BIC for model selection?** When would you prefer BIC?

3. **Explain the difference between Granger causality and true causality.** Give an example where Granger causality might be misleading.

4. **Why do we need cointegration tests?** What's wrong with running OLS regression on I(1) variables?

5. **How do VAR and VECM differ?** When would you use each?

6. **What assumptions underlie impulse response functions?** How does the Cholesky ordering affect results?

---

## Solutions Guide

*Solutions will be provided separately or discussed in class.*

**Tips for Success**:
- Start with simple exercises and build complexity
- Always check diagnostics after estimation
- Interpret results in economic context, not just statistically
- Compare your findings with economic theory
- Document your code and decisions

---

**Good luck with your exercises!**
