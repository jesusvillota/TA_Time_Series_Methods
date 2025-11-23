<todo1>
In the folder TeX/data_instalation_guide, create a tex document to guide students on how to download the data series. 
For reference, look at:
    - TeX/installation_guide/main.tex
    - TeX/example/main.tex

For details about the data look at
    - materials/instructions/empirical_applications.md
    - materials/instructions/metadata.md
    - data/ contains the downloaded data series
</todo1>

<todo2>
Read #file:materials/pdf/linear_models_own.tex. Your task is to create a notebook called #file:simulations.ipynb inside #file:sessions/ where you implement each and every simulation exercise in #file:materials/pdf/linear_models_own.tex. 
Simulations should be done in stata (we have a stata kernel in jupyter). 

Implement the following simulations:

[ ] ## Section 1: Univariate Models

1. **White Noise - Uniform**: Generate $e_1 = \mathrm{uniform}()$ and $e_2 = e_1 * e_1$
2. **White Noise - Gaussian**: Generate $u = \mathrm{normal}()$
3. **MA(1) - Invertible**: Simulate $x_t = u_t + \theta u_{t-1}$ with $\theta=0.8$ and $u_t \sim N(0,1)$, then compute $y_t = u_t - \theta u_{t-1}$
4. **MA(1) - Not Invertible**: Simulate $x_t = u_t + (1/\theta)u_{t-1}$ with $\theta=0.8$
5. **AR(1) - Stationary**: Simulate $x_t = \alpha x_{t-1} + u_t$ with $\alpha=0.8$, $u_t \sim N(0,1)$, and $x_1=100$
6. **AR(1) - Not Stationary**: Simulate $x_t = \alpha x_{t-1} + u_t$ with $\alpha=1.0001$ and $u_t \sim N(0,1)$
7. **AR(1) - Random Walk (Wiener Process)**: Simulate $x_t = \alpha x_{t-1} + u_t$ with $\alpha=1$ and $u_t \sim N(0,1)$
8. **Binary Variable**: Generate $b_t = 1(u_t<0.2)$ with $u_t \sim U(0,1)$
9. **Binary Markov Chain**: Simulate with $x_0=0$, $P(x_t=0|x_{t-1}=0)=p=0.7$, $P(x_t=1|x_{t-1}=1)=q=0.8$, using construction $x_t=(1-x_{t-1})1(u_t>p)+x_{t-1}1(u_t<q)$
10. **Markov Chain - Unconditional Probability**: Calculate and verify $\pi = \frac{1-q}{2-p-q}$ for the binary Markov chain
11. **Markov Chain - AR(1) Form**: Simulate $x_t = 1-p + (p+q-1)x_{t-1} + w_t$ and compare with Markov chain simulation
12. **ARMA(1,1)**: Simulate $x_t = \alpha x_{t-1} + u_t + \theta u_{t-1}$ with $\alpha=0.9$, $\theta=-0.8$, and $u_t \sim N(0,1)$

[ ] ## Section 2: Multivariate Models

1. **Multivariate White Noise - Cholesky**: Generate $v_t \sim N(0,\Sigma)$ using Cholesky factorization with $\Sigma=\begin{pmatrix}1 & 0.6\\0.6 & 1\end{pmatrix}$ and $H_1=\begin{pmatrix}1&0\\0.6&0.8\end{pmatrix}$
2. **Multivariate White Noise - Spectral Decomposition**: Generate $v_t$ using spectral decomposition with eigenvalues $\Delta=\operatorname{diag}(1.6,0.4)$
3. **VMA(1)**: Simulate $\begin{pmatrix}x_{1t}\\x_{2t}\end{pmatrix} = \begin{pmatrix}v_{1t}\\v_{2t}\end{pmatrix} + B \begin{pmatrix}v_{1,t-1}\\v_{2,t-1}\end{pmatrix}$ with $B=\begin{pmatrix}0.2 & 0.3\\0.6 & 0.5\end{pmatrix}$
4. **VAR(1) - Triangular**: Simulate $x_t = A x_{t-1} + v_t$ with triangular $A=\begin{pmatrix}0.9 & 0\\1 & 0\end{pmatrix}$
5. **VAR(1) - Non-triangular**: Simulate $x_t = A x_{t-1} + v_t$ with non-triangular $A=\begin{pmatrix}0.4 & 0.16\\0.36 & 0.4\end{pmatrix}$ using similarity transformation with $P=\begin{pmatrix}0.6 & 0.4\\0 & 1\end{pmatrix}$

[ ] ## Section 3: Kalman Filter

1. **Local Level Model with Kalman Filter**: Implement Kalman filter for $y_t = \mu_t + u_t$ and $\mu_t = \mu_{t-1} + v_t$ with the prediction update formula $y_t^* = y_{t-1}^* + (1-\delta)(y_{t-1}-y_{t-1}^*)$, where $\delta=\frac{\sigma_u^2}{\sigma_u^2+\sigma_v^2+p}$ and $p = -\sigma_v^2 + \sqrt{\sigma_v^4 + 4\sigma_u^2\sigma_v^2} / 2$

To get inspiration on how to craft the notebook, you can look at:
    - #file:sessions/session_1/01_autocorrelation_correlation.ipynb
    - #file:sessions/session_1/04_arma_models.ipynb
</todo2>