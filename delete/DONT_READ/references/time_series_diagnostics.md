# Time Series Diagnostic Tests: Interpretation Guide

Guide to interpreting common diagnostic tests used in time series analysis.

## Unit Root Tests

### Augmented Dickey-Fuller (ADF) Test
- **Null Hypothesis (H₀)**: Series has a unit root (non-stationary)
- **Alternative (H₁)**: Series is stationary

**Interpretation**:
- **p-value < 0.05**: Reject H₀ → Series is **stationary**
- **p-value ≥ 0.05**: Cannot reject H₀ → Series has **unit root** (non-stationary)

**Test Specifications**:
- `dfuller var, lags(k)`: No trend or drift
- `dfuller var, lags(k) trend`: Allows for deterministic trend
- `dfuller var, lags(k) drift`: Allows for drift (non-zero mean)

**Decision Rule**: Choose specification based on visual inspection of the series.

### Phillips-Perron (PP) Test
- **Null Hypothesis**: Unit root (same as ADF)
- **Interpretation**: Same as ADF
- **Advantage**: Robust to serial correlation and heteroskedasticity

### KPSS Test
- **Null Hypothesis (H₀)**: Series is **stationary**
- **Alternative (H₁)**: Series has unit root
- **Note**: Null is OPPOSITE of ADF/PP!

**Interpretation**:
- **p-value < 0.05**: Reject H₀ → Series is **non-stationary**
- **p-value ≥ 0.05**: Cannot reject H₀ → Series is **stationary**

**Best Practice**: Use both ADF/PP and KPSS for confirmation.

## Autocorrelation Tests

### Ljung-Box Test (`wntestq`)
- **Null Hypothesis (H₀)**: No autocorrelation (white noise)
- **Alternative (H₁)**: Autocorrelation present

**Interpretation**:
- **p-value < 0.05**: Reject H₀ → **Autocorrelation present** → ARMA model may be needed
- **p-value ≥ 0.05**: Cannot reject H₀ → **No autocorrelation** → White noise

**Use Cases**:
- Test original series: Is there serial correlation?
- Test residuals: Are residuals white noise? (Diagnostic check)

### Portmanteau Test (`wntestb`)
- Similar to Ljung-Box, alternative test for white noise
- Same interpretation

## ARCH Effects Test

### Engle's LM Test (`estat archlm`)
- **Null Hypothesis (H₀)**: No ARCH effects (homoskedasticity)
- **Alternative (H₁)**: ARCH effects present (heteroskedasticity)

**Interpretation**:
- **p-value < 0.05**: Reject H₀ → **ARCH effects present** → GARCH model needed
- **p-value ≥ 0.05**: Cannot reject H₀ → **No ARCH effects** → Homoskedastic

**When to Use**: After estimating mean equation (ARMA), test residuals for ARCH.

## VAR Model Diagnostics

### Lag Selection (`varsoc`)
- **Information Criteria**: AIC, BIC, HQIC
- **Lower is better**
- **BIC**: More conservative (penalizes complexity more)
- **AIC**: Less conservative (may overfit)

**Decision**: Choose lag with lowest BIC (or AIC if preferred).

### VAR Stability (`varstable`)
- **Condition**: All eigenvalues inside unit circle
- **Interpretation**:
  - **All inside**: VAR is stable → Can use for forecasting/IRF
  - **Any outside**: VAR is unstable → Cannot use for forecasting

### Granger Causality (`vargranger`)
- **Null Hypothesis (H₀)**: X does NOT Granger cause Y
- **Alternative (H₁)**: X Granger causes Y

**Interpretation**:
- **p-value < 0.05**: Reject H₀ → **X Granger causes Y**
- **p-value ≥ 0.05**: Cannot reject H₀ → **No Granger causality**

**Note**: Granger causality ≠ true causality (temporal precedence).

## Cointegration Tests

### Johansen Test (`johans`)
- **Trace Test**: Tests H₀: r cointegrating relationships vs H₁: > r
- **Max Eigenvalue Test**: Tests H₀: r vs H₁: r+1

**Interpretation**:
- Compare test statistic to critical values
- **Test stat > Critical value**: Reject H₀
- Determine number of cointegrating relationships (r)

**Decision**: Use highest r where H₀ is rejected.

## Normality Tests

### Shapiro-Wilk Test (`swilk`)
- **Null Hypothesis (H₀)**: Data are normally distributed
- **Alternative (H₁)**: Data are not normal

**Interpretation**:
- **p-value < 0.05**: Reject H₀ → **Not normal**
- **p-value ≥ 0.05**: Cannot reject H₀ → **Approximately normal**

**Use Case**: Test standardized residuals from GARCH models.

## Information Criteria

### AIC, BIC, HQIC
- **Lower is better**
- **BIC**: Stronger penalty for complexity → Prefer simpler models
- **AIC**: Weaker penalty → May choose more complex models

**Rule of Thumb**: Prefer BIC for forecasting, AIC for in-sample fit.

## Residual Diagnostics (After Model Estimation)

### Checklist for ARMA Models:
1. **Ljung-Box on residuals**: Should NOT reject (p > 0.05) → White noise
2. **Ljung-Box on squared residuals**: Should NOT reject → No ARCH
3. **Normality test**: May not be normal, but check

### Checklist for GARCH Models:
1. **Ljung-Box on standardized residuals**: Should NOT reject → White noise
2. **Ljung-Box on squared standardized residuals**: Should NOT reject → No remaining ARCH
3. **Normality test**: Check (may use t-distribution if needed)

## Common Pitfalls

1. **Unit Root Tests**:
   - Multiple tests may give conflicting results
   - Use economic theory to guide decision
   - Consider structural breaks

2. **Lag Selection**:
   - Too few lags: Misspecification
   - Too many lags: Overfitting
   - Use information criteria

3. **Residual Diagnostics**:
   - Always check residuals after estimation
   - If diagnostics fail, model may be misspecified

4. **Multiple Testing**:
   - Testing many models increases chance of false positives
   - Use information criteria rather than many hypothesis tests

5. **Sample Size**:
   - Unit root tests have low power in small samples
   - Cointegration tests require sufficient observations

---

**Remember**: Diagnostic tests are tools to guide model selection, not absolute rules. Always combine with economic theory and practical considerations.
