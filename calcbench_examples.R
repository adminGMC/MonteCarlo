# CalcBench API Usage Examples
# 
# This script demonstrates how to use the CalcBench API client
# for Monte Carlo simulation data preparation

# Source the main API client and configuration
source("calcbench_api.R")
source("calcbench_config.R")

# Example 1: Basic Setup and Authentication
setup_example <- function() {
  cat("=== CalcBench API Setup Example ===\n\n")
  
  # Method 1: Using environment variables (recommended)
  cat("Setting up credentials via environment variables:\n")
  cat("Sys.setenv(CALCBENCH_USERNAME = 'your_username')\n")
  cat("Sys.setenv(CALCBENCH_PASSWORD = 'your_password')\n")
  cat("# OR\n")
  cat("Sys.setenv(CALCBENCH_API_KEY = 'your_api_key')\n\n")
  
  # Method 2: Direct credential passing
  cat("Or pass credentials directly:\n")
  cat("client <- create_calcbench_client(\n")
  cat("  username = 'your_username',\n")
  cat("  password = 'your_password'\n")
  cat(")\n\n")
  
  return("Setup instructions displayed")
}

# Example 2: Company Data Retrieval
company_data_example <- function(demo_mode = TRUE) {
  cat("=== Company Data Retrieval Example ===\n\n")
  
  if (demo_mode) {
    cat("# Create client\n")
    cat("client <- create_calcbench_client()\n\n")
    
    cat("# Get information about Apple Inc.\n")
    cat("apple_info <- client$get_companies(ticker = 'AAPL')\n")
    cat("print(apple_info)\n\n")
    
    cat("# Get multiple technology companies\n")
    cat("tech_companies <- client$get_companies(sic_code = 3570, limit = 10)\n")
    cat("print(tech_companies)\n\n")
    
    return("Company data example displayed")
  } else {
    # Actual execution (requires valid credentials)
    client <- create_calcbench_client()
    
    if (client$authenticate()) {
      apple_info <- client$get_companies(ticker = "AAPL")
      return(apple_info)
    } else {
      return("Authentication failed")
    }
  }
}

# Example 3: Financial Data for Monte Carlo Simulation
monte_carlo_data_example <- function(demo_mode = TRUE) {
  cat("=== Monte Carlo Simulation Data Example ===\n\n")
  
  if (demo_mode) {
    cat("# Get 5 years of historical data for Apple\n")
    cat("client <- create_calcbench_client()\n")
    cat("historical_data <- client$get_historical_data_for_monte_carlo('AAPL', 5)\n\n")
    
    cat("# Extract cash flow trends\n")
    cat("cash_flows <- sapply(historical_data, function(x) {\n")
    cat("  if (!is.null(x$cash_flow)) {\n")
    cat("    x$cash_flow$NetCashProvidedByOperatingActivities\n")
    cat("  } else {\n")
    cat("    NA\n")
    cat("  }\n")
    cat("})\n\n")
    
    cat("# Calculate year-over-year growth rates\n")
    cat("growth_rates <- diff(cash_flows) / cash_flows[-length(cash_flows)]\n")
    cat("mean_growth <- mean(growth_rates, na.rm = TRUE)\n")
    cat("sd_growth <- sd(growth_rates, na.rm = TRUE)\n\n")
    
    cat("# These statistics can be used in Monte Carlo simulation\n")
    cat("cat('Mean growth rate:', mean_growth, '\\n')\n")
    cat("cat('Standard deviation:', sd_growth, '\\n')\n\n")
    
    return("Monte Carlo data example displayed")
  } else {
    # Actual execution (requires valid credentials)
    client <- create_calcbench_client()
    
    if (client$authenticate()) {
      historical_data <- client$get_historical_data_for_monte_carlo("AAPL", 5)
      return(historical_data)
    } else {
      return("Authentication failed")
    }
  }
}

# Example 4: Cash Flow Analysis
cash_flow_analysis_example <- function(demo_mode = TRUE) {
  cat("=== Cash Flow Analysis Example ===\n\n")
  
  if (demo_mode) {
    cat("# Get detailed cash flow data\n")
    cat("client <- create_calcbench_client()\n")
    cat("cash_flow_2023 <- client$get_cash_flow('AAPL', 'annual', 2023)\n")
    cat("cash_flow_2022 <- client$get_cash_flow('AAPL', 'annual', 2022)\n\n")
    
    cat("# Compare year-over-year changes\n")
    cat("operating_cf_change <- (\n")
    cat("  cash_flow_2023$NetCashProvidedByOperatingActivities -\n")
    cat("  cash_flow_2022$NetCashProvidedByOperatingActivities\n")
    cat(") / cash_flow_2022$NetCashProvidedByOperatingActivities\n\n")
    
    cat("cat('Operating Cash Flow YoY Change:', operating_cf_change * 100, '%\\n')\n\n")
    
    return("Cash flow analysis example displayed")
  } else {
    # Actual execution (requires valid credentials)
    client <- create_calcbench_client()
    
    if (client$authenticate()) {
      cash_flow_2023 <- client$get_cash_flow("AAPL", "annual", 2023)
      return(cash_flow_2023)
    } else {
      return("Authentication failed")
    }
  }
}

