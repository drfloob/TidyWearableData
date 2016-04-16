---
title: "HAR Codebook"
author: "AJ Heller"
date: "April 16th, 2016"
output:
  html_document:
    keep_md: yes
---

## Project Description
The purpose of this project is to demonstrate my ability to collect, work with, and tidy a data set, using UCI's "Human Activity Recognition Using Smartphones Data Set". The goal is to prepare tidy data that can be used for later analysis.



##Study design and data processing

###Collection of the raw data
The "Human Activity Recognition Using Smartphones Data Set" is comprised of accelerometer readings from a Samsung Galaxy S smartphone, worn on 30 volunteers, performing six different activities.

The data is downloaded and unzipped in the R script `run_analysis.R`, from [this Amazon Cloudfront url](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) provided as part of the assignment.

The HAR data is available on [UCI's Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).



###Notes on the original (raw) data 
The HAR zip file contains files that thoroughly describe the data, but to briefly summarize: there are 561 features, a categorical label, and a subject ID to uniquely identify the study participant. Each feature is a kind of measurement or summary statistic taken from the phone's accelerometer or gyroscope, transformed in various ways as described in their documentation, and normalized and bounded on [-1,1].




##Creating the tidy datafile

###Guide to create the tidy data file
The tidy data files are generated by running `run_analysis.R`. This downloads the necessary data, loads it, transforms it, tidies it, and saves the results.

###Cleaning of the data

The script performs a few tasks, which are described below.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set.
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


##Description of the variables in the `harTidier.result.R` file
This results file is generated by `run_analysis.R`. You can load it with `dget` to recreate the `harTidier` data.table. Here is a brief summary:

```R
> str(harTidier)
Classes ‘tbl_df’, ‘tbl’ and 'data.frame':	339867 obs. of  7 variables:
 $ observationID: int  1 1 1 1 1 1 1 1 1 1 ...
 $ subjectID    : int  2 2 2 2 2 2 2 2 2 2 ...
 $ dataset      : chr  "test" "test" "test" "test" ...
 $ activityLabel: chr  "STANDING" "STANDING" "STANDING" "STANDING" ...
 $ measurement  : chr  "fBodyAccJerk-X" "fBodyAccJerk-Y" "fBodyAccJerk-Z" "fBodyAccMag" ...
 $ mean         : num  -0.9 -0.937 -0.924 -0.791 -0.919 ...
 $ std          : num  -0.924 -0.943 -0.948 -0.711 -0.948 ...
 ```

###Variable: observationID
This is a integer id, generated by a simple sequence and appended to each observation in the original dataset. It ranges from 1 to 10,299. It was necessary to add this to differentiate between multiple measurements on the same subject during the same activity.

###Variable: subjectID
This is an integer id, provided in the `subject_*.txt` files, appended to each observation in the original dataset. It ranges from 1 to 30, and uniquely identifies the subject (participant) for each observation.

###Variable: dataset
This is a character string appended to each observation in the original dataset to identify whether the observation came from the "test" or "training" datasets, which would otherwise be lost when those datasets are merged.

###Variable: activityLabel
This is a character string, provided in the `y_*.txt` files, appended to each observation in the original dataset to label which of the 6 activities this observation pertained to. The data in the `y_*.txt` files is numeric, so the lookup table provided in `activity_labels.txt` is used to translate the 6 numbers into the corresponding activity name.

###Variable: measurement
This is a character string that identifies what kind of measurement is being taken in this observation. There are 33 unique types of measurements, ranging (alphabetically) from "fBodyAccJerk-X" to "tGravityAcc-Z". These names were extracted from the column headings of the original data files, after removing the summary statistic from the name (e.g. "fBodyAccJerk-mean()-X" became "fBodyAccJerk-X"). Originally, there were 66 original column headings between `mean` and `std` measurements, which were gathered into this single `measurement` column and separated out into `mean` and `std` measurements.

###Variable: mean
This is a decimal number, extracted from the original dataset. A column such as "fBodyAccJerk-mean()-X" became an observation with measurement "fBodyAccJerk-X" and mean set to the previous variable's value. This value is normalized and bounded to [-1,1].

###Variable: std
This is a decimal number, extracted from the original dataset. A column such as "fBodyAccJerk-std()-X" became an observation with measurement "fBodyAccJerk-X" and std set to the previous variable's value. This value is normalized and bounded to [-1,1].




##Description of the variables in the `harAvg.result.R` file
This results file is generated by `run_analysis.R`. You can load it with `dget` to recreate the `harAvg` data.table. Here is a brief summary:

```R
> str(harAvg)
Classes ‘grouped_df’, ‘tbl_df’, ‘tbl’ and 'data.frame':	5940 obs. of  5 variables:
 $ subjectID    : int  1 1 1 1 1 1 1 1 1 1 ...
 $ activityLabel: chr  "LAYING" "LAYING" "LAYING" "LAYING" ...
 $ measurement  : chr  "fBodyAccJerk-X" "fBodyAccJerk-Y" "fBodyAccJerk-Z" "fBodyAccMag" ...
 $ avg_mean     : num  -0.957 -0.922 -0.948 -0.862 -0.939 ...
 $ avg_std      : num  -0.964 -0.932 -0.961 -0.798 -0.924 ...
```
Variables "subjectID", "activityLabel", and "measurement" are described identically to those in `harTidier.result.R`

###Variable: avg_mean
This is a decimal number, representing the mean of all mean values from `harTidier` for each measurement, grouped by subject and activity. This value is normalized and bounded to [-1,1].

###Variable: avg_std
This is a decimal number, representing the mean of all std values from `harTidier` for each measurement, grouped by subject and activity. This value is normalized and bounded to [-1,1].




##Sources
Jorge L. Reyes-Ortiz(1,2), Davide Anguita(1), Alessandro Ghio(1), Luca Oneto(1) and Xavier Parra(2)
1 - Smartlab - Non-Linear Complex Systems Laboratory
DITEN - Università degli Studi di Genova, Genoa (I-16145), Italy. 
2 - CETpD - Technical Research Centre for Dependency Care and Autonomous Living
Universitat Politècnica de Catalunya (BarcelonaTech). Vilanova i la Geltrú (08800), Spain
activityrecognition '@' smartlab.ws

