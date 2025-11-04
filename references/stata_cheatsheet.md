# Stata Time Series Cheatsheet

Quick reference guide for common Stata commands used in time series analysis.

## Setup and Data Management

```stata
* Set time series
tsset date
tsset date, daily
tsset date, monthly

* Clear workspace
clear all
set more off

* Working directory
cd "path/to/directory"

* Install packages
ssc install package_name, replace
```

## Descriptive Statistics and Plots

```stata
* Summary statistics
summarize variable, detail

* Time series plot
tsline variable, title("Title") ytitle("Y Label") xtitle("X Label")

* Histogram
histogram variable, normal title("Title")

* Scatter plot
scatter yvar xvar

* Combine graphs
graph combine name1 name2, title("Combined")
```

## ARMA Models

```stata
* ACF and PACF
ac variable, lags(20)
pac variable, lags(20)

* Ljung-Box test (white noise)
wntestq variable, lags(10)
wntestb variable, lags(10)

* Estimate ARMA
arima variable, ar(1)           // AR(1)
arima variable, ma(1)           // MA(1)
arima variable, ar(1) ma(1)     // ARMA(1,1)
arima variable, ar(1/2) ma(1/2) // ARMA(2,2)

* Information criteria
estat ic

* Predict residuals
predict residuals, residuals

* Store and compare models
estimates store model1
estimates stats model1 model2
```

## Unit Root Tests

```stata
* Augmented Dickey-Fuller test
dfuller variable, lags(10)      // No trend
dfuller variable, lags(10) trend    // With trend
dfuller variable, lags(10) drift    // With drift

* Phillips-Perron test
pperron variable, lags(10)
pperron variable, lags(10) trend

* KPSS test (if installed)
kpss variable, lags(10) trend
```

## VAR Models

```stata
* Lag selection
varsoc varlist, maxlag(8)

* Estimate VAR
var varlist, lags(1/2)

* Check stability
varstable, graph

* Granger causality
vargranger

* Impulse response functions
irf create irfname, set(setname) replace
irf graph oirf, impulse(impulse_var) response(response_var)
irf table fevd, impulse(impulse_var) response(response_var)

* Forecast
fcast compute forecast_name, step(12)
fcast graph forecast_name, observed
```

## Cointegration

```stata
* Johansen cointegration test
johans varlist, lags(2) trend(constant)

* Vector Error Correction Model (VECM)
vec varlist, lags(2) rank(1) trend(constant)
```

## State Space Models

```stata
* State space model (general form)
sspace (state_eq1) (state_eq2) (obs_eq), options

* Example: time-varying beta
sspace (beta y x, state) (y beta x, noerror), var(...)

* Dynamic factor model
dfactor (vars = , noconstant), ar(1)

* Predict states
predict state_var, state equation(state_name)
predict factor, dynamic
```

## GARCH Models

```stata
* Test for ARCH effects
regress returns
estat archlm, lags(1/5)

* ARCH model
arch returns, arch(1)

* GARCH model
arch returns, arch(1) garch(1)        // GARCH(1,1)
arch returns, arch(1/2) garch(1/2)    // GARCH(2,2)

* EGARCH (asymmetric)
arch returns, earch(1) egarch(1)

* Predict volatility
predict cond_var, variance
predict cond_vol, variance
replace cond_vol = sqrt(cond_vol)
```

## Multivariate GARCH

```stata
* DCC-GARCH
mgarch dcc (var1 var2 = , noconstant), arch(1) garch(1)

* BEKK-GARCH
mgarch bekk (var1 var2 = , noconstant), arch(1) garch(1)

* CCC-GARCH
mgarch ccc (var1 var2 = , noconstant), arch(1) garch(1)

* Predict correlations
predict corr_var, corr(var1 var2)
```

## Principal Component Analysis

```stata
* PCA
pca varlist

* Scree plot
screeplot

* Predict components
predict pc1 pc2 pc3, score

* Display loadings
estat loadings
```

## Value at Risk (VaR)

```stata
* Normal distribution quantile
invnormal(0.05)  // 5th percentile
invnormal(0.01)  // 1st percentile

* Empirical quantiles
summarize returns, detail
r(p5)  // 5th percentile
r(p1)  // 1st percentile

* VaR calculation
scalar var_95 = mu + sigma * invnormal(0.05)
```

## Data Transformations

```stata
* Logarithms
gen log_var = ln(variable)

* First differences
gen d_var = D.variable

* Lagged variables
gen lag_var = L.variable
gen lag2_var = L2.variable

* Leads
gen lead_var = F.variable

* Returns (log differences)
gen returns = D.ln(price)
```

## Variable Generation

```stata
* Create variables
gen newvar = expression
gen newvar = oldvar if condition

* Replace values
replace var = value if condition

* Missing values
drop if missing(variable)

* Time variables
gen year = year(date)
gen month = month(date)
gen quarter = quarter(date)
```

## Regression

```stata
* OLS regression
regress yvar xvar1 xvar2

* With time series operators
regress yvar L.yvar L.xvar

* Predict fitted values
predict fitted, xb

* Predict residuals
predict residuals, residuals
```

## Output and Results

```stata
* Display scalar
display "Value: " scalar_name

* Save estimates
estimates save filename, replace

* Load estimates
estimates use filename

* Export results
estout using results.tex, replace
```

## Packages to Install

```stata
* Commonly needed packages
ssc install estout, replace
ssc install varsoc, replace
ssc install varstable, replace
ssc install johans, replace
ssc install sspace, replace
ssc install dfactor, replace
ssc install stata_kernel, replace  // For Jupyter
```

## Common Workflows

### Checking Stationarity
```stata
tsset date
tsline variable
dfuller variable, lags(10) trend
```

### ARMA Model Selection
```stata
ac variable, lags(20)
pac variable, lags(20)
arima variable, ar(1) ma(1)
estat ic
predict residuals, residuals
wntestq residuals, lags(10)
```

### VAR Analysis
```stata
varsoc varlist, maxlag(8)
var varlist, lags(1/2)
varstable, graph
vargranger
irf create myirf, set(myirfs) replace
irf graph oirf, impulse(impulse) response(response)
```

---

**Note**: This is a quick reference. See course materials for detailed explanations and examples.
