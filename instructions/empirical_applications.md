# Empirical Applications from Time Series Methods Slides

This document lists all empirical applications found in the lecture slides across 4 parts.

---

## Part 1: Linear Time Series Models

### 1. Autocorrelation - Examples based on Spanish data
**Slide:** 10/69
**Exercise:** Analysis of autocorrelation patterns of three Spanish economic time series
**Series Used:**
- Sovereign spreads (bp) - time series plot showing evolution from Jan 1993 to Jan 2014
- Real GDP annual growth rates (%) - time series plot showing evolution from Mar 1996 to Aug 2014
- Ibex-35 monthly returns (%) - time series plot showing evolution from Feb 1990 to Aug 2014
- Autocorrelations of sovereign spreads, GDP growth, and Ibex-35 returns - correlogram plot (lags 1-19)

**Source:** Spanish data (likely from Banco de España or official statistics)

---

### 2. Correlation: Long-term sovereign spreads
**Slide:** 5/69
**Exercise:** Visualization of long-term sovereign spreads relative to German yields
**Series Used:**
- Long-term sovereign spread for Spain (bp) - from Jan 1993 to Apr 2014
- Long-term sovereign spread for France (bp) - from Jan 1993 to Apr 2014
- Long-term sovereign spread for Italy (bp) - from Jan 1993 to Apr 2014
- German sovereign yields (benchmark) - used as reference for calculating spreads

**Source:** ECB Statistical Data Warehouse (Harmonised long-term interest rates for convergence assessment purposes)

---

### 3. Correlation between sovereign spreads - Table and scatter plots
**Slides:** 8/69, 9/69
**Exercise:** Analysis of correlation between long-term sovereign spreads for different country pairs across time periods
**Series Used:**
- Sovereign spreads for Spain (ES)
- Sovereign spreads for France (FR)
- Sovereign spreads for Italy (IT)

**Periods analyzed:**
- 1993-1999: ES-FR (77%), ES-IT (99%), IT-FR (75%)
- 2000-2007: ES-FR (88%), ES-IT (75%), IT-FR (73%)
- 2008-2015: ES-FR (83%), ES-IT (95%), IT-FR (93%)

**Source:** ECB Statistical Data Warehouse

---

### 4. Autocorrelation with confidence intervals
**Slide:** 12/69
**Exercise:** ACF plots with confidence bands for GDP growth and Ibex-35 returns
**Series Used:**
- Real GDP annual growth rates (gdp_real_growth) - ACF plot with Bartlett's 95% confidence bands (lags 0-40)
- Ibex-35 monthly returns (ibex_35) - ACF plot with Bartlett's 95% confidence bands (lags 0-40)

**Source:** Spanish data

---

### 5. Stationarity: Dickey-Fuller Unit root test for Ibex-35
**Slides:** 16/69, 17/69, 18/69, 19/69
**Exercise:** Unit root testing comparing Ibex-35 index levels vs returns, including time series plots, correlograms, and DF-GLS test results
**Series Used:**
- Ibex-35 index (%) - time series plot (Jan 1990 to Jan 2014)
- Ibex-35 daily returns (ribex35) (%) - time series plot (Jan 1990 to Jan 2014)
- Ibex-35 index levels (ibex35) - correlogram (lags 0-40)
- Ibex-35 daily returns (ribex35) - correlogram (lags 0-40)
- DF-GLS test results for ibex35 (levels) - table with test statistics for lags 1-3 (6659 observations)
- DF-GLS test results for ribex35 (returns) - table with test statistics for lags 1-3 (6658 observations)

**Source:** Ibex-35 stock market index data

---

### 6. Seasonality: Spanish inflation index
**Slide:** 22/69
**Exercise:** Analysis of seasonal patterns in Spanish inflation using monthly and annual returns with correlograms
**Series Used:**
- Spanish inflation index - monthly returns (%) (Jan 2003 to Jan 2015)
- Spanish inflation index - annual returns (%) (Jan 2003 to Jan 2015)
- Monthly inflation returns (monthly_inflation) - correlogram (lags 0-40) with Bartlett's 95% confidence bands
- Annual inflation returns (annual_inflation) - correlogram (lags 0-40) with Bartlett's 95% confidence bands

