# MonteCarlo
Build out a Monte Carlo Simulation to calculate the projected cash flow for a given company

## CalcBench API Integration

This repository now includes a comprehensive R client for connecting to the CalcBench API to retrieve financial data for Monte Carlo simulations.

### CalcBench API Files
- `calcbench_api.R` - Main API client for CalcBench integration
- `calcbench_config.R` - Configuration and financial metrics
- `calcbench_examples.R` - Usage examples and demonstrations
- `README_calcbench.md` - Detailed documentation for the CalcBench API client

### Quick Start
```r
# Load the CalcBench API client
source("calcbench_api.R")

# Create client and authenticate
client <- create_calcbench_client()

# Get historical data for Monte Carlo simulation
historical_data <- client$get_historical_data_for_monte_carlo("AAPL", 5)
```

### Demo
```r
# See examples without requiring API credentials
source("calcbench_examples.R")
run_all_examples(demo_mode = TRUE)
```

For detailed documentation, see `README_calcbench.md`.
