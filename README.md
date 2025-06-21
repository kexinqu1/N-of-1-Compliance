# Supplementary Code for:
**Instrumental Variable Approach to Estimating Individual Causal Effects in N-of-1 Trials: Application to ISTOP Study**

Author: Kexin Qu  
Contact: [kexin_qu@alumni.brown.edu](mailto:kexin_qu@alumni.brown.edu)

This repository contains supplementary R code for the Bayesian instrumental variable (IV) method described in the manuscript submitted to *Biostatistics*. The method estimates individual causal effects in N-of-1 trials using a Bayesian IV approach, motivated by the I-STOP-AFib Study on atrial fibrillation and alcohol exposure.

## 📄 Description

An N-of-1 trial is a multiple crossover trial conducted in a single individual to inform personalized treatment decisions. This repository implements a Bayesian IV framework to:

- Handle **imperfect compliance** to randomized treatment assignment.
- Address **binary outcomes and treatments**, accounting for **non-collapsibility** of odds ratios.
- Model **serial correlation** in longitudinal data.
- Use study randomization as an **instrumental variable** to isolate causal effects.

The code estimates two estimands:
1. The effect of **continuous exposure** (e.g., days with alcohol use).
2. The effect of an **individual’s observed behavior**.

Estimation is conducted via a system of two Bayesian models using `rjags`. A simulation study demonstrated reduced bias and improved coverage compared to ITT, PP, and AT analyses.

## 📁 Repository Contents

- `run_rjags_nof1_iv.R`: Main R script that runs the Bayesian IV model.
- `utility_functions.R`: Helper functions for preprocessing and modeling.
- `model.txt`: JAGS model file defining the latent structural model.
- `data/`: *(optional)* Folder to store input data (e.g., `simulated_example.csv`).
- `output/`: *(optional)* Folder for results such as posterior summaries or plots.

## ▶️ How to Use

### 1. Install Required R Packages

```r
install.packages(c("rjags", "coda", "ggplot2", "dplyr"))
