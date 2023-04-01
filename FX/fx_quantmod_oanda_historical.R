# Uses the quantmod package to download FX currency pair data from the Oanda API
# and merges it into a single eXtensible Time Series (xts) object.

library(dplyr)
library(quantmod)
library(highcharter)

# Lists all the available currencies and their symbols.
list_of_currencies <- oanda.currencies

# This is the key currency you will be pricing in various other currencies.
key_currency <- "AUD"

# A character vector of the currencies you wish to price your key currency in.
to <- c("USD", "GBP", "EUR", "SGD", "HKD", "CHF")

# A character vector of the key currency which matches the length of the 'to' character vector above.
from <- c(rep(key_currency, length(to)))

# A character vector of the currency pairs in the format required by the getFX function.
pairs <- paste0(from, "/", to)

# Gets and creates individual xts objects for each currency pair going back a
# specified number of days.
getFX(pairs, from = Sys.Date() - 180, to = Sys.Date())

# A character vector including the names of the individual xts objects we wish to merge.
merge_pairs <- paste0(from, to)

# A list of the individual xts objects we wish to merge.
list_of_merge_pairs <- list()
for (i in 1:length(merge_pairs)) {
  list_of_merge_pairs[[i]] <- get(merge_pairs[i])
}

# Merges the list objects into a single xts object.
fx_rates <- Reduce(merge.xts, list_of_merge_pairs)

# Chart the time series for each currency pairs.
for (i in length(merge_pairs):1) {
  # Must wrap plot in print function for this to work.
  print(hchart(get(merge_pairs[i]), name = merge_pairs[i]) %>%
  hc_title(text = pairs[i]) %>%
  hc_xAxis(title = list(text = "Date")) %>%
  hc_yAxis(title = list(text = "Value")))
  # Delay required if you wish to see the individual charts as they're rendering.
  Sys.sleep(5)
}

# Converts to a dataframe so can change the date order.
fx_rates <- as.data.frame(fx_rates)

# Converts the rownames (dates in old xts object) to values in a "Date" column.
fx_rates$Date <- rownames(fx_rates)

# Removes the dates as rownames.
rownames(fx_rates) <- NULL

# Moves the "Date" column from last to first position.
fx_rates <- fx_rates[,c(ncol(fx_rates),1:ncol(fx_rates)-1)]

# Reverse orders by date as useful to see the most recent rates at the top.
fx_rates <-arrange(fx_rates, desc(Date))

# Removes (cleans up) the individual xts objects.
rm(list = merge_pairs)