# CalcBench API R Client
# A comprehensive R script to connect and interact with the CalcBench API
# CalcBench provides financial data and analytics for public companies

# Load required libraries
suppressWarnings({
  if (!require(httr)) {
    install.packages("httr", repos = "http://cran.us.r-project.org")
    library(httr)
  }
  if (!require(jsonlite)) {
    install.packages("jsonlite", repos = "http://cran.us.r-project.org")
    library(jsonlite)
  }
  if (!require(dplyr)) {
    install.packages("dplyr", repos = "http://cran.us.r-project.org")
    library(dplyr)
  }
})

# CalcBench API Client Class
CalcBenchAPI <- function(username = NULL, password = NULL, api_key = NULL) {
  
  # Base configuration
  base_url <- "https://www.calcbench.com/api"
  
  # Initialize authentication credentials
  auth_username <- username
  auth_password <- password
  auth_api_key <- api_key
  
  # Authentication function
  authenticate <- function() {
    if (!is.null(auth_username) && !is.null(auth_password)) {
      # Username/password authentication
      auth_url <- paste0(base_url, "/authenticate")
      response <- POST(
        auth_url,
        body = list(
          username = auth_username,
          password = auth_password
        ),
        encode = "json",
        add_headers(
          "Content-Type" = "application/json",
          "User-Agent" = "R CalcBench Client"
        )
      )
      
      if (status_code(response) == 200) {
        message("Successfully authenticated with CalcBench API")
        return(TRUE)
      } else {
        warning("Authentication failed: ", status_code(response))
        return(FALSE)
      }
    } else if (!is.null(auth_api_key)) {
      # API key authentication
      message("Using API key authentication")
      return(TRUE)
    } else {
      warning("No authentication credentials provided")
      return(FALSE)
    }
  }
  
  # Helper function to make API requests
  make_request <- function(endpoint, params = list(), method = "GET") {
    url <- paste0(base_url, endpoint)
    
    # Add authentication headers
    headers <- list(
      "Content-Type" = "application/json",
      "User-Agent" = "R CalcBench Client"
    )
    
    if (!is.null(auth_api_key)) {
      headers[["Authorization"]] <- paste("Bearer", auth_api_key)
    }
    
    tryCatch({
      if (method == "GET") {
        response <- GET(url, query = params, add_headers(.headers = headers))
      } else if (method == "POST") {
        response <- POST(url, body = params, encode = "json", add_headers(.headers = headers))
      }
      
      if (status_code(response) == 200) {
        content <- content(response, "text", encoding = "UTF-8")
        return(fromJSON(content))
      } else {
        warning("API request failed: ", status_code(response), " - ", content(response, "text"))
        return(NULL)
      }
    }, error = function(e) {
      warning("Error making API request: ", e$message)
      return(NULL)
    })
  }
  
  # Get company information
  get_companies <- function(ticker = NULL, sic_code = NULL, limit = 100) {
    params <- list(limit = limit)
    if (!is.null(ticker)) params$ticker <- ticker
    if (!is.null(sic_code)) params$sic <- sic_code
    
    result <- make_request("/companies", params)
    return(result)
  }
  
  # Get financial data for a company
  get_financials <- function(ticker, period_type = "annual", year = NULL, metrics = NULL) {
    if (is.null(ticker)) {
      stop("Ticker symbol is required")
    }
    
    params <- list(
      company_identifiers = ticker,
      period_type = period_type
    )
    
    if (!is.null(year)) params$year <- year
    if (!is.null(metrics)) params$metrics <- paste(metrics, collapse = ",")
    
    result <- make_request("/financial_data", params)
    return(result)
  }
  
  # Get cash flow statement
  get_cash_flow <- function(ticker, period_type = "annual", year = NULL) {
    if (is.null(ticker)) {
      stop("Ticker symbol is required")
    }
    
    cash_flow_metrics <- c(
      "CashAndCashEquivalentsBeginningBalance",
      "NetCashProvidedByOperatingActivities",
      "NetCashUsedInInvestingActivities", 
      "NetCashUsedInFinancingActivities",
      "CashAndCashEquivalentsEndingBalance",
      "FreeCashFlow"
    )
    
    result <- get_financials(ticker, period_type, year, cash_flow_metrics)
    return(result)
  }
  
  # Get income statement
  get_income_statement <- function(ticker, period_type = "annual", year = NULL) {
    if (is.null(ticker)) {
      stop("Ticker symbol is required")
    }
    
    income_metrics <- c(
      "Revenue",
      "GrossProfit",
      "OperatingIncome",
      "NetIncome",
      "EarningsPerShareBasic",
      "EarningsPerShareDiluted"
    )
    
    result <- get_financials(ticker, period_type, year, income_metrics)
    return(result)
  }
  
  # Get balance sheet
  get_balance_sheet <- function(ticker, period_type = "annual", year = NULL) {
    if (is.null(ticker)) {
      stop("Ticker symbol is required")
    }
    
    balance_metrics <- c(
      "Assets",
      "Liabilities",
      "Equity",
      "CurrentAssets",
      "CurrentLiabilities",
      "WorkingCapital"
    )
    
    result <- get_financials(ticker, period_type, year, balance_metrics)
    return(result)
  }
  
  # Get historical data for Monte Carlo simulation
  get_historical_data_for_monte_carlo <- function(ticker, years_back = 5) {
    if (is.null(ticker)) {
      stop("Ticker symbol is required")
    }
    
    current_year <- as.numeric(format(Sys.Date(), "%Y"))
    historical_data <- list()
    
    for (year in (current_year - years_back):current_year) {
      cash_flow <- get_cash_flow(ticker, "annual", year)
      income <- get_income_statement(ticker, "annual", year)
      
      if (!is.null(cash_flow) && !is.null(income)) {
        historical_data[[as.character(year)]] <- list(
          year = year,
          cash_flow = cash_flow,
          income = income
        )
      }
    }
    
    return(historical_data)
  }
  
  # Return public interface
  list(
    authenticate = authenticate,
    get_companies = get_companies,
    get_financials = get_financials,
    get_cash_flow = get_cash_flow,
    get_income_statement = get_income_statement,
    get_balance_sheet = get_balance_sheet,
    get_historical_data_for_monte_carlo = get_historical_data_for_monte_carlo
  )
}

