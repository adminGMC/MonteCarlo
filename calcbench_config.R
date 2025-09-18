# CalcBench API Configuration
# 
# This file contains configuration settings for the CalcBench API client

# CalcBench API Configuration
CALCBENCH_CONFIG <- list(
  # Base API URL
  base_url = "https://www.calcbench.com/api",
  
  # Alternative API endpoints to try
  alternative_urls = c(
    "https://api.calcbench.com",
    "https://www.calcbench.com/public-api"
  ),
  
  # Default request timeout (seconds)
  timeout = 30,
  
  # Rate limiting (requests per minute)
  rate_limit = 60,
  
  # Default data formats
  default_period_type = "annual",
  default_limit = 100,
  
  # Common financial metrics for Monte Carlo analysis
  cash_flow_metrics = c(
    "CashAndCashEquivalentsBeginningBalance",
    "NetCashProvidedByOperatingActivities",
    "NetCashUsedInInvestingActivities", 
    "NetCashUsedInFinancingActivities",
    "CashAndCashEquivalentsEndingBalance",
    "FreeCashFlow",
    "CapitalExpenditures",
    "DividendsPaid",
    "ShareRepurchases"
  ),
  
  income_metrics = c(
    "Revenue",
    "GrossProfit",
    "OperatingIncome",
    "NetIncome",
    "EarningsPerShareBasic",
    "EarningsPerShareDiluted",
    "OperatingExpenses",
    "InterestExpense",
    "TaxExpense"
  ),
  
  balance_sheet_metrics = c(
    "Assets",
    "Liabilities", 
    "Equity",
    "CurrentAssets",
    "CurrentLiabilities",
    "WorkingCapital",
    "TotalDebt",
    "Cash",
    "Inventory",
    "AccountsReceivable"
  ),
  
  # Industries and SIC codes commonly used in Monte Carlo simulations
  common_industries = list(
    technology = c(3570, 3571, 3572, 7370, 7371, 7372),
    healthcare = c(2830, 2834, 2835, 2836, 3841, 3842),
    financial = c(6020, 6021, 6022, 6035, 6036),
    energy = c(1311, 1321, 1381, 2911, 4911, 4922),
    retail = c(5310, 5311, 5331, 5399, 5411, 5412)
  )
)

# Function to get configuration value
get_config <- function(key, default = NULL) {
  if (key %in% names(CALCBENCH_CONFIG)) {
    return(CALCBENCH_CONFIG[[key]])
  } else {
    return(default)
  }
}

# Function to validate API credentials
validate_credentials <- function(username = NULL, password = NULL, api_key = NULL) {
  if (!is.null(api_key) && nchar(api_key) > 0) {
    return(list(valid = TRUE, method = "api_key"))
  }
  
  if (!is.null(username) && !is.null(password) && 
      nchar(username) > 0 && nchar(password) > 0) {
    return(list(valid = TRUE, method = "username_password"))
  }
  
  return(list(valid = FALSE, method = "none"))
}

# Print configuration information
cat("CalcBench API Configuration loaded\n")
cat("Base URL:", get_config("base_url"), "\n")
cat("Default timeout:", get_config("timeout"), "seconds\n")
cat("Rate limit:", get_config("rate_limit"), "requests per minute\n")