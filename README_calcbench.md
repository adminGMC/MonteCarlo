# CalcBench API R Client

A comprehensive R client for connecting to the CalcBench API to retrieve financial data for Monte Carlo simulations and financial analysis.

## Overview

CalcBench provides financial data and analytics for public companies. This R client allows you to:

- Connect to the CalcBench API using username/password or API key authentication
- Retrieve company information and financial statements
- Extract historical data for Monte Carlo simulations
- Perform multi-company analysis for industry comparisons

## Files in this Package

- `calcbench_api.R` - Main API client with all connection and data retrieval functions
- `calcbench_config.R` - Configuration settings and common financial metrics
- `calcbench_examples.R` - Usage examples and demonstration functions
- `README_calcbench.md` - This documentation file

## Installation and Setup

### Prerequisites

The following R packages are required:
- `httr` - For HTTP requests
- `jsonlite` - For JSON parsing
- `dplyr` - For data manipulation

Install them using:
```r
install.packages(c("httr", "jsonlite", "dplyr"))
```

### Authentication

You need CalcBench API credentials to use this client. Set up authentication using one of these methods:

#### Method 1: Environment Variables (Recommended)
```r
Sys.setenv(CALCBENCH_USERNAME = "your_username")
Sys.setenv(CALCBENCH_PASSWORD = "your_password")
# OR
Sys.setenv(CALCBENCH_API_KEY = "your_api_key")
```

#### Method 2: Direct Credential Passing
```r
client <- create_calcbench_client(
  username = "your_username", 
  password = "your_password"
)
# OR
client <- create_calcbench_client(api_key = "your_api_key")
```

## Usage Examples

### Basic Setup
```r
# Load the API client
source("calcbench_api.R")

# Create a client instance
client <- create_calcbench_client()

# Authenticate with the API
if (client$authenticate()) {
  cat("Successfully connected to CalcBench API\n")
}
```

### Company Information
```r
# Get information about Apple Inc.
apple_info <- client$get_companies(ticker = "AAPL")

# Get multiple companies by industry (SIC code)
tech_companies <- client$get_companies(sic_code = 3570, limit = 10)
```

### Financial Data Retrieval
```r
# Get cash flow statement
apple_cash_flow <- client$get_cash_flow("AAPL", "annual", 2023)

# Get income statement
apple_income <- client$get_income_statement("AAPL", "annual", 2023)

# Get balance sheet
apple_balance <- client$get_balance_sheet("AAPL", "annual", 2023)
```

### Historical Data for Monte Carlo Simulation
```r
# Get 5 years of historical data
historical_data <- client$get_historical_data_for_monte_carlo("AAPL", 5)

# Extract cash flow trends for analysis
cash_flows <- sapply(historical_data, function(x) {
  if (!is.null(x$cash_flow)) {
    x$cash_flow$NetCashProvidedByOperatingActivities
  } else {
    NA
  }
})

# Calculate growth statistics for Monte Carlo inputs
growth_rates <- diff(cash_flows) / cash_flows[-length(cash_flows)]
mean_growth <- mean(growth_rates, na.rm = TRUE)
sd_growth <- sd(growth_rates, na.rm = TRUE)
```

### Multi-Company Analysis
```r
# Analyze multiple technology companies
tech_tickers <- c("AAPL", "MSFT", "GOOGL", "AMZN", "META")
revenue_data <- list()

for (ticker in tech_tickers) {
  income_data <- client$get_income_statement(ticker, "annual", 2023)
  if (!is.null(income_data)) {
    revenue_data[[ticker]] <- income_data$Revenue
  }
}

# Calculate industry statistics
industry_stats <- list(
  mean_revenue = mean(unlist(revenue_data), na.rm = TRUE),
  median_revenue = median(unlist(revenue_data), na.rm = TRUE),
  sd_revenue = sd(unlist(revenue_data), na.rm = TRUE)
)
```

## Running Examples

### Demo Mode (No API Credentials Required)
```r
# Load examples
source("calcbench_examples.R")

# Run all examples in demo mode
run_all_examples(demo_mode = TRUE)

# Test the API client installation
test_api_client()
```

### Live Mode (Requires Valid Credentials)
```r
# Run examples with actual API calls
run_all_examples(demo_mode = FALSE)
```

## API Functions Reference

### Authentication
- `create_calcbench_client(username, password, api_key)` - Create API client instance
- `client$authenticate()` - Authenticate with CalcBench API

### Company Data
- `client$get_companies(ticker, sic_code, limit)` - Get company information
- `client$get_financials(ticker, period_type, year, metrics)` - Get financial data

### Financial Statements
- `client$get_cash_flow(ticker, period_type, year)` - Get cash flow statement
- `client$get_income_statement(ticker, period_type, year)` - Get income statement  
- `client$get_balance_sheet(ticker, period_type, year)` - Get balance sheet

### Monte Carlo Support
- `client$get_historical_data_for_monte_carlo(ticker, years_back)` - Get historical data for simulation

## Configuration

The `calcbench_config.R` file contains:
- API endpoints and settings
- Common financial metrics for different statement types
- Industry classifications and SIC codes
- Rate limiting and timeout configurations

## Error Handling

The client includes comprehensive error handling:
- Network connectivity issues
- Authentication failures
- Invalid ticker symbols
- Rate limiting responses
- API endpoint changes

## Integration with Monte Carlo Simulation

This CalcBench client is designed to integrate with Monte Carlo simulations for:

1. **Historical Data Collection**: Gathering multi-year financial data
2. **Trend Analysis**: Calculating growth rates and volatility metrics
3. **Industry Comparisons**: Benchmarking against industry peers
4. **Risk Assessment**: Analyzing financial statement stability
5. **Projection Inputs**: Providing base data for future cash flow projections

## Support and Documentation

For additional information:
- CalcBench API documentation: https://www.calcbench.com/api
- This client's examples: Run `demo_calcbench_usage()` or `run_all_examples()`
- Configuration details: See `calcbench_config.R`

## Security Notes

- Never commit API credentials to version control
- Use environment variables for credential storage
- Regularly rotate API keys
- Monitor API usage and rate limits

## License

This R client is provided as-is for connecting to the CalcBench API. Please ensure you have appropriate CalcBench API access and comply with their terms of service.