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
            ylab = "Growth Rate", xlab = "Date", ylim=c(-0.25, 0.25))
grid(col = '#212A2F')
abline(h = 0, col = '#E8AEED')
dev.off()

# Plot the usd investment time sereis
pdf("/Users/Michael/Documents/DSGE/Figures/us_Inv.pdf",
      width = 9, height = 5)
par(mfrow = c(1, 2), cex = 0.8)
plot(us_ts$logGPDIC1, main = "Log of US Real Investment", ylab = "Log of Investment",
              xlab = "Date")
grid(col = '#212A2F')
plot(diff(us_ts$logGPDIC1), main = "Growth Rate of US Real Investment",
            ylab = "Growth Rate", xlab = "Date", ylim=c(-0.25, 0.25))
grid(col = '#212A2F')
abline(h = 0, col = '#E8AEED')
dev.off()

plot((diff(us_ts$logGPDIC1))^2)

# Plot the us real consumption time sereis
pdf("/Users/Michael/Documents/DSGE/Figures/us_Cons.pdf",
      width = 9, height = 5)
par(mfrow = c(1, 2), cex = 0.8)
plot(us_ts$logPCECC96, main = "Log of US Real Consumption", ylab = "Log of Consumption",
              xlab = "Date")
grid(col = '#212A2F')
plot(diff(us_ts$logPCECC96), main = "Growth Rate of US Consumption",
            ylab = "Growth Rate", xlab = "Date", ylim=c(-0.25, 0.25))
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
# install.packages("tsDyn")
library(urca)
# library(tsDyn)
# library(stargazer)
ar(coredata(us_ts$logGDPC1), order.max = 10, aic = TRUE)
us_gdp_ur <- ur.df(coredata(us_ts$logGDPC1), lags = 5, selectlags='AIC', type="trend")
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


plot(us_ts$logGPDIC1)

# invstment
us_inv_ur <- ur.df(coredata(us_ts$logGPDIC1), lags=10, selectlags='AIC', type="trend")
summary(us_inv_ur)
plot(us_inv_ur)

us_inv_ur2 <- ur.df(coredata(us_ts$logGPDIC1), lags=10, selectlags='AIC', type="drift")
summary(us_inv_ur2)
plot(us_inv_ur2)

# real consumption
us_cons_ur <- ur.df(coredata(us_ts$logPCECC96), lags=8, selectlags='AIC', type="trend")
summary(us_cons_ur)
plot(us_cons_ur)

us_cons_ur2 <- ur.df(coredata(us_ts$logPCECC96), lags=8, selectlags='AIC', type="drift")
summary(us_cons_ur2)
plot(us_cons_ur2)

coredata(us_ts$logGPDIC1)


# Stock market index
library('quantmod')

start_date <- as.Date("1948-01-01")
end_date <- as.Date("2017-12-31")
us_dji <- getSymbols("DJI", src = "yahoo", from = start_date, to = end_date)
head(DJI)

djiq <- read.csv('./Dataset/dji_q.csv', header=TRUE)
djiq$Date <- as.Date(djiq$Date)

djiq_sb <- djiq[which(djiq$Date >=start_date & djiq$Date <= end_date),]
dim(djiq_sb)
# take the log
djiq_names <- names(djiq_sb)[2:6]
datalog_dji <- log(djiq_sb[, 2:6])
# creat new index
logindex_dji <- c()
for (i in djiq_names) {
  index_temp <- paste("log", i, sep="")
  logindex_dji <- c(logindex_dji, index_temp)
}
logindex_dji
names(datalog_dji) <- logindex_dji
djiq_dataset <- cbind.data.frame(djiq_sb, datalog_dji)
dim(djiq_dataset)

# creat time series
djiq_ts <- zoo(djiq_dataset[, 2:11], djiq_dataset$Date)

# plot
plot(djiq_ts$Close)
plot(djiq_ts$Volume)
plot(djiq_ts$logClose)

# SPX
spx <- read.csv('./Dataset/spx_q.csv', header=TRUE)
spx$Date <- as.Date(spx$Date)

spx_sb <- spx[which(spx$Date >=start_date & spx$Date <= end_date),]
dim(spx_sb)
# take the log
spx_names <- names(spx_sb)[2:6]
datalog_spx <- log(spx_sb[, 2:6])
# creat new index
logindex_spx <- c()
for (i in spx_names) {
  index_temp <- paste("log", i, sep="")
  logindex_spx <- c(logindex_spx, index_temp)
}
logindex_spx
names(datalog_spx) <- logindex_spx
spx_dataset <- cbind.data.frame(spx_sb, datalog_spx)
dim(spx_dataset)

