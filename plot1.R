#Download the zip file from the internet
zipfile <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(zipfile,destfile = "hpczip.zip")

#Unzip the file
unzip("hpczip.zip")

#Load only the records needed.
library("sqldf")
fileName <- "household_power_consumption.txt"
myFile <- file(fileName)
hpcData <- sqldf("select * from myFile where Date == '1/2/2007' OR Date == '2/2/2007'",
                 file.format = list(header = TRUE, sep = ";"))
close(myFile)

#Introduce two columns that has Date and Datetime values
hpcData$newDate <- as.Date(hpcData$Date,format="%d/%m/%Y")
hpcData$newDateTime <- strptime(paste(hpcData$Date,hpcData$Time),format="%d/%m/%Y %H:%M:%S")

#Rearrange columns so the newly introduced ones are at the beginning
hpcData <- hpcData[,c(10,11,1:9)]

#Plot 1 
png(file = "plot1.png", width = 480, height = 480)
par(mar=c(5,5,5,1))
hist(hpcData$Global_active_power,col="red",main="Global Active Power", xlab="Global Active Power (kilowatts)", ylab="Frequency")
dev.off()



