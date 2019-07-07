# VAR model with R
# @ Michael

library(fredr)
library(tidyverse)
library(zoo)

###############################################################################
# Get the data
###############################################################################

fredr_set_key("c7cb8e359f4222145a267cad0c2e3abe")

# write a function to get a list of quarter series data from FREDR
fredr_get <- function (index, start, end, freq) {
  # input: a vector of index
  #        a vector of date "1948-01-01"

  index_length <- length(index)

  # initialize a dataframe
  if(freq == "quarter"){
    date <- seq.Date(as.Date(start), as.Date(end), by = "quarter")
  }else if (freq == 'month'){
    date <- seq.Date(as.Date(start), as.Date(end), by = "month")
  }else {
    print("Please indicate the right frequency, like quarter, month")
  }

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

quarterIndex <- c('A939RX0Q048SBEA', 'GDP', 'GDPDEF', 'PCND', 'COMPRNFB',
                  'PCESV', 'PCDG', 'GPDI', 'OPHNFB', 'PRS85006173', 'PRS85006023')

quarterData <- fredr_get(quarterIndex, "1950-01-01", "2017-12-31", "quarter")


monthIndex <- c('CE16OV', 'CNP16OV', 'UNRATE', 'FEDFUNDS', 'M1SL', 'M2SL',
                 'AAA10YM', 'BAA10YM')

monthData <- fredr_get(monthIndex, "1950-01-01", "2017-12-31", "month")

###############################################################################
# Clean the Data
###############################################################################
quarterData$quarter <- as.yearqtr(quarterData$date)
quarterData$RGDP <- log(quarterData$A939RX0Q048SBEA)
quarterData$RCon <- log((quarterData$PCND
                    + quarterData$PCESV)*quarterData$A939RX0Q048SBEA/quarterData$GDP)
quarterData$RInv <- log((quarterData$PCDG
                    + quarterData$GPDI)*quarterData$A939RX0Q048SBEA/quarterData$GDP)

# transform the monthly data into quarter
monthData$quarter <- as.yearqtr(monthData$date)

# the following three variables take average
quarterCE16OV <- summarise(group_by(monthData, quarter), CE16OVMean = mean(CE16OV))
quarterUNRATE <- summarise(group_by(monthData, quarter), UNRATEMean = mean(UNRATE))
quarterFEDFUNDS <- summarise(group_by(monthData, quarter), FEDFUNDSMean = mean(FEDFUNDS))
quarterAAA10YM <- summarise(group_by(monthData, quarter), AAA10Y = mean(AAA10YM))
quarterBAA10YM <- summarise(group_by(monthData, quarter), BAA10Y = mean(BAA10YM))

# the following three variables take the value at the end of period
monthData$month <- as.yearmon(monthData$date)
quarterCNP16OV <- select(filter(separate(monthData, month, c('M', 'y')),
                    M %in% c('Mar', 'Jun', 'Sep', 'Dec')), quarter, CNP16OV)

quarterData <- left_join(quarterData, quarterCE16OV, by = 'quarter')
quarterData <- left_join(quarterData, quarterUNRATE, by = 'quarter')
quarterData <- left_join(quarterData, quarterFEDFUNDS, by = 'quarter')
quarterData <- left_join(quarterData, quarterCNP16OV, by = 'quarter')
quarterData <- left_join(quarterData, quarterAAA10YM, by = 'quarter')
quarterData <- left_join(quarterData, quarterBAA10YM, by = 'quarter')


quarterData$Hours <- log(quarterData$PRS85006023*quarterData$CE16OVMean/quarterData$CNP16OV)
quarterData$Infla <- log(quarterData$GDPDEF/lag(quarterData$GDPDEF))
quarterData$InRt <- quarterData$FEDFUNDSMean/400  #
quarterData$Productivity <- quarterData$OPHNFB
quarterData$labshare <- log(quarterData$PRS85006173)
quarterData$Rwage <- log(quarterData$COMPRNFB)

# TFP

tfp_quarterly <- read_csv('./TFP-Solow/tfp_utadj.csv')
tfp_quarterly <- na.omit(tfp_quarterly)
tfp_quarterly$quarter <- as.yearqtr(seq.Date(as.Date('1947-04-01'), as.Date('2018-12-31'), 'quarter'))
quarterData <- left_join(quarterData, tfp_quarterly[, 2:5], by = 'quarter')
quarterData$TFP <- log(cumsum(quarterData$dtfp_util/100))

# SP 500

start_date <- as.Date("1948-01-01")
end_date <- as.Date("2017-12-31")
spx <- read.csv('./Dataset/spx_q.csv', header=TRUE)
spx$Date <- as.Date(spx$Date)
spx_sb <- spx[which(spx$Date >=start_date & spx$Date <= end_date),]
spx_sb$quarter <- as.yearqtr(spx_sb$Date)
SP500 <- select(spx_sb, quarter, Close)
SP500$SP500In <- log(SP500$Close)
SP500 <- select(SP500, quarter, SP500In)

quarterData <- left_join(quarterData, SP500, by = 'quarter')

###############################################################################
# Final dataset
###############################################################################
# Variable List
# date
# real GDP per capita: 'RGDP'
# real consumption per capita: 'RCon'
# real investment per capita: 'RInv'
# Hours worked: 'Hours'
# Inflation: 'Infla'
# Interest rate: 'InRt'
# Productivity: 'Productivity'
# Labor share: 'labshare'
# real wage: 'Rwage'
# TFP: 'TFP'
# SP500: SP500In (log)
# real interest rate: Rinr = InRt - Infla
# AAA10YM Moody's Seasoned Aaa Corporate Bond Yield Relative to Yield on 10-Year Treasury
# Constant Maturity
# BAA10YM  Moody's Seasoned Baa Corporate Bond Yield Relative to Yield on 10-Year Treasury
# Constant Maturity

names(quarterData)

# 'date' 'A939RX0Q048SBEA' 'GDP' 'GDPDEF' 'PCND' 'COMPRNFB' 'PCESV' 'PCDG' 'GPDI' 'OPHNFB' 'PRS85006173' 'PRS85006023' 'quarter' 'RGDP' 'RCon' 'RInv' 'CE16OVMean' 'UNRATEMean' 'FEDFUNDSMean' 'CNP16OV' 'AAA10Y' 'BAA10Y' 'Hours' 'Infla' 'InRt' 'Productivity' 'labshare' 'Rwage' 'dtfp' 'dutil' 'dtfp_util' 'TFP' 'SP500In'


dim(quarterData)


varmodelData <- select(quarterData, date, quarter, RGDP, RCon, RInv, Hours, Infla, InRt,
                        AAA10Y, BAA10Y, Productivity,
                        labshare, Rwage, TFP, SP500In)
varmodelData$Rinr <- varmodelData$InRt - varmodelData$Infla

# save the full dataset
write_csv(varmodelData, './VAR/US_Quarter_Data.csv')


###############################################################################
# Build the VAR model
###############################################################################
varjmulti <- na.omit(varmodelData)
write_csv(varjmulti, './VAR/varjmulti.csv')
write_csv(varjmulti, './VAR/varStata.csv')














# End of Code