**Source:** Spanish inflation index data

---

### 7. Application: Modelling the VIX index
**Slides:** 34/69, 35/69, 36/69, 37/69, 39/69, 40/69, 41/69, 42/69
**Exercise:** Comprehensive analysis and modeling of the VIX volatility index including historical evolution, distributional analysis, unit root tests, ARMA model estimation, and out-of-sample forecasting

**Series Used:**
- VIX index - historical evolution time series (Jan 1990 to Jan 2015)
- VIX - summary statistics (mean, std dev, skewness, kurtosis, min, max)
- log-VIX (lgvix) - summary statistics (mean, std dev, skewness, kurtosis, min, max)
- VIX - kernel density estimate vs normal density
- log-VIX - kernel density estimate vs normal density
- log-VIX (lgvix) - correlogram (lags 0-40) with Bartlett's 95% confidence bands
- log-VIX (lgvix) - partial correlogram (lags 0-40) with 95% confidence bands
- log-VIX (lgvix) - DF-GLS unit root test results (maxlag=10, notrend, 6287 observations)
- log-VIX - ARMA model selection table (comparing ARMA(1,0) through ARMA(6,0), MA(0,1) through MA(0,3), and ARMA(1,1), ARMA(2,1) with log-likelihood, AIC, BIC)
- log-VIX (lgvix) - ARMA(2,1) estimates table (6298 observations)
- log-VIX (lgvix) - ARMA(2,1) fitted correlogram vs empirical (lags 0-40)
- log-VIX (lgvix) - ARMA(2,1) fitted partial correlogram vs empirical (lags 0-40)
- VIX - out-of-sample forecasts vs actual (Jan 2015 to Jan 29, 2015)

**Source:** CBOE (Chicago Board Options Exchange) - computed from S&P500 index options prices

---

### 8. Modelling GDP and Credit to non-financial companies
**Slides:** 50/69, 51/69, 52/69, 53/69, 54/69, 56/69, 57/69
**Exercise:** VAR modeling of GDP and credit growth including stationarity tests, scatter plots, cross-correlogram, model selection, estimation, and impulse response functions

**Series Used:**
- Real GDP annual growth (%) (dgdp) - time series plot (Mar 1996 to Aug 2014)
- Real Credit to non-financial companies annual growth (%) (dcredit) - time series plot (Mar 1996 to Aug 2014)
- GDP growth (dgdp) vs Credit growth (dcredit) - scatter plot (contemporaneous)
- GDP growth (dgdp) vs Lagged Credit growth (dcredit, L) - scatter plot
- Lagged GDP growth (dgdp, L) vs Credit growth (dcredit) - scatter plot
- GDP annual growth (dgdp) - DF-GLS unit root test (maxlag=2, notrend, 74 observations)
- Credit annual growth (dcredit) - DF-GLS unit root test (maxlag=2, notrend, 74 observations)
- Cross-correlogram: Corr(ΔGDPt, ΔCreditt-l) for lags -20 to 20
- VAR model selection table (VAR(1), VAR(2), VAR(3)) with log-likelihood, AIC, BIC
- VAR(2) estimation results - table with coefficients for dgdp and dcredit equations
- Roots of companion matrix - scatter plot (stationarity check)
- OIRF of Credit to a GDP positive shock - impulse response function (steps 0-20)
- OIRF of GDP to a credit positive shock - impulse response function (steps 0-20)

**Source:** Spanish data (likely from Banco de España or official statistics)

---

### 9. Cointegration: Unemployment rates example
**Slides:** 65/69, 66/69, 67/69, 68/69, 69/69
**Exercise:** Cointegration analysis of unemployment rates between neighboring regions/states

