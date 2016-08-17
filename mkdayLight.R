library(ggplot2)
library(scales)
library(reshape2)
library(lubridate)
library(data.table)
library(dplyr)
library(gridExtra)

filename <- file.choose()
setwd(dirname(filename))

## read in raw data file

data <- read.table(filename, stringsAsFactors = FALSE)

## date, start and stop time

datestart <- as.POSIXct(strptime('2016-07-29 10:00:00', format = "%Y-%m-%d %H:%M:%S"))
datestop <- as.POSIXct(strptime('2016-08-15 09:55:00', format = "%Y-%m-%d %H:%M:%S"))

## convert time in data file to POSIX datetime

timelist <- paste(data$V2,data$V3,data$V4,data$V5)
timelist <- as.POSIXct(strptime(time, format='%d %b %g %H:%M:%S'))

## grab light data columns and rename

lightlist <- data$V17

## create list based on light status 000001 if on and 000000 if off

make_light_vec <- function(x) {
  if(light[x] > 0) {
    light <- '000001'
  } else {
    light <- '000000'
  }
}

## light_test <- sapply(1:length(timelist), make_light_vec)

format(time[1], '%Y%m%d')

make_datetime_vec <- function(x) {
  time <- format(time[x], '%Y%m%d %H%M')
}

## time_test <- sapply(1:length(timelist), make_datetime_vec)

daylight <- paste(sapply(1:length(timelist), make_datetime_vec), '  ', sapply(1:length(timelist), make_light_vec), sep = '')
lapply(daytime, write, 'test', append = TRUE)