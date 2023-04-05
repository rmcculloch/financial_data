# Get historical equities prices from Yahoo as individual xts objects and chart them.
# Also gets and displays their dividend data.
# Can switch out different equities lists depending on what you wish to analyse.

library(quantmod)
library(magrittr)
library(highcharter)
library(htmlwidgets)

# For Yahoo, Australian equities are suffixed with .AX, US equities have no suffix and
# Other international equities are suffixed with various other letters, e.g. .HK
# Indexes, e.g. the Nasdaq, begin with a "^", e.g. ^IXIC.

# Current portfolio
# equities <- c("NML.AX", "TPW.AX", "NIC.AX", "IGO.AX", "IRI.AX",
#                 "AVA.AX", "PAN.AX", "NXT.AX", "A4N.AX", "CIP.AX",
#                 "APA.AX", "AWC.AX", "DRR.AX", "CSL.AX", "NCM.AX",
#                 "TIE.AX", "HRZ.AX", "IFT.AX", "STM.AX", "RDY.AX",
#                 "EVN.AX", "MAD.AX", "EOS.AX", "GOR.AX",
#                           
#                 "ZYXI", "DLR", "HD", "TGT", "NVR", "IMMR", "OPRX",
#                 "IESC", "AZN", "CIEN","BILL", "VRTX", "UPLD", "ARRY",
#                 "SPGI", "SDGR", "LMT", "CTSO", "SWAV",
#                           
#                 "BNP.PA", "CNEW.MI", "CLNX.VI", "GIVN.SW", "2313.HK",
#                 "1833.HK", "9923.HK")

# Watchlist - technology focused
equities <-c("ARKK", "AAPL", "BBH", "COIN", "ESPO", "GOOG", "META",
               "MSFT", "GLXY.TO", "RELIANCE.NS", "ROBO", "SMH", "SMT.L",
               "TSLA", "^IXIC" )

##### EQUITIES DATA #####

# Create a new environment where the stock data objects will be stored.
a = new.env()

# Get historical pricing and volume data for portfolio equities.
# Assign function required due to having some equities start with numbers.
# All object names prefixed with an "s" to avoid the creation of invalid objects.
# Try function used to prevent loop termination if a single query fails.
for (i in 1:length(equities)) {
  try(assign(paste0("s", equities[i]),
         na.omit(getSymbols(equities[i], src = "yahoo", # from = Sys.Date() - 385, to = Sys.Date(),
                    auto.assign = FALSE)), envir = a))
}

# Create a vector of data object names in environment 'a'.
data_objects <- ls(a)

##### CHARTS #####

# Create a new environment where the chart objects will be stored.
b <- new.env()

# Create chart objects (htmlwidgets) from the xts stock data.
for (i in length(data_objects):1) {
data <- get(data_objects[i], envir = a)
volume <- data[,5]
try(assign(paste0("chart_", data_objects[i]),
highchart(type = "stock") %>%
  hc_title(text = data_objects[i]) %>%
  hc_yAxis_multiples(create_axis(3, height = c(2, 1, 1), turnopposite = TRUE)) %>%
  hc_add_series(data, yAxis = 0, name = data_objects[i]) %>%
  hc_add_series(SMA(Cl(data), n = 50), yAxis = 0, name = "MA(50)", color = "purple") %>%
  hc_add_series(SMA(Cl(data), n = 200), yAxis = 0, name = "MA(200)", color = "green") %>%
  hc_add_series(volume, color = "gray", yAxis = 1, name = "Volume", type = "column") %>%
  hc_add_series(RSI(Cl(data)), yAxis = 2, name = "Osciallator", color = hex_to_rgba("green", 0.7)) %>%
  hc_add_series(xts(rep(70, NROW(data)), index(data)), color = hex_to_rgba("red", 0.7), yAxis = 2, name = "Sell level") %>%
  hc_add_series(xts(rep(30, NROW(data)), index(data)), color = hex_to_rgba("blue", 0.7), yAxis = 2, name = "Buy level") %>%
  hc_tooltip(valueDecimals = 2) %>%
  hc_size(height = 800), envir = b))
}

# Create a vector of chart object names.
chart_objects <- ls(b)

# Convert the chart objects to html pages for selective viewing.
for (i in 1:length(chart_objects)) {
  saveWidget(get(chart_objects[i], envir = b),
           file = paste(chart_objects[i], "-", Sys.Date(), ".html",  sep = ""))
}

# Creates the Charts folder.
dir.create("./Equities/Charts")

# Clears out any old charts in your Charts folder.
system("rm ./Equities/Charts/*.html")

# Moves the charts to your Charts folder.
system("mv chart_* ./Equities/Charts")

# How you can send saved charts to the viewer if desired.
# rstudioapi::viewer(paste("http://localhost:8787/files/Projects/financial_data/Equities/Charts/",
# chart_objects[1], "-", Sys.Date(), ".html", sep = ""))

##### DIVIDENDS #####

# Create a new environment where dividend objects will be stored
c <- new.env()

# Get historical dividend information and store objects in environment 'c'.
for (i in 1:length(equities)) {
  try(assign(paste0("dividends_", equities[i]),
             na.omit(getDividends(equities[i], src = "yahoo", # from = Sys.Date() - 385, to = Sys.Date(),
                                auto.assign = FALSE)), envir = c))
}

# Create a vector of data object names in environment 'c'.
dividend_objects <- ls(c)

# # Displays the dividend data in a separate tab for each equity.
# for (i in 1:length(dividend_objects)) {
# View(get(dividend_objects[i], env = c), title = dividend_objects[i])
# }

##### SPLITS #####

# Create a new environment where splits objects will be stored
d <- new.env()

# Get historical splits information and store objects in environment 'd'.
for (i in 1:length(equities)) {
  try(assign(paste0("splits_", equities[i]),
             na.omit(getSplits(equities[i], src = "yahoo", # from = Sys.Date() - 385, to = Sys.Date(),
                                  auto.assign = FALSE)), envir = d))
}

# Create a vector of data object names in environment 'c'.
splits_objects <- ls(d)

# # Displays the dividend data in a separate tab for each equity.
# for (i in 1:length(splits_objects)) {
#   if (is.xts(get(splits_objects[i], env = d))) {
#     View(get(splits_objects[i], env = d), title = splits_objects[i])
#   }
# }