**Series Used:**
- Unemployment rate in Madrid (%) - time series (Sep 1976 to Jun 2012)
- Unemployment rate in Catalonia (%) - time series (Sep 1976 to Jun 2012)
- Unemployment rate in Connecticut (%) - time series (Mar 1976 to Nov 2012)
- Unemployment rate in Massachusetts (%) - time series (Mar 1976 to Nov 2012)
- Madrid - DF-GLS unit root test (maxlag=3, notrend, 15 observations)
- Catalonia - DF-GLS unit root test (maxlag=3, notrend, 15 observations)
- Johansen cointegration test results for Madrid and Catalonia (lags=3, trend=rconstant, 153 observations, sample: 1977q2-2015q2)
- Johansen cointegration test results for Connecticut and Massachusetts (lags=3, trend=rconstant, 156 observations, sample: 1976q4-2015q3)
- Vector error-correction model (VECM) estimates for Connecticut and Massachusetts

**Source:** 
- Spanish data: likely from official statistics (INE - Instituto Nacional de Estadística)
- US data: likely from Bureau of Labor Statistics (BLS)

---

## Part 2: Volatility Models

### 10. Stylised facts: Lack of persistence in returns vs persistence in squared returns
**Slide:** 6/41
**Exercise:** Comparison of autocorrelation functions for Ibex-35 returns vs squared returns
**Series Used:**
- Ibex-35 returns (ribex35) - correlogram (lags 0-40) with Bartlett's 95% confidence bands
- Ibex-35 squared returns (ribex35sq) - correlogram (lags 0-40) with Bartlett's 95% confidence bands

**Source:** Ibex-35 stock market index data

---

### 11. Stylised facts: Volatility clustering
**Slide:** 7/41
**Exercise:** Visualization of volatility clustering in Ibex-35 daily returns
**Series Used:**
- Ibex-35 daily returns (ribex35) (%) - time series plot (Jan 1990 to Jan 2015)
- Ibex-35 volatility, estimated with 60-day moving window - time series plot (Jan 1990 to Jan 2015)

**Source:** Ibex-35 stock market index data

---

### 12. Stylised facts: Asymmetries and leverage effect
**Slide:** 8/41
**Exercise:** Regression analysis of squared returns on lagged squared returns and lagged returns to detect leverage effect
**Series Used:**
- Ibex-35 squared returns (sq_ibex35) - dependent variable
- Lagged squared Ibex-35 (l.sq_ibex35, l2.sq_ibex35, l3.sq_ibex35) - independent variables
- Lagged Ibex-35 returns (l.ribex35) - independent variable
- Regression results table (2564 observations, F-statistic, R-squared)

**Source:** Ibex-35 stock market index data

---

### 13. Stylised facts: Non-normality
**Slide:** 9/41
**Exercise:** Kernel density estimation comparing Ibex-35 returns distribution to normal distribution
**Series Used:**
- Ibex-35 returns (ribex35) - kernel density estimate vs normal density (Gaussian kernel, bandwidth = 0.1620)

**Source:** Ibex-35 stock market index data

---

### 14. ARCH(1) example with Ibex-35 daily returns
**Slides:** 14/41, 15/41, 16/41
**Exercise:** ARCH(1) model estimation, volatility forecasting, and model diagnostics
**Series Used:**
- Ibex-35 daily returns (ribex35) - ARCH(1) estimates table (6587 observations, sample: 2-6588)
- One-day-ahead volatility estimates in logs (log_sigmat) - time series plot (Jan 1990 to Jan 2015)
- Squared Ibex-35 returns (ribex35sq) - correlogram (lags 0-40) vs squared standardized residuals (errorsq) - correlogram (lags 0-40)
- Squared Ibex-35 returns (ribex35sq) - partial correlogram (lags 0-40) vs squared standardized residuals (errorsq) - partial correlogram (lags 0-40)

**Source:** Ibex-35 stock market index data

---

### 15. ARCH(10) example with Ibex-35 daily returns
**Slides:** 17/41, 18/41, 19/41
**Exercise:** ARCH(10) model estimation, volatility forecasting, and model diagnostics
**Series Used:**
- Ibex-35 daily returns (ribex35) - ARCH(10) estimates table (ARCH terms L1-L10)
- One-day-ahead volatility estimates in logs (log_sigmat) - time series plot (Jan 1990 to Jan 2015)
- Squared Ibex-35 returns (y_t^2) - correlogram (lags 0-40) vs squared standardized residuals ((y_t/σ_t)^2) - correlogram (lags 0-40)
- Squared Ibex-35 returns (y_t^2) - partial correlogram (lags 0-40) vs squared standardized residuals ((y_t/σ_t)^2) - partial correlogram (lags 0-40)

