# Creates a formatted table from a dataframe imported from a .csv file.

library(dplyr)
library(tidyr)
library(gt)
library(htmlwidgets)

# Import data from .csv file to a dataframe.
table <- read.csv("./Finance APIs and Associated R Packages/table.csv")

# A function to format urls into hyperlinks. 
url_formatter <- function(x) {
    url_regex <- "(https?://[[:alnum:]_\\-\\+\\./]+)"
    gsub(url_regex, "<a href='\\1' target='_blank'>\\1</a>", x, perl = TRUE)
    }
# Transforms the table into something more presentable using the gt package.
table <- table %>%
  gt() %>%
  # Adds a title and subtitle to the table.
  tab_header(
    title = md("Financial APIs and Associated R Packages"),
    subtitle = md("Table last updated on 24th March 2023")
  ) %>%
  # Transforms urls in the specified columns into hyperlinks using the above url_formatter function.
  fmt(
    columns = c("API.Reference", "Package.Reference"),
    f = url_formatter
  ) %>%
  # Replaces the NA's in the table to blank strings for presentation.
  text_transform(
    locations = cells_body(everything()),
    fn = function(x) replace_na(x, "")
  ) %>%
  # Relabels the columns for easier reading.
   cols_label(
    APIs = md("**APIs**"),
    API.Reference = md("**API Reference**"),
    API.Notes = md("**API Notes**"),
    Relevant.R.Packages = md("**Relevant R Packages**"),
    Package.Reference = md("**Package Reference**"),
    Package.Notes = md("**Package Notes**")
  )

# Saves the table as an .html file for viewing.
gtsave(table, "./Finance APIs and Associated R Packages/finance_apis_and_associated_r_packages.html")
