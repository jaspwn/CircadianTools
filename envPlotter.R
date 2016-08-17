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

time <- paste(data$V2,data$V3,data$V4,data$V5)
time <- as.POSIXct(strptime(time, format='%d %b %g %H:%M:%S'))

## grab data columns and rename

light <- data$V17
temp <- data$V22/10
humidity <- data$V27

## add all data to data.table

graphdata <- data.frame(time, light, temp, humidity, stringsAsFactors = FALSE)

## subset date between start and stop times

lims <- c(datestart, datestop)
graphdata <- subset(graphdata, time >= lims[1] & time <= lims[2])

## melt data

molten.data <- melt(graphdata, id = c('time'), variable.name = 'env.cond', value.name = 'value')

# filter and plot data

light.data <- molten.data %>%
  filter(env.cond == 'light')

light.plot <- ggplot(data = light.data, aes(x = time, y = value, colour = env.cond)) +
  geom_line() +
  scale_x_datetime(breaks = date_breaks('1 day')) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

temp.data <- molten.data %>%
  filter(env.cond == 'temp')

temp.plot <- ggplot(data = temp.data, aes(x = time, y = value, colour = env.cond)) +
  geom_line()

humidity.data <- molten.data %>%
  filter(env.cond == 'humidity')

humidity.plot <- ggplot(data = humidity.data, aes(x = time, y = value, colour = env.cond)) +
  geom_line()

plot <- gridExtra::grid.arrange(light.plot, temp.plot, humidity.plot, ncol = 1, layout_matrix = cbind(c(1,2,3)))

plot

#ggsave(filename = 'Da1 sleep analsis.pdf', plot = plot, width = 17.8, height = 15, units = c('cm'))

## create daylight file