**Source:** Ibex-35 stock market index data

---

### 16. ARCH vs GARCH: Likelihood fit comparison
**Slide:** 27/41
**Exercise:** Comparison of model fit across different ARCH and GARCH specifications
**Series Used:**
- Ibex-35 daily returns (ribex35) - model comparison table (ARCH(1), ARCH(10), GARCH(1,1)) with log-likelihood and number of parameters

**Source:** Ibex-35 stock market index data

---

### 17. GARCH(1,1) example with Ibex-35 daily returns
**Slides:** 23/41, 24/41, 25/41, 26/41
**Exercise:** GARCH(1,1) model estimation, interpretation, volatility forecasting, and model diagnostics
**Series Used:**
- Ibex-35 daily returns (ribex35) - GARCH(1,1) estimates table
- One-day-ahead volatility estimates in logs (log_sigmat) - time series plot (Jan 1990 to Jan 2015)
- Squared Ibex-35 returns (y_t^2) - correlogram (lags 0-40) vs squared standardized residuals ((y_t/σ_t)^2) - correlogram (lags 0-40)
- Squared Ibex-35 returns (y_t^2) - partial correlogram (lags 0-40) vs squared standardized residuals ((y_t/σ_t)^2) - partial correlogram (lags 0-40)

**Source:** Ibex-35 stock market index data

---

### 18. Asymmetric GARCH(1,1) estimates
**Slide:** 29/41
**Exercise:** Asymmetric GARCH model estimation to capture leverage effect
**Series Used:**
- Ibex-35 daily returns (ribex35) - Asymmetric GARCH(1,1) estimates table (aarch(1), aarch_e L1, garch(1))

**Source:** Ibex-35 stock market index data

---

### 19. Likelihood fit comparison including Asymmetric GARCH
**Slide:** 30/41
**Exercise:** Model comparison including asymmetric specification
**Series Used:**
- Ibex-35 daily returns (ribex35) - model comparison table (ARCH(1), ARCH(10), GARCH(1,1), Asymmetric GARCH(1,1)) with log-likelihood and number of parameters

**Source:** Ibex-35 stock market index data

---

### 20. Ibex-35 example: Testing for Gaussianity
**Slide:** 35/41
**Exercise:** Jarque-Bera test for normality of standardized residuals
**Series Used:**
- GARCH(1,1) standardized residuals (ε_t) - Jarque-Bera test results table (Skewness: -0.35, Kurtosis: 6.79, Total JB: 4072.40)

**Source:** Ibex-35 stock market index data

---

### 21. GARCH(1,1) with Student t innovations
**Slides:** 37/41, 38/41, 39/41
**Exercise:** GARCH(1,1) model with Student t distribution for innovations
**Series Used:**
- Ibex-35 daily returns (ribex35) - GARCH(1,1) with Student t estimates table (degrees of freedom: 7.645)
- GARCH(1,1) innovations (ε_t) - kernel density plots comparing Kernel, Gaussian, and Student t densities (full distribution, left tail, right tail)

**Source:** Ibex-35 stock market index data

---

## Part 3: Multivariate Dependence

### 22. Correlations between returns of euro area reference stock indices
**Slide:** 7/33
**Exercise:** Time-varying correlations using 100-day moving window
**Series Used:**
- Returns of euro area reference stock indices - time series of correlations (100-day moving window, May 1990 to May 2014)
- Minimum, median, and maximum correlations across indices - line plot

**Source:** Euro area stock indices (specific indices not named on slide; could include Euro Stoxx 50, DAX, CAC 40, IBEX 35, FTSE MIB, AEX, etc.)

---

### 23. Correlations between stock indices and sovereign bonds
**Slide:** 8/33
**Exercise:** Time-varying correlations between stock index returns and sovereign bond returns using 100-day moving window
**Series Used:**
- France: Stock index returns vs sovereign bond returns - correlation time series (Aug 1991 to Aug 2015)
- Spain: Stock index returns vs sovereign bond returns - correlation time series (Aug 1991 to Aug 2015)
- Germany: Stock index returns vs sovereign bond returns - correlation time series (Aug 1991 to Aug 2015)