# Helper function to create API client instance
create_calcbench_client <- function(username = NULL, password = NULL, api_key = NULL) {
  if (is.null(username) && is.null(password) && is.null(api_key)) {
    # Try to get credentials from environment variables
    username <- Sys.getenv("CALCBENCH_USERNAME", unset = "")
    password <- Sys.getenv("CALCBENCH_PASSWORD", unset = "")
    api_key <- Sys.getenv("CALCBENCH_API_KEY", unset = "")
    
    # Convert empty strings to NULL
    if (username == "") username <- NULL
    if (password == "") password <- NULL
    if (api_key == "") api_key <- NULL
  }
  
  client <- CalcBenchAPI(username, password, api_key)
  return(client)
}

# Example usage function
demo_calcbench_usage <- function() {
  cat("CalcBench API R Client Demo\n")
  cat("===========================\n\n")
  
  # Create client (requires authentication)
  client <- create_calcbench_client()
  
  cat("Example 1: Get company information\n")
  cat("companies <- client$get_companies(ticker = 'AAPL')\n\n")
  
  cat("Example 2: Get cash flow data\n")
  cat("cash_flow <- client$get_cash_flow('AAPL', 'annual', 2023)\n\n")
  
  cat("Example 3: Get income statement\n")
  cat("income <- client$get_income_statement('AAPL', 'annual', 2023)\n\n")
  
  cat("Example 4: Get historical data for Monte Carlo simulation\n")
  cat("historical <- client$get_historical_data_for_monte_carlo('AAPL', 5)\n\n")
  
  cat("Note: To use this client, you need to set up authentication:\n")
  cat("1. Set environment variables:\n")
  cat("   Sys.setenv(CALCBENCH_USERNAME = 'your_username')\n")
  cat("   Sys.setenv(CALCBENCH_PASSWORD = 'your_password')\n")
  cat("   # OR\n")
  cat("   Sys.setenv(CALCBENCH_API_KEY = 'your_api_key')\n\n")
  cat("2. Or pass credentials directly:\n")
  cat("   client <- create_calcbench_client(username = 'user', password = 'pass')\n")
  cat("   # OR\n")
  cat("   client <- create_calcbench_client(api_key = 'your_key')\n\n")
}

# Print information when script is loaded
cat("CalcBench API R Client loaded successfully!\n")
cat("Use demo_calcbench_usage() to see examples\n")
cat("Use create_calcbench_client() to get started\n\n")