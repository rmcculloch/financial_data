# Uses the quandmod package to download the latest FX currency pair quotes in a 
# dataframe from the Yahoo API. It can also draw from Alpha Vantage and other
# sources/APIs.

library(quantmod)

# This is the key currency you will be pricing in various other currencies
key_currency <- "AUD"

# A character vector of the currencies you wish to price your key currency in.
to <- c("USD", "GBP", "EUR", "SGD", "HKD", "CHF")

# A character vector of the key currency which matches the length of the 'to' character vector above.
from <- c(rep(key_currency, length(to)))

# Calls the requested FX pair quotes from the Yahoo API and puts the data in a dataframe.
yahoo_fx_quote <- getQuote(paste0(from, to, "=X"), src = "yahoo")