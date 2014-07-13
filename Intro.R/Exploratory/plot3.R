## Exploratory Data Analysis: Plot 3 from Project 1

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
png (file = "plot3.png", width =480, height = 480)

## Plot 3

with (sample1, plot (sample1$Date_Time, sample1$Sub_metering_1, type ="l", xlab="", ylab="Energy sub metering"))
with (sample1, points (sample1$Date_Time, sample1$Sub_metering_2, type ="l", col="red"))
with (sample1, points (sample1$Date_Time, sample1$Sub_metering_3, type ="l", col="blue"))
legend("topright", pch= "-", col= c("black", "red", "blue"), legend = colnames (sample1[8:10]))
title (main ="Plot 3")

dev.off()
