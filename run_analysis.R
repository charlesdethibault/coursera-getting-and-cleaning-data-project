library(reshape2)
library(reshape)

filename <- "getdata_dataset.zip"

## Download ipfile from website and unzip it
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

##  load data into R
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
## load labels
activityLabels <- read.table(("UCI HAR Dataset/activity_labels.txt"), quote = "\"", col.names = c("activity_id", "activity_name"))
features <- read.table("UCI HAR Dataset/features.txt")

##  merge train and test datasets
trainData <- cbind(subject_train, y_train, x_train)
testData <- cbind(subject_test, y_test, x_test)
fullData <- rbind(trainData, testData)
colnames(fullData) <- c("subject_id","activity_id", as.character(features$V2))
combine <- merge(activityLabels, fullData, by = "activity_id")

##remove useless data ( not required to std and mean measurement)

combine <- combine[, grep("activity_name|subject|std\\(\\)-|mean\\(\\)-", colnames(combine))]

## prepare file and compute std and mean
allData <- melt(combine, id.vars = c("activity_name", "subject_id"), measure.vars = colnames(combine[3:50]))
allData <- dcast(allData, subject_id + variable ~ activity_name, mean)

## write table
write.table(allData, "tidy.txt", row.names = FALSE, quote = FALSE)