# Uses the priceR package to download FX currency data from the World Bank API.

library(dplyr)
library(priceR)

# Lists all the available currencies and their symbols.
list_of_currencies <- currencies()

# This is the key currency you will be pricing in various other currencies
key_currency <- "AUD"

# A character vector of the currencies you wish to price your key currency in.
to <- c("USD", "GBP", "EUR", "SGD", "HKD", "CHF")

# Retrieves the latest exchange rates for the key currency in a dataframe then
# filters and formats it to present the information for the currency pairs you
# are interested in.
fx_rates <- exchange_rate_latest(currency = key_currency) %>%
  filter(currency %in% to) %>%
  rename(Currency.Pair = currency) %>%
  rename(Rate = paste0("one_", tolower(key_currency), "_is_equivalent_to")) %>%
  mutate(Query.Date = Sys.Date(), .before = Currency.Pair) %>%
  arrange(factor(Currency.Pair, levels = to)) %>%
  mutate(Currency.Pair = paste0(key_currency, "/", Currency.Pair))
