################################################################################
## run_analysis.R, by AJ Heller, April 15th, 2016
## Completed as part of Johns Hopkins University / Coursera Data Science 
##
## Specialization, "Getting and Cleaning Data" Course. See README.md for mor
## information
##
##
## This script performs the following:
## 
## 1) Merges the training and the test sets to create one data set.
## 
## 2) Extracts only the measurements on the mean and standard deviation for each
##    measurement.
## 
## 3) Uses descriptive activity names to name the activities in the data set
## 
## 4) Appropriately labels the data set with descriptive variable names.
## 
## 5) From the data set in step 4, creates a second, independent tidy data set
##    with the average of each variable for each activity and each subject.
## 
##- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

library(data.table)
library(dplyr)
library(tidyr)



## - - download the data - - - - - - - - - - - - - - - - - - - - - - - - - - - -

HARzip <- "HAR.zip"
if (!file.exists(HARzip)) {
    HARurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(url = HARurl, destfile = HARzip, method="curl", quiet=T)
    unzip(zipfile = HARzip)
}



## - - load data into R - - - - - - - - - - - - - - - - - - - - - - - - - - - -

testData <- fread(input = "UCI HAR Dataset/test/X_test.txt", sep=" ", header = F)

trainData <- fread(input = "UCI HAR Dataset/train/X_train.txt", sep=" ", header = F)
# name the columns with the supplied feature names
featureNamesTbl <- fread(input="UCI HAR Dataset/features.txt", sep=" ", header=F, col.names = c("id", "name"))
names(testData) <- names(trainData) <- featureNamesTbl$name

# add activity names and subject identifiers
testLabels <- fread(input = "UCI HAR Dataset/test/y_test.txt", sep=" ", header = F)
trainLabels <- fread(input = "UCI HAR Dataset/train/y_train.txt", sep=" ", header = F)
testSubIDs <- fread(input = "UCI HAR Dataset/test/subject_test.txt", header = F)
trainSubIDs <- fread(input = "UCI HAR Dataset/train/subject_train.txt", header = F)

testData <- cbind(testData, activityLabel=testLabels$V1, subjectID=testSubIDs$V1, dataset="test")
trainData <- cbind(trainData, activityLabel=trainLabels$V1, subjectID = trainSubIDs$V1, dataset="train")


# merge test & train data, and add descriptive activity names
activityLabelNames <- fread(input = "UCI HAR Dataset/activity_labels.txt", sep=" ", header = F, col.names = c("id", "name"))
harData <- bind_rows(testData, trainData) %>% 
    mutate(activityLabel=activityLabelNames[activityLabel,name])


## - - extract mean and sd variables only - - - - - - - - - - - - - - - - - - -
harDataMeanSD <- select(harData, matches("(-mean|-std)\\(\\)"), activityLabel, dataset, subjectID) %>% 
    cbind(id = seq(1, nrow(harData)))



## - - tidy the data - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
## This next command separates the data into observations where each column is a
## single variable, and each row is an observation. Previously, this dataset 
## suffered from column headers that were values (not variables), multiple
## variables stored in a single column, and variables stored in both rows and
## columns.
## 
## There is information duplication here. Wickham[1] addresses this in saying 
## duplication, but that data analysis tools rarely work over relations.
## that this single dataset can be normalized into two or more tables to reduce
## 
## [1]: http://vita.had.co.nz/papers/tidy-data.pdf

harDataGathered <- harDataMeanSD %>% 
    gather(key, signal, -c(id, activityLabel, subjectID, dataset)) %>%
    separate(key, into=c("meas", "mean_std", "xyz"), sep="-") %>%
    mutate(mean_std = gsub("()", "", mean_std, fixed=TRUE))

harXYZ <- filter(harDataGathered, !is.na(xyz)) %>% mutate(measurement = paste(meas, xyz, sep="-"))
harXYZna <- filter(harDataGathered, is.na(xyz)) %>% mutate(measurement = meas)

harTidier <- bind_rows(harXYZ, harXYZna) %>% 
    select(id, subjectID, dataset, activityLabel, measurement, mean_std, signal) %>%
    spread(mean_std, signal) %>%
    rename(observationID = id)
 

## - - Part 5: Average of each variable by subject & activity - - - - - - - - -
## 
## The language of the assignmentis ambiguous here. I chose to interpret the
## instructions to mean "create a dataset with the average of each measurement
## (mean and std) for each subject-activity". 

harAvg <- group_by(harTidier, subjectID, activityLabel, measurement) %>% 
    summarize(avg_mean=mean(mean), avg_std=mean(std))
