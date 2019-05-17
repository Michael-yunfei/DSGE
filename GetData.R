# R code for getting and tidying the data series

# Install packages
# install.packages("fredr"); please install this one
# install.packages("tseries")
library(fredr)
library(purrr)
library(tidyverse)
library(zoo)
library(tseries)

getwd()

# set API keys (you have to request one by yourself)
# google: request fredr API key

fredr_set_key("c7cb8e359f4222145a267cad0c2e3abe")

# write a function to get a list of quarter series data from FREDR
fredr_get <- function (index, start, end) {
  # input: a vector of index
  #        a vector of date "1948-01-01"

  index_length <- length(index)

  # initialize a dataframe
  date <- seq.Date(as.Date(start), as.Date(end), by = "quarter")
  data <- data.frame(date)

  # download and collect the datasets
  for (i in 1:index_length) {
    temp_data <- fredr(series_id = index[i],
                  observation_start = as.Date(start),
                  observation_end = as.Date(end))
    temp_data <- temp_data[, c(1, 3)]
    data <- left_join(data, temp_data, by = "date")

  }
  names(data) <- c("date", index)

  # return dataset
  return(data)
}

# Units:Billions of Dollars; Quarterly
# Data collection
# GDP - nominal GDP
# GDPC1 - Real GDP
# PCEC - nominal consumption
# PCECC96 - real consumption
# GDPI - nominal investment
# GDPIC1 - real investment

dataindex <- c("GDP", "GDPC1", "PCEC", "PCECC96", "GPDI", "GPDIC1")
us_dataset <- fredr_get(dataindex, "1948-01-01", "2017-12-31")
head(us_dataset)
tail(us_dataset)
# take the log
datalog <- log(us_dataset[, 2:7])
# creat new index
logindex <- c()
for (i in dataindex) {
  index_temp <- paste("log", i, sep="")
  logindex <- c(logindex, index_temp)
}
logindex
names(datalog) <- logindex
us_dataset <- cbind.data.frame(us_dataset, datalog)
dim(us_dataset)  # 280 13
head(us_dataset)
# Check the characteristics of those time series
us_ts <- zoo(us_dataset[, 2:13], us_dataset$date)
head(us_ts)
tail(us_ts)
plot(us_ts$GDPC1)


# Plot the usd gdp time sereis
pdf("/Users/Michael/Documents/DSGE/Figures/us_realgdp.pdf",
      width = 9, height = 5)
par(mfrow = c(1, 2), cex = 0.8)
plot(us_ts$logGDPC1, main = "Log of US Real GDP", ylab = "Log of GDP",
              xlab = "Date")
grid(col = '#212A2F')
plot(diff(us_ts$logGDPC1), main = "Growth Rate of US Real GDP",
            ylab = "Growth Rate", xlab = "Date")
grid(col = '#212A2F')
abline(h = 0, col = '#E8AEED')
dev.off()

# Check the stationarity of growth rate of real gdp
acf(coredata(us_ts$GDPC1), lag.max = 100) # more like MA
pacf(coredata(us_ts$GDPC1), lag.max = 20)  # not ar
acf(coredata(us_ts$logGDPC1), lag.max = 100)
acf(coredata(diff(us_ts$logGDPC1)), lag.max = 20,
            main = "ACF for RGDP Growth Rate")
pacf(coredata(diff(us_ts$logGDPC1)), lag.max = 20,
            main = "PACF for RGDP Growth Rate")

# for I(1) process, acf declines linearly
# for I(0) process, acf declines exponentially

# check for the unit root
install.packages("urca")
library(urca)
# library(stargazer)
ar(coredata(us_ts$logGDPC1), order.max = 10, aic = TRUE)
us_gdp_ur <- ur.df(coredata(us_ts$logGDPC1), selectlags='AIC', type="trend")
summary(us_gdp_ur)
plot(us_gdp_ur)

us_gdp_ur2 <- ur.df(coredata(us_ts$logGDPC1), selectlags='AIC', type='drift')
summary(us_gdp_ur2)
plot(us_gdp_ur2)

# do the filter
install.packages("mFilter")
library(mFilter)
plot(hpfilter(us_ts$logGDPC1, freq = 1600))
plot(hpfilter(us_ts$logGDPC1, freq = 1600, drift = TRUE))

















# End of code
