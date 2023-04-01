# Uses the priceR package to download FX currency data from the World Bank API.

library(magrittr)
library(priceR)
library(highcharter)

# Lists all the available currencies and their symbols.
list_of_currencies <- currencies()

# This is the key currency you will be pricing in various other currencies.
key_currency <- "AUD"

# A character vector of the currencies you wish to price your key currency in.
to <- c("USD", "GBP", "EUR", "SGD", "HKD", "CHF")

# A character vector of the key currency which matches the length of the 'to' character vector above.
from <- c(rep(key_currency, length(to)))

# Gets and creates individual dataframes for each currency pair for the
# specified time period.
for (i in 1:length(to)) {
  assign(paste0(from[i], to[i]),
         historical_exchange_rates(from = from[i],
                                   to = to[i],
                                   start_date = Sys.Date() - 180,
                                   end_date = Sys.Date()))
}

# A character vector including the names of the individual xts objects we wish to merge.
merge_pairs <- paste0(from, to)

# A list of the individual dataframe objects we wish to merge.
list_of_merge_pairs <- list()
for (i in 1:length(merge_pairs)) {
  list_of_merge_pairs[[i]] <- get(merge_pairs[i])
}

# Merges the list objects into a single dataframe.
fx_rates <- Reduce(merge, list_of_merge_pairs)

# Cleans up the default column names.
for (i in 1:ncol(fx_rates)){
  colnames(fx_rates)[i] <-  sub(c("one_"), "", colnames(fx_rates)[i])
  colnames(fx_rates)[i] <-  sub(c("_equivalent_to_x_"), ".", colnames(fx_rates)[i])
}

# To be used for chart names.
pair_names <- paste0(from, "/", to)

# Chart the time series for each currency pairs.
for (i in length(pair_names):1) {
  # Must wrap plot in print function for this to work.
print(hchart(fx_rates, type = "line", name = pair_names[i],
  hcaes(x = fx_rates[,1], y = fx_rates[,i+1])) %>%
  hc_title(text = pair_names[i]) %>%
  hc_xAxis(title = list(text = "Date")) %>%
  hc_yAxis(title = list(text = "Value")))
  # Delay required if you wish to see the individual charts as they're rendering.
  Sys.sleep(5)
}

# Reverse orders by date as useful to see the most recent rates at the top.
fx_rates <-arrange(fx_rates, desc(date))

# Removes (cleans up) the individual dataframes.
rm(list = merge_pairs)