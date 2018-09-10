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


## Fourth plot
## Create the graphics device
png(file = "plot4.png", width = 480, height = 480)
## Set the plots to be arranged in a grid (2 x 2), column first
par(mfcol  =c(2, 2))
## First plot on the grid
with(rawdata, plot(datetime, Global_active_power, type = "l", xlab = "",
ylab = "Global Active Power (kilowatts)"))
## Second plot on the grid
with(rawdata, plot(datetime, Sub_metering_1, type = "l", xlab = "",
ylab = "Energy Sub Metering"))
with(rawdata, points(datetime, Sub_metering_2, type = "l", col = "red"))
with(rawdata, points(datetime, Sub_metering_3, type = "l", col = "blue"))
legend("topright", legend = names(rawdata)[7:9], col = c("black", "red", "blue"),
lty = "solid", bty = "n")
## Third plot on the grid
with(rawdata, plot(datetime, Voltage, type = "l"))
## Fourth plot on the grid
with(rawdata, plot(datetime, Global_reactive_power, type = "l"))
## Close the device
dev.off()

