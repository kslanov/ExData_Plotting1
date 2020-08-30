# Scripts for Getting and Cleaning Data course project

##loading libraries

library(dplyr)
library(stringr)
library(reshape2)
library(chron)
library(data.table)
##-----------------------------------FILE PREPARATION------------------------------------

##!!!!!!!!!!!!!!!!must enter the path for the directory with unzipped data files!!!!!!!!!

## Directory path for data files
DirPath <- '<your path to the file (including the file & extension)>' 


##--------------------------READING AND CONVERTING DATA----------------------------------
## Reading household power consumption (HPC) file
HPC_data <- read.table(file = DirPath, sep = ';', header = TRUE)
## Converting Date and Time columns
HPC_data$Date <- as.Date.character(HPC_data$Date, '%d/%m/%Y')
HPC_data$Time <- times(HPC_data$Time)
## Subsetting values for 2007-02-01 and 2007-02-02
HPC_dt <- subset(HPC_data, Date == '2007-02-01'| Date == '2007-02-02')
## Converting numeric columns
HPC_dt[, 3:9] <- sapply(HPC_dt[, 3:9], as.numeric)
## Creating Date + Time column
Date_Time <- strptime(paste(HPC_dt$Date, HPC_dt$Time, sep=" "), '%Y-%m-%d %H:%M:%S')
HPC_dt <- cbind(HPC_dt, Date_Time)

##-----------------------------------PLOTTING-------------------------------------------
png("plot4.png", width=480, height=480)
par(mfrow = c(2,2))
## Plot 1
with(HPC_dt, plot(Date_Time, Global_active_power, type="l", xlab="", ylab="Global Active Power"))
## Plot 2
with(HPC_dt, plot(Date_Time, Voltage, type = "l", xlab="datetime", ylab="Voltage"))
## Plot 3
with(HPC_dt, plot(Date_Time, Sub_metering_1, type="l", xlab="", ylab="Energy sub metering"))
lines(HPC_dt$Date_Time, HPC_dt$Sub_metering_2, type = 'l', col= 'red')
lines(HPC_dt$Date_Time, HPC_dt$Sub_metering_3, type = 'l', col= 'blue')
legend('topright', c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty = 1, lwd = 2, col = c('black', 'red', 'blue'))
## Plot 4
with(HPC_dt, plot(Date_Time, Global_reactive_power, type="l", xlab="datetime", ylab="Global_reactive_power"))
dev.off()
