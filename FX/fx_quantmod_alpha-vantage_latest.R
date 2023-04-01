# Uses the quandmod package to download the latest FX currency pair quotes in a 
# dataframe from the Alpha Vantage API. It can also draw from yahoo and other
# sources/APIs.

library(quantmod)

# This is the key currency you will be pricing in various other currencies
key_currency <- "AUD"

# A character vector of the currencies you wish to price your key currency in.
to <- c("USD", "GBP", "EUR", "SGD", "HKD", "CHF")

# A character vector of the key currency which matches the length of the 'to' character vector above.
from <- c(rep(key_currency, length(to)))

# A character vector of the currency pairs to be queried.
pair <- paste0(from, to)

# Calls the requested FX pair quotes from the Alpha Vantage API and puts the data in a dataframe.
for (i in 1:length(to)) {
    try(assign(pair[i], getQuote(pair[i], src = "av", api.key = "***API*KEY*HERE***")))
  # Alpha Vantage (av) only allows 5 API calls per minute. The script will therefore take some time
  # to run depending on how many calls you need to do.
  if (i%%5 == 0) {
    Sys.sleep(60)
  }
}
