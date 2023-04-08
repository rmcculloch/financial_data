# Financial Data

## Introduction

This project uses R scripts to source financial data across a range of asset
classes including:  

- Equities  
- Treasuries  
- Commodities  
- Currencies (FX)  
- Precious Metals  
- Cryptocurrencies  

The scripts use a number of different finance APIs and associated R packages
which can interact with them. All the data can be accessed free of charge
although there are subscriptions to many of the APIs which can give you greater
access. Click to [here](https://raw.githack.com/rmcculloch/financial_data/main/Finance%20APIs%20and%20Associated%20R%20Packages/finance_apis_and_associated_r_packages.html) to see information table.

The scripts also use the Highcharter package to plot charts of historical data
in each of the asset classes. This package is an R wrapper for the javascript
library, Highcharts, which renders professional looking interactive
charts. It is free to use except when using for commercial gain. The license
information for Highcharts can be viewed [here](https://shop.highcharts.com/).

## Installation

This project has been created in the [rstudio](https://github.com/rstudio/rstudio) IDE.
The best way to use these scripts is to start a new project in rstudio from this
repository, as follows:

- From within rstudio, click on File and then New Project...
- Select Version Control and then Git.
- Paste in the repository url which you can get by clicking on Code on the
  repository page and clicking the Copy icon for the selected protocol.
- Input a name for the directory/project and the parent directory where it will
  reside.
- Click Create Project.
- This will download the repository and create the project, putting you in the
  project root directory and using the project library.
- Type renv::restore in the rstudio console to install all packages in renv.lock.
- You can then open and run/source scripts as desired.
- Scripts can also be executed line-by-line in rstudio using ctrl-enter. 



