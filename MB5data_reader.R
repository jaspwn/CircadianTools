## set working directory by choosing any file in directory

filename <- file.choose()
wd <- setwd(dirname(filename))

## read in raw MB5 data

raw_data <- read.table(filename, sep = '\t')

## rename columns

data <- plyr::rename(raw_data, c('V1' = 'index', 'V2' = 'date', 'V3' = 'time', 'V4' = 'status', 'V5' = 'extras', 'V6' = 'mon_number', 'V7' = 'tube_number', 'V8' = 'data_type', 'V9' = 'blank', 'V10' = 'light_sensor', 'V11' = 'position', 'V12' = 'total'))

## create a single date/time column in POSIXct format

data$datetime <- as.POSIXct(paste(data$date, data$time), format = '%d %b %g %H:%M:%S')

## create list of files in working directory

file_list <- list.files()

## Gather experimental parameters

parameter_file <- read.table(file_list[1], header = FALSE, sep = '\n', stringsAsFactors = FALSE)
bin_num <- as.integer(parameter_file$V1[2])
bin_len <- parameter_file$V1[3]
first_bin <- as.POSIXct(strptime(parameter_file$V1[4], format = '%H%M'))

bin_times <- format((seq.POSIXt(first_bin, by = paste(bin_len, 'min', sep = ' '), length.out = bin_num)), '%H%M')

## read binned data and add to datatable


test <- read.table(file_list[1], skip = 4, header = FALSE, stringsAsFactors = FALSE)
test2 <- read.table(file_list[2], skip = 4, header = FALSE, stringsAsFactors = FALSE)

together <- merge(test, test2, by = 'V1')



read.data <- function(x) {
  dt <- read.table(file_list[x], skip = 4, header = FALSE, stringsAsFactors = FALSE)
}


data_list <- lapply(1:64, read.data)


