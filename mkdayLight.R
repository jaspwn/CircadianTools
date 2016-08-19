### Take environmental monitor binned data file and make dayLight file for matlab flytoolbox functions

## choose filename and set working directory

filename <- file.choose()
setwd(dirname(filename))

## read in raw data file

data <- read.table(filename, stringsAsFactors = FALSE)

## date, start and stop time

datestart <- as.POSIXct(strptime('2016-07-29 00:00:00', format = "%Y-%m-%d %H:%M:%S"))
datestop <- as.POSIXct(strptime('2016-08-15 00:00:00', format = "%Y-%m-%d %H:%M:%S"))

## convert time in data file to POSIX datetime

timelist <- paste(data$V2,data$V3,data$V4,data$V5)
timelist <- as.POSIXct(strptime(timelist, format='%d %b %g %H:%M:%S'))

## grab light data columns and rename

lightlist <- data$V17

## function to create list based on light status 000001 if on and 000000 if off

make_light_vec <- function(x) {
  if(lightlist[x] > 0) {
    light <- '000001'
  } else {
    light <- '000000'
  }
}

## function to create list of datetime in desired format - '%Y%m%d %H%M'

make_datetime_vec <- function(x) {
  time <- format(timelist[x], '%Y%m%d %H%M')
}

## call make_light_vec and make datetime_vec functions to coerce data into correct format

daylight <- paste(sapply(1:length(timelist), make_datetime_vec), '  ', sapply(1:length(timelist), make_light_vec), sep = '')

## create file heading with monitor name, start date, number of bins, bin length (mins) and first time bin

monitor <- tools::file_path_sans_ext(basename(filename))
heading <- paste(monitor, '   ', format(datestart, '%d %b %Y'), sep = '')
len <- length(timelist)
bin.length <- 5
starttime <- format(timelist[1], '%H%M')

## Create appropriate filename

name.split <- strsplit(monitor, 'Ct')
name.split <- name.split[[1]]
out.filename <- paste(name.split[1], 'CtDAYLIGHT', sep = '')

## Write all data to file

write(heading, out.filename, append = FALSE)
write(len, out.filename, append = TRUE)
write(bin.length, out.filename, append = TRUE)
write(starttime, out.filename, append = TRUE)
lapply(daylight, write, out.filename, append = TRUE)