# creat time series
spx_ts <- zoo(spx_dataset[, 2:11], spx_dataset$Date)

# NDQ

ndq <- read.csv('./Dataset/ndq_q.csv', header=TRUE)
ndq$Date <- as.Date(ndq$Date)

ndq_sb <- ndq[which(ndq$Date >=start_date & ndq$Date <= end_date),]
dim(ndq_sb)
# take the log
ndq_names <- names(ndq_sb)[2:6]
datalog_ndq <- log(ndq_sb[, 2:6])
# creat new index
logindex_ndq <- c()
for (i in ndq_names) {
  index_temp <- paste("log", i, sep="")
  logindex_ndq <- c(logindex_ndq, index_temp)
}
logindex_ndq
names(datalog_ndq) <- logindex_ndq
ndq_dataset <- cbind.data.frame(ndq_sb, datalog_ndq)
dim(ndq_dataset)

# creat time series
ndq_ts <- zoo(ndq_dataset[, 2:11], ndq_dataset$Date)


# plot all three time series
plot(djiq_ts$Close)
plot(spx_ts$Close)
plot(ndq_ts$Close)

pdf("/Users/Michael/Documents/DSGE/Figures/us_DJIA.pdf",
      width = 9, height = 5)
par(mfrow = c(1, 2), cex = 0.8)
plot(djiq_ts$logClose, main = "Dow Jones Industrial Average", ylab = "Log of Close Price",
              xlab = "Date")
grid(col = '#212A2F')
plot(diff(djiq_ts$logClose), main = "Return of DJIA",
            ylab = "Return", xlab = "Date", ylim=c(-0.3, 0.3))
grid(col = '#212A2F')
abline(h = 0, col = '#E8AEED')
dev.off()

pdf("/Users/Michael/Documents/DSGE/Figures/us_SPX.pdf",
      width = 9, height = 5)
par(mfrow = c(1, 2), cex = 0.8)
plot(spx_ts$logClose, main = "S&P 500", ylab = "Log of Close Price",
              xlab = "Date")
grid(col = '#212A2F')
plot(diff(spx_ts$logClose), main = "Return of S&P 500",
            ylab = "Return", xlab = "Date", ylim=c(-0.3, 0.3))
grid(col = '#212A2F')
abline(h = 0, col = '#E8AEED')
dev.off()

pdf("/Users/Michael/Documents/DSGE/Figures/us_NDQ.pdf",
      width = 9, height = 5)
par(mfrow = c(1, 2), cex = 0.8)
plot(ndq_ts$logClose, main = "Nasdaq Composite", ylab = "Log of Close Price",
              xlab = "Date")
grid(col = '#212A2F')
plot(diff(ndq_ts$logClose), main = "Return of Nasdaq Composite",
            ylab = "Return", xlab = "Date", ylim=c(-0.3, 0.3))
grid(col = '#212A2F')
abline(h = 0, col = '#E8AEED')
dev.off()

# DJIA
us_dji_ur <- ur.df(coredata(djiq_ts$logClose), lags=10, selectlags='AIC', type="trend")
summary(us_dji_ur)
plot(us_dji_ur)

us_dji_ur2 <- ur.df(coredata(djiq_ts$logClose), lags=10, selectlags='AIC', type="drift")
summary(us_dji_ur2)
plot(us_dji_ur2)

# SPX
us_spx_ur <- ur.df(coredata(spx_ts$logClose), lags=10, selectlags='AIC', type="trend")
summary(us_spx_ur)
plot(us_spx_ur)

us_spx_ur2 <- ur.df(coredata(spx_ts$logClose), lags=10, selectlags='AIC', type="drift")
summary(us_spx_ur2)
plot(us_spx_ur2)

# NDQ
us_ndq_ur <- ur.df(coredata(ndq_ts$logClose), lags=10, selectlags='AIC', type="trend")
summary(us_spx_ur)
plot(us_spx_ur)

us_spx_ur2 <- ur.df(coredata(ndq_ts$logClose), lags=10, selectlags='AIC', type="drift")
summary(us_spx_ur2)
plot(us_spx_ur2)

# Conclusion: random walk with drift










# End of code
