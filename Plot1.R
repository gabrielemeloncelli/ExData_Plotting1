## Create a working folder for data
if (!file.exists("./data")) {
	dir.create("./data")
}

## Dowload and unzip data
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
setwd("./data")
download.file(url, dest = "./power_consumption.zip")
unzip("./power_consumption.zip")
setwd("..")

## Read the headers
headers <- read.csv("./data/household_power_consumption.txt", sep = ";", nrows = 1) 

## Read the bulk data
## Only the required observations are read using skip and nrows
rawdata <- read.csv("./data/household_power_consumption.txt", sep = ";", na.strings = "?",
skip = 66637, nrows = 2880, header = FALSE)

## Set the names of the variables
names(rawdata) <- names(headers)
rm(headers)

## Convert date and time columns
rawdata$Date <- as.Date(rawdata$Date, "%d/%m/%Y")
rawdata$Time <- strptime(rawdata$Time, format="%H:%M:%S")

## Create a column with the complete date and time
rawdata$datetime = as.POSIXlt(rawdata$Time)
## Complete the time with the date
rawdata$datetime$year <- (as.POSIXlt(rawdata$Date))$year
rawdata$datetime$mon <- (as.POSIXlt(rawdata$Date))$mon
rawdata$datetime$mday <- (as.POSIXlt(rawdata$Date))$mday



## First plot
## Create the graphics device
png(file = "plot1.png", width = 480, height = 480)
## Create the plot 
with(rawdata, hist(Global_active_power, col = "red", main = "Global Active Power",
xlab = "Global Active Power (kilowatts)"))
## Close the device
dev.off()

