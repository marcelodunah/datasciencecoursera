## Exploratory Data Analysis: Plot 4 from Project 1

## Read from the Source file
sample1 <- read.table("household_power_consumption.txt", na.strings ="?",
                      comment.char ="", sep=";", header = T, 
                      colClasses = c("character", "character", "numeric", "numeric", "numeric", "numeric",
                                     "numeric", "numeric", "numeric"))

## Subset
sample1 <- subset (sample1, sample1[ ,1]=="1/2/2007" | sample1[ ,1]=="2/2/2007")

## merge fix date and time in 1 column
fts <- paste(sample1[ ,1], sample1[ ,2])
fts <- strptime (fts, "%d/%m/%Y %H:%M:%S")
sample1 <- cbind(fts, sample1)
colnames (sample1)[1] <- "Date_Time"

## Open Device .png
png (file = "plot4.png", width =480, height = 480)

## set Plot canvas
par (mfrow =c(2,2), mar=c(4,4,2,1), oma=c(0,0,0,0))
## Plot
with (sample1, {
      ## miniplot #1
      plot (sample1$Date_Time, sample1$Global_active_power, type="l", 
            ylab ="Global Active Power (kilowatts)", xlab = "")
      ## miniplot #2
      plot (sample1$Date_Time, sample1$Voltage, type ="l", ylab ="Voltage", xlab ="datetime")
      ## miniplot #3 with plots and points for additional graphs 
      plot (sample1$Date_Time, sample1$Sub_metering_1, type ="l", xlab="", ylab="Energy sub metering")
            points (sample1$Date_Time, sample1$Sub_metering_2, type ="l", col="red")
            points (sample1$Date_Time, sample1$Sub_metering_3, type ="l", col="blue")
            legend("topright", pch= "-", col= c("black", "red", "blue"), legend = colnames (sample1[8:10]))
      ## miniplot#4
      plot (sample1$Date_Time, sample1$Global_reactive_power, type ="l", 
            ylab = "Global reactive power", xlab ="datetime")
      
})

dev.off()