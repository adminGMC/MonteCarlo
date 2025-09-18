#!/usr/bin/env Rscript

# CalcBench API Test Script
# This script validates that the CalcBench API client is working correctly

cat("CalcBench API R Client Test\n")
cat("===========================\n\n")

# Test 1: Load configuration
cat("Test 1: Loading configuration...\n")
tryCatch({
  source("calcbench_config.R")
  cat("✓ Configuration loaded successfully\n")
}, error = function(e) {
  cat("✗ Configuration loading failed:", e$message, "\n")
  quit(status = 1)
})

# Test 2: Load main API client  
cat("\nTest 2: Loading API client...\n")
tryCatch({
  source("calcbench_api.R")
  cat("✓ API client loaded successfully\n")
}, error = function(e) {
  cat("✗ API client loading failed:", e$message, "\n")
  quit(status = 1)
})

# Test 3: Create client instance
cat("\nTest 3: Creating client instance...\n")
tryCatch({
  client <- create_calcbench_client()
  cat("✓ Client instance created successfully\n")
}, error = function(e) {
  cat("✗ Client creation failed:", e$message, "\n")
  quit(status = 1)
})

# Test 4: Load examples
cat("\nTest 4: Loading examples...\n")
tryCatch({
  source("calcbench_examples.R")
  cat("✓ Examples loaded successfully\n")
}, error = function(e) {
  cat("✗ Examples loading failed:", e$message, "\n")
  quit(status = 1)
})

# Test 5: Configuration validation
cat("\nTest 5: Validating configuration...\n")
base_url <- get_config("base_url")
if (!is.null(base_url) && nchar(base_url) > 0) {
  cat("✓ Base URL configured:", base_url, "\n")
} else {
  cat("✗ Base URL not configured properly\n")
  quit(status = 1)
}

timeout <- get_config("timeout")
if (!is.null(timeout) && is.numeric(timeout)) {
  cat("✓ Timeout configured:", timeout, "seconds\n")
} else {
  cat("✗ Timeout not configured properly\n")
  quit(status = 1)
}

# Test 6: Function availability
cat("\nTest 6: Checking function availability...\n")
required_functions <- c("get_companies", "get_financials", "get_cash_flow", 
                       "get_income_statement", "get_balance_sheet", 
                       "get_historical_data_for_monte_carlo")

all_functions_available <- TRUE
for (func_name in required_functions) {
  if (func_name %in% names(client)) {
    cat("✓", func_name, "available\n")
  } else {
    cat("✗", func_name, "not available\n")
    all_functions_available <- FALSE
  }
}

if (all_functions_available) {
  cat("✓ All required functions are available\n")
} else {
  cat("✗ Some required functions are missing\n")
  quit(status = 1)
}

# Test 7: Demo functions
cat("\nTest 7: Testing demo functions...\n")
demo_functions <- c("setup_example", "company_data_example", "monte_carlo_data_example",
                   "cash_flow_analysis_example", "multi_company_analysis_example")

for (func_name in demo_functions) {
  if (exists(func_name)) {
    cat("✓", func_name, "available\n")
  } else {
    cat("✗", func_name, "not available\n")
  }
}

cat("\n", strrep("=", 50), "\n")
cat("All basic tests passed! ✓\n")
cat("The CalcBench API R client is ready to use.\n\n")

cat("To get started:\n")
cat("1. Set up your CalcBench API credentials\n")
cat("2. Run: source('calcbench_examples.R')\n")
cat("3. Run: run_all_examples(demo_mode = TRUE)\n")
cat("4. For actual API calls: run_all_examples(demo_mode = FALSE)\n\n")

cat("Note: Actual API functionality requires valid CalcBench credentials.\n")