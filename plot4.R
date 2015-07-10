
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


#Start plotting the graphs
windows()
par(mfcol=c(2,2))
xrange <- range(hpcData$newDateTime)
yrange <- range(hpcData$Global_active_power)
plot(xrange, yrange, type="n", xlab="", ylab="Global Active Power" ) 
lines(hpcData$newDateTime, hpcData$Global_active_power, type="l", lwd=1.5,
      lty=1) 

#Plot DateTime Vs Sub-metering
xrange <- range(hpcData$newDateTime)
yrange <- range(hpcData$Sub_metering_1)
plot(xrange, yrange, type="n", xlab="", ylab="Energy sub metering") 
lines(hpcData$newDateTime, hpcData$Sub_metering_1, type="l", lwd=1.5,
      lty=1) 
lines(hpcData$newDateTime, hpcData$Sub_metering_2, type="l", lwd=1.5,
      lty=1, col="red") 
lines(hpcData$newDateTime, hpcData$Sub_metering_3, type="l", lwd=1.5,
      lty=1, col="blue")
legendText <- c("Sub_metering_1  ","Sub_metering_2 ", "Sub_metering_3 ")
legend("topright",
       legend=legendText,
       lty=c(1,1,1),
       lwd=c(1.5,1.5,1.5),
       col=c("black","red","blue"),bty="n") 

#Plot Datetime vs Voltage
yrange <- range(hpcData$Voltage)
plot(xrange, yrange, type="n", xlab="datetime", ylab="Voltage") 
lines(hpcData$newDateTime, hpcData$Voltage, type="l", lwd=1.5,
      lty=1) 

#Plot Datetime vs Global Reactive Power
yrange <- range(hpcData$Global_reactive_power)
plot(xrange, yrange, type="n", xlab="datetime", ylab="Global_reactive_power") 
lines(hpcData$newDateTime, hpcData$Global_reactive_power, type="l", lwd=1.5,
      lty=1) 


dev.copy(png,file="plot4.png")
dev.off()
