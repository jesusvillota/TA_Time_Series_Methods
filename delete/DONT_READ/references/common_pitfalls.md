# Common Pitfalls and Troubleshooting Guide

Common issues and solutions when working with time series in Stata.

## Data and Setup Issues

### Problem: "time variable not set"
**Error**: `time variable not set`
**Solution**:
```stata
tsset date
* Or specify frequency
tsset date, daily
tsset date, monthly
```

### Problem: Date format not recognized
**Error**: Date variables not formatted correctly
**Solution**:
```stata
* Convert string to date
gen date_numeric = date(date_string, "YMD")
format date_numeric %td

* Set as time series
tsset date_numeric
```

### Problem: Gaps in time series
**Issue**: Missing dates (e.g., weekends for daily data)
**Solution**:
```stata
* Fill gaps (optional, depends on analysis)
tsset date
tsfill

* Or keep only trading days
keep if dow(date) != 0 & dow(date) != 6  // Exclude weekends
```

## Unit Root Tests

### Problem: Conflicting results from different tests
**Issue**: ADF says stationary, KPSS says non-stationary (or vice versa)
**Solutions**:
- Use economic theory to guide decision
- Check for structural breaks
- Try different lag lengths
- Consider if series has trend or drift
- Use multiple tests and report all results

### Problem: Low power in small samples
**Issue**: Cannot reject unit root even if series is stationary
**Solution**:
- Collect more data if possible
- Be aware of power limitations
- Use alternative tests (PP test is more powerful)
- Consider panel unit root tests if applicable

## ARMA Models

### Problem: Model doesn't converge
**Error**: `convergence not achieved`
**Solutions**:
```stata
* Specify initial values
arima y, ar(1) ma(1) from(0.1 0.1, copy)

* Increase iterations
arima y, ar(1) ma(1) iterate(100)

* Try different starting values
* Check if series is truly stationary
```

### Problem: Residuals still autocorrelated
**Issue**: Ljung-Box test rejects after ARMA estimation
**Solutions**:
- Increase model order (try ARMA(2,2))
- Check for seasonality
- Consider ARIMA with differencing
- Check for structural breaks

### Problem: Information criteria suggest different models
**Issue**: AIC suggests AR(2), BIC suggests AR(1)
**Solution**:
- BIC is more conservative (prefer for forecasting)
- AIC may overfit (prefer for in-sample fit)
- Consider parsimony: simpler models are easier to interpret
- Use cross-validation if possible

## VAR Models

### Problem: VAR is unstable
**Issue**: `varstable` shows eigenvalues outside unit circle
**Solutions**:
- Check if variables are stationary (should be I(0))
- Try different lag lengths
- Consider VECM if variables are cointegrated
- Check for structural breaks

### Problem: Too many parameters
**Issue**: VAR with many variables and lags has too many parameters
**Solutions**:
- Reduce number of variables
- Reduce lag length
- Use Bayesian VAR (advanced)
- Use factor-augmented VAR

### Problem: Impulse response ordering matters too much
**Issue**: IRFs change dramatically with different orderings
**Solution**:
- Report IRFs with multiple orderings
- Use economic theory to justify ordering
- Consider alternative identification schemes (if available)
- Be transparent about ordering assumptions

## GARCH Models

### Problem: GARCH doesn't converge
**Error**: `convergence not achieved`
**Solutions**:
```stata
* Specify initial values
arch returns, arch(1) garch(1) from(0.1 0.8 0.1, copy)

* Try simpler model first (ARCH)
arch returns, arch(1)

* Check data: ensure enough variation
summarize returns
```

### Problem: ARCH effects still present after GARCH
**Issue**: `estat archlm` still rejects after GARCH estimation
**Solutions**:
- Increase GARCH order
- Try EGARCH or TGARCH (asymmetry)
- Check for structural breaks in volatility
- Consider alternative distributions (t-distribution)

### Problem: Negative variance forecasts
**Issue**: Predicted variance becomes negative (shouldn't happen)
**Solutions**:
- Check model specification
- Ensure GARCH parameters satisfy constraints
- Check for numerical issues
- Use alternative GARCH specification

## Multivariate Models

### Problem: Multivariate GARCH takes too long
**Issue**: DCC or BEKK estimation is very slow
**Solutions**:
- Start with fewer variables (2-3)
- Use simpler model (CCC instead of DCC)
- Reduce sample size for initial testing
- Consider computational alternatives

### Problem: Positive definite issues
**Error**: Covariance matrix not positive definite
**Solutions**:
- Check for highly correlated variables
- Remove redundant variables
- Use BEKK (guarantees positive definite)
- Check data quality

## Cointegration

### Problem: Johansen test results unclear
**Issue**: Trace and max eigenvalue tests give different conclusions
**Solution**:
- Report both tests
- Consider economic theory
- Check lag length selection
- Use trace test as primary (more robust)

### Problem: Cannot determine cointegration rank
**Issue**: Test statistics close to critical values
**Solution**:
- Try different lag lengths
- Check for structural breaks
- Use alternative tests (Engle-Granger)
- Consider economic interpretation

## State Space Models

### Problem: Kalman filter doesn't converge
**Issue**: State space model estimation fails
**Solutions**:
- Simplify model specification
- Check initial values
- Ensure observability/controllability
- Verify state space representation is correct

### Problem: Missing data handling
**Issue**: Kalman filter with missing observations
**Solution**:
- Kalman filter handles missing data naturally
- Ensure date variable is set correctly
- Check if missing pattern is systematic

## General Issues

### Problem: Out of memory
**Error**: `out of memory`
**Solutions**:
```stata
* Increase memory
set matsize 800
set maxvar 5000

* Use preserve/restore for large datasets
preserve
* Do analysis on subset
restore
```

### Problem: Results not reproducible
**Issue**: Results differ each time
**Solution**:
```stata
* Set seed for random processes
set seed 12345

* Ensure same data is used
* Document Stata version
```

### Problem: Too many graphs open
**Issue**: Graph window cluttered
**Solution**:
```stata
* Name graphs and close old ones
graph drop _all

* Save graphs to files
graph export "graph.png", replace
```

### Problem: Package not found
**Error**: `command not found`
**Solutions**:
```stata
* Install from SSC
ssc install package_name

* Or install from other sources
net install package_name, from(url)

* Check if package name is correct
findit package_name
```

## Best Practices to Avoid Pitfalls

1. **Always check data first**:
   ```stata
   summarize, detail
   tsline variable
   ```

2. **Test stationarity before modeling**:
   ```stata
   dfuller variable
   ```

3. **Start simple, then expand**:
   - Begin with AR(1), then try ARMA(1,1)
   - Start with GARCH(1,1), then expand

4. **Check diagnostics after estimation**:
   - Residual tests
   - Model stability
   - Information criteria

5. **Document decisions**:
   - Why specific lag length chosen
   - Why certain variables included
   - How missing data handled

6. **Be aware of sample size**:
   - Unit root tests need sufficient observations
   - VAR needs T >> p (number of parameters)

7. **Save work frequently**:
   ```stata
   save "backup.dta", replace
   estimates save "results.ster", replace
   ```

## Getting Help

- Stata help: `help command_name`
- Stata documentation
- Course materials
- Stata forums and communities
- Contact TA

---

**Remember**: Most problems have solutions. Start with simple checks (data, stationarity) before complex models.
