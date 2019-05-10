# R code for getting and tidying the data series

# Install packages
install.packages("fredr")
library(fredr)
library(purrr)
library(tidyverse)

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

# Units:Billions of Dollars

dataindex <- c("GDP", "GDPC1", "PCEC", "PCECC96", "GPDI", "GPDIC1")
us_dataset <- fredr_get(dataindex, "1948-01-01", "2017-12-31")
head(us_dataset)
tail(us_dataset)













# End of code
