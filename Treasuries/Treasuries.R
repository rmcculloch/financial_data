# Get and chart historical treasury yields from the FED (https://fred.stlouisfed.org/)
# and RBS (https://www.rba.gov.au/).

# Loads required packages.
# If packages don't already exist, they need to be installed, e.g. install.packages("quantmod").
library(quantmod)
library(readrba)
library(dplyr)
library(highcharter)

# US TREASURIES:
# US 1 Month: DGS1MO
# US 3 Month: DGS3MO
# US 6 Month: DGS6MO
# US 1 Year: DGS1
# US 2 Year: DGS2
# US 3 Year: DGS3
# US 5 Year: DGS5
# US 7 Year: DGS7
# US 10 Year: DGS10
# US 20 Year: DGS20
# US 30 Year: DGS30

# Vector of US Treasuries.
US_treasuries <- c("DGS1MO", "DGS3MO", "DGS6MO", "DGS1", "DGS2", "DGS3", "DGS5",
                "DGS7", "DGS10", "DGS20", "DGS30")

# For some reason with FRED, the 'to' and 'from' (date range) arguments are ignored if used.
getSymbols(paste0(US_treasuries),  src = "FRED")

# As these are xts objects, you can use the window function if you want a specific date range for your data, e.g.
# DGS2_subset <- window(DGS2, start = "2000-01-01", end = "2020-01-01")
  
# Charts the data - note they provide an interactive date filter.
# Can add and take off series as desired to compare the different treasuries.
highchart(type = "stock") %>%
  hc_title(text = "US Treasury Yields Comparison") %>%
  hc_add_series(DGS2, name = "2-Year") %>%
  hc_add_series(DGS10, name = "10-Year") %>%
  hc_legend(enabled = TRUE)

# AUSTRALIAN TREASURIES
# 1 Month Treasury Note - FIRMMTN1D
# 3 Month Treasury Note - FIRMMTN3D
# 6 Month Treasury Note - FIRMMTN6D
# Ausralian Government 2 Year Bond - FCMYGBAG2D
# Australian Government 3 Year Bond - FCMYGBAG3D
# Australian Government 5 Year Bond - FCMYGBAG5D
# Australian Government 10 Year Bond - FCMYGBAG10D

# Shows RBA data related to the search term 'yields'.
rba <- browse_rba_series("yields")

# Filters down the search results to include only those we are interested in.
rba_select <- rba %>% filter(cur_hist == "historical",
                             frequency == "Daily",
                             grepl('Australian|Note', series),
                             !grepl('Indexed', series))

# Stores the relevant series_ids in a vector.
symbols <- rba_select$series_id

# Grabs data on all those listed in the vector, which are stored as tibbles. 
for (i in 1:length(symbols)) {
  try(assign(symbols[i], read_rba_seriesid(symbols[i])))
}

# Selects only the columns relevant for charting.
for (i in 1:length(symbols)) {
assign(symbols[i], get(symbols[i]) %>%
  select(date, value))
}

# Converts the tibble objects to xts for charting.
for (i in 1:length(symbols)) {
  assign(symbols[i], xts(get(symbols[i])$value, get(symbols[i])$date))
}

# Charts the data - note they provide an interactive date filter.
# Can add and take off series as desired to compare the different treasuries.
highchart(type = "stock") %>%
  hc_title(text = "Australian Treasury Yields Comparison") %>%
  hc_add_series(FCMYGBAG2D, name = "2-Year") %>%
  hc_add_series(FCMYGBAG10D, name = "10-Year") %>%
  hc_legend(enabled = TRUE)
