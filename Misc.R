# Miscellaneous collection

date <- seq.Date(as.Date("1948-01-01"), as.Date("2016-12-31"), by = "quarter")
acdf <- as.data.frame(date)
names(acdf) <- "date"
acdf$date <- c(1:9)
acdf


acs <- c("he", "hq", "gj")
for (i in 1:length(acs)) {
  print(i)
}
