## Exploratory Data Analysis: Plot 2 from Project 1

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
png (file = "plot2.png", width =480, height = 480)

## Plot including axis labels
with (sample1, plot (sample1$Date_Time, sample1$Global_active_power, type="l", main ="Plot 2", ylab ="Global Active Power (kilowatts)", xlab = ""))

dev.off()

