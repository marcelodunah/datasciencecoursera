## Course Project Getting & Cleaning Data Week 3


reducing <- function (directory, namesdir, str1, str2){
      tempF <- read.table(directory) ## reads file
      tnames <- read.table (namesdir, colClasses ="character") ## reads file with colnames
      ## assign colnames
      colnames (tempF) <- tnames [ ,2]
      ## find partial matching by column names
      featemp <- tnames [grepl(str1, tnames[ ,2]) | grepl (str2, tnames[ ,2]), ]
      ## extract index for matching column names
      featemp <- featemp [ ,1]
      featemp <- as.numeric (featemp)
      ## reduce columns to matching
      tempF <- tempF[ , featemp]
      tempF
}

traint <- reducing("./train/X_train.txt", "features.txt", "mean", "std")
testt <- reducing("./test/X_test.txt", "features.txt", "mean", "std")



## Add Activity Column
colbinding <- function (directory, tobind, cname){
      tempA <- read.table (directory) ## "./train/y_train.txt"
      tempA <- cbind (tempA, tobind)
      colnames (tempA)[1] <- cname
      tempA
      
}

## Add Activity column in both data sets
traint <- colbinding ("./train/y_train.txt", traint, "ActivityID")
testt <- colbinding ("./test/y_test.txt", testt, "ActivityID")

## Add Subject column in both data sets
traint <- colbinding ("./train/subject_train.txt", traint, "SubjectID")
testt <- colbinding ("./test/subject_test.txt", testt, "SubjectID")

## Row Bind both data sets
fdata <- rbind (traint, testt)
## Convert ActivityID to factor and recode into new column Activity Name
fdata$ActivityID <- as.factor(fdata$ActivityID)
fdata$ActivityName <- recode(fdata$ActivityID,  "1='WALKING_UPSTAIRS'; 2='WALKING_DOWNSTAIRS'; 3='WALKING'; 4='SITTING'; 5='STANDING'; 6='LAYING'")
## Move column ActivityName from last to 3rd column
fdata <- fdata[ , c(1:2, 82, 3:81)]
## Remove "()" from column names
colnames(fdata) <- gsub ("\\()","", colnames(fdata))

## Tidy data #2 Mean for each Subject in each Activity
## split by Subject and Activity
pieces <- split (fdata, list(fdata[ , 1], fdata[ ,2]))

## Each element of pieces is processed to calculate means of all variables
for (i in 1: length (pieces)){
      t1 <- pieces [[i]]
      tmean1 <- apply (t1[ ,4:82], 2, mean) ## only calculate mean for measured variables
      ## result is a list of 1 col
      t1 <- t1[ 1, 1:3]
      t1 <- c(t1, tmean1)
      t1 <- as.data.frame (t1)
      pieces [[i]] <- t1     
}
## Recombine the split file
fdata2 <- do.call ("rbind", pieces)

write.table (fdata, "runproject.txt")
write.table (fdata2, "runprojectmeans.txt")