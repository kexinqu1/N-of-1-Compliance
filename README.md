# Supplementary Code for:
**Instrumental Variable Approach to Estimating Individual Causal Effects in N-of-1 Trials: Application to ISTOP Study**

Author: Kexin Qu  
Contact: [kexin_qu@alumni.brown.edu]


## Repository Contents

- `run_rjags_nof1_iv.R`: Main R script that runs the Bayesian IV model.
- `utility_functions.R`: Helper functions for preprocessing and modeling.
- `model.txt`: JAGS model file defining the latent structural model.
- `Data/`: *(optional)* Folder to store input data (e.g., `simulated_example.csv`).
- `Output/`: *(optional)* Folder for results such as posterior summaries or plots.

## How to Use

```r
# 1. Install Required R Packages

install.packages(c("rjags", "coda", "ggplot2", "dplyr"))

#  2. Run scripts
# Load utility functions
source("utility_functions.R")

# Run the main model
source("run_rjags_nof1_iv.R")
```

## Notes

### The input data for one N-of-1 trial should be structured as a matrix or data frame with dimensions TJ × 3, where the three columns include
  - `Y` represents the outcome (e.g., AF occurrence),
  - `X` represents the treatment selection (e.g., actual drinking) ,
  - `R` represents the treatment assignment (drinking period randomization).

 ### The model file `nof1_carryover_model.txt` must be located in the same folder** as the main script `run_rjags_nof1_iv.R` for the model to be correctly loaded.