**Source:** Euro area stock indices and sovereign bond data

---

### 24. Example: Overnight Index Swap (OIS) rates
**Slides:** 14/33, 15/33, 16/33, 17/33
**Exercise:** Principal Component Analysis (PCA) of OIS term structure
**Series Used:**
- 27 OIS rate series across different maturities - historical evolution (Aug 2005 to Aug 2015)
- OIS rates for maturities: 0.02, 0.06, 0.17, 0.33, 0.50, 0.67, 0.83, 1.00, 1.50, 2.00, 4.00, 6.00, 8.00, 10.00 years
- Standard deviation of yield daily changes - term structure plot (across maturities)
- PCA eigenvalues table (correlation matrix based, 2666 observations, 27 components, first 4 components retained)
- PCA eigenvectors plot - first 4 principal components (PC1, PC2, PC3, PC4) across time horizons

**Source:** Overnight Index Swap (OIS) rates data

---

### 25. CCC (Constant Conditional Correlation) Example
**Slides:** 20/33, 21/33
**Exercise:** CCC-MGARCH model estimation for Spain and Germany
**Series Used:**
- Spain returns - CCC-GARCH estimates table (mean equation constant, ARCH(1), GARCH(1))
- Germany returns - CCC-GARCH estimates table (mean equation constant, ARCH(1), GARCH(1))
- Constant conditional correlation (Spain, Germany) - estimate: 0.709
- Log volatility Spain (lgv_Spain_Spain) - time series plot (Jan 1990 to Jan 2015)
- Log volatility Germany (lgv_Germany_Germany) - time series plot (Jan 1990 to Jan 2015)
- Constant correlation (cor_Germany_Spain) - time series plot (Jan 1990 to Jan 2015)

**Source:** Spanish and German financial/economic series (likely stock index returns)

---

### 26. DCC (Dynamic Conditional Correlation) Example
**Slides:** 23/33, 24/33
**Exercise:** DCC-MGARCH model estimation and comparison with CCC model
**Series Used:**
- Spain returns - DCC-MGARCH estimates (individual GARCH processes)
- Germany returns - DCC-MGARCH estimates (individual GARCH processes)
- Dynamic conditional correlation (cor_Germany_Spain_dcc) - time series plot (Jan 1990 to Jan 2015)
- Constant correlation (cor_Germany_Spain) - reference line (Jan 1990 to Jan 2015)
- Log volatility Spain (lgv_Spain_Spain) - time series plot (Jan 1990 to Jan 2015)
- Log volatility Germany (lgv_Germany_Germany) - time series plot (Jan 1990 to Jan 2015)
- Likelihood ratio test: DCC vs CCC (LR = 837.84, 2 degrees of freedom)

**Source:** Spanish and German financial/economic series (likely stock index returns)

---

### 27. Asymmetric and tail dependence: Equity index returns
**Slides:** 27/33, 28/33
**Exercise:** Analysis of asymmetric and tail dependence using exceedance correlations
**Series Used:**
- Spain equity index returns (ES) - standardized returns (ε*yt)
- France equity index returns (FR) - standardized returns (ε*yt)
- Germany equity index returns (DE) - standardized returns (ε*yt)
- Italy equity index returns (IT) - standardized returns (ε*yt)
- Asymmetric correlation ES-IT (acorr_es_it) - exceedance correlation plot
- Asymmetric correlation ES-FR (acorr_es_fr) - exceedance correlation plot
- Asymmetric correlation ES-DE (acorr_es_de) - exceedance correlation plot

**Source:** Euro area equity indices

---

### 28. Copulas: Scatter plots of cdf transforms
**Slide:** 31/33
**Exercise:** Visualization of copula relationships via cdf transforms
**Series Used:**
- Spain cdf transform (es_cdf) vs Germany cdf transform (de_cdf) - scatter plot
- Spain cdf transform (es_cdf) vs Italy cdf transform (it_cdf) - scatter plot
- Spain cdf transform (es_cdf) vs France cdf transform (fr_cdf) - scatter plot

**Source:** Euro area equity indices (cdf transforms derived from standardized returns)

