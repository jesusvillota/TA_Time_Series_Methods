* ============================================================================
* UNIVARIATE TIME SERIES MODEL SIMULATIONS
* ============================================================================
*
* Script: 1_1_simul_univariate.do
* Purpose: Univariate Time Series Model Simulations
* Session: Session 1 • Part 1
* Author: Jesus Villota Miranda
* Date: 2025
*
* This script replicates exercises from the corresponding notebook:
* 1_1_simul_univariate.ipynb
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
log using "1_1_simul_univariate.log", replace text  // Start log file

display "============================================================================"
display "UNIVARIATE TIME SERIES MODEL SIMULATIONS"
display "============================================================================"
display ""

* ----------------------------------------------------------------------------
* WHITE NOISE PROCESSES
* ----------------------------------------------------------------------------

display "Section: White Noise Processes"
display ""

* White noise is the fundamental building block of time series models. 
* A white noise process {u_t} is formally defined by three properties:
*
* $E[u_t] = 0$ (zero mean)
* $V(u_t) = \sigma^2$ (constant variance)
* $Cov(u_t, u_s) = 0$ for $t \neq s$ (uncorrelated across time)
*
* Key Properties:
* 1. No Autocorrelation: $\rho(h) = 0$ for all $h \neq 0$
* 2. No Memory: Past values provide no information about future values
* 3. Foundation for Complex Models: AR, MA, and ARMA models are built by 
*    transforming and combining white noise

* ----------------------------------------------------------------------------
* Uniform White Noise
* ----------------------------------------------------------------------------

display "Section: Uniform White Noise"
display ""

* Objective: Generate uniform white noise $e_1 \sim U(0,1)$ and demonstrate 
* how nonlinear transformations affect the distribution. We compute $e_2 = e_1^2$ 
* to show how squaring a uniform random variable changes its properties.
*
* Mathematical Framework:
* $e_1 \sim U(0,1)$ (uniform distribution on [0,1])
* $e_2 = e_1^2$ (square transformation)
*
* Theoretical Properties:
* - $e_1$: Mean $E[U] = 0.5$, Variance $V(U) = 1/12 \approx 0.0833$
* - $e_2$: Mean $E[U^2] = 1/3 \approx 0.3333$, distribution concentrated toward zero
*
* **Objective**: Generate uniform white noise $e_1 \sim U(0,1)$ and demonstrate how nonlinear transformations affect the distribution. We compute $e_2 = e_1^2$ to show how squaring a uniform random variable changes its properties.
*
* #### Mathematical Framework
*
* We generate two processes:
*
* $
* \begin{aligned}
* e_1 &\sim U(0,1) \quad \text{(uniform distribution on [0,1])} \\
* e_2 &= e_1^2 \quad \text{(square transformation)}
* \end{aligned}
* $
*
* **Theoretical Properties**:
*
* - **$e_1$**: For $U \sim \text{Uniform}(0,1)$:
* - Mean: $\mathbb{E}[U] = \frac{1}{2} = 0.5$
* - Variance: $\mathbb{V}(U) = \frac{1}{12} \approx 0.0833$
* - Density: $f_U(u) = 1$ for $u \in [0,1]$, zero otherwise
*
* - **$e_2$**: For $e_2 = U^2$ where $U \sim \text{Uniform}(0,1)$:
* - Mean: $\mathbb{E}[U^2] = \int_0^1 u^2 \cdot 1 \, du = \frac{1}{3} \approx 0.3333$
* - The distribution is no longer uniform—it's concentrated toward zero (since squaring small numbers yields smaller results)
*
* **Important Note**: The transformation $e_2 = e_1^2$ demonstrates that **nonlinear transformations of random variables change their distribution**. While $e_1$ is uniformly distributed, $e_2$ follows a different distribution (specifically, $e_2$ has density $f_{e_2}(x) = \frac{1}{2\sqrt{x}}$ for $x \in [0,1]$).

* ============================================================================
* Simulation 1: Uniform White Noise
* ============================================================================
* Generate e1 = uniform() and e2 = e1 * e1

clear all  // Clear memory and remove all variables
set seed 12345  // Set random seed for reproducibility
set obs 1000  // Set number of observations to 1000

* Generate uniform random variable e1 on [0,1]
generate e1 = runiform()  // Generate uniform random numbers on [0,1]

* Generate e2 = e1 * e1 (square of e1)
generate e2 = e1 * e1  // Compute square of e1

* Display first 10 observations
list e1 e2 in 1/10  // Display first 10 observations of e1 and e2

* Summary statistics
display "Summary Statistics for Uniform White Noise:"
summarize e1 e2, detail  // Display detailed summary statistics for e1 and e2

* Generate time index for plotting
generate t = _n  // Create time index variable

* Time series plots
twoway (line e1 t), ///
    title("Uniform White Noise: e1 ~ U(0,1)") ///
    ytitle("e1") xtitle("Time") ///
    /* name(ts_uniform_e1, replace) // Save graph */

twoway (line e2 t), ///
    title("Squared Uniform: e2 = e1²") ///
    ytitle("e2") xtitle("Time") ///
    /* name(ts_uniform_e2, replace) // Save graph */

* Histogram plots
histogram e1, ///
    title("Histogram: Uniform White Noise e1") ///
    xtitle("e1") ytitle("Density") ///
    normal // Overlay normal curve for comparison ///
    /* name(hist_uniform_e1, replace) // Save graph */

histogram e2, ///
    title("Histogram: Squared Uniform e2 = e1²") ///
    xtitle("e2") ytitle("Density") ///
    /* name(hist_uniform_e2, replace) // Save graph */

* Theoretical mean of e1: E[U] = 0.5 for U ~ Uniform(0,1)
* Theoretical mean of e2: E[U^2] = 1/3 for U ~ Uniform(0,1)
display ""
display "Theoretical mean of e1 (Uniform(0,1)): 0.5"
display "Theoretical mean of e2 (E[U^2]): 1/3 ≈ 0.3333"


