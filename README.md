# TidyWearableData
A demonstration of working with and tidying data, using UCI's "Human Activity Recognition Using Smartphones Data Set"

## Scripts

`run_analysis.R` performs all of the data manipulations and generates the resulting datasets. It will download and unzip the data on its own, if necessary.

`tests.R` performs a few sanity checks on the intermediate datasets.

`harAvg.table.txt`, `harAvg.result.R`, and `harTidier.result.R` are the results of running the analysis.

## The Data

See [CodeBook.md](CodeBook.md).


## The Analysis

The original data are split between test and training sets, as well as being bundled with separate activity labels and subject identifiers. The first step is to merge these into a single dataset. Since feature names are not in the same data files, they are loaded separately and applied to the resulting data frame.

For this project, `mean` and `std` are the only measurements of interest, so just those 66 measurements are selected from the 561 measurements provided.

The next step separates and spreads the data into observations wherein each column is a single variable, and each row is an observation. The original dataset suffers from column headers that are values (not variables), multiple variables stored in a single column, and variables stored in both rows and columns. See Hadley Wickham's [Tidy Data](http://vita.had.co.nz/papers/tidy-data.pdf) for an explanation of these messy data issues.

The result is the `harTidier` dataset.

The final step summarizes the observations by taking the mean of each measurement's `mean` and `std` values, after grouping observations by subject and each activity. The result is the `harAvg` dataset.