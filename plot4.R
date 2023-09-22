# Load packages 
library(data.table)

# Check the library requs
library_check <- sapply("data.table", require, character.only = TRUE
                        , quietly = TRUE)

# Working the directories
path <- getwd()

if(!file.exists("./data")){
    dir.create("./data")
}

url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

# Download and unzip the dataset
download.file(url, file.path(path, "./data/DataFiles.zip"))
unzip(zipfile = "./data/DataFiles.zip")

# Load the dataset 
data <- data.table::fread(input = "./data/household_power_consumption.txt",
                          na.strings="?")

data[, Global_active_power := lapply(.SD, as.numeric), .SDcols = c("Global_active_power")]

data[, dateTime := as.POSIXct(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S")]

# subset the data to the desired time interval of two days
data <- data[(dateTime >= "2007-02-01") & (dateTime < "2007-02-02")]

png("plot4.png", width=480, height=480)
par(mfrow = c(2,2))

# Create plot 1
plot(data[,dateTime], data[, Global_active_power], type = "l", xlab = "", ylab = "Global_active_power")

# Create plot 2
plot(data[, dateTime], data[, Voltage], type = "l", xlab = "datetime", ylab = "Voltage")

# Create plot 3
plot(x = data[,dateTime], y = data[, Sub_metering_1], type = "l", xlab = "", ylab = "Energy sub metering")
lines(x = data[, dateTime], y = data[, Sub_metering_2], col = "red")
lines(x = data[, dateTime], y = data[, Sub_metering_3], col = "blue")
legend("topright",
       col = c("black", "red", "blue"),
       c("Sub_metering_1  ","Sub_metering_2  ", "Sub_metering_3  "),
       lty=c(1,1), 
       lwd=c(1,1))

# Create plot 4
plot(data[, dateTime], data[, Global_reactive_power], type = "l", xlab = "datetime", ylab = "Voltage")

dev.off()
