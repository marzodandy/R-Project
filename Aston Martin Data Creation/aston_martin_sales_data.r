# Load necessary libraries
set.seed(42)  # For reproducibility
library(dplyr)

# Define the parameters
models <- c("DBX", "DBX 707", "DB11 V8", "DB11 V12", "DBS", "Vantage 2023", "Vantage 2024", "DB12", "Valkyrie", "Valour", "Valiant")
categories <- c("SUV", "Sport/GT", "Specials")
regions <- c("UK", "Americas", "EMEA", "APAC")
engine_types <- c("V8", "V12")
prices <- list(
  "DBX" = c(195172, 250000),
  "DBX 707" = c(248172, 300000),
  "DB11 V8" = c(220086, 280000),
  "DB11 V12" = c(235586, 295000),
  "DBS" = c(330600, 475000),
  "Vantage 2023" = c(146986, 186000),
  "Vantage 2024" = c(165086, 250000),
  "DB12" = c(251825, 300000),
  "Valkyrie" = c(3200000, 4000000),
  "Valour" = c(2000000, 3000000),
  "Valiant" = c(2500000, 3500000)
)

# Generate realistic rows of data
num_rows <- 11562
payment_dates <- sample(seq(as.Date("2023-01-01"), as.Date("2024-11-16"), by="day"), num_rows, replace = TRUE)
models_selected <- sample(models, num_rows, replace = TRUE)
categories_selected <- sapply(models_selected, function(model) {
 if (model %in% c("Valkyrie", "Valour", "Valiant")) {
    return("Specials")
  } else if (model %in% c("DBX", "DBX 707")) {
    return("SUV")
  } else {
    return("Sport/GT")
  }
})
engine_types_selected <- sapply(models_selected, function(model) {
  if(model %in% c("DBS", "Valkyrie", "Valour", "Valiant", "DB11 V12")) {
    return("V12")
  } else {
    return("V8")
  }
})
prices_selected <- sapply(1:num_rows, function(i) {
  price_range <- prices[[models_selected[i]]]
   if (is.null(price_range)) {
    price_range <- prices[[models_selected[i]]]
  }
  sample(price_range[1]:price_range[2], 1)
})
regions_selected <- sample(regions, num_rows, replace = TRUE)
ages_selected <- sample(25:65, num_rows, replace = TRUE)
dealerships_selected <- sapply(categories_selected, function(category) {
  if(category == "Specials") return("Factory") else return("Dealership")
})
warranty_types_selected <- sapply(categories_selected, function(category) {
  if(category == "Specials") return("Pinnacle Extended Warranty") else sample(c("12 months", "24 months", "No"), 1)
})
customer_loyalty_selected <- sapply(categories_selected, function(category) {
  if(category == "Specials") return("Y") else sample(c("Y", "N"), 1)
})

# Create the dataset
sales_data <- data.frame(
  Payment_Date = payment_dates,
  Model = models_selected,
  Category = categories_selected,
  Year = sample(2023:2024, num_rows, replace = TRUE),
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
write.csv(sales_data, "aston_martin_sales_data_v2.csv", row.names = FALSE)