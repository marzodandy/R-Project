# Load necessary libraries
set.seed(42)  # For reproducibility
library(dplyr)

# Define the parameters
models <- c("DBX", "DBX 707", "DB11 V8", "DB11 V12", "DBS", "Vantage 2023", "Vantage V12", "DB12")  # Updated model list
categories <- c("SUV", "Sport/GT")
regions <- c("UK", "Americas", "EMEA", "APAC")
engine_types <- c("V8", "V12")
prices <- list(
  "DBX" = c(195172, 250000),
  "DBX 707" = c(248172, 300000),
  "DB11 V8" = c(220086, 280000),
  "DB11 V12" = c(235586, 295000),
  "DBS" = c(330600, 475000),
  "Vantage 2023" = c(146986, 186000),
  "Vantage V12" = c(180000, 220000),  # Updated price range for Vantage V12
  "DB12" = c(251825, 300000)
)

# Generate realistic rows of data
num_rows <- 3481  # Set max rows to 3481
num_vantage_v12 <- 224  # Limit Vantage V12 to 224 units
remaining_rows <- num_rows - num_vantage_v12  # Calculate remaining rows

# First, generate 224 rows for Vantage V12
vantage_v12_selected <- rep("Vantage V12", num_vantage_v12)
vantage_v12_categories <- rep("Sport/GT", num_vantage_v12)
vantage_v12_engine_types <- rep("V12", num_vantage_v12)
vantage_v12_prices <- sample(prices[["Vantage V12"]][1]:prices[["Vantage V12"]][2], num_vantage_v12, replace = TRUE)
vantage_v12_regions <- sample(regions, num_vantage_v12, replace = TRUE)
vantage_v12_ages <- sample(25:65, num_vantage_v12, replace = TRUE)
vantage_v12_dealerships <- rep("Dealership", num_vantage_v12)
vantage_v12_warranty_types <- sample(c("12 months", "24 months", "No"), num_vantage_v12, replace = TRUE)
vantage_v12_customer_loyalty <- sample(c("Y", "N"), num_vantage_v12, replace = TRUE)

# Generate the remaining rows with other models (excluding Vantage V12)
remaining_models_selected <- sample(models[models != "Vantage V12"], remaining_rows, replace = TRUE)

remaining_categories_selected <- sapply(remaining_models_selected, function(model) {
  if (model %in% c("DBX", "DBX 707")) {
    return("SUV")
  } else {
    return("Sport/GT")
  }
})

remaining_engine_types_selected <- sapply(remaining_models_selected, function(model) {
  if (model == "Vantage V12") {  # Ensure Vantage V12 has V12 engine
    return("V12")
  } else if (model %in% c("DBS", "DB11 V12")) {
    return("V12")
  } else {
    return("V8")
  }
})

remaining_prices_selected <- sapply(1:remaining_rows, function(i) {
  price_range <- prices[[remaining_models_selected[i]]]
  sample(price_range[1]:price_range[2], 1)
})

remaining_regions_selected <- sample(regions, remaining_rows, replace = TRUE)
remaining_ages_selected <- sample(25:65, remaining_rows, replace = TRUE)
remaining_dealerships_selected <- rep("Dealership", remaining_rows)  # Only Dealership for this version
remaining_warranty_types_selected <- sample(c("12 months", "24 months", "No"), remaining_rows, replace = TRUE)
remaining_customer_loyalty_selected <- sample(c("Y", "N"), remaining_rows, replace = TRUE)

# Combine Vantage V12 data with remaining model data
models_selected <- c(vantage_v12_selected, remaining_models_selected)
categories_selected <- c(vantage_v12_categories, remaining_categories_selected)
engine_types_selected <- c(vantage_v12_engine_types, remaining_engine_types_selected)
prices_selected <- c(vantage_v12_prices, remaining_prices_selected)
regions_selected <- c(vantage_v12_regions, remaining_regions_selected)
ages_selected <- c(vantage_v12_ages, remaining_ages_selected)
dealerships_selected <- c(vantage_v12_dealerships, remaining_dealerships_selected)
warranty_types_selected <- c(vantage_v12_warranty_types, remaining_warranty_types_selected)
customer_loyalty_selected <- c(vantage_v12_customer_loyalty, remaining_customer_loyalty_selected)

# Create the dataset
sales_data <- data.frame(
  Payment_Date = sample(seq(as.Date("2023-01-01"), as.Date("2023-12-31"), by="day"), num_rows, replace = TRUE),
  Model = models_selected,
  Category = categories_selected,
  Year = rep(2023, num_rows),  # Only 2023 year
  Engine_Type = engine_types_selected,
  Region = regions_selected,
  Price = prices_selected,
  Age = ages_selected,
  Dealership = dealerships_selected,
  Warranty_Type = warranty_types_selected,
  Customer_Loyalty = customer_loyalty_selected
)

# Export to CSV
setwd("D:/Downloads/Data Analyst Portfolio Project/Aston Martin Sales Performance Project")
write.csv(sales_data, "aston_martin_sales_data_add_2023.csv", row.names = FALSE)