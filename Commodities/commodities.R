# Getting and charting commodities data from the FRED, using the quantmod package.

library(magrittr)
library(quantmod)
library(highcharter)

# COMMODITIES
# Crude Oil Prices (WTI): DCOILWTICO
# Crude Oil Prices (Brent): DCOILBRENTEU
# Global Price of Natural Gas: PNGASEUUSDM
# Global Price of Wheat: PWHEAMTUSDM
# Global Price of Energy Index: PNRGINDEXM
# Global Price Index of All Commodities: PALLFNFINDEXQ
# Global Price of Copper: PCOPPUSDM
# Electricity per Kilowatt-Hour in U.S. City Average: APU000072610
# Global Price of Aluminium: PALUMUSDM
# Global Price of Iron Ore: PIORECRUSDM
# Global Price of Food Index: PFOODINDEXM
# Global Price of Rubber: PRUBBUSDM
# Global Price of Uranium: PURANUSDM
# Global Price of Nickel: PNICKUSDM
# Global Price of Sugar: PSUGAISAUSDM

commodities <- c("DCOILWTICO", "DCOILBRENTEU", "PNGASEUUSDM", "PWHEAMTUSDM",
                 "PNRGINDEXM", "PALLFNFINDEXQ", "PCOPPUSDM", "APU000072610",
                 "PALUMUSDM", "PIORECRUSDM", "PFOODINDEXM", "PRUBBUSDM",
                 "PURANUSDM", "PNICKUSDM", "PSUGAISAUSDM")

# For some reason with FRED, the 'to' and 'from' (date range) arguments are ignored if used.
getSymbols(paste0(commodities),  src = "FRED")

# As these are xts objects, you can use the window function if you want a specific date range for your data, e.g.
# DCOILWTICO_subset <- window(DCOILWTICO, start = "2000-01-01", end = "2020-01-01")

# Charts the data - note they provide an interactive date filter.
# Can modify and add/subtract series as desired to compare different commodities.
highchart(type = "stock") %>%
  hc_title(text = "Oil Prices") %>%
  hc_add_series(DCOILWTICO, name = "WTI") %>%
  hc_add_series(DCOILBRENTEU, name = "Brent") %>%
  hc_legend(enabled = TRUE)