# Example 5: Multi-company Analysis
multi_company_analysis_example <- function(demo_mode = TRUE) {
  cat("=== Multi-company Analysis Example ===\n\n")
  
  if (demo_mode) {
    cat("# Analyze multiple companies in the same industry\n")
    cat("tech_tickers <- c('AAPL', 'MSFT', 'GOOGL', 'AMZN', 'META')\n")
    cat("client <- create_calcbench_client()\n\n")
    
    cat("# Get revenue data for all companies\n")
    cat("revenue_data <- list()\n")
    cat("for (ticker in tech_tickers) {\n")
    cat("  income_data <- client$get_income_statement(ticker, 'annual', 2023)\n")
    cat("  if (!is.null(income_data)) {\n")
    cat("    revenue_data[[ticker]] <- income_data$Revenue\n")
    cat("  }\n")
    cat("}\n\n")
    
    cat("# Convert to data frame for analysis\n")
    cat("revenue_df <- data.frame(\n")
    cat("  Company = names(revenue_data),\n")
    cat("  Revenue = unlist(revenue_data)\n")
    cat(")\n\n")
    
    cat("# Calculate industry statistics\n")
    cat("industry_mean <- mean(revenue_df$Revenue, na.rm = TRUE)\n")
    cat("industry_median <- median(revenue_df$Revenue, na.rm = TRUE)\n")
    cat("industry_sd <- sd(revenue_df$Revenue, na.rm = TRUE)\n\n")
    
    return("Multi-company analysis example displayed")
  } else {
    # Actual execution (requires valid credentials)
    tech_tickers <- c("AAPL", "MSFT", "GOOGL", "AMZN", "META")
    client <- create_calcbench_client()
    
    if (client$authenticate()) {
      revenue_data <- list()
      for (ticker in tech_tickers) {
        income_data <- client$get_income_statement(ticker, "annual", 2023)
        if (!is.null(income_data)) {
          revenue_data[[ticker]] <- income_data$Revenue
        }
      }
      return(revenue_data)
    } else {
      return("Authentication failed")
    }
  }
}

# Function to run all examples
run_all_examples <- function(demo_mode = TRUE) {
  cat("CalcBench API Usage Examples\n")
  cat("============================\n\n")
  
  setup_example()
  cat("\n", strrep("=", 50), "\n\n")
  
  company_data_example(demo_mode)
  cat("\n", strrep("=", 50), "\n\n")
  
  monte_carlo_data_example(demo_mode)
  cat("\n", strrep("=", 50), "\n\n")
  
  cash_flow_analysis_example(demo_mode)
  cat("\n", strrep("=", 50), "\n\n")
  
  multi_company_analysis_example(demo_mode)
  
  cat("\n\nAll examples completed!\n")
  cat("To run with actual API calls, use: run_all_examples(demo_mode = FALSE)\n")
  cat("Note: This requires valid CalcBench API credentials.\n")
}

# Test function to verify the API client works
test_api_client <- function() {
  cat("Testing CalcBench API Client...\n")
  
  # Test client creation
  tryCatch({
    client <- create_calcbench_client()
    cat("✓ Client creation successful\n")
  }, error = function(e) {
    cat("✗ Client creation failed:", e$message, "\n")
    return(FALSE)
  })
  
  # Test configuration loading
  tryCatch({
    base_url <- get_config("base_url")
    if (!is.null(base_url)) {
      cat("✓ Configuration loading successful\n")
    } else {
      cat("✗ Configuration loading failed\n")
      return(FALSE)
    }
  }, error = function(e) {
    cat("✗ Configuration loading failed:", e$message, "\n")
    return(FALSE)
  })
  
  cat("✓ Basic API client tests passed\n")
  cat("Note: Full testing requires valid API credentials\n")
  return(TRUE)
}

# Print usage information when script is loaded
cat("CalcBench API Examples loaded!\n")
cat("Available functions:\n")
cat("- setup_example()\n")
cat("- company_data_example()\n")
cat("- monte_carlo_data_example()\n")
cat("- cash_flow_analysis_example()\n")
cat("- multi_company_analysis_example()\n")
cat("- run_all_examples()\n")
cat("- test_api_client()\n\n")
cat("Use run_all_examples() to see all examples\n")
cat("Use test_api_client() to verify installation\n")