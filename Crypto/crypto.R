# Get and chart crypto data from coinmarketcap.com using the crypto2 package. 

library(crypto2)
library(dplyr)
library(highcharter)

# A vector of the cryptocurrencies you're interested in.
coins <- c("BTC", "ETH", "XRP", "ADA", "MATIC")

# Get the list of available cryptocurrencies.
my_crypto_list <- crypto_list()

# Steps to creating a regex string required for filtering the crypto list.
coins_adj <- c()
for (i in 1:length(coins)) {
  coins_adj <- append(coins_adj, str_c("^", coins[i], "$"))
}
coins_regex <- str_flatten(coins_adj, collapse = "|")

# Filter the crypto list to include only the coins of interest.
my_crypto_list <- my_crypto_list %>% 
  filter(grepl(coins_regex, symbol))

# Get the historical data for your selected cryptocurrencies (single call).
# crypto_history <- crypto_history(my_crypto_list)

# Create separate environment to store the coin_list_objects.
a <- new.env()

# Splitting up the list to use as individual arguments for crypto_history()
# as just feeding in the complete list in a single call (as above by commented
# out) often seems to result in missing data.
for (i in 1:length(my_crypto_list$symbol)) {
  assign(my_crypto_list$symbol[i], slice(my_crypto_list, i), env = a)
}

# Create a vector listing the coin list objects in env a.
coin_list_objects <- ls(a)

# Create separate environment to store the coin data objects.
b <- new.env()

# Get the data for each coin and store in environment b.
for (i in 1:length(coin_list_objects)) {
  assign(coin_list_objects[i], crypto_history(get(coin_list_objects[i], env =a)), env =b)
}

# create a vector listing the coin data objects in environment b.
coin_data_objects <- ls(b)

# Create a separate environment to store the modified data objects (for charting).  
c <- new.env()

# Modify the coin data objects from environment b and store in evironment c.
for (i in 1:length(coin_data_objects)) {
assign(paste(coin_data_objects[i], "_mod", sep = ""),
       get(coin_data_objects[i], env = b) %>%
    select(timestamp, open, high, low, close, volume) %>%
    mutate(date = as.Date(timestamp)) %>%
    select(!timestamp) %>%
    relocate(date, .before = open), envir = c)
}

# Create a vector listing the modified data objects.
coin_mod_objects <- ls(c)

# Convert the modified objects in environment c to xts objects for charting.
for (i in 1:length(coin_mod_objects)) {
  assign(coin_mod_objects[i], xts(get(coin_mod_objects[i], env = c)[,2:6], get(coin_mod_objects[i], env = c)$date), envir = c)
}

# Chart the individual xts objects as desired for further analysis.
highchart(type = "stock") %>%
  hc_title(text = "Crypto Price Chart") %>%
  hc_add_series(c$ADA_mod, name = "ADA") %>%
  hc_add_series(c$BTC_mod, name = "BTC") %>%
  hc_add_series(c$ETH_mod, name = "ETH") %>%
  hc_add_series(c$MATIC_mod, name = "MATIC") %>%
  hc_add_series(c$XRP_mod, name = "XRP") %>%
  hc_legend(enabled = TRUE)
