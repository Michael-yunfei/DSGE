# Investment and Financial Risk

# Load the package
library(fredr)
library(purrr)
library(tidyverse)
library(zoo)
library(tseries)
library(MASS, stats)
library(fGarch)

# Prepare the data

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
# create new index
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

# SP 500
start_date <- as.Date("1948-01-01")
end_date <- as.Date("2017-12-31")
spx <- read.csv('./Dataset/spx_q.csv', header=TRUE)
spx$Date <- as.Date(spx$Date)

spx_sb <- spx[which(spx$Date >=start_date & spx$Date <= end_date),]
dim(spx_sb)
# take the log
spx_names <- names(spx_sb)[2:6]
datalog_spx <- log(spx_sb[, 2:6])
# create new index
logindex_spx <- c()
for (i in spx_names) {
  index_temp <- paste("log", i, sep="")
  logindex_spx <- c(logindex_spx, index_temp)
}
logindex_spx
names(datalog_spx) <- logindex_spx
spx_dataset <- cbind.data.frame(spx_sb, datalog_spx)
dim(spx_dataset)

# create time series
spx_ts <- zoo(spx_dataset[, 2:11], spx_dataset$Date)

###############################################################################
# The Stylized Facts of Investment
###############################################################################

# Plot growth rates
plot(diff(us_ts$logGPDIC1), main = "Growth Rate of US Real Investment",
            ylab = "Growth Rate", xlab = "Date", ylim=c(-0.25, 0.25))
grid(col = '#212A2F')
abline(h = 0, col = '#E8AEED')

# plot the volatility
plot((diff(us_ts$logGPDIC1)^2), main = "Volatility of US Real Investment",
            ylab = "Volatility", xlab = "Date")
grid(col = '#212A2F')
abline(h = 0, col = '#E8AEED')

# plot return
plot(diff(spx_ts$logClose), main = "Return of S&P 500",
            ylab = "Return", xlab = "Date")
grid(col = '#212A2F')
abline(h = 0, col = '#E8AEED')

# Plot volatility
plot((diff(spx_ts$logClose)^2), main = "Volatility of S&P 500",
            ylab = "Volatility", xlab = "Date")
grid(col = '#212A2F')
abline(h = 0, col = '#E8AEED')

# compare volatility of investment and S&P 500
pdf("/Users/Michael/Documents/DSGE/Figures/VolatInvSP500.pdf",
      width = 9, height = 5)
par(mfrow = c(1, 2), cex = 0.8)
plot((diff(us_ts$logGPDIC1)^2), main = "Volatility of US Real Investment",
            ylab = "Volatility", xlab = "Date", ylim=c(0, 0.09))
grid(col = '#212A2F')
abline(h = 0, col = '#E8AEED')
plot((diff(spx_ts$logClose)^2), main = "Volatility of S&P 500",
            ylab = "Volatility", xlab = "Date", ylim=c(0, 0.09))
grid(col = '#212A2F')
abline(h = 0, col = '#E8AEED')
dev.off()


# ACF plot

pdf("/Users/Michael/Documents/DSGE/Figures/AcfInvSP500.pdf",
      width = 9, height = 6)
par(mfrow = c(1, 2), cex = 0.8)
acf(coredata((diff(us_ts$logGPDIC1))^2), main="ACF of Investment Volatility",
ylim=c(0, 0.6))
acf(coredata((diff(spx_ts$logClose))^2), main="ACF of S&P500 Volatility",
ylim=c(0, 0.6))
dev.off()

pdf("/Users/Michael/Documents/DSGE/Figures/AcfInv.pdf",
      width = 7.6, height = 5.3)
par(mfrow = c(1, 1), cex = 0.8)
acf(coredata((diff(us_ts$logGPDIC1))^2), main="ACF of Investment Volatility",
      ylim=c(0, 0.6))
dev.off()

length(diff(us_ts$logGPDIC1))

# Caution: it's quarterly time series, we see the volatility autocorrelation
#          for SP500 isn't that strong

# Ljung-Box test
Box.test(coredata(diff(us_ts$logGPDIC1)), lag=21, type='Ljung-Box')

# spectrum
spectrum(coredata(diff(us_ts$logGPDIC1)))
spectrum(coredata(diff(spx_ts$logClose)))
spectrum(coredata(diff(us_ts$logGPDIC1)),
                  spans=c(25,5,25),main="Smoothed periodogram")
spectrum(coredata(diff(spx_ts$logClose)),
                  spans=c(25,5,25),main="Smoothed periodogram")

# fit with normal distribtuion
inv <- coredata(diff(us_ts$logGPDIC1))
hist(inv)
plot(inv)
inv_z <- (inv - mean(inv))/sd(inv)
qqnorm(inv_z)
abline(0, 1)

###############################################################################
# Fit ARCH and GARCH with investment
###############################################################################

inv <- diff(us_ts$logGPDIC1)*100  # growth rates * 100
inv <- inv - mean(inv)  # de-mean
inv_arch <- garchFit(~garch(1, 0), data=inv, include.mean=FALSE, trace=FALSE)
plot(inv_arch, which=11)

inv_garch <- garchFit(~garch(1, 1), data=inv, include.mean=FALSE, trace=FALSE)
plot(inv_garch, which=11)

# Student-t distribution
inv_archt <- garchFit(~garch(1, 0), data=inv,
                      include.mean=FALSE, trace=FALSE,
                      cond.dist='std')
plot(inv_archt, which=11)

inv_garcht <- garchFit(~garch(1, 1), data=inv,
                      include.mean=FALSE, trace=FALSE,
                      cond.dist='std')
plot(inv_garcht, which=11)

#         Estimate  Std. Error  t value Pr(>|t|)
# omega  1.447e-04   9.345e-05    1.548  0.12150
# alpha1 0.2309      8.157e-02    2.830  0.00465 **
# beta1  0.7195      8.704e-02    8.267 2.22e-16 ***
# shape  6.148e+00   2.139e+00    2.874  0.00405 **
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#
# Log Likelihood:
#  489.1064    normalized:  1.75307

inv_try <- garchFit(~garch(2, 1), data=inv,
                      include.mean=FALSE, trace=FALSE)
plot(inv_try, which = 11)

###############################################################################
# Fit ARCH and GARCH with SP500
###############################################################################

sp <- diff(spx_ts$logClose)*100
sp <- sp - mean(sp)  # de-mean
sp_arch <- garchFit(~garch(1, 0), data=sp, include.mean=FALSE, trace=FALSE)
plot(sp_arch, which=11)

sp_garch <- garchFit(~garch(1, 1), data=sp, include.mean=FALSE, trace=FALSE)
plot(sp_garch, which=11)

sp_garcht <- garchFit(~garch(1, 1), data=sp,
                      include.mean=FALSE, trace=FALSE,
                      cond.dist='std')
plot(sp_garcht, which=11)

#         Estimate  Std. Error  t value Pr(>|t|)
# omega    12.4738      5.8184    2.144   0.0320 *
# alpha1    0.2488      0.1156    2.153   0.0313 *
# beta1     0.5626      0.1238    4.543 5.54e-06 ***
# shape     6.2579      2.0615    3.036   0.0024 **
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#
# Log Likelihood:
#  -947.4601    normalized:  -3.395914

# End of code