* #### Interpretation of Results
*
* **🔍 What the Analysis Reveals:**
*
* 1. **Uniform Distribution Properties**: The summary statistics for `e1` show a mean close to 0.5 and variance close to 0.0833, matching the theoretical values for $U(0,1)$. The histogram should display a flat, uniform distribution.
*
* 2. **Transformation Effects**: The squared variable `e2` has a mean close to $\frac{1}{3} \approx 0.3333$, confirming the theoretical expectation. The distribution of `e2` is **skewed toward zero** because squaring values in $[0,1]$ compresses the range—smaller numbers become even smaller when squared.
*
* 3. **Variance Comparison**: Notice that $\mathbb{V}(e_2) > \mathbb{V}(e_1)$ in the empirical results. This occurs because the transformation $e_2 = e_1^2$ creates a non-uniform distribution with different spread characteristics.
*
* 4. **Visual Patterns**: The time series plots show that both `e1` and `e2` exhibit no autocorrelation (random fluctuations), but `e2` has a different amplitude distribution due to the squaring transformation.
*
* **Key Takeaway**: This simulation demonstrates that **nonlinear transformations preserve the white noise property (no autocorrelation) but change the marginal distribution**. This is important when modeling time series where we apply transformations (e.g., logarithms, squares) to the data.

* 1.2 Gaussian White Noise
*
* **Objective**: Generate standard normal white noise $u \sim N(0,1)$ to demonstrate the most commonly used white noise distribution in time series modeling. Gaussian white noise is preferred because of the central limit theorem and its mathematical tractability.
*
* We generate a standard normal white noise process:
*
* $
* u_t \sim N(0,1)
* $
*
* where:
* - Mean: $\mathbb{E}[u_t] = 0$
* - Variance: $\mathbb{V}[u_t] = 1$
* - Density: $f(u) = \frac{1}{\sqrt{2\pi}} e^{-\frac{u^2}{2}}$
*
* **Properties of Standard Normal White Noise**:
*
* 1. **Symmetry**: The distribution is symmetric around zero, with equal probability of positive and negative shocks.
*
* 2. **Bell-shaped Distribution**: Unlike uniform white noise, Gaussian white noise has a bell-shaped (normal) density curve, with most values concentrated near zero and fewer extreme values.
*
* 3. **Autocorrelation Check**: For true white noise, the autocorrelation function (ACF) should show $\rho(h) \approx 0$ for all $h \neq 0$, with values falling within the confidence bands.
*
* **Comparison with Uniform White Noise**: While uniform white noise has bounded support $[0,1]$, Gaussian white noise has unbounded support $(-\infty, \infty)$. This makes Gaussian white noise more suitable for modeling economic and financial data where shocks can be arbitrarily large (though with decreasing probability).

* #### Interpretation of Results
*
* **🔍 What the Analysis Reveals:**
*
* 1. **Distribution Verification**: The summary statistics show a mean close to 0 and variance close to 1, confirming the standard normal distribution. The histogram should display the characteristic bell-shaped curve, and the overlay normal curve should match closely.
*
* 2. **Autocorrelation Structure**: The ACF plot should show autocorrelations near zero for all lags $h \geq 1$, with most values falling within the confidence bands (gray area). This confirms the white noise property—no serial correlation.
*
* 3. **Random Fluctuations**: The time series plot shows random fluctuations around zero with no discernible pattern, trend, or cyclical behavior. This is the hallmark of white noise.
*
* 4. **Kurtosis Check**: The kurtosis should be close to 3 (the theoretical value for a normal distribution). Values significantly different from 3 indicate deviations from normality.

* ============================================================================
* Simulation 2: Gaussian White Noise
* ============================================================================
* Generate u = normal() (standard normal: N(0,1))

clear all  // Clear memory and remove all variables
set seed 12345  // Set random seed for reproducibility
set obs 1000  // Set number of observations to 1000

* Generate standard normal random variable u ~ N(0,1)
generate u = rnormal()  // Generate standard normal random numbers

* Display first 10 observations
list u in 1/10  // Display first 10 observations of u

* Summary statistics
display "Summary Statistics for Gaussian White Noise:"
summarize u, detail  // Display detailed summary statistics for u

* Generate time index for plotting
generate t = _n  // Create time index variable
tsset t  // Declare time series structure

* Time series plot
twoway (line u t), ///
    title("Gaussian White Noise: u ~ N(0,1)") ///
    ytitle("u") xtitle("Time") ///

* Histogram plot
histogram u, ///
    title("Histogram: Gaussian White Noise") ///
    xtitle("u") ytitle("Density") ///
    normal // Overlay normal curve ///

* Check autocorrelation (should be approximately zero for white noise)
ac u, lags(20) name(acf_wn, replace)

display ""
display "For white noise, autocorrelations should be approximately zero"
display "and fall within the confidence bands (gray area)"


* #### Interpretation of Results
*
* **🔍 What the Analysis Reveals:**
*
* 1. **Autocorrelation Pattern**: The ACF for `x` should show a significant autocorrelation at lag 1 (approximately 0.4878) and near-zero autocorrelations for $h \geq 2$. This "cut-off" pattern is the signature of an MA(1) process.
*
* 2. **Variance Comparison**: The variance of `x` is larger than the variance of `u` because the MA(1) process combines current and lagged shocks: $\mathbb{V}(x_t) = (1+\theta^2)\sigma^2 = 1.64$ when $\sigma^2 = 1$.
*
* 3. **Process Comparison**: The time series plots comparing `x` and `y` show different patterns—`x` (with positive $\theta$) tends to have smoother transitions, while `y` (with negative $\theta$) shows more oscillatory behavior due to the negative correlation.
*
* 4. **Invertibility Verification**: Since $|\theta| = 0.8
*
* **Key Takeaway**: The MA(1) process with $|\theta|

