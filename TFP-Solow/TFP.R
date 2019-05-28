# Total Factor Productivity
# @ Michael

###############################################################################
# Estimate TFP based on GDP per capita
###############################################################################

# Get the data

library(fredr)
library(purrr)
library(tidyverse)
library(zoo)
library(tseries)
library(pwt9)
library(MASS, stats)
library(fGarch)

getwd()
setwd('./TFP-Solow')

# Load data
data("pwt9.0")

ptw_data <- filter(pwt9.0, country=='United States of America')
ptw_data <- select(ptw_data, year, isocode, rgdpna, rkna, emp, labsh)
ptw_data <- na.omit(ptw_data)

ptw_data <- mutate(ptw_data, y_pc = log(rgdpna / emp), # GDP per worker
         k_pc = log(rkna / emp), # Capital per worker
         a = 1 - labsh) # Capital share

ptw_data <- mutate(ptw_data, g = (y_pc - lag(y_pc)) * 100, # the growth rate of GDP per capita
         dk = (k_pc - lag(k_pc)) * 100, # the growth rate of capital per capita
         dsolow = g - a * dk)
ptw_data <- na.omit(ptw_data)
# Once we get the Solow residual, let's examine it's properties

ptw_tfp_gr <- zoo(ptw_data$dsolow, ptw_data$year)
plot(ptw_tfp_gr)

ptw_tfp <- cumsum(ptw_tfp_gr)/length(ptw_tfp_gr)
plot(ptw_tfp)

# fit the ARCH model
ptw_tfp_grdm <- ptw_tfp_gr - mean(ptw_tfp_gr)
ptw_tfp_garch <- garchFit(~garch(1, 1), data=ptw_tfp_grdm, include.mean=FALSE, trace=FALSE)
plot(ptw_tfp_garch, which=11)


# exam tfp from
# https://www.frbsf.org/economic-research/indicators-data/total-factor-productivity-tfp/

tfp_quarterly <- read_csv('./tfp_utadj.csv')
tfp_quarterly <- na.omit(tfp_quarterly)
datesq <- seq.Date(as.Date('1947-04-01'), as.Date('2018-12-31'), 'quarter')

quar_tfp <- zoo(tfp_quarterly$dtfp, datesq)
plot(quar_tfp)

quar_tfpuadj <- zoo(tfp_quarterly$dtfp_util, datesq)
plot(quar_tfpuadj)

tfp_garch <- garchFit(~garch(1, 1), data=quar_tfp, include.mean=TRUE, trace=FALSE)
plot(tfp_garch, which=11)

tfpadj_garch <- garchFit(~garch(1, 1), data=quar_tfpuadj, include.mean=TRUE, trace=FALSE)

# End of Code
