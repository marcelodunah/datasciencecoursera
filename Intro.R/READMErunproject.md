Script for Course Project in Getting & Cleaning Data Course (june 2014)
========================================================
Task #1: Download file and unzip to appropiate files. This part of the script is not included in the submitted R script in the github account. 

```{r}
## Create dir
if (!file.exists ("Run_analysis_project")){
      dir.create ("Run_analysis_project")
}
## Download the zip file to folder and set Working dir to new folder
fileurl1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file (fileurl1, destfile="./Run_analysis_project/temp.zip")
setwd("./Run_analysis_project")
## Unzip file and list unzipped files
unzip ("temp.zip")
## Working directory is now with all needed files
setwd ("./UCI HAR Dataset")
```

Note: The README from the downloaded data set is key to understand all variables and files.

Task#2: Read the train and text files separately, add names from feature.txt file, and select only the columns with 'mean' and 'std' values. Matching columns were the ones having within the name the strings. This was done with a function that could work for both train and test data sets. Input variables for the function are:
 - directory: where is the table of featured variables; the observations
 - namesdir: the file name that has the column names
 - str1,str2: the two strings that will be looked in the column names to match requirement
The output of the function is a data frame with the required columns for the data set.

```{r}
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
```
Function must be run for both data sets: train and test

```{r}
traint <- reducing("./train/X_train.txt", "features.txt", "mean", "std")
testt <- reducing("./test/X_test.txt", "features.txt", "mean", "std")
```

Task #3: Add the columns for Activity and Subject. It is done with a function called colbinding. The function will read from the file the activity ID corresponding to each observation.The input arguments for the function are:
      - directory: where is the table of featured variables
      - tobind: the object that the read info will be bind. In this case will be the output from the reducing function
      - cname: the name for the new column
The output is an updated object with new first column

```{r}
colbinding <- function (directory, tobind, cname){
      tempA <- read.table (directory) ## "./train/y_train.txt"
      tempA <- cbind (tempA, tobind)
      colnames (tempA)[1] <- cname
      tempA
      
}
```
The function is run for both data sets (train and test) and for the activity ID and the Subject ID.
The result is two data sets (train and test) that have been merged with the featured observations, the activity for each observation and the subject for that observation.

```{r}
## Add Activity column in both data sets
traint <- colbinding ("./train/y_train.txt", traint, "ActivityID")
testt <- colbinding ("./test/y_test.txt", testt, "ActivityID")

## Add Subject column in both data sets
traint <- colbinding ("./train/subject_train.txt", traint, "SubjectID")
testt <- colbinding ("./test/subject_test.txt", testt, "SubjectID")
```

Task #4: Both data sets are merged by rows (rbind)
```{r}
## Row Bind both data sets
fdata <- rbind (traint, testt)
```

Task #5: Add a descriptive name to the Activity ID in the merged dataset. The column containing the activity ID is changed to factor to use recode function. recode changes the numbers in the activity ID for the corresponding names. new column is then moved to be the 3rd column for a cleaner/understandable vision of the data set. 
The '()' are removed from the column names for readability.

```{r}
## Convert ActivityID to factor and recode into new column Activity Name
fdata$ActivityID <- as.factor(fdata$ActivityID)
fdata$ActivityName <- recode(fdata$ActivityID,  "1='WALKING_UPSTAIRS'; 2='WALKING_DOWNSTAIRS'; 3='WALKING'; 4='SITTING'; 5='STANDING'; 6='LAYING'")
## Move column ActivityName from last to 3rd column
fdata <- fdata[ , c(1:2, 82, 3:81)]
## Remove "()" from column names
colnames(fdata) <- gsub ("\\()","", colnames(fdata))
```

Task #6: Generate a second data set with the means (average) of every observation for each activity and each subject. The merged data (fdata) is splited by Subject ID and Activity ID into a list(). This list (pieces) has length 180 (30 subjects x 6 activities), so each element of pieces() is the info of one subject and one activity. Using a for loop we take each element of pieces and generate the mean of each variable. This is done with apply to the numerical columns; columns 1:3 cannot be processed. The result is a list with one column, that must be merged with the info of subject and activity.


```{r}
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
```

Task #7: The splited data is combined again after assuring that each element is a data.frame.
```{r}
## Recombine the split file
fdata2 <- do.call ("rbind", pieces)
```

Task #8: Write both tidy data sets to .txt files
```{r}
write.table (fdata, "runproject.txt")
write.table (fdata2, "runprojectmeans.txt")
```