* 2.1 Invertible MA(1)
*
* **Objective**: Simulate an invertible MA(1) process with $\theta = 0.8$ (satisfying $|\theta|
*
* We simulate two processes:
*
* $
* \begin{aligned}
* x_t &= u_t + \theta u_{t-1} \quad \text{with } \theta = 0.8 \\
* y_t &= u_t - \theta u_{t-1} \quad \text{(alternative with negative coefficient)}
* \end{aligned}
* $
*
* **Theoretical Moments**:
*
* Assuming $u_t \sim N(0, \sigma^2)$ with $\sigma^2 = 1$:
*
* **For $x_t = u_t + \theta u_{t-1}$**:
*
* - **Expectation**:
* $
* \mathbb{E}[x_t] = \mathbb{E}[u_t + \theta u_{t-1}] = \mathbb{E}[u_t] + \theta \mathbb{E}[u_{t-1}] = 0 + \theta \cdot 0 = 0
* $
*
* - **Variance**:
* $
* \mathbb{V}(x_t) = \mathbb{V}(u_t + \theta u_{t-1}) = \mathbb{V}(u_t) + \theta^2 \mathbb{V}(u_{t-1}) + 2\theta \mathbb{C}\text{ov}(u_t, u_{t-1})
* $
* Since $u_t$ and $u_{t-1}$ are uncorrelated ($\mathbb{C}\text{ov}(u_t, u_{t-1}) = 0$):
* $
* \mathbb{V}(x_t) = \sigma^2 + \theta^2 \sigma^2 = \sigma^2(1 + \theta^2) = 1 \cdot (1 + 0.64) = 1.64
* $
*
* - **Covariances**:
* $
* \begin{aligned}
* \mathbb{C}\text{ov}(x_t, x_{t-1}) &= \mathbb{C}\text{ov}(u_t + \theta u_{t-1}, u_{t-1} + \theta u_{t-2}) \\
* &= \mathbb{C}\text{ov}(u_t, u_{t-1}) + \theta \mathbb{C}\text{ov}(u_t, u_{t-2}) + \theta \mathbb{C}\text{ov}(u_{t-1}, u_{t-1}) + \theta^2 \mathbb{C}\text{ov}(u_{t-1}, u_{t-2}) \\
* &= 0 + 0 + \theta \sigma^2 + 0 = \theta \sigma^2 = 0.8
* \end{aligned}
* $
*
* For $h \geq 2$:
* $
* \mathbb{C}\text{ov}(x_t, x_{t-h}) = 0 \quad \text{(no shared white noise terms)}
* $
*
* **For $y_t = u_t - \theta u_{t-1}$**:
*
* - **Expectation**:
* $
* \mathbb{E}[y_t] = \mathbb{E}[u_t - \theta u_{t-1}] = 0
* $
*
* - **Variance**:
* $$
* \mathbb{V}(y_t) = \mathbb{V}(u_t - \theta u_{t-1}) = \sigma^2(1 + \theta^2) = 1.64 \quad \text{(same as $x_t$)}
* $
*
* - **Covariances**:
* $
* \begin{aligned}
* \mathbb{C}\text{ov}(y_t, y_{t-1}) &= \mathbb{C}\text{ov}(u_t - \theta u_{t-1}, u_{t-1} - \theta u_{t-2}) \\
* &= \mathbb{C}\text{ov}(u_t, u_{t-1}) - \theta \mathbb{C}\text{ov}(u_t, u_{t-2}) - \theta \mathbb{C}\text{ov}(u_{t-1}, u_{t-1}) + \theta^2 \mathbb{C}\text{ov}(u_{t-1}, u_{t-2}) \\
* &= 0 - 0 - \theta \sigma^2 + 0 = -\theta \sigma^2 = -0.8
* \end{aligned}
* $$
*
* For $h \geq 2$:
* $
* \mathbb{C}\text{ov}(y_t, y_{t-h}) = 0
* $
*
* - **Autocorrelations**
*
* - For $x_t$ with $\theta = 0.8$:
* $
* \rho(1) = \frac{\mathbb{C}\text{ov}(x_t, x_{t-1})}{\sqrt{\mathbb{V}(x_t) \mathbb{V}(x_{t-1})}} = \frac{\theta \sigma^2}{\sigma^2(1+\theta^2)} = \frac{\theta}{1+\theta^2} = \frac{0.8}{1+0.64} = \frac{0.8}{1.64} \approx 0.4878
* $
*
* - For $y_t$ with $\theta = 0.8$:
* $
* \rho(1) = \frac{\mathbb{C}\text{ov}(y_t, y_{t-1})}{\sqrt{\mathbb{V}(y_t) \mathbb{V}(y_{t-1})}} = \frac{-\theta \sigma^2}{\sigma^2(1+\theta^2)} = \frac{-\theta}{1+\theta^2} = \frac{-0.8}{1.64} \approx -0.4878
* $
*
* **Where Does Autocorrelation Come From?**
*
* The autocorrelation in MA(1) processes arises from the **shared white noise term** between consecutive observations:
*
* - For $x_t = u_t + \theta u_{t-1}$ and $x_{t-1} = u_{t-1} + \theta u_{t-2}$:
* - Both depend on $u_{t-1}$, creating a **positive correlation** when $\theta > 0$
* - The covariance $\mathbb{C}\text{ov}(x_t, x_{t-1}) = \theta \sigma^2$ comes from the term $\theta \mathbb{C}\text{ov}(u_{t-1}, u_{t-1}) = \theta \sigma^2$
*
* - For $y_t = u_t - \theta u_{t-1}$ and $y_{t-1} = u_{t-1} - \theta u_{t-2}$:
* - Both depend on $u_{t-1}$, but with **opposite signs**, creating a **negative correlation**
* - The covariance $\mathbb{C}\text{ov}(y_t, y_{t-1}) = -\theta \sigma^2$ comes from the term $-\theta \mathbb{C}\text{ov}(u_{t-1}, u_{t-1}) = -\theta \sigma^2$
*
* - For $h \geq 2$, there are **no shared white noise terms** between $x_t$ and $x_{t-h}$ (or $y_t$ and $y_{t-h}$), so the autocorrelation is zero. This is the characteristic "cut-off" property of MA processes.
*
* **Key Takeaway**: The comparison between $x_t$ (positive $\theta$) and $y_t$ (negative $\theta$) illustrates how the sign of the MA coefficient affects the correlation structure. Positive $\theta$ creates positive autocorrelation, while negative $\theta$ creates negative autocorrelation at lag 1.

* ============================================================================
* Simulation 3: MA(1) - Invertible
* ============================================================================
* Simulate x_t = u_t + theta*u_{t-1} with theta=0.8, u_t ~ N(0,1)
* Then compute y_t = u_t - theta*u_{t-1}

clear all  // Clear memory and remove all variables
set seed 12345  // Set random seed for reproducibility
set obs 1000  // Set number of observations to 1000

* Generate time index
generate t = _n  // Create time index variable
tsset t  // Declare time series structure

* Set parameter
scalar theta = 0.8  // Set MA(1) coefficient to 0.8

* Generate white noise u_t ~ N(0,1)
generate u = rnormal()  // Generate standard normal white noise

* Generate lagged white noise
generate u_lag1 = L.u  // Create lag-1 of u (u_{t-1})

* Simulate MA(1) process: x_t = u_t + theta*u_{t-1}
generate x = u + theta * u_lag1  // Compute MA(1) process

* Compute y_t = u_t - theta*u_{t-1}
generate y = u - theta * u_lag1  // Compute y_t transformation

* Display first 10 observations
list t u u_lag1 x y in 1/10  // Display first 10 observations

* Summary statistics
display "Summary Statistics for MA(1) Process:"
summarize u x y, detail  // Display detailed summary statistics

* Time series plots
twoway (line x t), ///
    title("MA(1) Process: x_t = u_t + 0.8*u_{t-1}") ///
    ytitle("x_t") xtitle("Time") ///
    name(ts_ma1_inv, replace) // Save graph

twoway (line y t), ///
    title("Transformed Process: y_t = u_t - 0.8*u_{t-1}") ///
    ytitle("y_t") xtitle("Time") ///
    name(ts_ma1_y, replace) // Save graph

* Autocorrelation function for x_t
ac x, lags(20)

* Autocorrelation function for y_t
ac y, lags(20)

display ""
display "For MA(1) with theta=0.8:"
display "Theoretical rho(1) = theta/(1+theta^2) = " %6.4f theta/(1+theta^2)
display "Theoretical rho(h) = 0 for h >= 2"


* 2.2 Non-Invertible MA(1)
*
* **⚠️ Warning - Identifiability Problem**: This simulation demonstrates a **non-invertible** MA(1) process where $1/\theta = 1.25 > 1$. While this process has the same autocorrelation structure as the invertible case, it cannot be represented as a convergent infinite AR process, creating estimation and forecasting difficulties.
*
* We simulate a non-invertible MA(1) process:
*
* $
* x_t = u_t + \frac{1}{\theta} u_{t-1} \quad \text{with } \theta = 0.8 \text{ (so } 1/\theta = 1.25 \text{)}
* $
*
* **Key Issue**: Since $|1/\theta| = 1.25 > 1$, the process is **not invertible**.
*
* **The Identifiability Problem**:
*
* The MA(1) processes with coefficients $\theta$ and $1/\theta$ produce **identical autocorrelation functions**:
*
* $
* \rho(1) = \frac{\theta}{1+\theta^2} = \frac{1/\theta}{1+(1/\theta)^2}
* $
*
* For example:
* - MA(1) with $\theta = 0.8$: $\rho(1) = 0.4878$
* - MA(1) with $\theta = 1.25$: $\rho(1) = 0.4878$ (same!)
*
* This means we cannot distinguish between these two processes based on autocorrelations alone.
*
* **Why This Matters**: In practice, when estimating MA models, we **always choose the invertible representation** ($|\theta|

* #### Interpretation of Results
*
* **🔍 What the Analysis Reveals:**
*
* 1. **Identical Autocorrelation**: The ACF for the non-invertible process shows the same pattern as the invertible case—significant autocorrelation at lag 1 (approximately 0.4878) and zero for $h \geq 2$. This confirms the identifiability problem.
*
* 2. **Increased Variance**: The variance of the non-invertible process is larger: $\mathbb{V}(x_t) = (1+(1/\theta)^2)\sigma^2 = (1+1.5625) = 2.5625$ when $\sigma^2 = 1$. This reflects the larger coefficient magnitude.
*
* 3. **Convergence Failure**: The non-invertible process cannot be written as a convergent infinite AR representation. Attempting to recover $u_t$ from $x_t$ would require an infinite sum that does not converge.
*
* 4. **Practical Implication**: When you see an MA(1) process with $|\theta| \geq 1$ in estimation output, it indicates a problem. Standard software packages automatically restrict estimation to the invertible region ($|\theta|
*
* **Important Note**: This simulation demonstrates why the invertibility condition is crucial in MA modeling. While both processes generate the same autocorrelation structure, only the invertible representation is useful for practical time series analysis, forecasting, and model diagnostics.
*
* -->

* ============================================================================
* Simulation 4: MA(1) - Not Invertible
* ============================================================================
* Simulate x_t = u_t + (1/theta)*u_{t-1} with theta=0.8
* Note: 1/theta = 1/0.8 = 1.25 > 1, so process is not invertible

clear all  // Clear memory and remove all variables
set seed 12345  // Set random seed for reproducibility
set obs 1000  // Set number of observations to 1000

* Generate time index
generate t = _n  // Create time index variable
tsset t  // Declare time series structure

* Set parameter
scalar theta = 0.8  // Set theta parameter
scalar inv_theta = 1/theta  // Compute 1/theta = 1.25

* Generate white noise u_t ~ N(0,1)
generate u = rnormal()  // Generate standard normal white noise

* Generate lagged white noise
generate u_lag1 = L.u  // Create lag-1 of u (u_{t-1})

* Simulate non-invertible MA(1): x_t = u_t + (1/theta)*u_{t-1}
generate x = u + inv_theta * u_lag1  // Compute non-invertible MA(1) process

* Display first 10 observations
list t u u_lag1 x in 1/10  // Display first 10 observations

* Summary statistics
display "Summary Statistics for Non-Invertible MA(1) Process:"
summarize u x, detail  // Display detailed summary statistics

* Time series plot
twoway (line x t), ///
    title("Non-Invertible MA(1): x_t = u_t + 1.25*u_{t-1}") ///
    ytitle("x_t") xtitle("Time") ///
    name(ts_ma1_noninv, replace) // Save graph

* Autocorrelation function for x_t
ac x, lags(20) name(acf_ma1_noninv, replace)

display ""
display "For non-invertible MA(1) with 1/theta = " %6.4f inv_theta ":"
display "The process has the same autocorrelation structure as invertible MA(1)"
display "but cannot be represented as a convergent AR(infinity) process"


* 3.1 Stationary AR(1)
*
* **Objective**: Simulate a stationary AR(1) process with $\alpha = 0.8$ (satisfying $|\alpha|
*
* We simulate:
*
* $
* x_t = \alpha x_{t-1} + u_t \quad \text{with } \alpha = 0.8, \quad u_t \sim N(0,1), \quad x_1 = 100
* $
*
* **Theoretical Moments**:
*
* Assuming $u_t \sim N(0, \sigma^2)$ with $\sigma^2 = 1$ and $|\alpha|  0$
*
* - For $h \geq 1$, the autocovariance $\gamma(h) = \alpha^h \gamma(0)$ reflects the **infinite memory** of the AR(1) process—past values always matter, but their influence decays exponentially. This contrasts with MA(1), which has **finite memory** (autocorrelation is zero for $h \geq 2$)
*
* - The exponential decay pattern $\rho(h) = \alpha^h$ means that:
* - When $|\alpha|$ is close to 1, the process has **strong persistence** (slow decay)
* - When $|\alpha|$ is close to 0, the process has **weak persistence** (fast decay toward white noise)
*
* **Mean Reversion Dynamics**:
*
* The process exhibits **mean reversion** because $|\alpha| = 0.8
*
* **Key Takeaway**: The stationary AR(1) process demonstrates **persistence with decay**. While the process has memory (past values matter), this memory fades over time. The exponential decay in autocorrelation means that observations far apart are nearly uncorrelated, which is a hallmark of stationary processes.

* ============================================================================
* Simulation 5: AR(1) - Stationary
* ============================================================================
* Simulate x_t = alpha*x_{t-1} + u_t with alpha=0.8, u_t ~ N(0,1), x_1=100

clear all  // Clear memory and remove all variables
set seed 12345  // Set random seed for reproducibility
set obs 1000  // Set number of observations to 1000

* Generate time index
generate t = _n  // Create time index variable
tsset t  // Declare time series structure

* Set parameter
scalar alpha = 0.8  // Set AR(1) coefficient to 0.8 (stationary)

* Generate white noise u_t ~ N(0,1)
generate u = rnormal()  // Generate standard normal white noise

* Initialize and simulate AR(1) process
generate x = .  // Initialize x as missing
replace x = 100 if t == 1  // Set initial condition x_1 = 100

* Recursively generate AR(1): x_t = alpha*x_{t-1} + u_t
quietly {
    forvalues i = 2/1000 {  // Loop from observation 2 to 1000
        replace x = alpha * L.x + u if t == `i'  // Compute AR(1) recursively
    }
}

* Display first 10 observations
list t u x in 1/10  // Display first 10 observations

* Summary statistics
display "Summary Statistics for Stationary AR(1) Process:"
summarize u x, detail  // Display detailed summary statistics

* Time series plot
twoway (line x t), ///
    title("Stationary AR(1): x_t = 0.8*x_{t-1} + u_t") ///
    ytitle("x_t") xtitle("Time") ///
    /* name(ts_ar1_stat, replace) // Save graph */

* Plot showing mean reversion (with zero reference line)
twoway (line x t), ///
    title("Stationary AR(1): Mean Reversion to Zero") ///
    ytitle("x_t") xtitle("Time") ///
    yline(0, lcolor(red) lpattern(dash)) ///
    /* name(ts_ar1_meanrev, replace) // Save graph */

* Autocorrelation function
ac x, lags(20) name(acf_ar1_stat, replace)

* Partial autocorrelation function
pac x, lags(20) name(pacf_ar1_stat, replace)

display ""
display "For stationary AR(1) with alpha = " %6.4f alpha ":"
display "Theoretical rho(h) = alpha^h (exponential decay)"
display "Mean reverts to zero (after initial condition effect dissipates)"

* 3.2 Non-Stationary AR(1)
*
* **⚠️ Explosive Process**: This simulation demonstrates an **explosive** AR(1) process where $\alpha = 1.0001 > 1$. The process is non-stationary with variance that grows exponentially over time, causing the series to diverge without bound.
*
* We simulate:
*
* $
* x_t = \alpha x_{t-1} + u_t \quad \text{with } \alpha = 1.0001 > 1, \quad u_t \sim N(0,1)
* $
*
* **Why This is Problematic**:
*
* When $|\alpha| > 1$:
* - **Variance Explosion**: $\mathbb{V}(x_t)$ grows exponentially with time
* - **No Mean Reversion**: The process does not return to a stable mean
* - **Divergence**: Values become arbitrarily large (or small) as $t \to \infty$
* - **Statistical Inference Fails**: Standard tests and confidence intervals are invalid
*
* **Comparison with Stationary Case**:
*
* - **Stationary** ($|\alpha|  1$): Variance grows exponentially, process diverges

* ============================================================================
* Simulation 6: AR(1) - Not Stationary (Explosive)
* ============================================================================
* Simulate x_t = alpha*x_{t-1} + u_t with alpha=1.0001, u_t ~ N(0,1)

clear all  // Clear memory and remove all variables
set seed 12345  // Set random seed for reproducibility
set obs 1000  // Set number of observations to 1000

* Generate time index
generate t = _n  // Create time index variable
tsset t  // Declare time series structure

* Set parameter
scalar alpha = 1.0001  // Set AR(1) coefficient to 1.0001 (explosive, non-stationary)

* Generate white noise u_t ~ N(0,1)
generate u = rnormal()  // Generate standard normal white noise

* Initialize and simulate AR(1) process
generate x = .  // Initialize x as missing
replace x = 0 if t == 1  // Set initial condition x_1 = 0

* Recursively generate AR(1): x_t = alpha*x_{t-1} + u_t
quietly {
    forvalues i = 2/1000 {  // Loop from observation 2 to 1000
        replace x = alpha * L.x + u if t == `i'  // Compute AR(1) recursively
    }
}

* Display first 10 and last 10 observations
list t u x in 1/10  // Display first 10 observations
list t u x in -10/-1  // Display last 10 observations

* Summary statistics
display "Summary Statistics for Non-Stationary AR(1) Process:"
summarize u x, detail  // Display detailed summary statistics

* Time series plot
twoway (line x t), ///
    title("Non-Stationary AR(1): x_t = 1.0001*x_{t-1} + u_t (Explosive)") ///
    ytitle("x_t") xtitle("Time") ///
    name(ts_ar1_explosive, replace) // Save graph

* Note: Process explodes, so values become very large

display ""
display "For non-stationary AR(1) with alpha = " %6.4f alpha " > 1:"
display "The process is explosive - variance grows without bound"
display "No mean reversion - process diverges"


* 3.3 Random Walk (Wiener Process)
*
* **Unit Root Process**: This simulation demonstrates a **random walk** (also called a **unit root process**) where $\alpha = 1$. This is the boundary case between stationarity and explosiveness, and it has profound implications for economic modeling and statistical inference.
*
* We simulate:
*
* $
* x_t = x_{t-1} + u_t \quad \text{with } u_t \sim N(0,1)
* $
*
* This can be written as:
*
* $
* x_t = x_0 + \sum_{j=1}^{t} u_j
* $
*
* **Key Properties**:
*
* 1. **Variance Growth**: $\mathbb{V}[x_t] = t \sigma^2$ (variance grows **linearly** with time, not exponentially)
*
* 2. **Permanent Shocks**: Shocks have **permanent effects**—they never decay. A shock at time $s$ affects all future values $x_t$ for $t > s$.
*
* 3. **No Mean Reversion**: The process has no tendency to return to any fixed level. It "wanders" without bound.
*
* 4. **First Differences are White Noise**: $\Delta x_t = x_t - x_{t-1} = u_t$ (stationary!)
*
* **Economic Interpretation**:
*
* Random walks are commonly used to model:
* - **Stock prices** (efficient market hypothesis)
* - **Exchange rates** (uncovered interest parity)
* - **GDP levels** (stochastic trends)
*
* **Key Takeaway**: The random walk demonstrates that **first differencing** can transform a non-stationary process into a stationary one. This is the foundation of cointegration analysis and error correction models. If $\Delta x_t$ is white noise, then $x_t$ is a random walk, and standard inference must be applied to the differenced series.

* ============================================================================
* Simulation 7: AR(1) - Random Walk (Wiener Process)
* ============================================================================
* Simulate x_t = alpha*x_{t-1} + u_t with alpha=1, u_t ~ N(0,1)
* This is a random walk: x_t = x_{t-1} + u_t

clear all  // Clear memory and remove all variables
set seed 12345  // Set random seed for reproducibility
set obs 1000  // Set number of observations to 1000

* Generate time index
generate t = _n  // Create time index variable
tsset t  // Declare time series structure

* Set parameter
scalar alpha = 1.0  // Set AR(1) coefficient to 1.0 (unit root)

* Generate white noise u_t ~ N(0,1)
generate u = rnormal()  // Generate standard normal white noise

* Initialize and simulate random walk: x_t = x_{t-1} + u_t
generate x = .  // Initialize x as missing
replace x = 0 if t == 1  // Set initial condition x_1 = 0

* Recursively generate random walk
quietly {
    forvalues i = 2/1000 {  // Loop from observation 2 to 1000
        replace x = L.x + u if t == `i'  // Compute random walk: x_t = x_{t-1} + u_t
    }
}

* Alternative: Use cumulative sum (more efficient for random walk)
* generate x = sum(u)  // Cumulative sum of u gives random walk

* Display first 10 and last 10 observations
list t u x in 1/10  // Display first 10 observations
list t u x in -10/-1  // Display last 10 observations

* Summary statistics
display "Summary Statistics for Random Walk:"
summarize u x, detail  // Display detailed summary statistics

* Time series plot
twoway (line x t), ///
    title("Random Walk: x_t = x_{t-1} + u_t") ///
    ytitle("x_t") xtitle("Time") ///
    name(ts_rw, replace) // Save graph

* Plot first differences (should be white noise)
generate dx = D.x  // First difference: Delta x_t = x_t - x_{t-1}
twoway (line dx t), ///
    title("First Differences of Random Walk (White Noise)") ///
    ytitle("Delta x_t") xtitle("Time") ///
    name(ts_rw_diff, replace) // Save graph

* Autocorrelation function (should show high persistence)
ac x, lags(20) name(acf_rw, replace)

* Partial autocorrelation function
pac x, lags(20) name(pacf_rw, replace)

* Autocorrelation of first differences (should be white noise)
ac dx, lags(20) name(acf_rw_diff, replace)

display ""
display "For random walk with alpha = 1:"
display "Variance grows linearly with time: Var(x_t) = t*sigma^2"
display "No mean reversion - process has infinite memory"
display "First differences are white noise: Delta x_t = u_t"


* 4.1 Binary Variable
*
* Generate $b_t = \mathbf{1}\{u_t<0.2\}$ with $u_t \sim U(0,1)$, creating a binary indicator variable.

* ============================================================================
* Simulation 8: Binary Variable
* ============================================================================
* Generate b_t = 1(u_t < 0.2) with u_t ~ U(0,1)

clear all  // Clear memory and remove all variables
set seed 12345  // Set random seed for reproducibility
set obs 1000  // Set number of observations to 1000

* Generate uniform random variable u_t ~ U(0,1)
generate u = runiform()  // Generate uniform random numbers on [0,1]

* Generate binary variable: b_t = 1 if u_t < 0.2, 0 otherwise
generate b = (u < 0.2)  // Create binary indicator (1 if condition true, 0 otherwise)

* Display first 20 observations
list u b in 1/20  // Display first 20 observations

* Summary statistics
display "Summary Statistics for Binary Variable:"
summarize u b, detail  // Display detailed summary statistics

* Frequency table
tabulate b  // Display frequency table for binary variable

* Generate time index for plotting
generate t = _n  // Create time index variable

* Time series plot of binary variable
twoway (scatter b t, msize(tiny)), ///
    title("Binary Variable: b_t = 1(u_t < 0.2)") ///
    ytitle("b_t") xtitle("Time") ///
    ylabel(0 1) ///
    name(ts_binary, replace) // Save graph

* Bar chart of frequencies
graph bar (count), over(b) ///
    title("Frequency Distribution of Binary Variable") ///
    ytitle("Count") ///
    name(bar_binary, replace) // Save graph

display ""
display "Expected proportion of b=1: P(u < 0.2) = 0.2"
display "Expected proportion of b=0: P(u >= 0.2) = 0.8"


* 4.2 Binary Markov Chain
*
* Simulate a binary Markov chain with $x_0=0$, $\mathbb{P}(x_t=0|x_{t-1}=0)=p=0.7$, and $\mathbb{P}(x_t=1|x_{t-1}=1)=q=0.8$, using the construction:
*
* $x_t = (1-x_{t-1})\mathbf{1}\{u_t>p\} + x_{t-1}\mathbf{1}\{u_t<q\}$
*
* where $u_t \sim U(0,1)$.
*
* **Theoretical unconditional probabilities:**
*
* - $\mathbb{P}(x_t=0) =\pi = \frac{1-q}{2-p-q} = \frac{1-0.8}{2-0.7-0.8} = 0.4$
* - $\mathbb{P}(x_t=1) = 1-\pi = 0.6$

* ============================================================================
* Simulation 9: Binary Markov Chain
* ============================================================================
* Simulate binary Markov chain with x_0=0, P(x_t=0|x_{t-1}=0)=p=0.7, P(x_t=1|x_{t-1}=1)=q=0.8
* Construction: x_t = (1-x_{t-1})*1(u_t>p) + x_{t-1}*1(u_t<q)

clear all  // Clear memory and remove all variables
set seed 12345  // Set random seed for reproducibility
set obs 1000  // Set number of observations to 1000

* Generate time index
generate t = _n  // Create time index variable
tsset t  // Declare time series structure

* Set parameters
scalar p = 0.7  // P(x_t=0|x_{t-1}=0) = 0.7
scalar q = 0.8  // P(x_t=1|x_{t-1}=1) = 0.8

* Generate uniform random variable u_t ~ U(0,1)
generate u = runiform()  // Generate uniform random numbers on [0,1]

* Initialize and simulate binary Markov chain
generate x = .  // Initialize x as missing
replace x = 0 if t == 1  // Set initial condition x_0 = 0

* Recursively generate Markov chain: x_t = (1-x_{t-1})*1(u_t>p) + x_{t-1}*1(u_t<q)
quietly {
    forvalues i = 2/1000 {  // Loop from observation 2 to 1000
        replace x = (1-L.x)*(u > p) + L.x*(u < q) if t == `i'  // Compute Markov chain
    }
}

* Display first 30 observations
list t u x in 1/30  // Display first 30 observations

* Summary statistics
display "Summary Statistics for Binary Markov Chain:"
summarize u x, detail  // Display detailed summary statistics

* Frequency table
tabulate x  // Display frequency table for binary variable

* Transition matrix (empirical)
generate x_lag1 = L.x  // Create lag-1 of x
tabulate x_lag1 x, row  // Display transition matrix with row percentages

* Time series plot of binary Markov chain
twoway (scatter x t, msize(tiny)), ///
    title("Binary Markov Chain") ///
    ytitle("x_t") xtitle("Time") ///
    ylabel(0 1) ///
    name(ts_markov, replace) // Save graph

* Bar chart of state frequencies
graph bar (count), over(x) ///
    title("Frequency Distribution of Markov Chain States") ///
    ytitle("Count") ///
    name(bar_markov, replace) // Save graph

display ""
display "Transition probabilities:"
display "P(x_t=0|x_{t-1}=0) = p = " %6.4f p
display "P(x_t=1|x_{t-1}=1) = q = " %6.4f q


* 4.4 AR(1) Form of Markov Chain
*
* **Objective**: Simulate the Markov chain using the AR(1) representation $x_t = 1-p + (p+q-1)x_{t-1} + w_t$ and compare with the direct Markov chain simulation. This demonstrates how discrete-state processes can be represented in continuous AR form.
*
* To derive the AR(1) representation, we start by computing the conditional expectation of $x_t$ given $x_{t-1}$:
*
* $\mathbb{E}[x_t|x_{t-1}] = \mathbb{P}(x_t=1|x_{t-1}) \cdot 1 + \mathbb{P}(x_t=0|x_{t-1}) \cdot 0 = \mathbb{P}(x_t=1|x_{t-1})$
*
* Now, we express this conditional expectation in terms of $x_{t-1}$:
*
* - When $x_{t-1}=0$: $\mathbb{E}[x_t|x_{t-1}=0] = \mathbb{P}(x_t=1|x_{t-1}=0) = 1-p$
* - When $x_{t-1}=1$: $\mathbb{E}[x_t|x_{t-1}=1] = \mathbb{P}(x_t=1|x_{t-1}=1) = q$
*
* We can combine these two cases into a single linear expression:
*
* $\begin{aligned}
* \mathbb{E}[x_t|x_{t-1}] &= (1-p)(1-x_{t-1}) + qx_{t-1} \\
* &= (1-p) - (1-p)x_{t-1} + qx_{t-1} \\
* &= 1-p + (p+q-1)x_{t-1}
* \end{aligned}$
*
* Now, define the error term as the deviation from the conditional expectation:
*
* $w_t = x_t - \mathbb{E}[x_t|x_{t-1}] = x_t - [1-p + (p+q-1)x_{t-1}]$
*
* By construction, $w_t$ has mean zero conditional on $x_{t-1}$: $\mathbb{E}[w_t|x_{t-1}] = \mathbb{E}[x_t|x_{t-1}] - \mathbb{E}[x_t|x_{t-1}] = 0$. Rearranging the error term definition, we obtain the AR(1) representation:
*
* **AR(1) Representation**:
*
* $x_t = 1-p + (p+q-1)x_{t-1} + w_t$
*
* This shows that the binary Markov chain can be expressed as an AR(1) process with:
* - **Intercept**: $\beta_0 = 1-p$
* - **AR(1) coefficient**: $\beta_1 = p+q-1$
* - **Error term**: $w_t$ with $\mathbb{E}[w_t|x_{t-1}] = 0$
*
* **Martingale Difference Sequence**:
*
* A **martingale difference sequence** (MDS) is a sequence of random variables $\{w_t\}$ that satisfies:
*
* $\mathbb{E}[w_t | \mathcal{F}_{t-1}] = 0$
*
* where $\mathcal{F}_{t-1}$ represents the information set (sigma-algebra) available at time $t-1$.
*
* **Key properties**:
* - **Conditional mean zero**: The expected value of $w_t$ given past information is zero, but this does **not** imply independence.
* - **Dependence on past**: Unlike white noise, $w_t$ can depend on $x_{t-1}$ and other past information—it only needs to have zero conditional expectation.
* - **Variance may vary**: The conditional variance $\mathbb{V}(w_t | \mathcal{F}_{t-1})$ can depend on past information (heteroskedasticity).
*
* In our Markov chain case, $w_t = x_t - \mathbb{E}[x_t|x_{t-1}]$ is an MDS because:
* - $\mathbb{E}[w_t | x_{t-1}] = 0$ (by construction)
* - But $w_t$ clearly depends on $x_{t-1}$ (its distribution changes based on the previous state)
* - The variance of $w_t$ depends on $x_{t-1}$: $\mathbb{V}(w_t | x_{t-1}=0) \neq \mathbb{V}(w_t | x_{t-1}=1)$
*
* This is why $w_t$ is **not** independent white noise, but rather a martingale difference sequence.

* ============================================================================
* Simulation 11: Markov Chain - AR(1) Form
* ============================================================================
* Simulate x_t = 1-p + (p+q-1)*x_{t-1} + w_t and compare with Markov chain simulation

clear all  // Clear memory and remove all variables
set seed 12345  // Set random seed for reproducibility
set obs 1000  // Set number of observations to 1000

* Generate time index
generate t = _n  // Create time index variable
tsset t  // Declare time series structure

* Set parameters
scalar p = 0.7  // P(x_t=0|x_{t-1}=0) = 0.7
scalar q = 0.8  // P(x_t=1|x_{t-1}=1) = 0.8

* AR(1) coefficients
scalar beta0 = 1 - p  // Intercept: 1 - p
scalar beta1 = p + q - 1  // AR(1) coefficient: p + q - 1

* Method 1: Direct Markov chain simulation
generate u1 = runiform()  // Generate uniform random numbers for method 1
generate x_markov = .  // Initialize Markov chain
replace x_markov = 0 if t == 1  // Set initial condition
quietly {
    forvalues i = 2/1000 {  // Loop from observation 2 to 1000
        replace x_markov = (1-L.x_markov)*(u1 > p) + L.x_markov*(u1 < q) if t == `i'
    }
}

* Method 2: AR(1) form simulation
* Note: w_t is a martingale difference sequence
generate u2 = runiform()  // Generate uniform random numbers for method 2
generate x_ar1 = .  // Initialize AR(1) form
replace x_ar1 = 0 if t == 1  // Set initial condition

* Generate w_t (martingale difference sequence)
* w_t has conditional mean zero and appropriate variance
generate w = .  // Initialize w
quietly {
    forvalues i = 2/1000 {  // Loop from observation 2 to 1000
        * w_t depends on x_{t-1} and u_t
        * For x_{t-1}=0: w_t = 1(u_t>p) - (1-p)
        * For x_{t-1}=1: w_t = 1(u_t<q) - q
        replace w = (1-L.x_ar1)*((u2 > p) - (1-p)) + L.x_ar1*((u2 < q) - q) if t == `i'
        replace x_ar1 = beta0 + beta1*L.x_ar1 + w if t == `i'
    }
}

* Display first 30 observations
list t x_markov x_ar1 w in 1/30  // Display first 30 observations

* Summary statistics
display "Summary Statistics - Comparison:"
summarize x_markov x_ar1 w, detail  // Display detailed summary statistics

* Time series plot of w_t (martingale difference)
twoway (line w t), ///
    title("Martingale Difference Sequence: w_t") ///
    ytitle("w_t") xtitle("Time") ///
    name(ts_markov_w, replace) // Save graph

display ""
display "Correlation between Markov chain and AR(1) form: " %6.4f r(rho)
display ""
display "AR(1) form: x_t = " %6.4f beta0 " + " %6.4f beta1 "*x_{t-1} + w_t"
display "where w_t is a martingale difference sequence"


* ARMA(1,1) Simulation
*
* Simulate $x_t = \alpha x_{t-1} + u_t + \theta u_{t-1}$ with $\alpha=0.9$, $\theta=-0.8$, and $u_t \sim N(0,1)$.

* ============================================================================
* Simulation 12: ARMA(1,1)
* ============================================================================
* Simulate x_t = alpha*x_{t-1} + u_t + theta*u_{t-1} with alpha=0.9, theta=-0.8, u_t ~ N(0,1)

clear all  // Clear memory and remove all variables
set seed 12345  // Set random seed for reproducibility
set obs 1000  // Set number of observations to 1000

* Generate time index
generate t = _n  // Create time index variable
tsset t  // Declare time series structure

* Set parameters
scalar alpha = 0.9  // AR(1) coefficient
scalar theta = -0.8  // MA(1) coefficient

* Generate white noise u_t ~ N(0,1)
generate u = rnormal()  // Generate standard normal white noise

* Generate lagged white noise
generate u_lag1 = L.u  // Create lag-1 of u (u_{t-1})

* Initialize and simulate ARMA(1,1) process
generate x = .  // Initialize x as missing
replace x = 0 if t == 1  // Set initial condition x_1 = 0

* Recursively generate ARMA(1,1): x_t = alpha*x_{t-1} + u_t + theta*u_{t-1}
quietly {
    forvalues i = 2/1000 {  // Loop from observation 2 to 1000
        replace x = alpha * L.x + u + theta * u_lag1 if t == `i'  // Compute ARMA(1,1)
    }
}

* Display first 10 observations
list t u u_lag1 x in 1/10  // Display first 10 observations

* Summary statistics
display "Summary Statistics for ARMA(1,1) Process:"
summarize u x, detail  // Display detailed summary statistics

* Time series plot
twoway (line x t), ///
    title("ARMA(1,1): x_t = 0.9*x_{t-1} + u_t - 0.8*u_{t-1}") ///
    ytitle("x_t") xtitle("Time") ///
    name(ts_arma11, replace) // Save graph

* Autocorrelation function
ac x, lags(20) name(acf_arma11, replace)

* Partial autocorrelation function
pac x, lags(20) name(pacf_arma11, replace)

display ""
display "For ARMA(1,1) with alpha = " %6.4f alpha " and theta = " %6.4f theta ":"
display "Stationarity condition: |alpha| < 1 (satisfied: " %6.4f abs(alpha) " < 1)"
display "Invertibility condition: |theta| < 1 (satisfied: " %6.4f abs(theta) " < 1)"
display "The ACF shows exponential decay (from AR component)"
display "The PACF also shows exponential decay (from MA component)"



* Close log file
log close  // Close log file

display "============================================================================"
display "Script completed"
display "============================================================================"