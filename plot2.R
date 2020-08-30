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
png("plot2.png", width=480, height=480)
with(HPC_dt, plot(Date_Time, Global_active_power, type = 'l', xlab = 'Day', ylab="Global Active Power (kilowatts)"))
dev.off()
