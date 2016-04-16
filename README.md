# TidyWearableData
A demonstration of working with and tidying data, using UCI's "Human Activity Recognition Using Smartphones Data Set"

## Scripts

`run_analysis.R` performs all of the data manipulations and generates the resulting datasets.

`tests.R` performs a few sanity checks on the intermediate datasets.


## The Data

See [CodeBook.md](CodeBook.md).


## The Analysis

The original data are split between test and training sets, as well as being bundled with separate labels and subject identifiers. The first step is to merge these into a single uniform dataset. And since feature names are not bundled with the data itself, they need to be loaded in and applied to the resulting data frame as well.

We are only interested in `mean` and `std` measurements, so the next step is to select just those 66 measurements from the 561 provided.

The next step separates the data into observations where each column is a single variable, and each row is an observation. The original dataset suffers from column headers that are values (not variables), multiple variables stored in a single column, and variables stored in both rows and columns.

This results in a tidy dataset.

The final step creates a grouped summary dataset from this tidy dataset, producing the mean of each measurement's `mean` and `std` values, grouped for each subject and each activity.