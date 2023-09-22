# Load necessary libraries
library(data.table)

# Check and load required libraries quietly
library_check <- sapply("data.table", require, character.only = TRUE, quietly = TRUE)

path <- getwd()

if (!file.exists("./data")) {
    dir.create("./data")
}
# Load the Dataset
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

# Download and unzip the dataset
download.file(url, file.path(path, "./data/DataFiles.zip"))
unzip(zipfile = "./data/DataFiles.zip")

# Load the dataset 
data <- data.table::fread(input = "./data/household_power_consumption.txt",
                          na.strings="?")

# Change Date Column to Date Type
data[, Date := lapply(.SD, as.Date, "%d/%m/%Y"), .SDcols = c("Date")]

# Prevents histogram from printing in scientific notation
data[, Global_active_power := lapply(.SD, as.numeric), .SDcols = c("Global_active_power")]

# Filter Dates 
data <- data[(Date >= "2007-02-01") & (Date <= "2007-02-02")]

png("plot1.png", width=480, height=480)

## Creating the first plot
hist(data[, Global_active_power], main="Global Active Power", 
     xlab="Global Active Power (kilowatts)", ylab="Frequency", col="Red")

dev.off()


