# Get historical metals prices from Oanda as individual xts objects and chart them.

library(quantmod)
library(magrittr)
library(highcharter)

# List of the metals available from Oanda.
oanda_metals <- c("gold", "silver", "platinum", "palladium")

# List of the currencies you want the metals priced in.
priced_in <- c("USD", "AUD")

# Get the metals data from Oanda as xts objects.
for (i in 1:length(oanda_metals)) {
  for (j in 1:length(priced_in)) {
  assign(paste0(oanda_metals[i], priced_in[j]),
         getMetals(oanda_metals[i], base.currency = priced_in[j], from = Sys.Date() - 180, to = Sys.Date(), auto.assign = FALSE))
  }
}

# Create a list of the xts object names
metals_list <- c()

for (i in 1:length(oanda_metals)) {
  for (j in 1:length(priced_in)) {
  value <- paste(oanda_metals[i], priced_in[j], sep = "")
  metals_list <- c(metals_list, value)
  }
}

# Chart the time series for each metal/currency pair.
for (i in length(metals_list):1) {
  # Must wrap plot in print function for this to work.
  print(hchart(get(metals_list[i]), name = metals_list[i]) %>%
          hc_title(text = metals_list[i]) %>%
          hc_xAxis(title = list(text = "Date")) %>%
          hc_yAxis(title = list(text = "Value")))
  # Delay required if you wish to see the individual charts as they're rendering.
  Sys.sleep(5)
}