---

### 29. Copulas: Contour plots of copula densities
**Slide:** 33/33
**Exercise:** Comparison of different copula specifications for Spanish vs German equity index returns
**Series Used:**
- Spanish equity index returns
- German equity index returns
- Contour plots for: Independent normals, Correlated normals, Symmetric mixture, Asymmetric mixture

**Source:** Euro area equity indices

---

## Part 4: Risk Management

**Note:** Part 4 is primarily theoretical, focusing on definitions and concepts of Value at Risk (VaR) and risk management measures. No empirical applications with plots or tables were found in this section.

---

## Complete List of Unique Series to Download

Below is the consolidated list of all unique time series identified across all empirical applications:

### Financial Market Indices
1. **Ibex-35 index** - Spanish stock market index (levels)
2. **Ibex-35 daily returns** (ribex35) - Percentage returns
3. **Ibex-35 monthly returns** - Percentage returns
4. **Ibex-35 squared returns** (ribex35sq) - For volatility analysis

### Sovereign Spreads and Interest Rates
5. **Long-term sovereign spread - Spain** (vs German yields, in basis points)
6. **Long-term sovereign spread - France** (vs German yields, in basis points)
7. **Long-term sovereign spread - Italy** (vs German yields, in basis points)
8. **German sovereign yields** - Long-term interest rates (benchmark)

### Macroeconomic Series
9. **Real GDP annual growth rates** (gdp_real_growth, dgdp) - Spain, percentage
10. **Real Credit to non-financial companies annual growth** (dcredit) - Spain, percentage
11. **Spanish inflation index** - Monthly data (to compute monthly and annual returns)
12. **Spanish inflation - monthly returns** (monthly_inflation)
13. **Spanish inflation - annual returns** (annual_inflation)

### Volatility and Options
14. **VIX index** - CBOE Volatility Index (levels and log-VIX)
15. **VIX** - Raw index values
16. **log-VIX** (lgvix) - Natural logarithm of VIX

### Unemployment Rates
17. **Unemployment rate - Madrid** (%) - Quarterly or monthly
18. **Unemployment rate - Catalonia** (%) - Quarterly or monthly
19. **Unemployment rate - Connecticut** (%) - Quarterly or monthly
20. **Unemployment rate - Massachusetts** (%) - Quarterly or monthly

### Euro Area Stock Indices (Returns)
21. **Spain equity index returns** (ES) - Daily or monthly returns
22. **France equity index returns** (FR) - Daily or monthly returns
23. **Germany equity index returns** (DE) - Daily or monthly returns
24. **Italy equity index returns** (IT) - Daily or monthly returns
25. **Euro area reference stock indices** (multiple, for correlation analysis) - Returns

### Euro Area Sovereign Bonds
26. **France sovereign bond returns** - Daily or monthly returns
27. **Spain sovereign bond returns** - Daily or monthly returns
28. **Germany sovereign bond returns** - Daily or monthly returns

### Interest Rate Derivatives
29. **Overnight Index Swap (OIS) rates** - 27 series for different maturities:
    - Maturities: 0.02, 0.06, 0.17, 0.33, 0.50, 0.67, 0.83, 1.00, 1.50, 2.00, 4.00, 6.00, 8.00, 10.00 years

### Data Sources Identified
- **ECB Statistical Data Warehouse** - Sovereign spreads and harmonised long-term interest rates
- **Banco de España** - Spanish macroeconomic and financial data
- **CBOE (Chicago Board Options Exchange)** - VIX index
- **Spanish official statistics (INE)** - GDP, inflation, unemployment
- **US Bureau of Labor Statistics (BLS)** - US state unemployment rates
- **Stock exchange data** - Ibex-35, Euro area indices
- **Financial data providers** - OIS rates, sovereign bonds (likely Bloomberg, Reuters, or central bank sources)

### Notes
- Some series are derived (e.g., returns, growth rates, squared returns) and can be computed from underlying price/index levels
- Time periods vary by application but generally span from early 1990s to mid-2010s
- For Spanish data, quarterly or monthly frequency is common; daily frequency is used for financial market data
- For correlation analysis and multivariate models, series need to be aligned by date

